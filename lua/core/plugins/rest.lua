---@type LazyPlugin
local M = {
	"NTBBloodbath/rest.nvim",
	ft = { "http" },
}

function M.config()
	local mapper = require("core.utils.mapper")
	mapper.nnoremap({ "<LocalLeader>rx", "<Cmd>lua require('rest-nvim').run()<CR>" })
	mapper.nnoremap({ "<LocalLeader>rp", "<Plug>RestNvimPreview<CR>" })
	-- nnoremap { "<LocalLeader>rp", "<Plug>RestNvimPreview" }
	-- nnoremap { "<LocalLeader>rl", "<Plug>RestNvimLast" }
	require("rest-nvim").setup({
		-- Open request results in a horizontal split
		result_split_horizontal = false,
		-- Skip SSL verification, useful for unknown certificates
		skip_ssl_verification = true,
		-- Highlight request on run
		highlight = { enabled = true, timeout = 150 },
		-- Jump to request line on run
		jump_to_request = false,
		result = { formatters = { json = "jq" } },
	})
end

return M
