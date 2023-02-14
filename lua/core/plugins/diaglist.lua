---@type LazyPlugin
local M = {
	"onsails/diaglist.nvim",
	event = { "User LspDiagnosticsChanged" },
	keys = {
		-- {
		-- 	"<Leader>xw",
		-- 	function()
		-- 		require("diaglist").open_buffer_diagnostics()
		-- 	end,
		-- },
		{
			"<Leader>xw",
			function()
				require("diaglist").open_all_diagnostics()
			end,
		},
	},
}

function M.config()
	-- run config
	require("diaglist").init({})
end

return M
