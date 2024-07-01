---@type LazyPluginSpec
local M = {
	"lewis6991/gitsigns.nvim",
	event = { "VeryLazy" },
}

M.config = function()
	local mapper = require("core.utils.mapper")
	local icons = require("core.global.style").icons.git
	mapper.nnoremap({ "<Leader>tb", "<Cmd>Gitsigns toggle_current_line_blame<CR>" })

	local gs = require("gitsigns")
	gs.setup({
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
		on_attach = function()
			-- Navigation
			mapper.nmap({
				"]c",
				function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(gs.next_hunk)
					return "<Ignore>"
				end,
				expr = true,
			})
			mapper.nmap({
				"[c",
				function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(gs.prev_hunk)
					return "<Ignore>"
				end,
			})

			-- Actions
			mapper.nmap({ "<leader>hs", gs.stage_hunk })
			mapper.nmap({ "<leader>hr", gs.reset_hunk })
			mapper.vmap({
				"<leader>hs",
				function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
			})
			mapper.vmap({
				"<leader>hr",
				function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
			})
			mapper.nmap({ "<leader>hS", gs.stage_buffer })
			mapper.nmap({ "<leader>hS", gs.reset_buffer })
			mapper.nmap({ "<leader>hu", gs.undo_stage_hunk })
			mapper.nmap({ "<leader>hp", gs.preview_hunk })
			mapper.nmap({
				"<leader>hb",
				function()
					gs.blame_line({ full = true })
				end,
			})
			mapper.nmap({
				"<leader>tb",
				gs.toggle_current_line_blame,
			})

			mapper.nmap({
				"<leader>td",
				gs.toggle_deleted,
			})

			-- Text object
			mapper.multi_map({ "o", "x" }, { "ih", ":<C-U>Gitsigns select_hunk<CR>" })
		end,
		watch_gitdir = { interval = 1000, follow_files = true },
		attach_to_untracked = true,
		current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			delay = 500,
		},
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
	})
end

return M
