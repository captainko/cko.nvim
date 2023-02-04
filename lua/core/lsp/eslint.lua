local lsp = require("core.utils.lsp")
local util = require("lspconfig.util")
-- local M = {
-- 	settings = {
-- 		autoFixOnSave = { enable = true },
-- 		validate = "on",
-- 		packageManager = "npm",
-- 		useESLintClass = false,
-- 		codeActionOnSave = {
-- 			enable = false,
-- 			mode = "all",
-- 		},
-- 		format = true,
-- 		quiet = false,
-- 		onIgnoredFiles = "off",
-- 		rulesCustomizations = {},
-- 		run = "onType",
-- 		-- nodePath configures the directory in which the eslint server should start its node_modules resolution.
-- 		-- This path is relative to the workspace folder (root dir) of the server instance.
-- 		nodePath = "",
-- 		-- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
-- 		workingDirectory = { mode = "location" },
-- 		codeAction = {
-- 			disableRuleComment = {
-- 				enable = true,
-- 				location = "separateLine",
-- 			},
-- 			showDocumentation = {
-- 				enable = true,
-- 			},
-- 		},
-- 	},

-- 	root_dir = util.root_pattern(
-- 		".eslintrc",
-- 		".eslintrc.js",
-- 		".eslintrc.cjs",
-- 		".eslintrc.yaml",
-- 		".eslintrc.yml",
-- 		".eslintrc.json"
-- 	),
-- 	on_attach = function(client, bufnr)
-- 		vim.g.use_eslint = true

-- 		if vim.g.use_prettier then
-- 			vim.g.use_eslint = false
-- 			cko.lsp.disable_formatting(client)
-- 		end

-- 		vim.api.nvim_create_autocmd({ "BufWritePre" }, { buffer = bufnr, command = "EslintFixAll" })
-- 		cko.lsp.on_attach(client, bufnr)
-- 	end,
-- }

-- return M
-- local lsp = vim.lsp

-- local function fix_all(opts)
-- 	opts = opts or {}

-- 	local eslint_lsp_client = util.get_active_client_by_name(opts.bufnr, "eslint")
-- 	if eslint_lsp_client == nil then
-- 		return
-- 	end

-- 	local request
-- 	if opts.sync then
-- 		request = function(bufnr, method, params)
-- 			eslint_lsp_client.request_sync(method, params, nil, bufnr)
-- 		end
-- 	else
-- 		request = function(bufnr, method, params)
-- 			eslint_lsp_client.request(method, params, nil, bufnr)
-- 		end
-- 	end

-- 	local bufnr = util.validate_bufnr(opts.bufnr or 0)
-- 	request(0, "workspace/executeCommand", {
-- 		command = "eslint.applyAllFixes",
-- 		arguments = {
-- 			{
-- 				uri = vim.uri_from_bufnr(bufnr),
-- 				version = lsp.util.buf_versions[bufnr],
-- 			},
-- 		},
-- 	})
-- end

-- local bin_name = "vscode-eslint-language-server"
-- local cmd = { bin_name, "--stdio" }

-- if vim.fn.has("win32") == 1 then
-- 	cmd = { "cmd.exe", "/C", bin_name, "--stdio" }
-- end

local M = {
	settings = {
		format = true,
		-- format = { enable = true },
		-- autoFixOnSave = { enable = true },
	},
	on_attach = function(client, bufnr)
		vim.g.use_eslint = true
		if vim.g.use_prettier then
			vim.g.use_eslint = false
			lsp.disable_formatting(client)
		end

		vim.api.nvim_create_autocmd({ "BufWritePre" }, { buffer = bufnr, command = "EslintFixAll" })
		lsp.on_attach(client, bufnr)
	end,
}

return M
