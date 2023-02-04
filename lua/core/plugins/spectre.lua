---@type LazyPlugin
local M = {
	"windwp/nvim-spectre",
	keys = { "<LocalLeader>S", "<LocalLeader>s" },
}

function M.config()
	local spectre = require("spectre")
	local mapper = require("core.utils.mapper")
	local nnoremap = mapper.nnoremap
	local vnoremap = mapper.vnoremap
	nnoremap({ "<LocalLeader>S", spectre.open })
	nnoremap({
		"<LocalLeader>sw",
		function()
			spectre.open_visual({ select_word = true })
		end,
	})
	vnoremap({ "<LocalLeader>s", spectre.open })
	nnoremap({
		"<LocalLeader>sp",
		"viw :lua require('spectre').open_file_search()<CR>",
	})
	-- NOTE: keep this in case I go back to horizon
	-- write your custom open function
	local search_phuquy = function()
		spectre.open({
			is_insert_mode = false,
			search_text = "phuquy",
			replace_text = "phuquy",
			path = "src/app/services/*.service.ts",
		})
	end
	nnoremap({ "<LocalLeader>sq", search_phuquy })
end

return M
