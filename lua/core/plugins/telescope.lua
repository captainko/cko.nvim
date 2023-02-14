---@type LazyPlugin
local M = {
	"nvim-telescope/telescope.nvim",
	enabled = not vim.g.vscode,
	-- keys = {
	-- 	"<LocalLeader>fd",
	-- 	"<LocalLeader>fo",
	-- 	"<LocalLeader>ff",
	-- 	"<LocalLeader>fb",
	-- 	"<LocalLeader>fB",
	-- 	"<LocalLeader>f.",
	-- },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-lua/popup.nvim",
		"nvim-telescope/telescope-symbols.nvim",
		"nvim-telescope/telescope-media-files.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-frecency.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			dependencies = { "tami5/sqlite.lua" },
		},
	},
}

function M.config()
	local telescope = require("telescope")
	local actions = require("telescope.actions")
	local sorters = require("telescope.sorters")
	local previewers = require("telescope.previewers")
	require("core.telescope.mappings")
	telescope.setup({
		defaults = {
			find_cmd = "fd",
			path_display = { "smart" },
			layout_config = { prompt_position = "top", horizontal = { width = 0.88 } },
			sorting_strategy = "ascending",
			file_ignore_patterns = {
				-- nodejs
				"node_modules",
				"dist",
				-- java
				"target",
			},
			file_sorter = sorters.get_fzy_sorter,
			prompt_prefix = " >",
			color_devicons = true,
			-- set_env = { ["COLORTERM"] = "truecolor" },
			borderchars = { "━", "┃", "━", "┃", "┏", "┓", "┛", "┗" },

			file_previewer = previewers.vim_buffer_cat.new,
			grep_previewer = previewers.vim_buffer_vimgrep.new,
			qflist_previewer = previewers.vim_buffer_qflist.new,

			mappings = { i = { ["<C-x>"] = false, ["<C-q>"] = actions.send_to_qflist } },
			history = {
				path = vim.fn.stdpath("data") .. "/databases/telescope_history.sqlite3",
				limit = 100,
			},
		},
		pickers = {
			buffers = {
				sort_lastused = true,
				mappings = {
					i = { ["<c-x>"] = require("telescope.actions").delete_buffer },
					n = { ["<c-x>"] = require("telescope.actions").delete_buffer },
				},
			},
			-- find_files = { }
		},
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = false, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case",
			},
			media_files = {
				-- filetypes whitelist
				-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
				filetypes = { "png", "webp", "jpg", "jpeg" },
			},
			frecency = {
				db_root = vim.fn.stdpath("data") .. "/databases/",
				default_workspace = "CWD",
			},
		},
	})

	require("telescope").load_extension("fzf")
	require("telescope").load_extension("media_files")
	require("telescope").load_extension("frecency")
	require("telescope").load_extension("file_browser")
	require("telescope").load_extension("git_worktree")
end

return M
