TelescopeMapArgs = TelescopeMapArgs or {}

local should_reload = false

local function map_tele(lhs, rhs, options, buffer, mode)
	local map_key = vim.keycode(lhs .. rhs .. (buffer or ""))

	TelescopeMapArgs[map_key] = options or {}

	mode = mode or "n"
	rhs = string.format(
		should_reload and "<Cmd>lua pcall(require('core.telescope')['%s'],TelescopeMapArgs['%s'])<CR>"
			or "<Cmd>lua pcall(require('core.telescope')['%s'],TelescopeMapArgs['%s'])<CR>",
		rhs,
		map_key
	)

	local map_opts = { noremap = true, silent = true, nowait = true, buffer = buffer }

	vim.keymap.set(mode, lhs, rhs, map_opts)
end
-- TJ config

-- vim.api.nvim_set_keymap("c", "<c-r><c-r>", "<Plug>(TelescopeFuzzyCommandSearch)", { noremap = false, nowait = true })

-- Dotfiles
map_tele("<Leader>en", "edit_neovim")
map_tele("<C-p>", "file_browser")
-- map_tele("<Leader>ez", "edit_zsh")

-- Search
-- TODO: I would like to completely remove _mock from my search results here when I'm in SG/SG
-- map_tele("<LocalLeader>gw", "grep_string", {
--   short_path = true,
--   word_match = "-w",
--   only_sort_text = true,
--   layout_strategy = "vertical",
--   sorter = sorters.get_fzy_sorter(),
-- })

-- map_tele("<LocalLeader>f/", "grep_last_search", {
--   layout_strategy = "vertical",
-- })

-- Files
-- map_tele("<LocalLeader>ft", "git_files")
-- -- map_tele("<LocalLeader>fg", "live_grep")
-- map_tele("<LocalLeader>fg", "multi_rg")

map_tele("<LocalLeader>fd", "diagnostics")
-- map_tele("<LocalLeader>fo", "oldfiles")
map_tele("<LocalLeader>fo", "frecency")
map_tele("<LocalLeader>f:", "command_history")
map_tele("<LocalLeader>fk", "keymaps")
map_tele("<LocalLeader>ff", "search_current_folders")
map_tele("<LocalLeader>fa", "autocommands")
map_tele("<LocalLeader>fi", "find_files__hidden")
map_tele("<LocalLeader>ft", "find_files__test")
-- map_tele("<LocalLeader>fg", "grep_string")
map_tele("<LocalLeader>fl", "live_grep")
map_tele("<LocalLeader>f.", "search_relative_files")
map_tele("<LocalLeader>fw", "grep_curr_word")
map_tele("<LocalLeader>fb", "buffers")
map_tele("<LocalLeader>fr", "resume")
map_tele("<LocalLeader>fR", "reloader")
map_tele("<LocalLeader>fh", "help_tags")
map_tele("<LocalLeader>fp", "search_plugins")
map_tele("<LocalLeader>fc", "current_buffer_fuzzy_find")
map_tele("<LocalLeader>bc", "git_bcommits")

--  ============================================================================
--  Code Diagnostics
--  ============================================================================

-- cko.nnoremap({
-- 	"go",
-- 	function()
-- 		require("telescope.builtin.lsp").document_symbols({
-- 			winnr = vim.api.nvim_get_current_win(),
-- 		})
-- 	end,
-- })
-- -- map_tele("go", "lsp_document_symbols")
-- map_tele("gO", "lsp_dynamic_workspace_symbols")
-- map_tele("<Leader>fd", "lsp_workspace_diagnostics")
-- map_tele("<LocalLeader>fd", "fd")
-- map_tele("<LocalLeader>pp", "project_search")
-- map_tele("<LocalLeader>fv", "find_nvim_source")
-- map_tele("<LocalLeader>fe", "file_browser")
-- map_tele("<LocalLeader>fz", "search_only_certain_files")

-- -- Sourcegraph
-- map_tele("<LocalLeader>sf", "sourcegraph_find")
-- map_tele("<LocalLeader>saf", "sourcegraph_about_find")
-- map_tele("<LocalLeader>sag", "sourcegraph_about_grep")
-- -- map_tele('<LocalLeader>fz', 'sourcegraph_tips')

-- -- Git
map_tele("<LocalLeader><LocalLeader>fb", "git_branches")
map_tele("<LocalLeader><LocalLeader>fg", "git_dot")
-- Other locations
map_tele("<LocalLeader><LocalLeader>fs", "scripts")
-- map_tele("<LocalLeader>gs", "git_status")
-- map_tele("<LocalLeader>gc", "git_commits")

-- Jira
map_tele("<LocalLeader>fj", "jira_issue")
map_tele("<LocalLeader>fm", "jira_my_issue")
-- Refactoring
-- -- Nvim
-- map_tele("<LocalLeader>fb", "buffers")
-- map_tele("<LocalLeader>fp", "my_plugins")
-- map_tele("<LocalLeader>fa", "installed_plugins")
-- map_tele("<LocalLeader>fi", "search_all_files")
-- map_tele("<LocalLeader>ff", "curbuf")
-- map_tele("<LocalLeader>fh", "help_tags")
-- map_tele("<LocalLeader>vo", "vim_options")
-- map_tele("<LocalLeader>gp", "grep_prompt")

-- -- Telescope Meta
map_tele("<LocalLeader>fB", "builtin")

return map_tele
