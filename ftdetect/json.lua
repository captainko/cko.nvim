vim.api.nvim_create_autocmd({
	"BufNewFile",
	"BufRead",
}, {
	pattern = { "*.code-workspace", ".stylelintrc", ".swcrc" },
	callback = function()
		vim.bo.filetype = "json"
	end,
})
