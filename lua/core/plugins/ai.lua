---@type LazyPluginSpec[]
local M = {
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
	{
		"David-Kunz/gen.nvim",
		cmd = { "Gen" },
		keys = { { mode = { "v", "n" }, "<leader>]]", "<Cmd>Gen<CR>" } },
		config = function()
			-- local gen = require("gen")
			-- gen.container = "ollama" -- default nil
			-- gen.model = "llama2" -- default nil
			require("gen").setup({
				-- model = "codellama",
				model = "mistral",
			})
		end,
	},
}

return M
