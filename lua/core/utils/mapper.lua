local M = {}

-- check if a mapping already exists
---@param lhs  string
---@param mode string default is `n`
---@return boolean
function M.has_map(lhs, mode)
	mode = mode or "n"
	return vim.fn.maparg(lhs, mode, nil, nil) ~= ""
end

---@class core.MakeMappingOption
---@field noremap boolean
---@field silent  boolean

---create a mapping function factory
---@param mode        string
---@param default_opt core.MakeMappingOption
---@return fun(opts: core.MakeMappingOption)
local function make_mapper(mode, default_opt)
	-- copy the opts table as extends will mutate the opts table passed in otherwise
	local parent_opt = vim.deepcopy(default_opt)
	---Create a mapping

	---@class core.MappingOption
	---@field [1]    string - lhs
	---@field [2]    string|function - rhs
	---@field lhs    string - lhs
	---@field rhs    string|function - rhs
	---@field bufnr  number?
	---@field desc   string?
	---@field nowait boolean?
	---@field silent boolean?
	---@field expr   boolean?
	---@field unique boolean?
	---@field script string?

	---@function mapping function
	return function(opt)
		opt = opt and vim.deepcopy(opt) or {}

		local lhs = opt[1] or opt.lhs
		local rhs = opt[2] or opt.rhs
		opt[1] = nil
		opt[2] = nil
		assert(type(rhs) == "string" or type(rhs) == "function", '"rhs" should be a function or string')

		local bufnr = opt.bufnr
		opt.bufnr = nil
		if type(rhs) == "function" then
			opt.callback = rhs
			rhs = ""
		end

		if bufnr then
			opt = vim.tbl_extend("keep", opt, parent_opt)
			vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opt)
		elseif not bufnr then
			vim.api.nvim_set_keymap(mode, lhs, rhs, vim.tbl_extend("keep", opt, parent_opt))
		end
	end
end

---@type core.MakeMappingOption
local map_opt = { noremap = false, silent = true }
---@type core.MakeMappingOption
local noremap_opt = { noremap = true, silent = true }

M.map = make_mapper("", map_opt)
M.nmap = make_mapper("n", map_opt)
M.xmap = make_mapper("x", map_opt)
M.imap = make_mapper("i", map_opt)
M.vmap = make_mapper("v", map_opt)
M.omap = make_mapper("o", map_opt)
M.tmap = make_mapper("t", map_opt)
M.smap = make_mapper("s", map_opt)
M.cmap = make_mapper("c", { noremap = false, silent = false })

M.noremap = make_mapper("", noremap_opt)
M.nnoremap = make_mapper("n", noremap_opt)
M.xnoremap = make_mapper("x", noremap_opt)
M.vnoremap = make_mapper("v", noremap_opt)
M.inoremap = make_mapper("i", noremap_opt)
M.onoremap = make_mapper("o", noremap_opt)
M.tnoremap = make_mapper("t", noremap_opt)
M.snoremap = make_mapper("s", noremap_opt)
M.cnoremap = make_mapper("c", { noremap = true, silent = false })

---steal from @akinsho again :))

---Factory function to create multi mode map functions
---e.g. `M.map({"n", "s"}, opts)`
---@param target "map"|"noremap"
---@return fun(modes: string[], opts: core.MappingOption)
local function multimap(target)
	return function(modes, opts)
		for _, m in ipairs(modes) do
			M[m .. target](opts)
		end
	end
end

M.multi_map = multimap("map")
M.multi_noremap = multimap("noremap")

return M
