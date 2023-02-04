local schemastore = R("schemastore")

local M = {
	settings = { json = { schemas = schemastore.json.schemas() } },
}

return M
