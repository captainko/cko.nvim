local builtin = require("telescope.builtin")

---@type string store last file u type
local last_file_type
return function()
	local opts = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},

		file_ignore_patterns = {
			-- common
			".git",
			-- nodejs
			"node_modules",
			"dist",
			-- java
			"target",
			".settings",
			".mvn",
			".classpath",
			".factorypath",
			"mvnw",
		},
	}

	-- vim.fn.inputrestore()
	-- vim.fn.inputsave()

	last_file_type = vim.fn.input({
		prompt = "File pattern (default:*)",
		default = last_file_type or "*",
	})

	if last_file_type ~= "" then
		table.insert(opts.vimgrep_arguments, "-g")
		table.insert(opts.vimgrep_arguments, last_file_type)
	else
		return
	end

	builtin.live_grep(opts)
end
