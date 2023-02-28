if vim.g.vscode then
	return
end
local bo = vim.bo

bo.formatoptions = "jncrql"

local mapper = require("core.utils.mapper")
---@param opts core.MappingOption
local function b_map(opts)
	opts.buffer = 0
	mapper.nnoremap(opts)
end

b_map({ "<Leader>zd", "<Cmd>lua require('core.shortcuts').switch_svc()<CR>" })
b_map({ "<Leader>zz", "<Cmd>lua require('core.shortcuts').component_html()<CR>" })
b_map({ "<Leader>zm", "<Cmd>lua require('core.shortcuts').module_ts()<CR>" })
b_map({ "<Leader>zc", "<Cmd>lua require('core.shortcuts').component_ts()<CR>" })
b_map({ "<Leader>za", "<Cmd>lua require('core.shortcuts').component_style()<CR>" })
b_map({ "<Leader>zh", "<Cmd>lua require('core.shortcuts').component_html()<CR>" })
b_map({ "<Leader>zs", "<Cmd>lua require('core.shortcuts').service_ts()<CR>" })
b_map({ "<Leader>zo", "<Cmd>lua require('core.shortcuts').controller_ts()<CR>" })
b_map({ "<Leader>zr", "<Cmd>lua require('core.shortcuts').repository_ts()<CR>" })
b_map({ "<Leader>ze", "<Cmd>lua require('core.shortcuts').entity_ts()<CR>" })
b_map({ "<Leader>zt", "<Cmd>lua require('core.shortcuts').test_ts()<CR>" })
