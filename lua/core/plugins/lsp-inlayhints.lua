---@type LazyPlugin
local M = {
	"lvimuser/lsp-inlayhints.nvim",
}

function M.config()
	require("lsp-inlayhints").setup()
end

return M
