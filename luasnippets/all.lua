local ls = require("luasnip")
local u = require("core.utils")
local fmt = string.format
local f = ls.function_node
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

local flag = function()
	-- e.g <!-- %s -->
	local c = u.cmt_open() .. "%s" .. u.cmt_close()
	local flag = string.rep("=", 2 + vim.wo.colorcolumn - string.len(c))
	return fmt(c, flag)
end

local M = {
	s({ trig = "uuid", name = "UUID" }, { t("'"), f(u.uuid, {}), t("'") }),
	s({ trig = "luuid", name = "Last UUID" }, { t("'"), f(u.last_uuid, {}), t("'") }),
	s({ trig = "utc", name = "Date" }, { t("'"), f(u.t_utc, {}), t("'") }),
	s({ trig = "date", name = "Date" }, { t("'"), f(u.t_local, {}), t("'") }),
	s({
		name = "Section Flag",
		trig = "ft",
		--[[
-- =============================================================================
-- <Section>
-- =============================================================================
--]]
	}, {
		t({ "", "" }),
		f(flag, {}, "fun"),
		t({ "", "" }),
		f(u.cmt_open, {}),
		i(1),
		f(u.cmt_close, {}),
		t({ "", "" }),
		f(flag, {}, "fun"),
		t({ "", "" }),
	}),
	s({
		name = "Section Flag + Closing Flag",
		trig = "ftc",
		--[[
-- =============================================================================
-- <Section>
-- =============================================================================

-- =============================================================================
-- <Section> End
-- =============================================================================
--]]
	}, {
		t({ "", "" }),
		f(flag, {}, "fun"),
		t({ "", "" }),
		f(u.cmt_open, {}),
		i(1),
		f(u.cmt_close, {}),
		t({ "", "" }),
		f(flag, {}, "fun"),
		t({ "", "" }),
		i(0),
		t({ "", "" }),
		f(flag, {}, "fun"),
		t({ "", "" }),
		f(u.cmt_open, {}),
		f(function(args)
			return args[1][1] .. " End" -- append " End"
		end, { 1 }),
		f(u.cmt_close, {}),
		t({ "", "" }),
		f(flag, {}, "fun"),
		t({ "", "" }),
	}),
}

-- e.g  TODO:
local cmts = {
	"discard",
	"done",
	"fixme",
	"hack",
	"note",
	"reason",
	"todo",
	"warn",
}

for _, cmt in ipairs(cmts) do
	M[#M + 1] = s({ trig = cmt }, {
		f(u.cmt_open, {}),
		t(cmt:upper() .. ": "),
		i(0),
		f(u.cmt_close, {}),
	})
end

return M
