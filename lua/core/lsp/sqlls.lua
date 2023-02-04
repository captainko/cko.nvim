local lsp = require("core.utils.lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.formatting = nil

local M = {
	cmd = { "sql-language-server", "up", "--method", "stdio" },
	on_init = function(client)
		lsp.disable_formatting(client)
	end,
}
return M
