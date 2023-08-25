---@type LazyPluginSpec
local M = {
	"szw/vim-maximizer",
	keys = { "<Leader>tz" },
}

function M.config()
	vim.g.maximizer_default_mapping_key = "<Leader>tz"
	vim.g.maximizer_restore_on_winleave = 1
	local mapper = require("core.utils.mapper")
	mapper.tnoremap({
		vim.g.maximizer_default_mapping_key,
		"<C-\\><C-n><Cmd>MaximizerToggle<CR>",
	})
end

return M
