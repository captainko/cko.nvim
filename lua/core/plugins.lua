---@type boolean
local not_has_vscode = not vim.g.vscode

---@type LazyPlugin[]
local M = {
	{ "nvim-lua/plenary.nvim" },
	{ "tweekmonster/startuptime.vim", cmd = { "StartupTime" } },
	{ "nvim-lua/popup.nvim" },
	{ "mg979/vim-visual-multi", keys = { "<C-n>" } },
	-- { "tpope/vim-sleuth", event = { "VeryLazy" }, enabled = not_has_vscode },
	{ "tpope/vim-repeat" },
	{ "tpope/vim-surround", event = { "VeryLazy" } }, -- Surround
	{ "rbong/vim-flog", dependencies = { "vim-fugitive" }, enabled = not_has_vscode },
	{ "gpanders/editorconfig.nvim", enabled = not_has_vscode, event = { "VeryLazy" } },
	{
		"mbbill/undotree",
		event = { "VeryLazy" },
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
		keys = { { "ga" }, { mode = "x", "ga" } },
		config = function()
			local mapper = require("core.utils.mapper")
			mapper.xmap({ "ga", "<Plug>(EasyAlign)" })
			mapper.nmap({ "ga", "<Plug>(EasyAlign)" })
		end,
	},
	{ "mfussenegger/nvim-jdtls", enabled = not_has_vscode },
	{ "Decodetalkers/csharpls-extended-lsp.nvim", enabled = not_has_vscode },
	{ "Hoffs/omnisharp-extended-lsp.nvim", enabled = not_has_vscode },
	{
		"heavenshell/vim-jsdoc",
		ft = { "js", "jsx", "ts", "tsx", "vue" },
		cmd = { "JsDoc" },
		build = "make install",
		config = function()
			local mapper = require("core.utils.mapper")
			mapper.nnoremap({ "<leader><C-l>", "<Cmd>JsDoc<CR>" })
		end,
	},
	{
		"williamboman/mason.nvim",
		enabled = not_has_vscode,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		enabled = not_has_vscode,
		config = function()
			require("mason-lspconfig").setup()
		end,
	},

	{
		"haringsrob/nvim_context_vt",
		event = { "VeryLazy" },
		config = function()
			require("nvim_context_vt").setup({})
		end,
	},
	{
		"nvim-treesitter/playground",
		cmd = { "TSPlaygroundToggle" },
		keys = { "<Leader>tp" },
		config = function()
			local mapper = require("core.utils.mapper")
			mapper.nnoremap({ "<Leader>tp", "<Cmd>TSPlaygroundToggle<CR>" })
		end,
	},
	{
		"akinsho/git-conflict.nvim",
		enabled = not_has_vscode,
		event = { "VeryLazy" },
		config = function()
			require("git-conflict").setup()
		end,
	},
	{ "Joakker/lua-json5", build = "./install.sh" },
	{
		"saecki/crates.nvim",
		enabled = not_has_vscode,
		ft = { "rust", "toml" },
		-- tag = "v0.2.1",
		config = function()
			require("crates").setup({
				null_ls = {
					enabled = true,
					name = "crates.nvim",
				},
			})

			vim.api.nvim_create_autocmd("BufRead", {
				group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
				pattern = "Cargo.toml",
				callback = function()
					require("cmp").setup.buffer({ sources = { { name = "crates" } } })
				end,
			})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		enabled = not_has_vscode,
		build = "cd app && yarn install",
		ft = { "markdown" },
		config = function()
			vim.g.mkdp_auto_start = 0
			vim.g.mkdp_auto_close = 1
		end,
	},
	{
		"mattn/emmet-vim",
		enabled = not_has_vscode,
		ft = { "html", "css", "vue", "javascriptreact", "typescriptreact" },
		init = function()
			vim.g.user_emmet_leader_key = "<C-y>"
			vim.g.user_emmet_install_global = false
		end,
		config = function()
			local commander = require("core.utils.commander")
			commander.augroup("FileTypeEmmetInstall", {
				{
					event = "FileType",
					pattern = { "html", "css" },
					once = true,
					nested = true,
					command = "EmmetInstall",
				},
			})
			vim.api.nvim_command([[do FileTypeEmmetInstall]])
		end,
	},
	{
		"ray-x/go.nvim",
		enabled = not_has_vscode,
		ft = { "go" },
		config = function()
			require("go").setup()
		end,
	},
	{ "chrisbra/csv.vim", ft = { "csv" }, enabled = not_has_vscode },
	{ "chr4/nginx.vim", ft = { "nginx" }, enabled = not_has_vscode },
	{ "baskerville/vim-sxhkdrc", ft = { "sxhkdrc" }, enabled = not_has_vscode },
	{ "towolf/vim-helm", ft = { "helm" }, enabled = not_has_vscode },
}

return M
