local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node

local M = {
	s({ trig = "gd", name = "git discard" }, {
		t({
			"git_discard || {",
			'	echo "Check the committed files for DISCARD:"',
			"	exit 1",
			"}",
			"",
		}),
	}),
	s({ trig = "gfh", name = "git format html" }, {
		t({
			"git_format_html || {",
			"	echo",
			'	echo "format html failed"',
			"	exit 1",
			"}",
			"",
		}),
	}),
	s({ trig = "gfj", name = "git format java" }, {
		t({
			"git_format_java || {",
			"	echo",
			'	echo "format java failed"',
			"	exit 1",
			"}",
			"",
		}),
	}),
}

return M
