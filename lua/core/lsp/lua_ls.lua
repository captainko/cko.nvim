local lsp = require("core.utils.lsp")
local api = vim.api
require("neodev").setup({
	setup_jsonls = false,
})
-- library = {
--  vimruntime = true, -- runtime path
--  types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
--  plugins = true, -- installed opt or start plugins in packpath
--  -- you can also specify the list of plugins to make available as a workspace library
--  -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
-- },
local M = {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT", special = { ["R"] = "require", ["PR"] = "require" } },
			diagnostics = {
				globals = {
					"vim",
					"describe",
					"it",
					"before_each",
					"after_each",
					"pending",
					"clear",
					"teardown",
					"packer_plugins",
				},
			},
			completion = { keywordSnippet = "Replace", callSnippet = "Replace" },
			hint = { enable = true },
			telemetry = { enable = false },
			workspace = {
				checkThirdParty = false,
			},
		},
	},
	on_attach = function(client, bufnr)
		-- if vim.g.use_stylua then
		if true then
			lsp.disable_formatting(client)
			lsp.on_attach(client, bufnr)
		end
	end,
}

M.extras = {
	hover = function(word)
		local original_iskeyword = vim.bo.iskeyword
		vim.bo.iskeyword = vim.bo.iskeyword .. ",."

		---@diagnostic disable-next-line: missing-parameter
		word = word or vim.fn.expand("<cword>")

		vim.bo.iskeyword = original_iskeyword

		-- TODO: This is kind of a lame hack... since you could rename `vim.api` -> `a` or similar
		if string.find(word, "vim.api") then
			local _, finish = string.find(word, "vim.api.")
			local api_function = string.sub(word, finish + 1)

			api.nvim_command("help " .. api_function)
			return
		elseif string.find(word, "vim.fn") then
			local _, finish = string.find(word, "vim.fn.")
			local api_function = string.sub(word, finish + 1) .. "()"

			api.nvim_command("help " .. api_function)
			return
		else
			-- TODO: This should be exact match only. Not sure how to do that with `:help`
			-- TODO: Let users determine how magical they want the help finding to be
			local ok = pcall(api.nvim_command, "help " .. word)

			if not ok then
				local split_word = vim.split(word, ".", true)
				ok = pcall(api.nvim_command, "help " .. split_word[#split_word])
			end

			if not ok then
				vim.lsp.buf.hover()
			end
		end
	end,
}

return M
