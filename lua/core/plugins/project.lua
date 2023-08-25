---@type LazyPluginSpec
local M = {
	"ahmedkhalf/project.nvim",
	event = { "VeryLazy" },
}

function M.config()
	require("project_nvim").setup({
		manual_mode = false,
		patterns = {
			"src/",
			".mvn",
			"*.sln",
			"_darcs",
			".hg",
			".bzr",
			".svn",
			"Makefile",
			"package.json",
			">packages",
			".git",
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
			"lemminx",
			"null-ls",
			"markdown",
			"taplo",
		},
	})
end

return M
