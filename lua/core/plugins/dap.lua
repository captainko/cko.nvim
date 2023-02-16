---@type LazyPlugin
local M = {
	"mfussenegger/nvim-dap",
	keys = { "<F5>", "<Leader>db" },
	enabled = not vim.g.vscode,
	dependencies = {
		"williamboman/mason.nvim",
		"jayp0521/mason-nvim-dap.nvim",
		"rcarriga/nvim-dap-ui",
		"stevearc/overseer.nvim", -- Task manager
		"Joakker/lua-json5",
	},
}

function M.config()
	local dap = require("dap")
	-- dap.set_log_level("TRACE")
	dap.defaults.fallback.external_terminal = {
		command = "/usr/local/bin/alacritty",
		args = { "-e" },
	}
	require("dap.ext.vscode").json_decode = require("json5").parse
	require("dap.ext.vscode").load_launchjs(nil, { coreclr = { "cs", "csharp" } })

	local mason_dap = require("mason-nvim-dap")
	mason_dap.setup({
		automatic_setup = { adapters = {} },
	})
	mason_dap.setup_handlers({
		require("mason-nvim-dap.automatic_setup"),
		coreclr = function()
			require("core.daps.coreclr")()
		end,
	})

	local mapper = require("core.utils.mapper")
	local nnoremap = mapper.nnoremap
	nnoremap({ "<F5>", "<Cmd>lua require'dap'.continue()<CR>" })
	nnoremap({ "<F10>", "<Cmd>lua require'dap'.step_over()<CR>" })
	nnoremap({ "<F11>", "<Cmd>lua require'dap'.step_into()<CR>" })
	nnoremap({ "<F12>", "<Cmd>lua require'dap'.step_out()<CR>" })
	nnoremap({ "<F12>", "<Cmd>lua require'dap'.step_out()<CR>" })
	nnoremap({ "<Leader>db", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>" })
	nnoremap({ "<Leader>dB", "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>" })
	nnoremap({ "<Leader>dl", "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>" })
	nnoremap({ "<Leader>dr", "<Cmd>lua require'dap'.repl_open()<CR>" })
	nnoremap({ "<Leader>d$", "<Cmd>lua require'dap'.run_last()<CR>" })

	-- =============================================================================
	--  Map K to hover while session is active
	-- =============================================================================

	local keymap_restore = {}
	dap.listeners.after["event_initialized"]["me"] = function()
		for _, buf in pairs(vim.api.nvim_list_bufs()) do
			local keymaps = vim.api.nvim_buf_get_keymap(buf, "n")
			for _, keymap in pairs(keymaps) do
				if keymap.lhs == "K" then
					table.insert(keymap_restore, keymap)
					vim.api.nvim_buf_del_keymap(buf, "n", "K")
				end
			end
		end
		vim.api.nvim_set_keymap("n", "K", '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
	end

	dap.listeners.after["event_terminated"]["me"] = function()
		for _, keymap in pairs(keymap_restore) do
			-- api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs, { silent = keymap.silent == 1 })
			mapper.multi_map({ keymap.mode }, { keymap.lhs, keymap.rhs or keymap.callback })
		end
		keymap_restore = {}
	end

	local dapui = require("dapui")
	require("dapui").setup()

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open({})
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close({})
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close({})
	end
end

return M
