if vim.g.vscode then
	return
end
local mapper = require("core.utils.mapper")
---@param opts core.MappingOption
local function buf_nnoremap(opts)
	opts.buffer = 0
	mapper.nnoremap(opts)
end

buf_nnoremap({
	"<Leader>zz",
	[[require('core.require("core.shortcuts").component_ts()<CR>]],
})
buf_nnoremap({
	"<Leader>zm",
	[[require('core.require("core.shortcuts").module_ts()<CR>]],
})
buf_nnoremap({
	"<Leader>zc",
	[[require('core.require("core.shortcuts").component_ts()<CR>]],
})
buf_nnoremap({
	"<Leader>za",
	[[require('core.require("core.shortcuts").component_style()<CR>]],
})
buf_nnoremap({
	"<Leader>zh",
	[[require('core.require("core.shortcuts").component_html()<CR>]],
})
buf_nnoremap({
	"<Leader>zs",
	[[require('core.require("core.shortcuts").service_ts()<CR>]],
})
buf_nnoremap({
	"<Leader>zt",
	[[require('core.require("core.shortcuts").test_ts()<CR>]],
})
