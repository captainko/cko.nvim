if not core then
	return
end

local lsp, fs, fn, api, fmt = vim.lsp, vim.fs, vim.fn, vim.api, string.format
local diagnostic = vim.diagnostic
local L, S = vim.lsp.log_levels, vim.diagnostic.severity
local M = vim.lsp.protocol.Methods

local style = require("core.global.style")
local icons = style.icons
local commander = require("core.utils.commander")
local lsp_utils = require("core.utils.lsp")
-- local border = core.ui.current.border
local augroup = commander.augroup

if vim.env.DEVELOPING then
	vim.lsp.set_log_level(L.DEBUG)
end

----------------------------------------------------------------------------------------------------
--  LSP file Rename
----------------------------------------------------------------------------------------------------

---@param data { old_name: string, new_name: string }
local function prepare_rename(data)
	local bufnr = fn.bufnr(data.old_name)
	for _, client in pairs(lsp.get_clients({ bufnr = bufnr })) do
		local rename_path = { "server_capabilities", "workspace", "fileOperations", "willRename" }
		if not vim.tbl_get(client, rename_path) then
			return vim.notify(fmt("%s does not LSP file rename", client.name), L.INFO, { title = "LSP" })
		end
		local params = {
			files = { { newUri = "file://" .. data.new_name, oldUri = "file://" .. data.old_name } },
		}
		---@diagnostic disable-next-line: invisible
		local resp = client.request_sync(M.workspace_willRenameFiles, params, 1000, bufnr or 0)
		if resp then
			vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
		end
	end
end

local function rename_file()
	vim.ui.input({ prompt = "New name: " }, function(name)
		if not name then
			return
		end
		local old_name = api.nvim_buf_get_name(0)
		local new_name = fmt("%s/%s", fs.dirname(old_name), name)
		prepare_rename({ old_name = old_name, new_name = new_name })
		lsp.util.rename(old_name, new_name, {})
	end)
end

----------------------------------------------------------------------------------------------------
--  Related Locations
----------------------------------------------------------------------------------------------------
-- This relates to:
-- 1. https://github.com/neovim/neovim/issues/19649#issuecomment-1327287313
-- 2. https://github.com/neovim/neovim/issues/22744#issuecomment-1479366923
-- neovim does not currently correctly report the related locations for diagnostics.
-- TODO: once a PR for this is merged delete this workaround

local function show_related_locations(diag)
	local related_info = diag.relatedInformation
	if not related_info or #related_info == 0 then
		return diag
	end
	for _, info in ipairs(related_info) do
		diag.message = ("%s\n%s(%d:%d)%s"):format(
			diag.message,
			fn.fnamemodify(vim.uri_to_fname(info.location.uri), ":p:."),
			info.location.range.start.line + 1,
			info.location.range.start.character + 1,
			not core.falsy(info.message) and (": %s"):format(info.message) or ""
		)
	end
	return diag
end

local publish_diagnostics_handler = lsp.handlers[M.textDocument_publishDiagnostics]
---@diagnostic disable-next-line: duplicate-set-field
lsp.handlers[M.textDocument_publishDiagnostics] = function(err, result, ctx)
	result.diagnostics = vim.tbl_map(show_related_locations, result.diagnostics)
	publish_diagnostics_handler(err, result, ctx)
end

local inlay_hint_handler = vim.lsp.handlers[M.textDocument_inlayHint]
lsp.handlers[M.textDocument_inlayHint] = function(err, result, ctx)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	if client and client.name == "typescript-tools" then
		result = vim.iter(result)
			:map(function(hint)
				local label = hint.label ---@type string
				if label:len() >= 30 then
					label = label:sub(1, 29) .. icons.misc.ellipsis
				end
				hint.label = label
				return hint
			end)
			:totable()
	end

	inlay_hint_handler(err, result, ctx)
end

-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//

