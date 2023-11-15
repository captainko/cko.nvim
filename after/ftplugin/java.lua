if vim.g.vscode then
	return
end
local md5 = require("core.utils.md5")

vim.bo.formatoptions = "jncrql"
-- vim.bo.tabstop = 4
local cwd = vim.fn.getcwd()
local workspace_name = vim.fn.fnamemodify(cwd, ":p:h:t")
local workspace_folder = vim.fs.normalize("~/.workspace/") .. workspace_name .. "_" .. md5.tohex(cwd) -- add uniqueness
local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {

		-- 💀
		-- "java",
		vim.fs.normalize("~/.sdkman/candidates/java/19.0.2-open/bin/java"), -- or '/path/to/java11_or_newer/bin/java'
		-- depends on if `java` is in your $PATH env variable and if it points to the right version.

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1g",
		"-Xmx2G",
		"-javaagent:" .. jdtls_path .. "/lombok.jar",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		-- 💀
		"-jar",
		jdtls_path .. "/plugins/org.eclipse.equinox.launcher_1.6.500.v20230717-2134.jar",
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
		-- Must point to the                                                     Change this to
		-- eclipse.jdt.ls installation                                           the actual version

		-- 💀
		"-configuration",
		jdtls_path .. "/config_linux",
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
		-- Must point to the                      Change to one of `linux`, `win` or `mac`
		-- eclipse.jdt.ls installation            Depending on your system.

		-- 💀
		-- See `data directory configuration` section in the README
		"-data",
		workspace_folder,
		-- "/path/to/unique/per/project/workspace/folder",
	},
	-- capabilities = capabilities,

	flags = { allow_incremental_sync = true },

	-- 💀
	-- This is the default if not provided, you can remove it. Or adjust as needed.
	-- One dedicated LSP server & client will be started per unique root_dir
	root_dir = require("jdtls.setup").find_root({ "mvnw", "gradlew", ".git", ".ide" }),

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options

	capabilities = {},
	settings = require("core.lsp.jdtls").settings,
	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	-- init_options = {
	-- 	bundles = {},
	-- 	extendedClientCapabilities = require("jdtls").extendedClientCapabilities,
	-- },
	on_attach = function(client, bufnr)
		local lsp = require("core.utils.lsp")
		-- cko.lsp.disable_formatting(client)
		lsp.on_attach(client, bufnr)
		-- cko.nnoremap({ "<Leader>ca", vim.lsp.buf.code_action, bufnr = bufnr })
		-- cko.vnoremap({ "<Leader>ca", vim.lsp.buf.code_action, bufnr = bufnr })
	end,
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require("jdtls").start_or_attach(config)
