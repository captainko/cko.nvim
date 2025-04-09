local _M = {}

_M.command_history = function()
	return require("telescope.builtin").command_history({
		-- attach_mapping = function(_, map)
		--   map("i", "<c-e>", actions.edit_command_line)
		-- end,
	})
end

_M.find_files__hidden = function()
	return require("telescope.builtin").find_files({ hidden = true })
end

_M.grep_curr_word = function()
	return require("telescope.builtin").grep_string({
		---@diagnostic disable-next-line: missing-parameter
		search = vim.fn.expand("<cword>"),
	})
end

_M.git_files = function()
	require("telescope.builtin").git_files({ args = { "--no-hidden" } })
end

_M.search_relative_files = function()
end

_M.find_files__test = function()
	require("telescope.builtin").find_files({
		prompt_title = "Test Files",
		find_command = {
			"fd",
			"--type",
			"f",
			"--full-path",
			"--glob",
			"**/__test__/**/*",
		},
	})
end

_M.search_plugins = function()
	require("telescope.builtin").find_files({
		prompt_title = "Plugins Folder",
		cwd = vim.stdpath("data") .. "/lazy/",
		path_display = { "smart" },
	})
end

_M.search_current_folders = function()
	require("telescope.builtin").find_files({
		prompt_title = "Current Folder",
		cwd = "./",
		hidden = true,
		path_display = { shorten = 8 },
		file_ignore_patterns = { ".git/objects", ".git/logs", ".git/refs", ".git/info" },
	})
end

function _M.lsp_implementations()
	require("telescope.builtin").lsp_implementations({
		layout_strategy = "vertical",
		layout_config = { prompt_position = "top" },
		sorting_strategy = "ascending",
		ignore_filename = false,
	})
end

_M.git_branches = function()
	require("telescope.builtin").git_branches({
		attach_mapping = function(_, map)
			map("i", "<c-d>", require("telescope.actions").git_delete_branch)
			map("n", "<c-d>", require("telescope.actions").git_delete_branch)
			map("i", "<c-e>", require("telescope.actions").git_checkout)
			map("n", "<c-e>", require("telescope.actions").git_checkout)
		end,
	})
end

function _M.lsp_references()
	require("telescope.builtin").lsp_references({
		-- layout_strategy = "vertical",
		layout_config = { prompt_position = "top" },
		sorting_strategy = "ascending",
		ignore_filename = false,
	})
end

function _M.current_buffer_fuzzy_find()
	require("telescope.builtin").current_buffer_fuzzy_find({
		-- layout_strategy = "vertical",
		-- previewer =false,
		layout_config = { prompt_position = "top" },
		sorting_strategy = "ascending",
		ignore_filename = false,
	})
end

-- M.refactors = function()
--   require("telescope.pickers").new({}, {
--     prompt_title = "Refactors",
--     finder = require("telescope.finders").new_table {
--       results = require("refactoring").get_refactors(),
--     },
--     sorter = require("telescope.config").values.generic_sorter {},
--     attach_mappings = function(_, map)
--       map("i", "<CR>", refactor)
--       map("n", "<CR>", refactor)
--       return true
--     end,
--   }):find()
-- end

local M = setmetatable({}, {
	__index = function(_, k)
		-- reloader()

		if _M[k] then
			return _M[k]
		end

		local has_custom, custom = PR(string.format("core.telescope.custom.%s", k))
		if has_custom then
			return custom
		end

		return require("telescope.builtin")[k]
	end,
})

return M
