local lsp = require("core.utils.lsp")
local u = require("lspconfig.util")

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.semanticTokens = { legend = {} }

local M = {
	capabilities = capabilities,
	organize_imports_on_format = true,
	enable_import_completion = false,
	enable_roslyn_analyzers = true,
	analyze_open_documents_only = true,
	cmd = { "omnisharp" },
	root_dir = u.root_pattern("*.sln", ".git"),
	-- root_dir = u.root_pattern("*.sln", ".git", "*.csproj"),
	handlers = {
		["textDocument/definition"] = require("omnisharp_extended").handler,
	},
	on_attach = function(client, bufnr)
		-- client.server_capabilities.semanticTokensProvider = { legend = {} }
		local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
		for i, v in ipairs(tokenModifiers) do
			tokenModifiers[i] = v:gsub(" ", "_")
		end
		local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
		for i, v in ipairs(tokenTypes) do
			tokenTypes[i] = v:gsub(" ", "_")
		end
		lsp.on_attach(client, bufnr)
	end,
}

return M
