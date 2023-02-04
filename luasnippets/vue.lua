local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

local M = {
	s({ trig = "db" }, { t("debugger;") }),
	s({ trig = "dp" }, {
		t({
			"function p(value, label = 'value') {",
			"	return console.log(label, value), value;",
			"}",
		}),
	}),
}

return M
