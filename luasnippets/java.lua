local ls = require("luasnip")
local u = require("core.utils")
local f = ls.function_node
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

local M = {
	s({ trig = "sb", name = "Static block" }, { t({ "static {", "	" }), i(0), t({ "", "}" }) }),
	s({ trig = "lm", name = "() -> { }" }, { t("("), i(1), t(")"), t(" -> {"), i(0), t("}") }),
	-- s({ trig = "uuid", name = "UUID" }, { t "'", f(u.uuid, {}), t "'" }),
	-- s({ trig = "luuid", name = "Last UUID" }, { t "'", f(u.last_uuid, {}), t "'" }),
}

return M
