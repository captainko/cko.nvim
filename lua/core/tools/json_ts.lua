local a = require("plenary.async")
local Pipeline = require("core.utils.pipeline")
---comment
---@param question string?
---@param default string?
---@return string
local function get_input(question, default)
	question = question or ""
	default = default or ""
	local input = vim.fn.input({ prompt = question, default = default })
	return input
end

---@class JsonOption
---@field prefix string|nil
---@field rootName string|nil
---@field txt string|nil

---comment
---@type fun(opts:JsonOption)
local parse_json = a.wrap(function(opts, callback)
	local args = { "--stdin", "--prefix" }

	if opts.prefix and opts.prefix ~= "" then
		table.insert(args, opts.prefix)
	else
		table.insert(args, "")
	end

	if opts.rootName and opts.rootName ~= "" then
		table.insert(args, "--rootName")
		table.insert(args, opts.rootName)
	end

	assert(type(opts.txt) == "string", "txt should be a string")

	local Job = require("plenary.job")
	Job:new({
		command = "json-ts",
		args = args,
		writer = opts.txt,
		---@diagnostic disable-next-line: unused-local
		on_exit = function(self, _code, _signal)
			---@type Job
			self = self
			local errs = self:stderr_result()
			if #errs ~= 0 then
				return callback(false, table.concat(errs, ". "))
			end

			callback(true, self:result())
		end,
	}):start()
end, 2)

---@param req string?
---@diagnostic disable-next-line: unused-local
local function get_txt_from_reg(req)
	---@param opt JsonOption
	return function(opt)
		---@diagnostic disable-next-line: missing-parameter
		opt.txt = vim.fn.getreg("+", 1)
		return true, opt
	end
end

---@return Pipeline
local function get_user_input_pipeline()
	return Pipeline:from_task(function()
		local opt = {
			prefix = get_input("Prefix: "),
			rootName = get_input("Root name: "),
		}
		return true, opt
	end)
end

---comment
---@param lines string[]
local function paste_at_current_cursor(lines)
	vim.schedule(function()
		vim.paste(lines, -1)
	end)
	return true, nil
end

---Get json from register and paste
---@param reg string?
local function ts_from_reg_pipeline(reg)
	return get_user_input_pipeline():add_task(get_txt_from_reg(reg)):add_task(parse_json)
end

---Get json from register
---@param txt string
local function as_ts_pipeline(txt)
	return get_user_input_pipeline()
		:add_task(function(opt)
			opt.txt = txt
			return true, opt
		end)
		:add_task(parse_json)
end

---@param reg string
local function paste_from_reg(reg)
	ts_from_reg_pipeline(reg):add_task(paste_at_current_cursor):run()
end

---@param txt string
local function paste_txt_at_cursor(txt)
	as_ts_pipeline(txt):add_task(paste_at_current_cursor):run()
end

local M = {
	paste_from_reg = paste_from_reg,
	paste_txt_at_cursor = paste_txt_at_cursor,
}

return M
