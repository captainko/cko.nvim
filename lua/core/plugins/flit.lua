---@type LazyPlugin
local M = {
	"ggandor/flit.nvim",
	enabled = false,
	dependencies = { "ggandor/leap.nvim" },
	lazy = false,
}

function M.config()
	require("flit").setup()
end

return M
