local ok = PR("schemastore")

local schemas = ok and require("schemastore").json.schemas() or {}

local M = {
	settings = {
		json = {
			schemas = schemas,
			validate = { enable = true },
		},
	},
}

return M
