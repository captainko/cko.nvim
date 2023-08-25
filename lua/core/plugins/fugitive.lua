---@type LazyPluginSpec
local M = {
	"tpope/vim-fugitive",
	keys = {
		{ "<LocalLeader>gf", "<Cmd>diffget //2<CR>" },
		{ "<LocalLeader>gj", "<Cmd>diffget //3<CR>" },
		{ "<LocalLeader>gs", "<Cmd>Git<CR>" },
		{ "<LocalLeader>gh", "<Cmd>0Gclog<CR>" },
	},
	enabled = not vim.g.vscode,
}

return M
