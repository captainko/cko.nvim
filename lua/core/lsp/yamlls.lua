-- local custom = require "core.lsp.custom"
-- local format_opt = {
--   enable = true,
--   singleQuote = true,
--   bracketSpacing = true,
--   proseWrap = "Always",
-- }
-- local function format()
--   return vim.lsp.buf.formatting(vim.tbl_extend("keep", {}, format_opt))
-- end
local M = {
	settings = {
		yaml = {
			schemas = {
				kubernetes = "/*.k8s.*",
				["http://json.schemastore.org/kustomization"] = "kustomization.*",
				["https://raw.githubusercontent.com/GoogleContainerTools/skaffold/master/docs/content/en/schemas/v2beta8.json"] = "skaffold.*",
			},
		},
	},
}

return M
