---@type LazyPlugin
local M = {
	"stevearc/overseer.nvim",
	dependencies = {
		"Joakker/lua-json5",
	},
}

function M.config()
	-- override default jsonc parser
	require("overseer.util").decode_json = require("json5").parse
	require("overseer").setup()
end

return M
