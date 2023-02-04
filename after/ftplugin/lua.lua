if vim.g.vscode then
	return
end
local bo = vim.bo
bo.syntax = "off"
bo.formatoptions = "jncrql"
bo.tabstop = 4
