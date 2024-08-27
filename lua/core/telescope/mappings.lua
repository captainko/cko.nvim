local mapper = require("core.utils.mapper")
local builtin = require("telescope.builtin")
-- TelescopeMapArgs = TelescopeMapArgs or {}

-- local should_reload = false

-- local function map_tele(lhs, rhs, options, buffer, mode)
-- 	local map_key = vim.keycode(lhs .. rhs .. (buffer or ""))

-- 	TelescopeMapArgs[map_key] = options or {}

-- 	mode = mode or "n"
-- 	rhs = string.format(
-- 		should_reload and "<Cmd>lua pcall(require('core.telescope')['%s'],TelescopeMapArgs['%s'])<CR>"
-- 			or "<Cmd>lua pcall(require('core.telescope')['%s'],TelescopeMapArgs['%s'])<CR>",
-- 		rhs,
-- 		map_key
-- 	)

-- 	local map_opts = { noremap = true, silent = true, nowait = true, buffer = buffer }

-- 	vim.keymap.set(mode, lhs, rhs, map_opts)
-- end
-- TJ config

-- vim.api.nvim_set_keymap("c", "<c-r><c-r>", "<Plug>(TelescopeFuzzyCommandSearch)", { noremap = false, nowait = true })

-- Dotfiles
-- map_tele("<Leader>en", "edit_neovim")

mapper.nnoremap({
	"<Leader>en",
	function()
		builtin.find_files({ prompt_title = "Edit Neovim Folder", cwd = vim.fn.stdpath("config") })
	end,
})
mapper.nnoremap({
	"<LocalLeader>fo",
	function()
		local frecency = require("telescope").extensions.frecency.frecency
		frecency()
	end,
})

mapper.nnoremap({
	"<LocalLeader>ff",
	function()
		builtin.find_files()
	end,
})

local last_file_type
mapper.nnoremap({
	"<LocalLeader>fl",
	function()
		local opts = {
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
			},

			file_ignore_patterns = {
				-- common
				".git",
				-- nodejs
				"node_modules",
				"dist",
				-- java
				"target",
				".settings",
				".mvn",
				".classpath",
				".factorypath",
				"mvnw",
			},
		}

		last_file_type = vim.fn.input({
			prompt = "File pattern (default:*)",
			default = last_file_type or "*",
		})

		if last_file_type ~= "" then
			table.insert(opts.vimgrep_arguments, "-g")
			table.insert(opts.vimgrep_arguments, last_file_type)
		else
			return
		end

		builtin.live_grep(opts)
	end,
})

mapper.nnoremap({
	"<LocalLeader>fb",
	function()
		builtin.buffers()
	end,
})

mapper.nnoremap({
	"<LocalLeader>fr",
	function()
		builtin.resume()
	end,
})

mapper.nnoremap({
	"<LocalLeader>f.",
	function()
		builtin.search_relative_files()
	end,
})

mapper.nnoremap({
	"<LocalLeader>fw",
	function()
		builtin.grep_curr_word()
	end,
})

mapper.nnoremap({
	"<LocalLeader>fB",
	function()
		builtin.builtin()
	end,
})
-- map_tele("<LocalLeader>fi", "find_files__hidden")
-- map_tele("<LocalLeader>ft", "find_files__test")
-- -- map_tele("<LocalLeader>fg", "grep_string")
-- map_tele("<LocalLeader>fl", "live_grep")
-- map_tele("<LocalLeader>f.", "search_relative_files")
-- map_tele("<LocalLeader>fw", "grep_curr_word")
-- map_tele("<LocalLeader>fb", "buffers")
-- map_tele("<LocalLeader>fr", "resume")
-- map_tele("<LocalLeader>fR", "reloader")
-- map_tele("<LocalLeader>fh", "help_tags")
-- map_tele("<LocalLeader>fp", "search_plugins")
-- map_tele("<LocalLeader>fc", "current_buffer_fuzzy_find")
-- map_tele("<LocalLeader>bc", "git_bcommits")

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
-- map_tele("<LocalLeader><LocalLeader>fb", "git_branches")
-- map_tele("<LocalLeader><LocalLeader>fg", "git_dot")
-- Other locations
-- map_tele("<LocalLeader><LocalLeader>fs", "scripts")
-- map_tele("<LocalLeader>gs", "git_status")
-- map_tele("<LocalLeader>gc", "git_commits")

-- Jira
-- map_tele("<LocalLeader>fj", "jira_issue")
-- map_tele("<LocalLeader>fm", "jira_my_issue")
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
