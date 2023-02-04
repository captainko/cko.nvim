local M = {}

function M.cmt_open()
	local frags = vim.split(vim.bo.commentstring, "%s", { plain = true })
	local suf = vim.fn.trim(frags[1] or "")
	return suf .. " "
end

function M.cmt_close()
	local frags = vim.split(vim.bo.commentstring, "%s", { plain = true })
	local suf = vim.fn.trim(frags[2] or "")
	return not M.is_empty(suf) and " " .. suf or ""
end

---@param str string
---@return string
function M.lower_first(str)
	return str:sub(1, 1):lower() .. str:sub(2)
end

---@param str string
---@return string
function M.upper_first(str)
	return str:sub(1, 1):upper() .. str:sub(2)
end

local last_uuid

function M.uuid()
	if not vim.fn.executable("uuidgen") then
		vim.notify("uuidgen not found")
		return ""
	end
	last_uuid = vim.fn.substitute(vim.fn.system("uuidgen"), "\n", "", "")
	return last_uuid
end

function M.last_uuid()
	return last_uuid or M.uuid()
end

---UTC time
---@return string|osdate
function M.t_utc()
	return os.date("!%Y-%m-%dT%TZ", os.time())
end

---Local time
---@return string|osdate
function M.t_local()
	return os.date("%Y-%m-%dT%T", os.time())
end

---check whether item is empty
---@param item unknown
---@return boolean
function M.is_empty(item)
	if not item then
		return true
	end
	local item_type = type(item)
	if item_type == "string" then
		return item == ""
	elseif item_type == "table" then
		return vim.tbl_isempty(item)
	end
	return true
end

---check if a certain feature/version/commit exists in nvim
---@param feature string
---@return boolean
function M.has_feature(feature)
	return vim.fn.has(feature) > 0
end

return M