---Setup mapping when an lsp attaches to a buffer
---@param client vim.lsp.Client
---@param bufnr integer
local function setup_mappings(client, bufnr)
	-- local ts = { "typescript", "typescriptreact" }
	local mappings = {
		{
			"n",
			"]g",
			function()
				diagnostic.jump({ float = true, count = 1 })
			end,
			desc = "go to prev diagnostic",
		},
		{
			"n",
			"[g",
			function()
				diagnostic.jump({ float = true, count = -1 })
			end,
			desc = "go to next diagnostic",
		},
		{
			"n",
			"]w",
			function()
				diagnostic.jump({ severity = S.WARN, float = true, count = 1 })
			end,
			desc = "go to next warning diagnostic",
		},
		{
			"n",
			"[w",
			function()
				diagnostic.jump({ severity = S.WARN, float = true, count = -1 })
			end,
			desc = "go to previous warning diagnostic",
		},
		{
			"n",
			"]e",
			function()
				diagnostic.jump({ severity = S.ERROR, float = true, count = 1 })
			end,
			desc = "go to next error diagnostic",
		},
		{
			"n",
			"[e",
			function()
				diagnostic.jump({ severity = S.ERROR, float = true, count = -1 })
			end,
			desc = "go to previous error diagnostic",
		},
		{
			{ "n", "x" },
			"<leader>ca",
			lsp.buf.code_action,
			desc = "code action",
			capability = M.textDocument_codeAction,
		},
		{ "n", "gd", lsp.buf.definition, desc = "definition", capability = M.textDocument_definition },
		{ "n", "gr", lsp.buf.references, desc = "references", capability = M.textDocument_references },
		{
			"n",
			"gI",
			lsp.buf.incoming_calls,
			desc = "incoming calls",
			capability = M.textDocument_prepareCallHierarchy,
		},
		{
			"n",
			"gi",
			lsp.buf.implementation,
			desc = "implementation",
			capability = M.textDocument_implementation,
		},
		-- stylua: ignore start
		{
			'n',
			'<leader>gd',
			lsp.buf.type_definition,
			desc = 'go to type definition',
			capability = M.textDocument_definition
		},
		-- stylua: ignore end
		{
			"n",
			"<leader>cl",
			lsp.codelens.run,
			desc = "run code lens",
			capability = M.textDocument_codeLens,
		},
		{
			"n",
			"<leader>ci",
			function()
				lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({ bufnr = 0 }))
			end,
			desc = "inlay hints toggle",
			capability = M.textDocument_inlayHint,
		},
		{ "n", "<leader>ff", lsp.buf.format, desc = "format file", capability = M.textDocument_formatting },
		{ "v", "<leader>ff", lsp.buf.format, desc = "format range", capability = M.textDocument_rangeFormatting },
		{ "n", "<leader>rr", lsp.buf.rename, desc = "rename", capability = M.textDocument_rename },
		{ "n", "<leader>rm", rename_file, desc = "rename file", capability = M.textDocument_rename },
		{
			"n",
			"gs",
			function()
				require("telescope.builtin").lsp_document_symbols()
			end,
			desc = "out lines",
			capability = M.textDocument_documentSymbol,
		},
		{
			"n",
			"gS",
			function()
				require("telescope.builtin").lsp_dynamic_workspace_symbols()
			end,
			desc = "workspace symbols",
			capability = M.workspace_symbol,
		},
	}

	vim.iter(mappings):each(function(m)
		if
			(not m.exclude or not vim.tbl_contains(m.exclude, vim.bo[bufnr].ft))
			and (not m.capability or client.supports_method(m.capability))
		then
			vim.keymap.set(m[1], m[2], m[3], { buffer = bufnr, desc = fmt("lsp: %s", m.desc) })
		end
	end)
end

-----------------------------------------------------------------------------//
-- LSP SETUP/TEARDOWN
-----------------------------------------------------------------------------//

---@alias ClientOverrides {on_attach: fun(client: vim.lsp.Client, bufnr: number), semantic_tokens: fun(bufnr: number, client: vim.lsp.Client, token: table)}

--- A set of custom overrides for specific lsp clients
--- This is a way of adding functionality for specific lsps
--- without putting all this logic in the general on_attach function
---@type {[string]: ClientOverrides}
local client_overrides = {
	tsserver = {
		semantic_tokens = function(bufnr, client, token)
			if token.type == "variable" and token.modifiers["local"] and not token.modifiers.readonly then
				lsp.semantic_tokens.highlight_token(token, bufnr, client.id, "@danger")
			end
		end,
	},
	["typescript-tools"] = {
		on_attach = function(client, bufnr)
			local biome_client = vim.lsp.get_clients({ name = "biome" })[1]

			if biome_client then
				lsp_utils.disable_formatting(client)
			end
		end,
	},
	biome = {
		on_attach = function(client, bufnr)
			local ts_tools_config = require("typescript-tools.config")
			local ts_client = vim.lsp.get_clients({ name = ts_tools_config.plugin_name })[1]

			if ts_client then
				lsp_utils.disable_formatting(ts_client)
			end
		end,
	},
}

-- -----------------------------------------------------------------------------//
-- -- Semantic Tokens
-- -----------------------------------------------------------------------------//

-- ---@param client lsp.Client
-- ---@param bufnr number
-- local function setup_semantic_tokens(client, bufnr)
-- 	local overrides = client_overrides[client.name]
-- 	if not overrides or not overrides.semantic_tokens then
-- 		return
-- 	end
-- 	augroup(fmt("LspSemanticTokens%s", client.name), {
-- 		event = "LspTokenUpdate",
-- 		buffer = bufnr,
-- 		desc = fmt("Configure the semantic tokens for the %s", client.name),
-- 		command = function(args)
-- 			overrides.semantic_tokens(args.buf, client, args.data.token)
-- 		end,
-- 	})
-- end
-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//

