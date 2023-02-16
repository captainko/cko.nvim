---@alias core.MappingMode "c"|"i"|"n"|"o"|"s"|"t"|"v"|"x"

---@class core.MakeMappingOption
---@field noremap boolean
---@field silent  boolean

---@class core.MappingOption
---@field [1]              string - lhs
---@field [2]              string|function - rhs
---@field lhs              string - lhs
---@field rhs              string|function - rhs
---@field buffer           number?
---@field desc             string?
---@field nowait           boolean?
---@field silent           boolean?
---@field expr             boolean?
---@field replace_keycodes boolean?
---@field unique           boolean?
---@field script           string?

---@class core.MultiMappingOption: core.MappingOption
---@field noremap boolean

local M = {}

-- check if a mapping already exists
---@param lhs  string
---@param mode string default is `n`
---@return boolean
function M.has_map(lhs, mode)
	mode = mode or "n"
	return vim.fn.maparg(lhs, mode, nil, nil) ~= ""
end

---@param opt core.MappingOption
local function clear_opt(opt)
	opt[1] = nil
	opt[2] = nil
	opt.lhs = nil
	opt.rhs = nil
end

---create a mapping function factory
---@param mode        "" | core.MappingMode
---@param default_opt core.MakeMappingOption
---@return fun(opt: core.MappingOption)
local function make_mapper(mode, default_opt)
	-- copy the opts table as extends will mutate the opts table passed in otherwise
	local parent_opt = vim.deepcopy(default_opt)
	---Create a mapping

	return function(opt)
		opt = opt and vim.deepcopy(opt) or {}

		local lhs = opt[1] or opt.lhs
		local rhs = opt[2] or opt.rhs
		clear_opt(opt)

		opt = vim.tbl_extend("keep", opt, parent_opt)
		vim.keymap.set(mode, lhs, rhs, opt)
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
---e.g. `M.map({"n", "s"}, opt)`
---@param noremap boolean
---@return fun(modes: core.MappingMode[], opt: core.MultiMappingOption)
local function multimap(noremap)
	return function(modes, opt)
		opt = opt and vim.deepcopy(opt) or {}
		opt.noremap = noremap

		local lhs = opt[1] or opt.lhs
		local rhs = opt[2] or opt.rhs

		clear_opt(opt)
		vim.keymap.set(modes, lhs, rhs, opt)
	end
end

M.multi_map = multimap(false)
M.multi_noremap = multimap(true)

return M
