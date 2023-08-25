---@type LazyPluginSpec
local M = {
	"ThePrimeagen/harpoon",
	keys = {
		"<C-A-]>",
		"<C-A-[>",
		"<Leader>ha",
		"<Leader>hm",
		"<Leader>h1",
		"<Leader>h2",
		"<Leader>h3",
	},
}

function M.config()
	local mapper = require("core.utils.mapper")
	local nnoremap = mapper.nnoremap
	nnoremap({ "<Leader>ha", "<Cmd>lua require('harpoon.mark').add_file()<CR>" })

	nnoremap({
		"<Leader>hm",
		"<Cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>",
	})

	nnoremap({ "<C-A-[>", "<Cmd>lua require('harpoon.ui').nav_prev()<CR>" })
	nnoremap({ "<C-A-]>", "<Cmd>lua require('harpoon.ui').nav_next()<CR>" })
	for i = 1, 9 do
		nnoremap({
			("<Leader>h%s"):format(i),
			("<Cmd>lua require('harpoon.ui').nav_file(%s)<CR>"):format(i),
		})
	end
end

return M
