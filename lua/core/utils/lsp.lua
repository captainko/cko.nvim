local mapper = require("core.utils.mapper")
local map_tele = require("core.telescope.mappings")
local commander = require("core.utils.commander")
local Methods = vim.lsp.protocol.Methods

local M = {}

function M.disable_formatting(client)
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false
end

-- =============================================================================
-- Autocommands{{{
-- =============================================================================

-- local can_show_line_diagnostics = function()
-- 	local existing_float = vim.F.npcall(vim.api.nvim_buf_get_var, 0, "lsp_floating_preview")
-- 	return not (existing_float and vim.api.nvim_win_is_valid(existing_float))
-- end

function M.do_cursor_hold()
	vim.lsp.buf.document_highlight()
	vim.diagnostic.open_float({
		scope = "line",
		focusable = false,
		severity_sort = true,
		close_events = {
			"BufLeave",
			"CursorMoved",
			"CursorMovedI",
			"InsertCharPre", --[[default]]
		},
	})
end

function M.clear_references()
	vim.lsp.buf.clear_references()
end

function M.setup_autocommands(client, bufnr)
	if client.supports_method(Methods.textDocument_codeLens) then
		commander.augroup("LspCodeLens", {
			{
				event = { "BufEnter", "CursorHold", "InsertLeave" },
				buffer = bufnr,
				command = vim.lsp.codelens.refresh,
			},
		})
		mapper.nnoremap({ "<Leader>cl", vim.lsp.codelens.run, buffer = bufnr })
	end

	if client.supports_method(Methods.textDocument_documentHighlight) then
		commander.augroup("LspCursorCommands", {
			{
				event = "CursorHold",
				buffer = bufnr,
				command = M.do_cursor_hold,
			},
			{
				event = { "CursorMoved", "CursorMovedI" },
				buffer = bufnr,
				command = M.clear_references,
			},
		})
	end

	-- if server_capabilities.semanticTokensProvider and server_capabilities.semanticTokensProvider.full then
	-- 	local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
	-- 	vim.api.nvim_create_autocmd("TextChanged", {
	-- 		group = augroup,
	-- 		buffer = bufnr,
	-- 		callback = function()
	-- 			vim.lsp.buf.semantic_tokens_full()
	-- 		end,
	-- 	})
	-- 	-- fire it first time on load as well
	-- 	vim.lsp.buf.semantic_tokens_full()
	-- end

	-- NOTE: comment out for now
	-- local extras = client.config and client.config.extras or {}
	-- if server_capabilities.documentFormattingProvider then
	---- format on save
	-- cko.augroup("LspFormat", {
	-- 	{
	-- 		event = "BufWritePre",
	-- 		buffer = bufnr,
	-- 		command = function()
	-- 			-- BUG: folds are are removed when formatting is done, so we save the current state of the
	-- 			-- view and re-apply it manually after formatting the buffer
	-- 			-- @see: https://github.com/nvim-treesitter/nvim-treesitter/issues/1424#issuecomment-909181939
	-- 			(extras.formatting_sync or vim.lsp.buf.format)({ async = false })
	-- 		end,
	-- 	},
	-- })
	-- end
end

-- =============================================================================
-- }}}
-- =============================================================================

