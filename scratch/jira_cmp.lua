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
---@param jql      string
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
		local search_term = vim.trim(string.sub(params.context.cursor_before_line, params.offset))

		-- local is_search = string.find(search_term, " ")
		-- if not is_search then
		-- 	return
		-- end

		local search_words = vim.split(search_term, " ", { trim_ws = true })
		if #search_words < 2 then
			return
		end

		local project = search_words[1]
		local keyword = table.concat(search_words, " ", 2) .. "-"

		jira.issues.list({
			jql = "project=" .. project .. " AND key~*" .. keyword .. "*",
		}, function(res)
			local parsed = res.body
			local items = {}

			for _, issue in ipairs(parsed.issues) do
				-- issue.body = issue.fields.description ~= vim.NIL and string.gsub(issue.fields.description, "\r", "") or ""

				issue.body = issue.fields.description ~= vim.NIL and issue.fields.description or ""

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
