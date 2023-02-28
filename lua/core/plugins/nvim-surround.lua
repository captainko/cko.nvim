---@type LazyPlugin
local M = {
	"kylechui/nvim-surround",
	event = { "CursorMoved" },
}

function M.config()
	require("nvim-surround").setup({})
end

return M
