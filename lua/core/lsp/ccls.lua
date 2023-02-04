local u = require("lspconfig.util")

local M = {
	root_dir = u.root_pattern("grammar.json", "compile_command.json", ".ccls", ".git"),
}

return M
