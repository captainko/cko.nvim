local file_browser = require("telescope").extensions.file_browser.file_browser
return function()
	file_browser({ prompt_title = "Neovim File Explorer" })
end
