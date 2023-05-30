---@type LazyPlugin
local M = {
	"onsails/lspkind-nvim",
}

function M.config()
	require("lspkind").init({
		-- enables text annotations
		--
		-- default: true
		mode = "symbol_text",

		-- default symbol map
		-- can be either 'default' (requires nerd-fonts font) or
		-- 'codicons' for codicon preset (requires vscode-codicons font)
		--
		-- default: 'default'
		preset = "codicons",

		-- override preset symbols
		--
		-- default: {}
		-- symbol_map = kinds,
	})
end

return M
