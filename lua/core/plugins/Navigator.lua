---@type LazyPluginSpec
local M = {
	"numToStr/Navigator.nvim",
	keys = {
		{
			"<C-h>",
			function()
				require("Navigator").left()
			end,
		},
		{
			"<C-k>",
			function()
				require("Navigator").up()
			end,
		},
		{
			"<C-l>",
			function()
				require("Navigator").right()
			end,
		},
		{
			"<C-j>",
			function()
				require("Navigator").down()
			end,
		},
	},
}

function M.config()
	require("Navigator").setup({ auto_save = nil, disable_on_zoom = true })
end

return M
