---@type LazyPlugin
local M = {
	"L3MON4D3/LuaSnip",
	event = { "InsertEnter" },
	dependencies = { "rafamadriz/friendly-snippets" },
}

function M.config()
	local mapper = require("core.utils.mapper")
	mapper.nnoremap({ "<leader>cs", "<Cmd>LuaSnipUnlinkCurrent<CR>" })
	mapper.imap({ "<C-E>", "<Plug>luasnip-next-choice" })
	mapper.smap({ "<C-E>", "<Plug>luasnip-next-choice" })

	local ls = require("luasnip")
	local types = require("luasnip.util.types")
	ls.config.set_config({
		history = true,
		updateevents = "TextChanged,TextChangedI",
		region_check_events = "CursorMoved,CursorHold,InsertEnter",
		delete_check_events = "TextChanged",
		ext_opts = {
			[types.choiceNode] = { active = { virt_text = { { "c", "Operator" } } } },
			[types.insertNode] = { active = { virt_text = { { "i", "Type" } } } },
		},
		enable_autosnippets = true,
		store_selection_keys = "<Tab>",
	})
	ls.filetype_extend("NeogitCommitMessage", { "gitcommit" })
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_lua").lazy_load()

	-- NOTE: don't work
	-- require("luasnip/loaders/from_vscode").lazy_load {
	--   paths = { "./snippets/textmate" },
	-- }
end

return M
