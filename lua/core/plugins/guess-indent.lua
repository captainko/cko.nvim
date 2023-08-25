---@type LazyPluginSpec
local M = {
	"nmac427/guess-indent.nvim",
	enabled = not vim.g.vscode,
	event = { "BufReadPre" },
}

function M.config()
	require("guess-indent").setup({
		auto_cmd = true, -- Set to false to disable automatic execution
		filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
			"netrw",
			"tutor",
			"Outline",
			"NvimTree",
		},
		buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
			"help",
			"nofile",
			"terminal",
			"prompt",
		},
	})
end

return M
