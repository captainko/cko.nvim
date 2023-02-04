-- Thank @akinsho again!

---@type LazyPlugin
local M = {
	"neovim/nvim-lspconfig",
	lazy = false,
	enabled = not vim.g.vscode,
	dependencies = {
		"williamboman/mason.nvim",
		"lvimuser/lsp-inlayhints.nvim",
		"williamboman/mason-lspconfig.nvim",
		"jose-elias-alvarez/typescript.nvim",
		"folke/neodev.nvim",
		"b0o/schemastore.nvim",
	},
}

function M.config()
	local lsp = require("core.utils.lsp")
	local commander = require("core.utils.commander")

	commander.command("LspLog", function()
		vim.api.nvim_command("edit " .. vim.lsp.get_log_path())
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

	local icons = require("core.global.style").icons.git
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

	local publishDiagnostics = vim.lsp.with(function(...)
		---@diagnostic disable-next-line: missing-parameter
		return vim.lsp.diagnostic.on_publish_diagnostics(...)
	end, { virtual_text = { prefix = "▇", spacing = 2, severity_sort = true } })

	vim.lsp.handlers["textDocument/publishDiagnostics"] = publishDiagnostics

	-- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	lsp.setup_servers()
end

return M

-- =============================================================================
-- }}}
-- =============================================================================

-- vim: foldmethod=marker :
