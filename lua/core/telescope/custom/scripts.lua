local builtin = require("telescope.builtin")
return function()
	builtin.find_files({
		prompt_title = "Scripts Folder",
		cwd = "~/.dotfiles/.scripts",
	})
end
