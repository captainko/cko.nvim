---@type LazyPlugin
local M = {
	"j-hui/fidget.nvim",
	event = { "VeryLazy" },
}

function M.config()
	require("fidget").setup()
end

return M
