---@diagnostic disable: missing-parameter
local fn = vim.fn
local contains = vim.tbl_contains
local mapper = require("core.utils.mapper")
local commander = require("core.utils.commander")

-- =============================================================================
-- @akinsho saved my ass
-- =============================================================================
-- Ensure all autocommands are cleared
vim.api.nvim_exec(
	[[
augroup vimrc
	autocmd!
augroup END]],
	false
)

-- WARNING: it will trim spaces in string
local function trim()
	local save = vim.fn.winsaveview()
	vim.api.nvim_command([[keeppatterns %s/\s\+$//e]])
	vim.fn.winrestview(save)
end

commander.augroup("TrimWhitespace", { { event = "BufWritePre", pattern = "*", command = trim } })

vim.api.nvim_command([[command! CloseHiddenBuffers call core#close_hidden_buffers()]])

local smart_close_filetypes = {
	"NvimTree",
	"dbui",
	"fugitive",
	"fugitiveblame",
	"git-log",
	"git-status",
	"gitcommit",
	"harpoon",
	"help",
	"log",
	"qf",
	"tsplayground",
}

commander.augroup("VimrcIncSearchHighlight", {
	{
		-- automatically clear search highlight once leaving the commandline
		event = "CmdlineEnter",
		pattern = "[/\\?]",
		command = [[:set hlsearch  | redrawstatus]],
	},
	{
		event = "CmdlineLeave",
		pattern = "[/\\?]",
		command = ":set nohlsearch | redrawstatus",
	},
})

local function smart_close()
	if fn.winnr("$") ~= 1 then
		vim.api.nvim_win_close(0, true)
	end
end

commander.augroup("SmartClose", {
	{
		-- Auto open grep quickfix window
		event = "QuickFixCmdPost",
		pattern = "*grep*",
		command = "cwindow",
	},
	{
		-- Close certain filetypes by pressing q.
		event = "FileType",
		pattern = "*",
		command = function()
			local is_readonly = (vim.bo.readonly or not vim.bo.modifiable) and fn.hasmapto("q", "n") == 0

			local is_eligible = vim.bo.buftype ~= ""
				or is_readonly
				or vim.wo.previewwindow
				or contains(smart_close_filetypes, vim.bo.filetype)

			if is_eligible then
				mapper.nnoremap({ "q", smart_close, buffer = 0, nowait = true })
			end
		end,
	},
	{
		-- Close quick fix window if the file containing it was closed
		event = "BufEnter", --[[: when closing when closing windows if the last window is a quickfix then close it too ]]
		pattern = "*",
		command = function()
			if fn.winnr("$") == 1 and vim.bo.buftype == "quickfix" then
				vim.api.nvim_buf_delete(0, { force = true })
			end
		end,
	},
	{
		-- automatically close corresponding loclist when quitting a window
		event = "QuitPre",
		pattern = "*",
		nested = true,
		command = function()
			if vim.bo.filetype == "qf" then
				return
			end

			vim.api.nvim_command("silent! lclose")
		end,
	},
})

-- TODO: check `open_command`
commander.augroup("ExternalCommands", {
	{
		-- Open images in an image viewer (probably Preview)
		event = "BufEnter",
		pattern = { "png", "jpg", "gif" },
		command = function()
			vim.api.nvim_command(string.format('silent! "%s | :bw"', vim.g.open_command .. " " .. fn.expand("%")))
		end,
	},
})
-- NOTE: no idea what its does. Comment it out for now
-- cko.augroup('CheckOutsideTime', {
--   {
--     -- automatically check for changed files outside vim
--     event = { 'WinEnter', 'BufWinEnter', 'BufWinLeave', 'BufRead', 'BufEnter', 'FocusGained' },
--     pattern = { '*' },
--     command = 'silent! checktime',
--   },
-- })

-- See :h skeleton
commander.augroup("Templates", {
	{
		event = "BufNewFile",
		pattern = "*sh",
		command = "0r $HOME/.config/nvim/templates/skeleton.sh",
	},
	{
		event = "BufNewFile",
		pattern = "*.lua",
		command = "0r $HOME/.config/nvim/templates/skeleton.lua",
	},
})

--- automatically clear commandline messages after a few seconds delay
--- source: http://unix.stackexchange.com/a/613645
---@return function
local function clear_commandline()
	--- Track the timer object and stop any previous timers before setting
	--- a new one so that each change waits for 10secs and that 10secs is
	--- deferred each time
	local timer
	return function()
		if timer then
			timer:stop()
		end
		timer = vim.defer_fn(function()
			if vim.api.nvim_get_mode().mode == "n" then
				vim.api.nvim_command([[echon '']])
			end
		end, 10000)
	end
end

commander.augroup("ClearCommandMessages", {
	{
		event = { "CmdlineLeave", "CmdlineChanged" },
		pattern = ":",
		command = clear_commandline(),
	},
})

commander.augroup("TextYankHighlight", {
	{
		-- don't execute silently in case of errors
		event = "TextYankPost",
		pattern = "*",
		command = function()
			vim.highlight.on_yank({
				timeout = 100,
				on_visual = false,
				-- higroup = 'Visual',
				higroup = "DiffText",
			})
		end,
	},
})

commander.augroup("UpdateVim", {
	{
		-- TODO: not clear what effect this has in the post vimscript world
		-- it correctly sources $MYVIMRC but all the other files that it
		-- requires will need to be resourced or reloaded themselves
		event = "BufWritePost",
		pattern = { vim.fn.stdpath("config") .. "/plugin/**/*.{lua,vim}", "$MYVIMRC" },
		-- modifiers = { "++nested" },
		nested = true,
		command = function()
			local ok, msg = pcall(vim.api.nvim_command, "source $MYVIMRC | redraw | silent doautocmd ColorScheme")
			msg = ok and "sourced " .. vim.fn.fnamemodify(vim.env.MYVIMRC, ":t") or msg
			vim.notify(msg)
		end,
	},
	-- { event = { "FocusLost" }, pattern = { "*" }, command = "silent! wall" },
	-- Make windows equal size when vim resizes
	{ event = "VimResized", pattern = "*", command = "wincmd =" },
})

commander.augroup("WindowBehaviours", {
	{
		-- map q to close command window on quit
		event = "CmdwinEnter",
		pattern = "*",
		command = "nnoremap <silent><buffer><nowait> q <C-W>c",
	},
	-- Automatically jump into the quickfix window on open
	{
		event = "QuickFixCmdPost",
		pattern = "[^l]*",
		nested = true,
		command = "cwindow",
	},
	{ event = "QuickFixCmdPost", pattern = "l*", nested = true, command = "lwindow" },
})

local function should_show_cursorline()
	return (
		vim.bo.buftype ~= "terminal"
		and not vim.wo.previewwindow
		and vim.wo.winhighlight == ""
		and vim.bo.filetype ~= ""
	) or (vim.bo.ft == "NvimTree")
end
if not vim.g.vscode then
	commander.augroup("Cursorline", {
		{
			event = "BufEnter",
			pattern = "*",
			command = function()
				if should_show_cursorline() then
					vim.wo.cursorline = true
				end
			end,
		},
		{
			event = "BufLeave",
			pattern = "*",
			command = function()
				vim.wo.cursorline = false
			end,
		},
	})
end

commander.augroup("Utilities", {
	{
		-- @source: https://vim.fandom.com/wiki/Use_gf_to_open_a_file_via_its_URL
		event = "BufReadCmd",
		pattern = "file:///*",
		command = function()
			vim.api.nvim_command(string.format("bd!|edit %s", vim.uri_from_fname("<afile>")))
		end,
	},
	{
		-- When editing a file, always jump to the last known cursor position.
		-- Don't do it for commit messages, when the position is invalid, or when
		-- inside an event handler (happens when dropping a file on gvim).
		event = "BufReadPost",
		pattern = "*",
		command = function(args)
			local mark = vim.api.nvim_buf_get_mark(0, '"')
			local lcount = vim.api.nvim_buf_line_count(0)
			if mark[1] > 0 and mark[1] <= lcount then
				pcall(vim.api.nvim_win_set_cursor, 0, mark)
			end
		end,
	},
	{
		event = { "BufNewFile", "BufRead" },
		pattern = ".env.*",
		nested = false,
		command = function()
			if vim.bo.filetype == "" then
				vim.bo.filetype = "sh"
			end
		end,
	},
	{
		event = "FileType",
		pattern = { "gitcommit", "gitrebase" },
		command = "set bufhidden=delete",
	},
	{
		event = { "BufWritePre", "FileWritePre" },
		pattern = "*",
		command = "silent! call mkdir(expand('<afile>:p:h'), 'p')",
	},
	{
		event = "BufWritePost",
		pattern = "*",
		nested = true,
		command = function()
			local utils = require("core.utils")
			if utils.is_empty(vim.bo.filetype) or fn.exists("b:ftdetect") == 1 then
				vim.cmd([[
unlet! b:ftdetect
filetype detect
echom 'Filetype set to ' . &ft]])
			end
		end,
	},
	-- {
	--   event = { "Syntax" },
	--   pattern = { "*" },
	--   command = "if 5000 < line('$') | syntax sync minlines=200 | endif",
	-- },
})
