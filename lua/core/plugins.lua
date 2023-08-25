---@type boolean
local not_has_vscode = not vim.g.vscode

---@type LazyPluginSpec[]
local M = {
	{ "tweekmonster/startuptime.vim", cmd = { "StartupTime" } },
	{
		"heavenshell/vim-jsdoc",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
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
		"akinsho/git-conflict.nvim",
		enabled = not_has_vscode,
		event = { "VeryLazy" },
		keys = {
			{ "<LocalLeader>co", "<Plug>(git-conflict-ours)" },
			{ "<LocalLeader>ct", "<Plug>(git-conflict-theirs)" },
			{ "<LocalLeader>cb", "<Plug>(git-conflict-both)" },
			{ "<LocalLeader>c0", "<Plug>(git-conflict-none)" },
			{ "]x", "<Plug>(git-conflict-prev-conflict)" },
			{ "[x", "<Plug>(git-conflict-next-conflict)" },
		},
		config = function()
			require("git-conflict").setup({ default_mappings = false })
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
