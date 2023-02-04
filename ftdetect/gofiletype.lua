if vim.g.vscode then
	return
end
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.gohtml" },
	callback = function()
		vim.bo.filetype = "html"
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "go.mod" },
	callback = function()
		vim.bo.filetype = "gomod"
	end,
})
