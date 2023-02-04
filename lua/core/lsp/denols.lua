local u = require("lspconfig.util")

local M = {
	root_dir = u.root_pattern("deno.json", "deno.jsonc"),
}

return M
