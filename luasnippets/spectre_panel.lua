local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

local M = {}

local file_types = { "*", "ts", "js", "json", "html", "css", "scss" }
for _, ft in pairs(file_types) do
	M[#M + 1] = s({ trig = "*" .. ft, desc = "**/*." .. ft }, { t("**/*." .. ft) })
	M[#M + 1] = s({ trig = "." .. ft, desc = "*." .. ft }, { t("*." .. ft) })
end

return M
