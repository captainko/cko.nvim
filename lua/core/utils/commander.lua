local M = {}
---@class CoreAutoCommand
---@field description string
---@field event       string[]|string list of autocommand events
---@field pattern     string[]|string list of autocommand patterns
---@field command     string|function
---@field nested      boolean?
---@field once        boolean?
---@field buffer      number?

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name     string
---@param commands CoreAutoCommand[]
---@return number
function M.augroup(name, commands)
	local id = vim.api.nvim_create_augroup(name, { clear = true })
	for _, autocmd in ipairs(commands) do
		local is_callback = type(autocmd.command) == "function"
		local opts = {
			group = id,
			pattern = autocmd.pattern,
			desc = autocmd.description,
			callback = is_callback and autocmd.command or nil,
			command = not is_callback and autocmd.command or nil,
			once = autocmd.once,
			nested = autocmd.nested,
			buffer = autocmd.buffer,
		}
		vim.api.nvim_create_autocmd(autocmd.event, opts)
	end
	return id
end

--- @class CoreCommandArgs
--- @field args  string
--- @field fargs table
--- @field bang  boolean,

---Create an nvim command
---@param name string
---@param rhs  string|fun(args: CoreCommandArgs)
---@param opts table<string, any>?
function M.command(name, rhs, opts)
	opts = opts or {}
	vim.api.nvim_create_user_command(name, rhs, opts)
end

return M
