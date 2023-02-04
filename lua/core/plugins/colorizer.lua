---@type LazyPlugin
local M = {
	"norcalli/nvim-colorizer.lua",
	event = { "VeryLazy" },
}

function M.config()
	require("colorizer").setup({ "*", "!fugitive", "!gitcommit" })
end

return M
