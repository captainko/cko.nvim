local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("core.plugins", {
	defaults = { lazy = true },
	-- concurrency = 40,
	install = { colorscheme = { "onedark" } },
	-- dev = { patterns = jit.os:find("Windows") and {} or { "CaptainKo" } },
	checker = { enabled = true },
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		notify = false, -- get a notification when changes are found
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	-- debug = true,
})

local mapper = require("core.utils.mapper")
mapper.nnoremap({ "<Leader>ps", "<Cmd>Lazy sync<CR>" })
mapper.nnoremap({ "<Leader>pp", "<Cmd>Lazy profile<CR>" })
mapper.nnoremap({ "<Leader>pc", "<Cmd>Lazy clean<CR>" })
