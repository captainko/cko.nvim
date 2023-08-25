---@type LazyPluginSpec
local M = {
	"David-Kunz/treesitter-unit",
	event = { "CursorMoved" },
}

function M.config()
	local mapper = require("core.utils.mapper")
	mapper.xnoremap({ "iu", '<Cmd>lua require("treesitter-unit").select()<CR>' })
	mapper.xnoremap({
		"au",
		'<Cmd>lua require("treesitter-unit").select(true)<CR>',
	})
	mapper.onoremap({ "iu", '<Cmd>lua require("treesitter-unit").select()<CR>' })
	mapper.onoremap({
		"au",
		'<Cmd>lua require("treesitter-unit").select(true)<CR>',
	})
end

return M
