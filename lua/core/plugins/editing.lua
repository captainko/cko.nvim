local not_has_vscode = not vim.g.vscode

---@type LazyPlugin[]
local M = {
	{ "mg979/vim-visual-multi", keys = { "<C-n>" } },
	-- { "tpope/vim-sleuth", event = { "VeryLazy" }, enabled = not_has_vscode },
	{ "tpope/vim-repeat" },
	{ "tpope/vim-surround", event = { "VeryLazy" } }, -- Surround
	{ "rbong/vim-flog", dependencies = { "vim-fugitive" }, enabled = not_has_vscode },
	{ "gpanders/editorconfig.nvim", enabled = not_has_vscode, event = { "VeryLazy" } },
	{
		"mbbill/undotree",
		lazy = false,
		enabled = not_has_vscode,
		config = function()
			local mapper = require("core.utils.mapper")
			vim.o.undofile = true
			vim.o.undodir = vim.fn.stdpath("data") .. "/undodir"
			mapper.nnoremap({ "<Leader>tu", "<Cmd>UndotreeToggle<CR>" })
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = { "InsertEnter" },
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
				fast_wrap = {},
				map_cr = true,
			})
		end,
	},
	{
		"junegunn/vim-easy-align",
		keys = {
			{ "ga", "<Plug>(EasyAlign)", remap = true },
			{ mode = "x", "ga", "<Plug>(EasyAlign)", remap = true },
		},
	},
}

return M
