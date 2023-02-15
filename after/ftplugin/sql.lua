if vim.g.vscode then
	return
end
local mapper = require("core.util.mapper")

mapper.nnoremap({
	"<LocalLeader>be",
	"<Plug>DBUI_ExecuteQuery",
	silent = true,
	buffer = 0,
})
mapper.nnoremap({
	"<LocalLeader>bf",
	"<Cmd>DBUIFindBuffer<CR>",
	silent = true,
	buffer = 0,
})
mapper.nnoremap({
	"<LocalLeader>br",
	"<Cmd>DBUIRenameBuffer<CR>",
	silent = true,
	buffer = 0,
})
mapper.nnoremap({
	"<LocalLeader>bl",
	"<Cmd>DBUILastQueryInfo<CR>",
	silent = true,
	buffer = 0,
})
