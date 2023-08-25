---@type LazyPluginSpec
local M = {
	"ggandor/leap.nvim",
	enabled = false,
	lazy = false,
}

function M.config()
	require("leap").add_default_mappings()
end

return M
