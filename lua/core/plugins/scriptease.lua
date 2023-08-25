---@type LazyPluginSpec
local M = {
	"tpope/vim-scriptease",
	keys = { "<Leader><Leader>m" },
	cmd = { "Messages" },
}

function M.config()
	local mapper = require("core.utils.mapper")
	local nnoremap = mapper.nnoremap
	nnoremap({ "<Leader><Leader>m", "<Cmd>Messages<CR>" })
	nnoremap({ "<Leader><Leader>M", "<Cmd>Messages clear<CR>" })
end

return M
