local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local M = {
	s({ trig = "db" }, { t("debugger;") }),
	s({ trig = "dp" }, {
		t({
			"function p(value, label = 'value') {",
			"	return console.log(label, value), value;",
			"}",
		}),
	}),
	s(
		{ trig = "tryfinally", name = "Try Finally" },
		fmt(
			[[try {{
	{}
}} finally {{
	{}
}}
]],
			{
				i(1),
				i(2),
			}
		)
	),
}

return M
