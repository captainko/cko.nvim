-- Thanks @akinsho for the full configuration

-- =============================================================================
-- Global namespace
-- =============================================================================

--- Inspired by @tjdevries' astraunauta.nvim/ @TimUntersberger's config
--- store all callbacks in one global table so they are able to survive re-requiring this file

-- =============================================================================
-- Debugging
-- =============================================================================

P = vim.print
--- binding arguments to a function
---@generic TParam
---@generic TReturn
---@param   cb fun(...: TParam): TReturn
---@vararg  TParam
---@return fun():TReturn
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