-- =============================================================================
-- Setup Mappings{{{
-- =============================================================================

local float_opt = { scope = "cursor", focusable = false }
function M.diag_go_next()
	vim.diagnostic.goto_next({ float = float_opt })
end

function M.diag_go_prev()
	vim.diagnostic.goto_prev({ float = float_opt })
end

function M.diag_go_next_warn()
	vim.diagnostic.goto_next({
		severity = { min = vim.diagnostic.severity.WARN },
		float = float_opt,
	})
end

function M.diag_go_prev_warn()
	vim.diagnostic.goto_prev({
		severity = { min = vim.diagnostic.severity.WARN },
		float = float_opt,
	})
end

function M.diag_go_next_err()
	vim.diagnostic.goto_next({
		severity = vim.diagnostic.severity.ERROR,
		float = float_opt,
	})
end

function M.diag_go_prev_err()
	vim.diagnostic.goto_prev({
		severity = vim.diagnostic.severity.ERROR,
		float = float_opt,
	})
end

function M.extend_option(server_name, config)
	if not server_name then
		return config
	end
	local has_default_config, default_config = PR("lspconfig.server_configurations." .. server_name)
	if has_default_config then
		default_config = default_config.default_config
	end
	return vim.tbl_deep_extend("force", default_config, config)
end

---Setup common mapping when an lsp attaches to a buffer
---@param bufnr integer
function M.setup_common_mappings(client, bufnr)
	local server_capabilities = client.server_capabilities
	local nnoremap = mapper.nnoremap

	nnoremap({ "]g", M.diag_go_next, buffer = bufnr, nowait = true })
	nnoremap({ "[g", M.diag_go_prev, buffer = bufnr, nowait = true })
	nnoremap({ "]w", M.diag_go_next_warn, buffer = bufnr, nowait = true })
	nnoremap({ "[w", M.diag_go_prev_warn, buffer = bufnr, nowait = true })
	nnoremap({ "]e", M.diag_go_next_err, buffer = bufnr, nowait = true })
	nnoremap({ "[e", M.diag_go_prev_err, buffer = bufnr, nowait = true })

	if client.supports_method(Methods.textDocument_rename) then
		nnoremap({ "<Leader>rr", vim.lsp.buf.rename, buffer = bufnr, nowait = true })
	end

	if client.supports_method(Methods.textDocument_declaration) then
		nnoremap({ "gd", vim.lsp.buf.definition, buffer = bufnr, nowait = true })
	end

	-- if client.supports_method(Methods.textDocument_inlayHint) then
	-- 	nnoremap({ "<Leader>ti", "<Cmd>lua require('lsp-inlayhints').toggle()", buffer = bufnr, nowait = true })
	-- end

	if client.supports_method(Methods.textDocument_typeDefinition) then
		-- nnoremap({
		-- 	"<Leader>gt",
		-- 	vim.lsp.buf.type_definition,
		-- 	bufnr = bufnr,
		-- 	nowait = true,
		-- })

		map_tele("<Leader>gt", "lsp_type_definitions", nil, bufnr)
	end

	if client.supports_method(Methods.textDocument_hover) then
		nnoremap({ "K", vim.lsp.buf.hover, buffer = bufnr, nowait = true })
	end

	if client.supports_method(Methods.callHierarchy_incomingCalls) then
		nnoremap({ "gI", vim.lsp.buf.incoming_calls, buffer = bufnr, nowait = true })
	end

	if client.supports_method(Methods.textDocument_references) then
		nnoremap({ "gr", vim.lsp.buf.references, buffer = bufnr, nowait = true })
	end

	if client.supports_method(Methods.textDocument_documentSymbol) then
		map_tele("go", "lsp_document_symbols", nil, bufnr)
	end

	if client.supports_method(Methods.workspace_symbol) then
		map_tele("gO", "lsp_dynamic_workspace_symbols", nil, bufnr)
	end
	map_tele("<Leader>fd", "lsp_workspace_diagnostics", nil, bufnr)
end

---Setup mapping when an lsp attaches to a buffer
---@param client table lsp client
---@param bufnr  integer
function M.setup_mappings(client, bufnr)
	M.setup_common_mappings(client, bufnr)
	local nnoremap = mapper.nnoremap
	local vnoremap = mapper.vnoremap
	local extras = client.config and client.config.extras or {}
	local server_capabilities = client.server_capabilities

	-- local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

	if extras.hover then
		nnoremap({ "<Leader>K", extras.hover, buffer = bufnr, nowait = true })
	end

	if client.supports_method(Methods.textDocument_codeAction) then
		nnoremap({ "<Leader>ca", vim.lsp.buf.code_action, buffer = bufnr, nowait = true })
		vnoremap({ "<Leader>ca", vim.lsp.buf.code_action, buffer = bufnr, nowait = true })
	end

	if client.supports_method(Methods.textDocument_formatting) then
		nnoremap({
			"<Leader><Leader>f",
			function()
				(extras.format or vim.lsp.buf.format)({ async = false })
			end,
			buffer = bufnr,
			nowait = true,
		})
	end

	if client.supports_method(Methods.textDocument_rangeFormatting) then
		vnoremap({ "<Leader><Leader>f", extras.range_format or vim.lsp.buf.format, buffer = bufnr, nowait = true })
	end

	if client.supports_method(Methods.textDocument_implementation) then
		nnoremap({ "gi", vim.lsp.buf.implementation, buffer = bufnr, nowait = true })
	end

	if client.supports_method(Methods.textDocument_typeDefinition) then
		nnoremap({ "<Leader>gd", vim.lsp.buf.type_definition, buffer = bufnr, nowait = true })
	end
end

-- function M.tagfunc(pattern, flags)
-- 	if flags ~= "c" then
-- 		return vim.NIL
-- 	end
-- 	---@diagnostic disable-next-line: missing-parameter
-- 	local params = vim.lsp.util.make_position_params()
-- 	---@diagnostic disable-next-line: param-type-mismatch
-- 	local client_id_to_results, err = vim.lsp.buf_request_sync(0, "textDocument/definition", params, 500)
-- 	assert(not err, vim.inspect(err))

-- 	local results = {}
-- 	for _, lsp_results in ipairs(client_id_to_results) do
-- 		for _, location in ipairs(lsp_results.result or {}) do
-- 			local start = location.targetRange.start
-- 			table.insert(results, {
-- 				name = pattern,
-- 				filename = vim.uri_to_fname(location.targetUri),
-- 				cmd = string.format("call cursor(%d, %d)", start.line + 1, start.character + 1),
-- 			})
-- 		end
-- 	end
-- 	return results
-- end

---comment
---@param client lsp.Client
---@param bufnr  number
function M.on_attach(client, bufnr)
	-- M.setup_autocommands(client, bufnr)
	-- M.setup_mappings(client, bufnr)

	-- local status = require("lsp-status")
	-- status.on_attach(client)

	-- local aerial = require("aerial")
	-- aerial.on_attach(client, bufnr)

	-- local has_inlay_hints, inlay_hints = PR("lsp-inlayhints")
	-- if has_inlay_hints then
	-- 	inlay_hints.on_attach(client, bufnr, false)
	-- end

	-- local navic = require("nvim-navic")
	-- if client.supports_method(Methods.textDocument_documentSymbol, { bufnr = bufnr }) then
	-- 	navic.attach(client, bufnr)
	-- end

	-- if client.server_capabilities.goto_definition then
	--   vim.bo[bufnr].tagfunc = "v:lua.M.tagfunc"
	-- end
end

-- =============================================================================
-- }}}
-- =============================================================================

