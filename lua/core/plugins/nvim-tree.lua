---@type LazyPlugin
local M = {
	"nvim-tree/nvim-tree.lua",
	keys = { "<Leader><c-n>" },
}

function M.config()
	local mapper = require("core.utils.mapper")
	mapper.nnoremap({ "<Leader><c-n>", "<Cmd>NvimTreeToggle<CR>" })

	local icons = require("core.global.style").icons

	icons = {
		error = icons.error,
		warning = icons.warn,
		info = icons.info,
		hint = icons.hint,
	}

	require("nvim-tree").setup({
		-- project nvim
		sync_root_with_cwd = true,
		respect_buf_cwd = false,
		prefer_startup_root = true,
		update_focused_file = {
			enable = true,
			update_root = true,
		},
		-- project nvim ~
		disable_netrw = false,
		hijack_netrw = true,
		open_on_setup = false,
		ignore_ft_on_setup = {},
		-- auto_close = false,
		auto_reload_on_write = false,
		open_on_tab = false,
		hijack_cursor = true,
		git = { enable = true, ignore = false, timeout = 500 },
		update_cwd = true,
		diagnostics = { enable = true, icons = icons },
		system_open = { cmd = nil, args = {} },
		actions = {
			open_file = {
				resize_window = true,
				window_picker = {
					exclude = { filetype = { "qf", "help", "terminal", "toggleterm" } },
				},
			},
		},

		view = {
			-- width = 35,
			width = {
				min = 35,
				max = "40%",
			},
			side = "right",
			mappings = { custom_only = false, list = {} },
		},

		renderer = {
			add_trailing = false,
			group_empty = true,
			highlight_opened_files = "name",
			icons = {
				glyphs = {
					default = "",
					symlink = "",
					git = {
						unstaged = "✗",
						staged = "✓",
						unmerged = "",
						renamed = "➜",
						untracked = "★",
						deleted = "",
						ignored = "◌",
					},
					folder = {
						default = "",
						open = "",
						empty = "",
						empty_open = "",
						symlink = "",
						symlink_open = "",
					},
				},
			},
		},
	})
end

return M
