local popup = require("popup")
local api = vim.api
local fn = vim.fn
local exec = api.nvim_command

local output = api.nvim_exec("G commit", true)

api.nvim_create_buf(false, false)

local bufnr = api.nvim_create_buf(false, false)
api.nvim_exec("split below", false)

api.nvim_buf_set_lines(bufnr, 0, 0, true, vim.split(output, "\n"))

api.nvim_buf_set_option(bufnr, "filetype", "text")
api.nvim_buf_set_option(bufnr, "modified", false)
api.nvim_buf_set_option(bufnr, "modifiable", false)
api.nvim_win_set_buf(0, bufnr)
