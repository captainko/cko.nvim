---@type LazyPluginSpec
local M = {
	"klen/nvim-test",
	enabled = false,
	keys = {
		{ "<Leader>tt", "<Cmd>TestNearest<CR>" },
		{ "<Leader>tf", "<Cmd>TestFile<CR>" },
		{ "<Leader>tl", "<Cmd>TestLast<CR>" },
	},
}

function M.config()
	require("nvim-test").setup({})
end

return M
