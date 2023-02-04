local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
local M = {
	-- root_dir = u.root_pattern("package.json", "node_modules", ".git"),
	capabilities = capabilities,
}

return M
