local popup = require("popup")
local api = vim.api
local fn = vim.fn
local exec = api.nvim_command

local output = api.nvim_exec2("G commit", { output = true })

api.nvim_create_buf(false, false)

local bufnr = api.nvim_create_buf(false, false)
api.nvim_exec2("split below", { output = false })

api.nvim_buf_set_lines(bufnr, 0, 0, true, vim.split(output, "\n"))

api.nvim_set_option_value("filetype", "text", { buffer = bufnr })
api.nvim_set_option_value("modified", false, { buffer = bufnr })
api.nvim_set_option_value("modifiable", false, { buffer = bufnr })
api.nvim_win_set_buf(0, bufnr)
