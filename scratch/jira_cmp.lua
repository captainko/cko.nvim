local cmp = require("cmp")
local Curl = require("plenary.curl")
local jira = R("core.utils.jira")
local fmt = string.format

if JIRA_CMP_ID then
	require("cmp").unregister_source(JIRA_CMP_ID)
end

local source = {}
source.new = function()
	local self = setmetatable({ cache = {} }, { __index = source })

	return self
end

function source.execute(_self, complete_item, callback)
	return callback(complete_item)
end

---comment
---@param search_text any
local function parse_text_info(search_text)
	local project = search_text
	local key = nil
	if string.find(search_text, "-") ~= nil then
		local split = vim.split(search_text, "-")
		project = split[1]
		key = search_text
	end
	return {
		project = project,
		key = key,
	}
	-- code
end

---comment
---@param jql string
---@param and_cond string|nil
local function add_and(jql, and_cond)
	and_cond = and_cond or ""
	if jql ~= "" then
		return jql .. " AND " .. and_cond
	end
	return jql .. and_cond
end

source.complete = function(self, params, callback)
	local search_term = vim.trim(string.sub(params.context.cursor_before_line, params.offset))

	if self.cache[search_term] then
		callback({ items = self.cache[search_term], isIncomplete = false })
	else
		-- local is_search = string.find(search_term, " ") ~= nil

		local jql = ""

		local info = parse_text_info(search_term)
		if info.project then
			jql = fmt([[project = "%s"]], info.project)
		end
		-- if is_search then
		-- 	if search_term and search_term ~= "" then
		-- 		jql = jql .. fmt([[summary ~ "%s" OR description ~ "%s"]], search_term, search_term)
		-- 	end
		-- else -- search by code
		-- 	local info = parse_text_info(search_term)
		-- 	if info.project then
		-- 		jql = jql .. fmt([[project = "%s"]], info.project)
		-- 	end

		-- 	if info.text and info.text ~= "" then
		-- 		if info.project then
		-- 			jql = add_and(jql)
		-- 		end
		-- 		jql = jql .. fmt([[summary ~ "%s" or description ~ "%s" ]], info.text, info.text)
		-- 	end
		-- end
		-- jql = add_and(jql, [[status NOT IN ("DONE")]])

		local data = {
			-- [[summary ~ "quota" AND assignee IN (61b95adf40142900700da61d,5b7e6bb3ed4f842a6ddb4fb5)]],
			jql = jql,
			maxResults = 100,
		}

		-- Curl.post("https://ttekvn.atlassian.net/rest/api/latest/search", {
		-- 	headers = { ["Content-Type"] = "application/json" },
		-- 	-- body = { jql = "project = BV2" },
		-- 	body = vim.json.encode(data),
		-- 	auth = fmt("%s:%s", vim.env.ATLASSIAN_EMAIL, vim.env.ATLASSIAN_TOKEN),
		-- 	callback = function(res)
		-- 		if res.status >= 300 or res.status < 200 then
		-- 			return
		-- 		end

		-- 		local ok, parsed = pcall(vim.json.decode, res.body)
		-- 		if not ok then
		-- 			return
		-- 		end

		jira.issues.list(data, function(res)
			local parsed = res.body
			local items = {}

			for _, issue in ipairs(parsed.issues) do
				issue.body = issue.fields.description ~= vim.NIL and string.gsub(issue.fields.description, "\r", "")
					or ""

				table.insert(items, {
					label = issue.key,
					-- kind = cmp.lsp.CompletionItemKind.Snippet,
					documentation = {
						kind = "markdown",
						value = fmt("# %s | %s\n\n%s", issue.key, issue.fields.summary, issue.body),
					},
					data = issue,
				})
			end

			callback({ items = items, isIncomplete = false })
			self.cache[search_term] = items
		end)
	end
end
source.get_trigger_characters = function()
	return { "|" }
end

source.is_available = function()
	return vim.bo.filetype == "gitcommit"
end

JIRA_CMP_ID = require("cmp").register_source("jira", source:new())
