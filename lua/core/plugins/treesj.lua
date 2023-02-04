---@type LazyPlugin
local M = {
	"Wansmer/treesj",
	dependencies = { "nvim-treesitter" },
	keys = {
		{ mode = "n", "gS", "<Cmd>TSJSplit<CR>", noremap = true },
		{ mode = "n", "gJ", "<Cmd>TSJJoin<CR>", noremap = true },
	},
}

function M.config()
	-- run config
	require("treesj").setup({
		use_default_keymaps = false,
	})
end

return M
