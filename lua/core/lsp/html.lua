local lsp = require("core.utils.lsp")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local default_format_opt = vim.g.format_opt and vim.g.format_opt.html
	or {
		-- wrapAttributes = "force-aligned",
		-- tabSize = number;
		-- insertSpaces = boolean;
		-- indentEmptyLines = boolean;
		-- wrapLineLength = number;
		-- unformatted = string;
		-- contentUnformatted = string;
		-- indentInnerHtml = boolean;
		-- wrapAttributes = 'auto' | 'force' | 'force-aligned' | 'force-expand-multiline' | 'aligned-multiple' | 'preserve' | 'preserve-aligned';
		-- wrapAttributesIndentSize = number;
		-- preserveNewLines = boolean;
		-- maxPreserveNewLines = number;
		-- indentHandlebars = boolean;
		-- endWithNewline = boolean;
		-- extraLiners = string;
		-- indentScripts = 'keep' | 'separate' | 'normal';
		-- templating = boolean;
		-- unformattedContentDelimiter = string;
	}

default_format_opt.async = false
local extras = {}

extras.format = function(format_opts)
	return vim.lsp.buf.format(vim.tbl_extend("keep", format_opts, default_format_opt))
end

extras.range_format = function(format_opts)
	---@diagnostic disable-next-line: param-type-mismatch
	return vim.lsp.buf.range_formatting(vim.tbl_extend("keep", format_opts, default_format_opt), nil, nil)
end

extras.formatting_sync = function(format_opts)
	return vim.lsp.buf.format(vim.tbl_extend("keep", format_opts, default_format_opt))
end

-- local html_config = require("lspinstall/util").extract_config "html"

local M = {
	init_options = { provideFormatter = true },
	capabilities = capabilities,
	settings = { html = { format = { wrapAttributes = "force-aligned" } } },
	-- root_dir = u.root_pattern("package.json", "node_modules", ".git"),
	extras = extras,

	on_attach = function(client, bufnr)
		if vim.g.use_prettier then
			lsp.disable_formatting(client)
		end
		lsp.on_attach(client, bufnr)
	end,
}
return M
