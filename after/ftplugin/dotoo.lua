if vim.g.vscode then
	return
end
local bo = vim.bo
local wo = vim.wo
bo.expandtab = true
bo.shiftwidth = 2
bo.softtabstop = 2
bo.errorformat = '"%f", line %l: %m'
bo.makeprg = "compiler %"
bo.bufhidden = "hide"

wo.concealcursor = "n"
wo.wrap = false
vim.cmd([[
inoreabbrev todo TODO
inoreabbrev done DONE
]])
