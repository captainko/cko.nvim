---@type LazyPlugin
local M = {
	"ahmedkhalf/project.nvim",
	event = { "VeryLazy" },
}

function M.config()
	require("project_nvim").setup({
		manual_mode = false,
		patterns = {
			".mvn",
			".sln",
			".git",
			"_darcs",
			".hg",
			".bzr",
			".svn",
			"Makefile",
			"package.json",
			"!>packages",
			"!>src",
			-- "*.csproj",
		},
		ignore_lsp = {
			"bashls",
			"dockerls",
			"eslint",
			"graphql",
			"jsonc",
			"jsonls",
			"null-ls",
			"tailwindcss",
			"yamlls",
			-- "lemminx",
			"null-ls",
		},
	})
end

return M
