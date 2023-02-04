---@type LazyPlugin
local M = {
	"numToStr/Comment.nvim",
	keys = {
		"<C-_>",
		{ mode = "v", "<C-_>" },
		"gcc",
		"gc",
		{ mode = "i", "<C-_>" },
		{ mode = "n", "<C-_>" },
	},
}
function M.config()
	local mapper = require("core.utils.mapper")
	mapper.nmap({ "<C-_>", "gcc" })
	mapper.vmap({ "<C-_>", "gc" })
	mapper.inoremap({ "<C-_>", "<C-o>gcc" })
	require("Comment").setup({
		ignore = "^$",
		---@param ctx CommentCtx
		---@return string
		pre_hook = function(ctx)
			local U = require("Comment.utils")

			-- Determine whether to use linewise or blockwise commentstring
			local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

			-- Determine the location where to calculate commentstring from
			local location = nil
			if ctx.ctype == U.ctype.blockwise then
				location = require("ts_context_commentstring.utils").get_cursor_location()
			elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
				location = require("ts_context_commentstring.utils").get_visual_start_location()
			end

			return require("ts_context_commentstring.internal").calculate_commentstring({
				key = type,
				location = location,
			})
		end,
	})
end

return M
