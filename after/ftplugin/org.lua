if vim.g.vscode then
	return
end
-- continue bullet comments
vim.bo.formatoptions = "ctnqro"
vim.bo.comments = vim.bo.comments .. ",n:*,n:#"
