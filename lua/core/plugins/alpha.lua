---@type LazyPlugin
local M = {
	"goolord/alpha-nvim",
	lazy = false,
}

function M.config()
	require("alpha").setup(require("alpha.themes.startify").config)
end

return M
