---@type LazyPlugin
local M = {
	"jose-elias-alvarez/null-ls.nvim",
	lazy = false,
	enabled = not vim.g.vscode,
	dependencies = {
		"williamboman/mason.nvim",
		"jayp0521/mason-null-ls.nvim",
	},
}

function M.config()
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
		return utils.root_has_file(".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml", ".eslintrc.yml", ".eslintrc.json")
	end
	-- local has_stylua = lsputil.root_pattern "*stylua.toml"

	local filetype_config = { html = { disable_format = false } }

	---Customize null-ls attach
	---@param client table
	---@param bufnr number
	local function on_attach(client, bufnr)
		lsp.setup_autocommands(client, bufnr)
		lsp.setup_common_mappings(client, bufnr)

		local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
		local config = filetype_config[filetype] or {}
		local mapper = require("core.utils.mapper")

		if not config.disable_format then
			if client.server_capabilities.documentFormattingProvider then
				mapper.nnoremap({
					"<Leader><Leader>f",
					vim.lsp.buf.format,
					bufnr = bufnr,
					nowait = true,
				})
			end

			if client.server_capabilities.documentRangeFormattingProvider then
				mapper.vnoremap({
					"<Leader><Leader>f",
					vim.lsp.buf.format,
					bufnr = bufnr,
					nowait = true,
				})
			end
		end
		if not config.disable_rename and client.server_capabilities.renameProvider then
			mapper.nnoremap({ "<Leader>rr", vim.lsp.buf.rename, bufnr = bufnr, nowait = true })
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
	-- lspconfig["null-ls"].setup { on_attach = on_attach }
end

return M
