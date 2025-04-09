---@type LazyPluginSpec
local M = {
	"NTBBloodbath/rest.nvim",
	ft = { "http" },
	enabled = false,
}

function M.config()
	local rest_nvim = require("rest-nvim")
	local commander = require("core.utils.commander")

	rest_nvim.setup({
		-- Open request results in a horizontal split
		result_split_horizontal = false,
		-- Skip SSL verification, useful for unknown certificates
		skip_ssl_verification = true,
		-- Highlight request on run
		highlight = { enabled = true, timeout = 150 },
		-- Jump to request line on run
		-- jump_to_request = false,
		result = { formatters = { json = "jq" } },
	})

	commander.augroup("RestNvimAugroup", {
		{
			event = "FileType",
			pattern = "http",
			command = function(event)
				local mapper = require("core.utils.mapper")
				mapper.nnoremap({ "<LocalLeader>rx", rest_nvim.run, buffer = event.buf })
				mapper.nnoremap({ "<LocalLeader>rp", "<Plug>RestNvimPreview<CR>", buffer = event.buf })
			end,
		},
	})
end

return M
