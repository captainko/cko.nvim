local mapper = require("core.utils.mapper")
vim.bo.tabstop = 4
vim.bo.shiftwidth = 2
mapper.nnoremap({ "<LocalLeader>gp", "<Cmd>G! push<CR>", buffer = 0 })
