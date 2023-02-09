local M = {
	"utilyre/barbecue.nvim",
	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons", -- optional dependency
	},
	event = { "BufReadPost" },
}

function M.config()
	require("barbecue").setup({
		exclude_filetypes = { "gitcommit", "toggleterm", "Trouble" },
	})
end

return M
