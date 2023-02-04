local Curl = require("plenary.curl")
local M = { issues = {} }

---comment
---@param data     table
---@param callback fun(res: table)
function M.issues.list(data, callback)
	return Curl.post("https://ttekvn.atlassian.net/rest/api/latest/search", {
		headers = { ["Content-Type"] = "application/json" },
		body = vim.json.encode(data),
		auth = string.format("%s:%s", vim.env.ATLASSIAN_EMAIL, vim.env.ATLASSIAN_TOKEN),
		callback = callback,
	})
end

return M
