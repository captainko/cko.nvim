local lsp = require("core.utils.lsp")
local default_capabilities = vim.lsp.protocol.make_client_capabilities()
default_capabilities.textDocument.completion.editsNearCursor = true
default_capabilities.offsetEncoding = "utf-8"
-- {
-- 	textDocument = {
-- 		completion = {
-- 			editsNearCursor = true,
-- 		},
-- 	},
-- }
local M = {

	capabilities = default_capabilities,

	on_attach = function(client, bufnr)
		-- cko.lsp.disable_formatting(client)
		lsp.on_attach(client, bufnr)
	end,
}

return M
