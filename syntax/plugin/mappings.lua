local mapper = require("core.utils.mapper")
local nmap = mapper.nmap
local nnoremap = mapper.nnoremap
local inoremap = mapper.inoremap
local vnoremap = mapper.vnoremap
local cnoremap = mapper.cnoremap
local multi_noremap = mapper.multi_noremap

if not not vim.g.vscode then
	nnoremap({ "<Leader>ca", "<Cmd>call VSCodeNotify('editor.action.quickFix')<CR>" })
	nnoremap({ "gi", "<Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>" })
	nnoremap({ "gr", "<Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>" })
	nnoremap({ "gI", "<Cmd>call VSCodeNotify('editor.action.peekImplementation')<CR>" })
	nnoremap({ "<Leader>rr", "<Cmd>call VSCodeNotify('editor.action.rename')<CR>" })
	nnoremap({ "<Leader>gi", "<Cmd>call VSCodeNotify('references-view.findImplementations')<CR>" })
	nnoremap({ "go", "<Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>" })
	nnoremap({ "gO", "<Cmd>call VSCodeNotify('workbench.action.showAllSymbols')<CR>" })
end
-- =============================================================================
-- Utils
-- =============================================================================
--- save and source
nnoremap({
	"<Leader><Leader>x",
	"<Cmd>call core#save_and_exec()<CR>",
	nowait = true,
	silent = true,
})

--- toggle relativenumber
nnoremap({
	"<Leader>tn",
	"<Cmd>ToggleRelativeNumber<CR>",
	silent = true,
	nowait = true,
})

-- <C-BS> to delete a whole word
inoremap({ "<C-BS>", "<C-w>" })

-- Thanks  ThePrimeagen
nnoremap({ "n", "nzzzv" })
nnoremap({ "N", "Nzzzv" })
nnoremap({ "J", "mzJ`z" })

multi_noremap({ "n", "v" }, { "c", '"_c' })
multi_noremap({ "n", "v" }, { "C", '"_C' })

multi_noremap({ "n", "v" }, { "s", '"_s' })
multi_noremap({ "n", "v" }, { "S", '"_S' })
-- don't copy to clipboard

-- paste as interface
nnoremap({
	"<C-A-v>",
	"<Cmd>lua require('core.tools.json_ts').paste_from_reg('+')<CR>",
	silent = true,
})

nnoremap({
	"<Leader>cp",
	":let @+ = expand('%')<CR>:echomsg 'relative file path copied!'<CR>",
	nowait = true,
	silent = true,
})
nnoremap({
	"<Leader>cfp",
	":let @+ = expand('%:p')<CR>:echomsg 'full file path copied!'<CR>",
	nowait = true,
	silent = true,
})

-- insert new lines
nnoremap({ "<C-CR>", [[mzo<Esc>`z]], silent = true })
nnoremap({ "<S-CR>", [[mzO<Esc>`z]], silent = true })

