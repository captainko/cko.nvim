---@type LazyPluginSpec
local M = {
	"Matt-A-Bennett/vim-surround-funk",
	event = { "VeryLazy" },
}

function M.config()
	vim.g.surround_funk_create_mappings = 0

	local mapper = require("core.utils.mapper")
	local nnoremap = mapper.nnoremap
	-- operator pending mode: grip surround
	-- map({ "n", "v" }, "gs", "<Plug>(GripSurroundObject)")
	-- map({ "o", "x" }, "sF", "<Plug>(SelectWholeFUNCTION)")
	mapper.multi_map({ "o", "x" }, { "sF", "<Plug>(SelectWholeFUNCTION)" })
	mapper.multi_map({ "n", "v" }, { "gs", "<Plug>(GripSurroundObject)" })

	nnoremap({ "ysf", "<Plug>(YankSurroundingFUNCTION)" }) -- outer function
	nnoremap({ "ysF", "<Plug>(YankSurroundingFunction)" })

	nnoremap({ "dsf", "<Plug>(DeleteSurroundingFUNCTION)" }) -- outer function
	nnoremap({ "dsF", "<Plug>(DeleteSurroundingFunction)" })

	nnoremap({ "csf", "<Plug>(ChangeSurroundingFUNCTION)" }) -- outer function
	nnoremap({ "csF", "<Plug>(ChangeSurroundingFunction)" })
end

return M
