---@type LazyPluginSpec
local M = {
	"phaazon/hop.nvim",
	event = { "CursorMoved" },
	enabled = false,
}

function M.config()
	local hop = require("hop")

	hop.setup({ keys = "etovxqpdygfblzhckisuran" })

	local directions = require("hop.hint").HintDirection

	vim.keymap.set("", "f", function()
		hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false })
	end, { remap = true })
	vim.keymap.set("", "F", function()
		hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false })
	end, { remap = true })
	vim.keymap.set("", "t", function()
		hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false, hint_offset = -1 })
	end, { remap = true })
	vim.keymap.set("", "T", function()
		hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false, hint_offset = 1 })
	end, { remap = true })
end

return M
