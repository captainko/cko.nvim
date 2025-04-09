local lsp = require("core.utils.lsp")
-- local function organize_imports()
-- 	vim.lsp.buf.execute_command({
-- 		command = "_typescript.organizeImports",
-- 		---@diagnostic disable-next-line: missing-parameter
-- 		arguments = { vim.api.nvim_buf_get_name(0) },
-- 		title = "",
-- 	})

-- 	vim.defer_fn(vim.lsp.buf.formatting_sync, 800)
-- end

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
local M = {
	-- root_dir = lsp.is_tsserver_root,
	-- root_dir = function(startpath)
	-- 	return lsp.is_tsserver_root(startpath) and not lsp.is_vue_root(startpath)
	-- end,
	-- init_options = {
	-- 	preferences = {
	-- 		-- quotePreference = "auto", -- "auto" | "double" | "single";
	-- 		-- importModuleSpecifierPreference = "non-relative",
	-- 		-- includeCompletionsForImportStatements = true,
	-- 		-- includeAutomaticOptionalChainCompletions = true,
	-- 	},
	-- },
	capabilities = capabilities,
}

-- vim.api.nvim_command([[command! TsImportAll TypescriptAddMissingImports]])
-- vim.api.nvim_command([[command! TsOrgImports TypescriptOrganizeImports]])

function M.on_attach(client, bufnr)
	local ts_tools_config = require("typescript-tools.config")
	local ts_client = vim.lsp.get_clients({ name = ts_tools_config.plugin_name })[1]

	-- if vim.g.use_eslint or vim.g.use_prettier then
	if ts_client then
		lsp.disable_formatting(ts_client)
	end
	-- lsp.on_attach(client, bufnr)

	-- mapper.nnoremap({ "gD", "<Cmd>TypescriptGoToSourceDefinition<CR>", buffer = bufnr })
	-- no default maps, so you may want to define some here
	-- local opts = { silent = true }
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
	-- -- vim.api.nvim_buf_set_keymap(bufnr, "n", "qq", ":TSLspFixCurrent<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>rf", ":TSLspRenameFile<CR>",
	--   opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>gi", ":TSLspImportAll<CR>",
	--   opts)
end

return M
