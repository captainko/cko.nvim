---@class core.AutoCommand
---@field description string
---@field event       string[]|string list of autocommand events
---@field pattern     string[]|string list of autocommand patterns
---@field command     string|core.AutoCommandCallbackType
---@field nested      boolean?
---@field once        boolean?
---@field buffer      number?

---@class core.CallbackArgument
---@field id    number     autocommand id
---@field event string     name of triggered event id
---@field group number|nil autocommand group id event
---@field match string     expanded value of `<amatch>`
---@field buf   number     expanded value of `<abuf>`
---@field file  string     expanded value of `<afile>`
---@field data  any        arbitrary data passed from `nvim_exec_autocmds()`

---@alias core.AutoCommandCallbackType fun(event: core.CallbackArgument)

---@class core.CommandArgs
---@field args  string
---@field fargs table
---@field bang  boolean,

local M = {}

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name     string
---@param commands core.AutoCommand[]
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

---Create an nvim command
---@param name string
---@param rhs  string|fun(args: core.CommandArgs)
---@param opts table<string, any>?
function M.command(name, rhs, opts)
	opts = opts or {}
	vim.api.nvim_create_user_command(name, rhs, opts)
end

return M
