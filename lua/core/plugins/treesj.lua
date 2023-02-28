---@type LazyPlugin
local M = {
	"Wansmer/treesj",
	enabled = false,
	dependencies = { "nvim-treesitter" },
	keys = {
		{ "gS", "<Cmd>TSJSplit<CR>", noremap = true },--[[@as LazyKeys]]
		{ "gJ", "<Cmd>TSJJoin<CR>", noremap = true },
	},
}

function M.config()
	-- run config
	require("treesj").setup({
		use_default_keymaps = false,
	})
end

return M
