---@type LazyPluginSpec
local M = {
	"folke/neoconf.nvim",
}

function M.config()
	require("neoconf").setup({})
end

return M
