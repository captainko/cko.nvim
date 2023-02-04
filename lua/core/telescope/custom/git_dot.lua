return function()
	local utils = require("core.utils")
	local fn = vim.fn
	local builtin = require("telescope.builtin")

	---@link https://stackoverflow.com/a/38082196
	local get_git_dir = function()
		---@diagnostic disable-next-line: missing-parameter
		return fn.fnameescape(fn.fnamemodify(fn.finddir(".git", fn.escape(fn.expand("%:p:h"), " ") .. ";"), ":h"))
	end
	local git_parent_dir = get_git_dir()
	if utils.is_empty(git_parent_dir) then
		vim.notify("cannot find .git folder")
		return
	end

	git_parent_dir = git_parent_dir .. "/.git"

	builtin.find_files({
		prompt_title = ".Git Folder",
		cwd = git_parent_dir,
		find_command = { "fd", "--type", "f", "--exclude", "{objects}/**/*" },
	})
end