-- Opens line below or above the current line
inoremap({ "<C-CR>", "<C-O>o" })
inoremap({ "<S-CR>", "<C-O>O" })
-- bind_key('n', '<A-CR>', [[I<CR><Esc>]], {noremap=true, silent =true}

-- surround selection
vnoremap({ [["]], [[<esc>`>a"<esc>`<i"<esc>]] })
vnoremap({ [[(]], [[<esc>`>a)<esc>`<i(<esc>]] })
vnoremap({ "[", [[<esc>`>a]<esc>`<i[<esc>]] })

-- move lines up or down
nnoremap({ "<A-k>", [[<Cmd>m .-2<CR>==]], silent = true })
nnoremap({ "<A-j>", [[<Cmd>m .+1<CR>==]], silent = true })

inoremap({ "<A-j>", [[<Esc><Cmd>m .+1<CR>==gi]], silent = true })
inoremap({ "<A-k>", [[<Esc><Cmd>m .-2<CR>==gi]], silent = true })

vnoremap({ "<A-j>", [[:m '>+1<CR>gv=gv]], silent = true })
vnoremap({ "<A-k>", [[:m '<-2<CR>gv=gv]], silent = true })

-- nnoremap { "<Leader>bca", '<Cmd>%bdelete|edit #|normal `" <CR>', {  }
nnoremap({ "<Leader>bca", "<Cmd>CloseHiddenBuffers<CR>" })
-- inoremap { "<C-BS>", "<C-W>" }

nnoremap({ "<Leader>sw", ":%s/<C-r><C-w>//gc<Left><Left><Left>" })
nnoremap({ "<Leader>S", ":%s/<C-r><C-w>//g<Left><Left>" })
-- nnoremap { "<Leader><Leader>h", "<Cmd>execute 'h '.expand('<cword>)'<CR>",
--   {  }

-- bind_key('n', '<Leader>pw', ':Rg <C-R>=expand("<cword>)"<CR><CR>', {  }
-- bind_key('n', '<Leader>phw', ':h <C-R>=expand("<cword>)"<CR><CR>', {  }

if not vim.g.vscode then
	-- Windows navigator
	nnoremap({ "<Leader>h", "<Cmd>wincmd h<CR>", silent = true })
	nnoremap({ "<Leader>j", "<Cmd>wincmd j<CR>", silent = true })
	nnoremap({ "<Leader>k", "<Cmd>wincmd k<CR>", silent = true })
	nnoremap({ "<Leader>l", "<Cmd>wincmd l<CR>", silent = true })

	-- splitting
	nnoremap({ "<Leader><C-s>", ":sp<CR> :wincmd j<CR>" })
	nnoremap({ "<Leader><C-v>", ":vsp<CR> :wincmd l<CR>" })

	-- sizing
	nnoremap({ "<A-=>", ":vertical resize +5 <CR>" })
	nnoremap({ "<A-->", ":vertical resize -5 <CR>" })
	nnoremap({ "<Leader>rp", ":resize 100 <CR>" })

	-- switching
	nnoremap({ "<Leader><c-i>", "<Cmd>bnext<CR>" })
	nnoremap({ "<Leader><c-o>", "<Cmd>bprev<CR>" })
end

-- nnoremap { "<Leader>tu", "<Cmd>lua require('u'.toggle_tab(<cr>", {  }
nnoremap({ "<Leader>pv", ":wincmd v<bar> :Ex <bar> :vertical resize 30 <CR>" })
-- nnoremap { "<Leader>ps", ":Rg<LocalLeader>", {  }
-- nnoremap { "<Leader><CR>", "luafile ~/.config/nvim/init.lua <CR>", {  }

-- quick fix
nnoremap({ "<a-[>", "<Cmd>cp<CR>", nowait = true })
nnoremap({ "<a-]>", "<Cmd>cn<CR>", nowait = true })

-- visual mode
vnoremap({ "J", ":m '>+1<CR>gv=gv" })
vnoremap({ "K", ":m '>-2<CR>gv=gv" })

-- buffers
nnoremap({ "<Leader>zq", "<Cmd>bwipeout<CR>", silent = true })

-- Window resizing

-- Sizing window horizontally
nnoremap({ "<C-,>", "<C-W><" })
nnoremap({ "<C-.>", "<C-W>>" })

-- Sizing window vertically
nnoremap({ "<A-,>", "<C-W>5<" })
nnoremap({ "<A-.>", "<C-W>5>" })

-- Taller
nnoremap({ "<A-t>", "<C-W>+" })
-- shorter
nnoremap({ "<A-s>", "<C-W>-" })

nmap({ "<Leader>d", '"_d' })

-- Break undo sequence on specific characters
inoremap({ ",", ",<C-g>u" })
inoremap({ ".", ".<C-g>u" })

-- Basically commandline fixes for fat fingering
cnoremap({ "%:H", "%:h" })

-- But really I should use these instead
-- find the plugin
-- cnoremap %H <C-R>=expand('%:h:p') . std#path#separator()<CR>
cnoremap({ "%H", "<C-R>=expand('%:h:p')<CR>" })
cnoremap({ "%T", "<C-R>=expand('%:t')<CR>" })
cnoremap({ "%P", "<C-R>=expand('%:p')<CR>" })
cnoremap({ "%E", "<C-R>=expand('%:e')<CR> " })
-- nnoremap { "<Leader>m", [[<Cmd>MaximizerToggle!<CR>]] }

-- Quit
nnoremap({ "<Leader>qw", "<Cmd>wq<CR>" })
nnoremap({ "<Leader>qq", "<Cmd>quit<CR>" })
nnoremap({ "<Leader>qa", "<Cmd>quitall<CR>" })
