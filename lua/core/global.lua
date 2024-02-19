-- =============================================================================
-- Debugging
-- =============================================================================

core = {}
P = vim.print
--- binding arguments to a function
---@generic TParam
---@generic TReturn
---@param   cb fun(...: TParam): TReturn
---@vararg  TParam
---@return fun(): TReturn
function B(cb, ...)
	local args = { ... }
	return function()
		return cb(unpack(args))
	end
end

---protected require
---@param package string
function PR(package)
	return pcall(require, package)
end

---Determine if a value of any type is empty
---@param item any
---@return boolean?
function core.falsy(item)
	if not item then
		return true
	end
	local item_type = type(item)
	if item_type == "boolean" then
		return not item
	end
	if item_type == "string" then
		return item == ""
	end
	if item_type == "number" then
		return item <= 0
	end
	if item_type == "table" then
		return vim.tbl_isempty(item)
	end
	return item ~= nil
end
