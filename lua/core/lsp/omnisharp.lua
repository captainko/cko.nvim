local lsp = require("core.utils.lsp")
local u = require("lspconfig.util")

local Methods = vim.lsp.protocol.Methods
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- capabilities.textDocument.semanticTokens = { legend = {} }

local M = {
	capabilities = capabilities,
	organize_imports_on_format = true,
	enable_import_completion = true,
	enable_roslyn_analyzers = false,
	analyze_open_documents_only = true,
	cmd = { "omnisharp" },
	-- settings = {
	-- 	csharp = {
	-- 		inlayHints = {
	-- 			parameters = {
	-- 				enabled = true,
	-- 				forLiteralParameters = true,
	-- 			},
	-- 			types = {
	-- 				enabled = true,
	-- 				forImplicitVariableTypes = true,
	-- 			},
	-- 		},
	-- 	},
	-- },
	root_dir = u.root_pattern("*.sln", ".git"),
	-- root_dir = u.root_pattern("*.sln", ".git", "*.csproj"),
	handlers = {
		[Methods.textDocument_definition] = require("omnisharp_extended").handler,
	},
}

return M
