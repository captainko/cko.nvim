local u = require("lspconfig.util")

local M = {
	-- root_dir=
	root_dir = u.root_pattern("*.sln", ".git"),
	-- root_dir = u.root_pattern("*.sln", ".git", "*.csproj"),
	handlers = {
		["textDocument/definition"] = require("csharpls_extended").handler,
	},
	-- on_attach = function(client, bufnr)
	-- 	cko.nnoremap({ "gd", require("csharpls_extended").lsp_definitions, bufnr = bufnr })
	-- end,
}

return M
