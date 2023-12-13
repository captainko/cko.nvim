vim.api.nvim_create_autocmd({
	"BufNewFile",
	"BufRead",
}, {
	pattern = {
		"[tj]sconfig*.json",
		"*/.vscode/*.json",
		"*/.devcontainer/*.json",
		".eslintrc.json",
		"*/waybar/config",
	},
	callback = function()
		vim.bo.filetype = "jsonc"
	end,
})
