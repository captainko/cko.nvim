---@type LazyPluginSpec
local M = {
	"ahmedkhalf/project.nvim",
	event = { "VeryLazy" },
}

function M.config()
	require("project_nvim").setup({
		detection_methods = { "lsp", "pattern" },
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
			-- "package.json",
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
			-- "csharp_ls"
		}
	})
end

return M
