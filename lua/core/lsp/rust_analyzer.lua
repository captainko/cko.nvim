local lsp = require("core.utils.lsp")
-- TODO: go to angular template
-- local goToComponent = "angular.goToComponentWithTemplateFile";
-- local setup_commands = function(client)
--   vim.lsp.commands[goToComponent] = function(client, ctx)
--     P(vim.lsp.codelens.get(ctx.bufnr))

--   end
-- end

local M = {
	on_attach = function(client, bufnr)
		local mapper = require("core.utils.mapper")
		lsp.on_attach(client, bufnr)

		if client.server_capabilities.codeActionProvider then
			mapper.nnoremap({ "<Leader>ca", "<Cmd>RustCodeAction<CR>", bufnr = bufnr, nowait = true })
			mapper.vnoremap({ "<Leader>ca", "<Cmd>RustCodeAction<CR>", bufnr = bufnr, nowait = true })
		end
		mapper.nnoremap({ "<C-j>", "<Cmd>RustJoinLines<CR>" })
	end,
}
return M
