---@type LazyPlugin
local M = {
	"lewis6991/gitsigns.nvim",
	event = { "VeryLazy" },
}

M.config = function()
	local mapper = require("core.utils.mapper")
	local icons = require("core.global.style").icons.git
	mapper.nnoremap({ "<Leader>tb", "<Cmd>Gitsigns toggle_current_line_blame<CR>" })

	require("gitsigns").setup({
		signs = {
			add = { text = icons.add },
			change = { text = icons.change },
			delete = { text = icons.delete },
			topdelete = { text = icons.top_delete },
			changedelete = { text = icons.change_delete },
		},
		signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
		numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
		linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
		word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
		-- keymap = nil, -- TODO: add keymaps
		keymaps = {
			--   -- Default keymap options
			noremap = true,

			["n ]c"] = {
				expr = true,
				"&diff ? ']c' : '<Cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'",
			},
			["n [c"] = {
				expr = true,
				"&diff ? '[c' : '<Cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'",
			},

			["n <Leader>hp"] = '<Cmd>lua require"gitsigns".preview_hunk()<CR>',
			["n <Leader>hs"] = '<Cmd>lua require"gitsigns".stage_hunk()<CR>',
			["v <Leader>hs"] = '<Cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
			["n <Leader>hu"] = '<Cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
			["n <Leader>hr"] = '<Cmd>lua require"gitsigns".reset_hunk()<CR>',
			["v <Leader>hr"] = '<Cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
			--   ["n <Leader>hR"] = "<Cmd>lua require\"gitsigns\".reset_buffer()<CR>",
			--   ["n <Leader>hp"] = "<Cmd>lua require\"gitsigns\".preview_hunk()<CR>",
			--   ["n <Leader>hb"] = "<Cmd>lua require\"gitsigns\".blame_line(true)<CR>",
			--   ["n <Leader>hS"] = "<Cmd>lua require\"gitsigns\".stage_buffer()<CR>",
			--   ["n <Leader>hU"] = "<Cmd>lua require\"gitsigns\".reset_buffer_index()<CR>",

			--   -- Text objects
			["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
			["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
		},
		watch_gitdir = { interval = 1000, follow_files = true },
		attach_to_untracked = true,
		current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			delay = 500,
		},
		current_line_blame_formatter_opts = { relative_time = false },
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil, -- Use default
		max_file_length = 40000,
		preview_config = {
			-- Options passed to nvim_open_win
			border = "single",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
		diff_opts = { internal = true },
		-- use_internal_diff = true, -- If vim.diff or luajit is present
		yadm = { enable = false },
	})
end

return M
