vim.api.nvim_create_autocmd({
	"BufNewFile",
	"BufRead",
}, {
	pattern = { "*.code-workspace", ".stylelintrc" },
	callback = function()
		vim.bo.filetype = "json"
	end,
})
