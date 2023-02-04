local builtin = require("telescope.builtin")

return function()
	builtin.find_files({ prompt_title = "Edit Neovim Folder", cwd = vim.fn.stdpath("config") })
end