-- =============================================================================
-- Commands{{{
-- =============================================================================

commander.command("LspLog", function()
	vim.api.nvim_command("edit " .. vim.lsp.get_log_path())
end, {})

local function get_server_option(server_name)
	local has_opt, result = PR("core.lsp." .. server_name) -- load config if it exists

	if has_opt then
		if type(result) == "table" then
			return result
		end

		if type(result) == "function" then
			return result()
		end
	end

	return {}
end

-- =============================================================================
-- }}}
-- =============================================================================

-- =============================================================================
-- Setup servers{{{
-- =============================================================================

---Logic to (re)start installed language servers for use initializing lsp
---and restart them on installing new ones
function M.setup_servers()
	-- local ok_install, lspinstall = PR("nvim-lsp-installer")
	local has_cmp_lsp, cmp_lsp = PR("cmp_nvim_lsp")
	-- can't reasonably proceed if lspinstall isn't loaded
	-- if not ok_install then
	-- 	return vim.notify(lspinstall, vim.log.levels.ERROR)
	-- end

	local function empty_config() end

	require("mason-lspconfig").setup_handlers({
		function(server_name)
			local opt = get_server_option(server_name)

			opt.on_attach = opt.on_attach or M.on_attach
			opt.capabilities = opt.capabilities or vim.lsp.protocol.make_client_capabilities()
			if has_cmp_lsp then
				opt.capabilities = cmp_lsp.default_capabilities(opt.capabilities)
			end
			-- opt.capabilities = vim.tbl_extend("keep", opt.capabilities, status_capabilities)

			require("lspconfig")[server_name].setup(opt)
		end,
		["jdtls"] = empty_config,
		["rust_analyzer"] = empty_config,
		["tsserver"] = function(server_name)
			require("typescript").setup({
				disable_commands = false, -- prevent the plugin from creating Vim commands
				debug = false, -- enable debug logging for commands
				go_to_source_definition = {
					fallback = true, -- fall back to standard LSP definition on failure
				},
				server = get_server_option(server_name),
			})
		end,
	})
end

-- =============================================================================
-- }}}
-- =============================================================================

-- =============================================================================
-- Utils
-- =============================================================================

---@param filter {id: number, bufnr: number, name: string}
function M.stop_client(filter)
	local clients = vim.lsp.get_clients(filter)

	for _, client in ipairs(clients) do
		client.stop()
	end
end

function M.is_vue_root(startpath)
	local u = require("lspconfig.util")
	return u.root_pattern("nuxt.config.ts", "nuxt.config.js", "vue.config.js", "vue.config.js")(startpath)
end

function M.is_tsserver_root(startpath)
	local u = require("lspconfig.util")
	return u.root_pattern("tsconfig.json", "tsconfig.*.json")(startpath)
		or u.root_pattern("package.json", "jsconfig.json", ".git")(startpath)
end

return M
