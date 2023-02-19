---@type LazyPlugin
local M = {
	"utilyre/barbecue.nvim",
	enabled = not vim.g.started_by_firenvim,
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
