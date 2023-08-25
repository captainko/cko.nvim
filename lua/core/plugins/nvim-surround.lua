---@type LazyPluginSpec
local M = {
	"kylechui/nvim-surround",
	enabled = false,
	event = { "CursorMoved" },
}

function M.config()
	require("nvim-surround").setup({})
end

return M
