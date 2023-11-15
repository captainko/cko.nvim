local lsp = require("core.utils.lsp")
local M = {
	-- init_options = {
	-- 	provideFormatter = true, -- vetur
	-- 	languageFeatures = {
	-- 		implementation = true, -- new in @volar/vue-language-server v0.33
	-- 		references = true,
	-- 		definition = true,
	-- 		typeDefinition = true,
	-- 		callHierarchy = true,
	-- 		hover = true, -- vetur
	-- 		rename = true,
	-- 		renameFileRefactoring = true,
	-- 		signatureHelp = true,
	-- 		codeAction = true,
	-- 		workspaceSymbol = true,
	-- 		completion = true, -- vetur
	-- 		-- completion = {
	-- 		-- 	defaultTagNameCase = "both",
	-- 		-- 	defaultAttrNameCase = "kebabCase",
	-- 		-- 	getDocumentNameCasesRequest = false,
	-- 		-- 	getDocumentSelectionRequest = false,
	-- 		-- },
	-- 	},
	-- },
	-- settings = { html = { format = { wrapAttributes = "force-aligned" } } },
	root_dir = lsp.is_vue_root,
	filetypes = { "vue", "javascript", "typescript" },
	on_attach = function(client, bufnr)
		if vim.g.use_eslint or vim.g.use_prettier then
			lsp.disable_formatting(client)
		end
		-- lsp.on_attach(client, bufnr)
	end,
}
return M
