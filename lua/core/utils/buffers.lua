local M = {}

---make buffer options
---@param bufnr number
---@return table
function M.make_buf_options(bufnr)
	return {
		__index = function(key)
			return vim.api.nvim_buf_get_option(bufnr, key)
		end,
	}
end

return M
