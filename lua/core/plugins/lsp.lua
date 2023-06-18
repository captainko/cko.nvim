---@type LazyPlugin[]
local M = {
	{
		"onsails/lspkind-nvim",
		dependencies = {},
		config = function()
			require("lspkind").init({
				-- enables text annotations
				--
				-- default: true
				mode = "symbol_text",

				-- default symbol map
				-- can be either 'default' (requires nerd-fonts font) or
				-- 'codicons' for codicon preset (requires vscode-codicons font)
				--
				-- default: 'default'
				preset = "codicons",

				-- override preset symbols
				--
				-- default: {}
				-- symbol_map = kinds,
			})
		end,
	},
	{
		"lvimuser/lsp-inlayhints.nvim",
		config = function()
			require("lsp-inlayhints").setup()
		end,
	},
	{
		"simrat39/symbols-outline.nvim",
		keys = { "<Leader>to" },
		cmd = { "SymbolsOutline" },
		config = function()
			require("symbols-outline").setup()
			local mapper = require("core.utils.mapper")
			mapper.nnoremap({ "<Leader>to", "<Cmd>SymbolsOutline<CR>" })
		end,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		enabled = not vim.g.vscode,
		dependencies = {
			"williamboman/mason.nvim",
			"lvimuser/lsp-inlayhints.nvim",
			"williamboman/mason-lspconfig.nvim",
			"jose-elias-alvarez/typescript.nvim",
			"folke/neodev.nvim",
			"folke/neoconf.nvim",
			"b0o/schemastore.nvim",
		},
		config = function()
			local lsp = require("core.utils.lsp")
			local commander = require("core.utils.commander")
			local icons = require("core.global.style").icons.git

			commander.command("LspLog", function()
				vim.cmd.edit(vim.lsp.get_log_path())
			end, {})

			-- require("mason-lspconfig").setup()
			-- if vim.env.DEVELOPING then
			-- vim.lsp.set_log_level(vim.lsp.log_levels.DEBUG)
			-- end
			-- require("mason-lspconfig").setup()
			vim.diagnostic.config({
				severity_sort = true,
				signs = true,
				underline = true,
				update_on_insert = false,
			})

			-- =============================================================================
			-- Signs
			-- =============================================================================

			vim.fn.sign_define({
				{
					name = "DiagnosticSignError",
					text = icons.error,
					texthl = "DiagnosticSignError",
				},
				{
					name = "DiagnosticSignHint",
					text = icons.hint,
					texthl = "DiagnosticSignHint",
				},
				{
					name = "DiagnosticSignWarn",
					text = icons.warn,
					texthl = "DiagnosticSignWarn",
				},
				{
					name = "DiagnosticSignInfo",
					text = icons.info,
					texthl = "DiagnosticSignInfo",
				},
			})

			-- =============================================================================
			-- Handler Override
			-- =============================================================================

			vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(function(...)
				return vim.lsp.diagnostic.on_publish_diagnostics(...)
			end, { virtual_text = { prefix = "▇", spacing = 2, severity_sort = true } })

			-- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			lsp.setup_servers()
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		lazy = false,
		enabled = not vim.g.vscode,
		dependencies = {
			"williamboman/mason.nvim",
			"jayp0521/mason-null-ls.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			local lsp = require("core.utils.lsp")

			require("mason-null-ls").setup({
				ensure_installed = {
					"stylua",
					"jq",
					"prettierd",
					"stylelint",
					"goimports",
					"shellcheck",
					"uncrustify",
					"hadolint",
					"nginx_beautifier",
					"codespell",
					"csharpier",
					-- "protolint",
				},
			})
			-- local lspconfig = require "lspconfig"
			-- local helpers = require "null-ls.helpers"

			-- null_ls.register(golint)

			-- TODO: use glob for this
			local function has_stylua(utils)
				return utils.root_has_file("stylua.toml", ".stylua.toml")
			end

			local function has_prettier(utils)
				return utils.root_has_file(".prettierrc", ".prettierrc.json")
			end
			local function has_eslint(utils)
				return utils.root_has_file(
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.yaml",
					".eslintrc.yml",
					".eslintrc.json"
				)
			end
			-- local has_stylua = lsputil.root_pattern "*stylua.toml"

			local filetype_config = { html = { disable_format = false } }

			---Customize null-ls attach
			---@param client table
			---@param bufnr  number
			local function on_attach(client, bufnr)
				lsp.setup_autocommands(client, bufnr)
				lsp.setup_common_mappings(client, bufnr)

				local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
				local config = filetype_config[filetype] or {}
				local mapper = require("core.utils.mapper")

				if not config.disable_format then
					if client.server_capabilities.documentFormattingProvider then
						mapper.nnoremap({
							"<Leader><Leader>f",
							vim.lsp.buf.format,
							buffer = bufnr,
							nowait = true,
						})
					end

					if client.server_capabilities.documentRangeFormattingProvider then
						mapper.vnoremap({
							"<Leader><Leader>f",
							vim.lsp.buf.format,
							buffer = bufnr,
							nowait = true,
						})
					end
				end
				if not config.disable_rename and client.server_capabilities.renameProvider then
					mapper.nnoremap({ "<Leader>rr", vim.lsp.buf.rename, buffer = bufnr, nowait = true })
				end
			end

			null_ls.setup({
				on_attach = on_attach,
				-- debug = true,
				sources = {

					-- =============================================================================
					-- Git Actions
					-- =============================================================================

					-- null_ls.builtins.code_actions.gitsigns,

					-- =============================================================================
					-- Formatting
					-- =============================================================================

					-- null_ls.builtins.diagnostics.eslint.with({
					-- 	prefer_local = "node_modules/.bin",
					-- 	condition = function(utils)
					-- 		return has_eslint(utils) and not has_prettier(utils)
					-- 	end,
					-- }),
					-- null_ls.builtins.formatting.clang_format,

					null_ls.builtins.formatting.prettierd.with({
						filetypes = { "css", "scss", "sass", "markdown", "svelte", "vue", "yaml" },
						condition = function(utils)
							return not has_prettier(utils)
						end,
					}),

					null_ls.builtins.formatting.prettierd.with({
						filetypes = {
							"css",
							"scss",
							"sass",
							"markdown",
							"svelte",
							"vue",
							"yaml",
							"html",
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
						},
						condition = function(utils)
							return has_prettier(utils)
						end,
					}),
					-- =============================================================================
					-- CSS
					-- =============================================================================

					null_ls.builtins.diagnostics.stylelint.with({
						condition = function(utils)
							return utils.root_has_file(".stylelintrc.json")
						end,
					}),

					-- =============================================================================
					-- Lua
					-- =============================================================================

					null_ls.builtins.formatting.stylua.with({ condition = has_stylua }),

					-- use lua formatter as default
					null_ls.builtins.formatting.lua_format.with({
						condition = function(utils)
							return not has_stylua(utils)
						end,
					}),

					-- =============================================================================
					-- C Sharp
					-- =============================================================================

					null_ls.builtins.formatting.csharpier,
					-- =============================================================================
					-- Golang
					-- =============================================================================

					-- null_ls.builtins.diagnostics.golint,
					-- null_ls.builtins.formatting.gofmt,
					null_ls.builtins.formatting.goimports,

					-- =============================================================================
					-- SQL
					-- =============================================================================

					null_ls.builtins.formatting.sqlformat,

					-- =============================================================================
					-- Shell script
					-- =============================================================================

					null_ls.builtins.diagnostics.shellcheck,
					null_ls.builtins.formatting.shfmt.with({ filetypes = { "sh", "zsh" } }),

					-- =============================================================================
					-- C/C++/Java
					-- =============================================================================

					null_ls.builtins.formatting.uncrustify.with({
						filetypes = { "c", "cpp" },
					}),

					-- =============================================================================
					-- Docker
					-- =============================================================================

					null_ls.builtins.diagnostics.hadolint,

					-- =============================================================================
					-- Extras
					-- =============================================================================

					-- NGINX
					null_ls.builtins.formatting.nginx_beautifier,
					-- Protobuf
					null_ls.builtins.formatting.buf,
					-- null_ls.builtins.diagnostics.protolint,
					-- null_ls.builtins.diagnostics.buf,

					-- =============================================================================
					-- Spell
					-- =============================================================================
					-- English linter
					null_ls.builtins.diagnostics.codespell,
					-- English prose linter.
					-- null_ls.builtins.diagnostics.write_good.with({
					-- 	filetypes = { "markdown", "gitcommit" },
					-- }),
					-- null_ls.builtins.diagnostics.cspell,
					-- null_ls.builtins.diagnostics.misspell,
					-- null_ls.builtins.diagnostics.write_good.with {
					--   filetypes = { "markdown", "typescript", "lua" },
					--   extra_args = { "--no-passive" },
					-- },
				},
			})
		end,
	},

	{
		"simrat39/rust-tools.nvim",
		ft = { "rust" },
		config = function()
			local rt = require("rust-tools")
			rt.setup({
				server = require("core.lsp.rust_analyzer"),
				tools = {
					inlay_hints = {
						auto = false,
					},
				},
			})
		end,
	},
}

return M
