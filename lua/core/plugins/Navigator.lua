---@type LazyPlugin
local M = {
	"numToStr/Navigator.nvim",
	keys = {
		"<C-h>",
		"<C-k>",
		"<C-l>",
		"<C-j>",
	},
}

function M.config()
	local navigator = require("Navigator")
	navigator.setup({ auto_save = nil, disable_on_zoom = true })

	local mapper = require("core.utils.mapper")
	local nnoremap = mapper.nnoremap
	nnoremap({ "<C-h>", navigator.left })
	nnoremap({ "<C-k>", navigator.up })
	nnoremap({ "<C-l>", navigator.right })
	nnoremap({ "<C-j>", navigator.down })
end

return M
