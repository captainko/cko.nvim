local previewers = require("telescope.previewers")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")

return function()
	pickers
		.new({
			results_title = "Jira Issues",
			-- Run an external command and show the results in the finder window
			finder = finders.new_job({
				"jira",
				"ls",
				"--query",
				string.format(
					"project = %s AND (assignee=currentuser() OR watcher=currentuser()) AND issuetype IN (sub-task,sub-bug) ORDER BY status,created,priority",
					vim.env.JIRA_PROJECT
				),
			}, { env = vim.env, writer = true }),
			sorter = sorters.get_generic_fuzzy_sorter(),
			previewer = previewers.new_buffer_previewer({
				---@diagnostic disable-next-line: unused-local
				define_preview = function(self, entry, status)
					local beg = string.find(entry.value, ":")
					if beg == nil then
						return
					end
					local key = string.sub(entry.value, 0, beg - 1)
					-- Execute another command using the highlighted entry
					return require("telescope.previewers.utils").job_maker({ "jira", "view", key }, self.state.bufnr, {
						callback = function(bufnr, content)
							if content ~= nil then
								require("telescope.previewers.utils").regex_highlighter(bufnr, "yaml")
							end
						end,
					})
				end,
			}),
		}, nil)
		:find() -- code
end
