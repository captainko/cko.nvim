---@type LazyPluginSpec
local M = {
	"akinsho/toggleterm.nvim",
	keys = { "<c-`>", "<LocalLeader>gg" },
}

function M.config()
	local toggleterm = require("toggleterm")
	local border = require("core.global.style").border
	toggleterm.setup({
		-- size can be a number or function which is passed the current terminal
		size = function(term)
			if term.direction == "horizontal" then
				return 18
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.3
			end
		end,
		open_mapping = [[<Leader><C-`>]],
		hide_numbers = false, -- hide the number column in toggleterm buffers
		shade_filetypes = {},
		shade_terminals = false,
		shading_factor = 0.4, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
		start_in_insert = true,
		insert_mappings = true, -- whether or not the open mapping applies in insert mode
		persist_size = true,
		direction = "horizontal", -- | 'vertical'  | 'window' | 'float',
		close_on_exit = true, -- close the terminal window when the process exits
		shell = vim.o.shell, -- change the default shell
		-- This field is only relevant if direction is set to 'float'
		float_opts = {
			-- The border key is *almost* the same as 'nvim_open_win'
			-- see :h nvim_open_win for details on borders however
			-- the 'curved' border is a custom border type
			-- not natively supported but implemented in this plugin.
			-- border = "single", -- | 'double' | 'shadow' | 'curved' | ... other options supported by win open
			border = border,
			-- width = <value>,
			-- height = <value>,
			-- winblend = 10,
			highlights = { border = "Normal", background = "Terminal" },
		},
	})
	local mapper = require("core.utils.mapper")
	local tnoremap = mapper.tnoremap

	local Terminal = require("toggleterm.terminal").Terminal

	local lazydocker = Terminal:new({
		count = 9,
		cmd = "lazydocker",
		shade_terminals = false,
		-- dir = "git_dir",
		direction = "float",
		hidden = true,
		float_opts = { border = "single" },
		start_in_insert = true,
		-- function to run on opening the terminal
		---@param term Terminal
		on_open = function(term)
			tnoremap({
				"<C-q>",
				function()
					term:close()
				end,
				buffer = term.bufnr,
			})

			tnoremap({ "<C-h>", "<C-h>", buffer = term.bufnr })
			tnoremap({ "<C-j>", "<C-j>", buffer = term.bufnr })
			tnoremap({ "<C-k>", "<C-k>", buffer = term.bufnr })
			tnoremap({ "<C-l>", "<C-l>", buffer = term.bufnr })
		end,
	})

	local lazygit = Terminal:new({
		count = 8,
		-- id = 101,
		cmd = "lazygit",
		shade_terminals = false,
		-- dir = "git_dir",
		direction = "float",
		hidden = true,
		float_opts = { border = "single" },
		start_in_insert = true,
		-- function to run on opening the terminal
		---@param term Terminal
		on_open = function(term)
			tnoremap({
				"<c-q>",
				function()
					term:close()
				end,
				buffer = term.bufnr,
			})
			tnoremap({ "<C-h>", "<C-h>", silent = true, buffer = term.bufnr })
			tnoremap({ "<C-j>", "<C-j>", silent = true, buffer = term.bufnr })
			tnoremap({ "<C-k>", "<C-k>", silent = true, buffer = term.bufnr })
			tnoremap({ "<C-l>", "<C-l>", silent = true, buffer = term.bufnr })
		end,
	})

	local function lazydocker_toggle()
		lazydocker:toggle()
	end
	local function lazygit_toggle()
		lazygit:toggle()
	end

	mapper.nnoremap({ "<LocalLeader>gg", lazygit_toggle })
	mapper.nnoremap({ "<LocalLeader>dd", lazydocker_toggle })

	local function set_terminal_keymaps(event)
		tnoremap({ "<C-`>", [[<C-\><C-n><Cmd>ToggleTermToggleAll<CR>]] })
		tnoremap({
			"<C-h>",
			"<C-\\><C-n><Cmd>lua require'Navigator'.left()<CR>",
			buffer = event.buf,
		})
		tnoremap({
			"<C-k>",
			"<C-\\><C-n><Cmd>lua require'Navigator'.up()<CR>",
			buffer = event.buf,
		})
		tnoremap({
			"<C-j>",
			"<C-\\><C-n><Cmd>lua require'Navigator'.down()<CR>",
			buffer = event.buf,
		})
		tnoremap({
			"<C-l>",
			"<C-\\><C-n><Cmd>lua require'Navigator'.right()<CR>",
			buffer = event.buf,
		})
	end

	vim.api.nvim_create_autocmd("TermOpen", {
		pattern = "term://*",
		callback = set_terminal_keymaps,
	})

	mapper.nnoremap({
		"<C-`>",
		function()
			toggleterm.toggle(1)
			toggleterm.toggle(2)
			toggleterm.toggle(3)
		end,
	})
end

return M
