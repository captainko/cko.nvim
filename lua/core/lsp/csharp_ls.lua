local u = require("lspconfig.util")

local M = {
	-- root_dir=
	-- root_dir = u.root_pattern("*.sln"),
	root_dir = function(startpath)
		return u.root_pattern("*.sln")(startpath)
			or u.root_pattern("*.csproj")(startpath)
			or u.root_pattern("*.fsproj")(startpath)
			or u.root_pattern(".git")(startpath)
	end,
	-- root_dir = u.root_pattern("*.sln", ".git", "*.csproj"),
	handlers = {
		["textDocument/definition"] = require("csharpls_extended").handler,
	},
	-- on_attach = function(client, bufnr)
	-- 	cko.nnoremap({ "gd", require("csharpls_extended").lsp_definitions, bufnr = bufnr })
	-- end,
}

return M
