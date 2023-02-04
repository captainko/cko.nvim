---@type LazyPlugin
local M = {
	"tpope/vim-fugitive",
	keys = { "<LocalLeader>gs" },
	enabled = not vim.g.vscode,
}

M.config = function()
	local mapper = require("core.utils.mapper")
	local nnoremap = mapper.nnoremap
	nnoremap({ "<LocalLeader>gf", "<Cmd>diffget //2<CR>" })
	nnoremap({ "<LocalLeader>gj", "<Cmd>diffget //3<CR>" })
	nnoremap({ "<LocalLeader>gs", "<Cmd>Git<CR>" })
	nnoremap({ "<LocalLeader>gh", "<Cmd>0Gclog<CR>" })
end

return M
