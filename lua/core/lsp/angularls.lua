local lsp = require("core.utils.lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.rename = nil
capabilities.textDocument.formatting = nil

-- TODO: go to angular template
-- local goToComponent = "angular.goToComponentWithTemplateFile";
-- local setup_commands = function(client)
--   vim.lsp.commands[goToComponent] = function(client, ctx)
--     P(vim.lsp.codelens.get(ctx.bufnr))

--   end
-- end

local M = {
	-- cmd = cmd,
	root_dir = require("lspconfig.util").root_pattern("angular.json"),
	capabilities = capabilities,
	on_init = function(client)
		local rc = client.server_capabilities
		rc.renameProvider = false
		lsp.disable_formatting(client)
		-- setup_commands(client)
	end,
	-- on_new_config = function(new_config ,new_root_dir)
	--   new_config.cmd = cmd
	-- end,
}
return M
