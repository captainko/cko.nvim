local M = {}

---@param result table
---@return boolean
local result_not_valid = function(result)
	return result.exit_status == 0
		or not result.args
		or result.args[1] ~= "commit"
		or not result.file
		or not vim.fn.filereadable(result.file)
end

---@param line string
---@return boolean
local str_contains_DISCARD = function(line)
	return string.match(line, "DISCARD") ~= nil
end

M.after_commit = function()
	if not vim.fn.exists("*FugitiveResult") then
		return
	end
	local result = vim.fn["FugitiveResult"]()

	if result_not_valid(result) then
		return
	end

	-- TODO: check the entire file instead
	local first_line = vim.fn.readfile(result.file, "", 1)[1] or ""

	if str_contains_DISCARD(first_line) then
		vim.api.nvim_command("Gsplit -")
	end
end

return M
