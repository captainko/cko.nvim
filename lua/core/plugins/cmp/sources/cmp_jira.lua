local cmp = require("cmp")
local jira = require("core.utils.jira")

if JIRA_CMP_ID then
	require("cmp").unregister_source(JIRA_CMP_ID)
end

local source = {}
function source.new()
	local self = setmetatable({ cache = {} }, { __index = source })

	return self
end

---@diagnostic disable-next-line: unused-local
-- function source.execute(self, complete_item, callback)
-- 	return callback(complete_item)
-- end

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
---@param issues table[]
local function map_issues_to_item(issues)
	local result = {}

	for _, issue in ipairs(issues) do
		issue.body = issue.fields.description ~= vim.NIL and string.gsub(issue.fields.description, "\r", "") or ""

		result[#result + 1] = {
			label = string.format("%s | %s,", issue.key, issue.fields.summary),
			-- kind = cmp.lsp.CompletionItemKind.Snippet,
			documentation = {
				kind = "markdown",
				value = string.format("# %s | %s\n\n%s", issue.key, issue.fields.summary, issue.body),
			},
			data = issue,
		}
	end

	return result
end

function source.complete(self, params, callback)
	local search_term = vim.trim(string.sub(params.context.cursor_before_line, params.offset))

	if self.cache[search_term] then
		callback({ items = self.cache[search_term], isIncomplete = false })
	else
		-- local is_search = string.find(search_term, " ") ~= nil

		local jql = ""

		local info = parse_text_info(search_term)
		if info.project then
			jql = string.format(
				[[project = "%s" AND assignee="61b95adf40142900700da61d" ORDER BY updated,created]],
				info.project
			)
		end

		local data = {
			jql = jql,
			maxResults = 100,
			fields = { "key", "summary", "description" },
		}

		jira.issues.list(data, function(res)
			if res.status >= 300 or res.status < 200 then
				return
			end

			local ok, parsed = pcall(vim.json.decode, res.body)
			if not ok then
				return
			end

			local result = map_issues_to_item(parsed.issues)

			callback({ items = result, isIncomplete = false })
			self.cache[search_term] = result
		end)

		-- 	end,
		-- })
	end
	-- Job:new({
	-- 	-- Uses `gh` executable to request the issues from the remote repository.
	-- 	"curl",

	-- 	on_exit = function(job)
	-- 		local result = job:result()
	-- 		local ok, parsed = pcall(vim.json.decode, table.concat(result, ""))
	-- 		if not ok then
	-- 			vim.notify "Failed to parse gh result"
	-- 			return
	-- 		end

	-- 		local items = {}
	-- 		for _, gh_item in ipairs(parsed) do
	-- 			gh_item.body = string.gsub(gh_item.body or "", "\r", "")

	-- 			table.insert(items, {
	-- 				label = fmt("#%s", gh_item.number),
	-- 				documentation = {
	-- 					kind = "markdown",
	-- 					value = fmt("# %s\n\n%s", gh_item.title, gh_item.body),
	-- 				},
	-- 			})
	-- 		end

	-- 		callback { items = items, isIncomplete = false }
	-- 		self.cache[bufnr] = items
	-- 	end,
	-- }):start()
	-- else
end
function source.get_trigger_characters()
	return { "|" }
end

function source.is_available()
	return vim.bo.filetype == "gitcommit"
end

JIRA_CMP_ID = cmp.register_source("jira", source:new())
