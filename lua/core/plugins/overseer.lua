---@type LazyPlugin
local M = {
	"stevearc/overseer.nvim",
	dependencies = {
		"Joakker/lua-json5",
	},
}

function M.config()
	require("overseer").setup()
	-- override default jsonc parser
	require("overseer.util").decode_json = require("json5").parse
end

return M
