local o = vim.opt
local g = vim.g

-- =============================================================================
-- Message Output{{{
-- =============================================================================

o.shortmess = {
	l = true, -- use "999L, 888C" instead of "999 lines, 888 characters"
	t = true, -- truncate file messages at start
	A = true, -- ignore annoying swap file messages
	o = true, -- file-read message overwrites previous
	O = true, -- file-read message overwrites previous
	T = true, -- truncate non-file messages in middle
	f = true, -- (file x of x) instead of just (x of x
	F = true, -- Don't give file info when editing a file, WARN: this breaks AutoCommand messages
	s = true,
	c = true, -- hide no match
	W = true, -- Don't show [w] or written when writing
}

-- =============================================================================
-- }}}
-- =============================================================================

-- =============================================================================
-- Folds{{{
-- =============================================================================

o.foldlevelstart = 3
o.foldmethod = "expr"
-- o.foldminlines = 15
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldtext = "v:lua.require('core.folds').folds()"
o.foldopen = "search"

-- =============================================================================
-- }}}
-- =============================================================================

-- =============================================================================
-- General{{{
-- =============================================================================

o.exrc = true
o.secure = true
o.completeopt = "menu,menuone,noselect"
o.termguicolors = true
o.guifont = "FiraCode Nerd Font"
o.inccommand = "nosplit" -- show substitute results on screen
o.signcolumn = "yes"
o.updatetime = 300
o.showmode = false
o.clipboard = "unnamedplus"
o.colorcolumn = "80"
o.encoding = "UTF-8"
o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize"
o.errorbells = false
o.belloff = "all" -- turn that dang bell off
o.emoji = false
o.viewoptions = "cursor,folds"
o.switchbuf = "useopen,uselast"
o.cmdheight = 1 -- Height of the command bar
o.mouse = "nv" -- mouse: no visual
o.scrolloff = 20
o.list = true
o.equalalways = true -- TJ: I don't like my windows changing all the time

-- =============================================================================
-- }}}
-- =============================================================================

-- =============================================================================
-- Searching{{{
-- =============================================================================

o.hlsearch = false
o.ignorecase = true
o.smartcase = true
o.incsearch = true

-- =============================================================================
-- }}}
-- =============================================================================

-- =============================================================================
-- Numbers{{{
-- =============================================================================

o.number = true
o.relativenumber = true

-- =============================================================================
-- }}}
-- =============================================================================

-- =============================================================================
-- Formatting{{{
-- =============================================================================

o.expandtab = true
o.softtabstop = 2
o.shiftwidth = 2
o.wrap = false
o.joinspaces = false -- Two spaces and grade school, we're done
o.virtualedit = "block"
o.showbreak = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
o.formatoptions = o.formatoptions
	- "a" -- Auto formatting is BAD.
	- "t" -- Don't auto format my code. I got linters for that.
	+ "c" -- In general, I like it when comments respect textwidth
	+ "q" -- Allow formatting comments w/ gq
	- "o" -- O and o, don't continue comments
	+ "r" -- But do continue when pressing enter.
	+ "n" -- Indent past the formatlistpat, not underneath it.
	+ "j" -- Auto-remove comments if possible.
	- "2" -- I'm not in gradeschool anymore

o.listchars = {
	tab = "▸ ",
	trail = "~",
	nbsp = "%",
	eol = "", --[[↴]]
}
o.fillchars = {
	-- vert = "▕", -- alternatives │
	fold = " ",
	eob = "~", -- suppress ~ at EndOfBuffer
	diff = "╱", -- alternatives = ⣿ ░ ─
	msgsep = "‾",
	foldopen = "▾",
	foldsep = "│",
	foldclose = "▸",
}
--- This is used to handle markdown code blocks where the language might
--- be set to a value that isn't equivalent to a vim filetype
-- g.markdown_fenced_languages = {
-- 	"js=javascript",
-- 	"ts=typescript",
-- 	"shell=sh",
-- 	"bash=sh",
-- 	"console=sh",
-- 	"csharp=cs",
-- }

-- =============================================================================
-- }}}
-- =============================================================================

-- =============================================================================
-- Indent{{{
-- =============================================================================

o.autoindent = true
o.smartindent = true
o.cindent = true
-- o.hidden = true

-- =============================================================================
-- }}}
-- =============================================================================

-- =============================================================================
-- Split{{{
-- =============================================================================
o.splitbelow = true
o.splitright = true
o.eadirection = "hor"

-- =============================================================================
-- }}}
-- =============================================================================

-- exclude usetab as we do not want to jump to buffers in already open tabs
-- do not use split or vsplit to ensure we don't open any new windows

-- =============================================================================
-- Backup{{{
-- =============================================================================
o.backup = false
o.backupcopy = "yes"
o.swapfile = false
o.undofile = true

-- =============================================================================
-- }}}
-- =============================================================================

-- =============================================================================
-- Spell{{{
-- =============================================================================

o.spell = true
o.spelllang = "en_us"
o.spellsuggest:prepend({ 12 })
o.spelloptions = "camel"
o.spellcapcheck = "" -- don't check for capital letters at start of sentence
o.fileformats = { "unix", "mac", "dos" }
g.spellfile_URL = "https://ftp.nluug.nl/vim/runtime/spell" -- change defaults spell host

-- =============================================================================
-- }}}
-- =============================================================================

-- =============================================================================
-- Others
-- =============================================================================

g.loaded_matchit = 1
g.loaded_matchparen = 1

--- vim: foldmethod=marker :
