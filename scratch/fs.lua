local a = require("plenary.async")
local uv = require("plenary.async.uv_async")

local check_file = a.void(function()
	local err, stat = uv.fs_stat(vim.fn.expand("~"))
	if err then
		return
	end

	vim.schedule(function()
		P(stat)
	end)
end)
check_file()
