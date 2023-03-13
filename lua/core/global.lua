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
function B(func, ...)
	local opts = { ... }
	return function()
		return func(unpack(opts))
	end
end

---protected require
---@param package string
function PR(package)
	return pcall(require, package)
end
