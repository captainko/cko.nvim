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
---@param search_text string
local function parse_issue_key(search_text)
	local project = search_text
	local key = nil
	if search_text:find("-") ~= nil then
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
local function map_issues_to_items(issues)
	local result = {}

	for _, issue in ipairs(issues) do
		issue.body = issue.fields.description ~= vim.NIL and string.gsub(issue.fields.description, "\r", "") or ""

		result[#result + 1] = {
			label = ("%s | %s,"):format(issue.key, issue.fields.summary),
			-- kind = cmp.lsp.CompletionItemKind.Snippet,
			documentation = {
				kind = "markdown",
				value = ("# %s | %s\n\n%s"):format(issue.key, issue.fields.summary, issue.body),
			},
			data = issue,
		}
	end

	return result
end

function source.complete(self, params, callback)
	local search_term = vim.trim(string.sub(params.context.cursor_before_line, params.offset))

	if self.cache[search_term] then
		callback({ items = self.cache[search_term], isIncomplete = true })
	end

	local jql = ""

	local info = parse_issue_key(search_term)
	if info.project then
		jql = ([[project="%s" AND (assignee=currentUser() OR watcher=currentUser()) ORDER BY updated,created]]):format(
			info.project
		)
	end

	---@type JiraRequest
	local request = {
		jql = jql,
		maxResults = 100,
		fields = { "key", "summary", "description" },
	}

	jira.issues.list(request, function(res)
		if res.status >= 300 or res.status < 200 then
			return
		end

		local ok, parsed = pcall(vim.json.decode, res.body)

		local items = {}
		if ok and parsed ~= nil then
			items = map_issues_to_items(parsed.issues)
		end

		callback({ items = items, isIncomplete = false })
		self.cache[search_term] = items
	end)
end

function source:get_trigger_characters()
	return { "|" }
end

function source:is_available()
	return vim.bo.filetype == "gitcommit"
end

JIRA_CMP_ID = cmp.register_source("jira", source:new())
