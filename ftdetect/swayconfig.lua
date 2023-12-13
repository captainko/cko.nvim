vim.api.nvim_create_autocmd({
	"BufNewFile",
	"BufRead",
}, {
	pattern = { "*/sway/config", "*/sway/config.d/*" },
	callback = function()
		vim.bo.filetype = "swayconfig"
	end,
})
