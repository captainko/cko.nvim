vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { [[**/haproxy/*\.cfg]], "haproxy*.cfg" },
	callback = function()
		vim.bo.filetype = "haproxy"
	end,
})
