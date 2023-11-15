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
	s({ trig = "et", name = "{{$t()}}" }, fmt("{{{{ $t({}) }}}}", { i(1) })),
	s({ trig = "ttc", name = "$t('Cancel')" }, t({ "$t('Cancel')" })),
	s({ trig = "tts", name = "$t('Submit')" }, t({ "$t('Submit')" })),
	s({ trig = "ttcf", name = "$t('Confirm')" }, t({ "$t('Confirm')" })),
	s({ trig = "tto", name = "$t('OK')" }, t({ "$t('OK')" })),
	s({ trig = "ttcl", name = "$t('Close')" }, t({ "$t('Close')" })),
}

return M
