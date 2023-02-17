---@type LazyPlugin
local M = {
	"utilyre/barbecue.nvim",
	event = { "BufReadPost" },
	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons", -- optional dependency
	},
}

function M.config()
	require("barbecue").setup({
		exclude_filetypes = { "gitcommit", "toggleterm", "Trouble" },
	})
end

return M
