---@type LazyPlugin
local M = {
	"simrat39/rust-tools.nvim",
	ft = { "rust" },
}

function M.config()
	local rt = require("rust-tools")
	rt.setup({
		server = require("core.lsp.rust_analyzer"),
		tools = {
			inlay_hints = {
				auto = false,
			},
		},
	})
end

return M
