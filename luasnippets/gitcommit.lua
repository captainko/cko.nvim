local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

local M = { s({ trig = "jt", dscr = "| JIRA: " }, { t("| JIRA: ") }) }

local projects = { { trig = "ph", txt = "PHRM" }, { trig = "bv", txt = "BV2" } }

for _, project in pairs(projects) do
	M[#M + 1] = s({
		trig = string.format("t%s", project.trig),
		dscr = string.format("%s-12 #time 3h", project.txt),
	}, {
		t(string.format("%s-", project.txt)),
		i(1, "number"),
		t(" #time "),
		i(2, ""),
		c(3, { t("h"), t("w"), t("m") }),
	})
end

local git_messages = {
	{ trig = "c", txt = "chore" },
	{ trig = "e", txt = "feat" },
	{ trig = "f", txt = "fix" },
	{ trig = "i", txt = "improve" },
	{ trig = "r", txt = "refactor" },
	{ trig = "s", txt = "style" },
	{ trig = "w", txt = "rewrite" },
	-- -- WH
	-- { trig = "cw", txt = "WH: chore" },
	-- { trig = "ew", txt = "WH: feat" },
	-- { trig = "fw", txt = "WH: fix" },
	-- { trig = "iw", txt = "WH: improve" },
	-- { trig = "rw", txt = "WH: refactor" },
	-- { trig = "sw", txt = "WH: style" },
	-- { trig = "ww", txt = "WH: rewrite" },
	-- -- BE
	-- { trig = "cb", txt = "BE: chore" },
	-- { trig = "eb", txt = "BE: feat" },
	-- { trig = "fb", txt = "BE: fix" },
	-- { trig = "ib", txt = "BE: improve" },
	-- { trig = "rb", txt = "BE: refactor" },
	-- { trig = "sb", txt = "BE: style" },
	-- { trig = "wb", txt = "BE: rewrite" },
}

-- create commit message snippets
-- e.g chore(scope): message
for _, m in ipairs(git_messages) do
	M[#M + 1] = s({ trig = m.trig, dscr = m.txt .. "(scope): message" }, {
		t(m.txt),
		t("("),
		i(1, "scope"),
		t("): "),
		i(2, "message"),
		t({ "", "" }),
		i(0),
	})
end

return M
