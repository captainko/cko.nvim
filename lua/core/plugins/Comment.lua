---@type LazyPlugin
local M = {
	"numToStr/Comment.nvim",
	keys = {
		"gc",
		{ mode = "v", "gc", noremap = false },
		{ mode = "v", "gC", "<Plug>(comment_toggle_blockwise_visual)", noremap = false },
		{
			mode = { "i", "n" },
			"<C-_>",
			function()
				require("Comment.api").toggle.linewise.current()
			end,
			noremap = false,
		},
		{ mode = "v", "<C-_>", "<Plug>(comment_toggle_linewise_visual)", noremap = false },
	},
}
function M.config()
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

			---@diagnostic disable-next-line: return-type-mismatch
			return require("ts_context_commentstring.internal").calculate_commentstring({
				key = type,
				location = location,
			})
		end,
	})
end

return M
