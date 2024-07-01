---@type LazyPluginSpec[]
local M = {
	{
		"github/copilot.vim",
		event = { "InsertEnter", cmd = "Copilot" },
		config = function(self, opts)
			local mapper = require("core.utils.mapper")

			mapper.imap({ "<C-J>", 'copilot#Accept("\\<CR>")', expr = true, replace_keycodes = false })
			-- vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
			-- 	expr = true,
			-- 	replace_keycodes = false,
			-- })
			vim.g.copilot_no_tab_map = true
		end,
	},

	-- {
	-- 	"jackMort/ChatGPT.nvim",
	-- 	enabled = false,
	-- 	cmd = { "ChatGPT", "ChatGPTActAs" },
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-telescope/telescope.nvim",
	-- 	},
	-- 	config = function()
	-- 		require("chatgpt").setup({
	-- 			-- optional configuration
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	"huggingface/hfcc.nvim",
	-- 	enabled = false,
	-- 	cmd = { "HFccToggleAutoSuggest" },
	-- 	config = function()
	-- 		require("hfcc").setup({
	-- 			model = "meta-llama/Llama-2-7b",
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	"David-Kunz/gen.nvim",
	-- 	cmd = { "Gen" },
	-- 	keys = { { mode = { "v", "n" }, "<leader>]]", "<Cmd>Gen<CR>" } },
	-- 	config = function()
	-- 		-- local gen = require("gen")
	-- 		-- gen.container = "ollama" -- default nil
	-- 		-- gen.model = "llama2" -- default nil
	-- 		require("gen").setup({
	-- 			-- model = "codellama",
	-- 			model = "mistral",
	-- 		})
	-- 	end,
	-- },
}

return M