---@param client vim.lsp.Client
---@param buf integer
local function setup_autocommands(client, buf)
	if client.supports_method(M.textDocument_codeLens) then
		augroup(("LspCodeLens%d"):format(buf or vim.api.nvim_get_current_buf()), {
			event = { "BufEnter", "InsertLeave", "BufWritePost" },
			desc = "LSP: Code Lens",
			buffer = buf,
			-- call via vimscript so that errors are silenced
			command = "silent! lua vim.lsp.codelens.refresh()",
		})
	end

	if client.supports_method(M.textDocument_inlayHint, { bufnr = buf }) then
		vim.lsp.inlay_hint.enable(true, { bufnr = buf })
	end

	if client.supports_method(M.textDocument_documentHighlight) then
		augroup(("LspReferences%d"):format(buf), {
			{
				event = { "CursorHold", "CursorHoldI" },
				buffer = buf,
				desc = "LSP: References",
				command = function()
					lsp.buf.document_highlight()
				end,
			},
			{
				event = "CursorMoved",
				desc = "LSP: References Clear",
				buffer = buf,
				command = function()
					lsp.buf.clear_references()
				end,
			},
		})
	end
end

-- Add buffer local mappings, autocommands etc for attaching servers
-- this runs for each client because they have different capabilities so each time one
-- attaches it might enable autocommands or mappings that the previous client did not support
---@param client vim.lsp.Client the lsp client
---@param bufnr number
local function on_attach(client, bufnr)
	bufnr = bufnr or api.nvim_get_current_buf()
	setup_autocommands(client, bufnr)
	setup_mappings(client, bufnr)
end

augroup("LspSetupCommands", {
	{
		event = "LspAttach",
		desc = "setup the language server autocommands",
		command = function(args)
			local client = lsp.get_client_by_id(args.data.client_id)
			if not client then
				return
			end

			local overrides = client_overrides[client.name]
			if overrides and overrides.on_attach then
				overrides.on_attach(client, args.buf)
			end

			on_attach(client, args.buf)
		end,
	},
	{
		event = "DiagnosticChanged",
		desc = "Update the diagnostic locations",
		command = function(args)
			diagnostic.setloclist({ open = false })
			if #args.data.diagnostics == 0 then
				vim.cmd("silent! lclose")
			end
		end,
	},
})

local crc = lsp.handlers[M.client_registerCapability]
lsp.handlers[M.client_registerCapability] = function(error, result, ctx)
	local r = crc(error, result, ctx)
	local client = vim.lsp.get_client_by_id(ctx.client_id)

	if client then
		on_attach(client, ctx.bufnr)
	end

	return r
end

-----------------------------------------------------------------------------//
-- Handler Overrides
-----------------------------------------------------------------------------//
-- This section overrides the default diagnostic handlers for signs and virtual text so that only
-- the most severe diagnostic is shown per line

--- The custom namespace is so that ALL diagnostics across all namespaces can be aggregated
--- including diagnostics from plugins
local ns = api.nvim_create_namespace("severe-diagnostics")

--- Restricts nvim's diagnostic signs to only the single most severe one per line
--- see `:help vim.diagnostic`
---@param callback fun(namespace: integer, bufnr: integer, diagnostics: table, opts: table)
---@return fun(namespace: integer, bufnr: integer, diagnostics: table, opts: table)
local function max_diagnostic(callback)
	return function(_, bufnr, diagnostics, opts)
		local max_severity_per_line = vim.iter(diagnostics):fold({}, function(diag_map, d)
			local m = diag_map[d.lnum]
			if not m or d.severity < m.severity then
				diag_map[d.lnum] = d
			end
			return diag_map
		end)
		callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
	end
end

local signs_handler = diagnostic.handlers.signs
diagnostic.handlers.signs = vim.tbl_extend("force", signs_handler, {
	show = max_diagnostic(signs_handler.show),
	hide = function(_, bufnr)
		signs_handler.hide(ns, bufnr)
	end,
})
-----------------------------------------------------------------------------//
-- Diagnostic Configuration
-----------------------------------------------------------------------------//
-- local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
-- local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

diagnostic.config({
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	signs = {
		text = {
			[S.WARN] = icons.warn,
			[S.INFO] = icons.info,
			[S.HINT] = icons.hint,
			[S.ERROR] = icons.error,
		},
		linehl = {
			[S.WARN] = "DiagnosticSignWarnLine",
			[S.INFO] = "DiagnosticSignInfoLine",
			[S.HINT] = "DiagnosticSignHintLine",
			[S.ERROR] = "DiagnosticSignErrorLine",
		},
	},
	virtual_text = false and {
		severity = { min = S.WARN },
		spacing = 1,
		prefix = function(d)
			local level = diagnostic.severity[d.severity]
			return icons[level:lower()]
		end,
	},
	float = {
		-- max_width = max_width,
		-- max_height = max_height,
		-- border = border,
		title = { { "  ", "DiagnosticFloatTitleIcon" }, { "Problems  ", "DiagnosticFloatTitle" } },
		focusable = true,
		scope = "cursor",
		source = "if_many",
		prefix = function(diag)
			local level = diagnostic.severity[diag.severity]
			local prefix = fmt("%s ", icons[level:lower()])
			return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
		end,
	},
})
