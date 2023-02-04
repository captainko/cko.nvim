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
capabilities.textDocument.completion.completionItem.snippetSupport = true
local M = {
	settings = {
		typescript = {
			surveys = { enabled = false },
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
		javascript = {
			surveys = { enabled = false },
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	},
	init_options = {
		preferences = {
			quotePreference = "auto", -- "auto" | "double" | "single";
			--   includeCompletionsForImportStatements = true,
			--   includeAutomaticOptionalChainCompletions = true,
		},
	},
	capabilities = capabilities,
}

vim.api.nvim_command([[command! TsImportAll TypescriptAddMissingImports]])
vim.api.nvim_command([[command! TsOrgImports TypescriptOrganizeImports]])

M.on_attach = function(client, bufnr)
local mapper = require("core.utils.mapper")
	if vim.g.use_eslint or vim.g.use_prettier then
		lsp.disable_formatting(client)
	end
	lsp.on_attach(client, bufnr)

	mapper.nnoremap({ "gD", "<Cmd>TypescriptGoToSourceDefinition<CR>" })
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
