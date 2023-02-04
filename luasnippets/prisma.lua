local ls = require("luasnip")
local u = require("core.utils")
local f = ls.function_node
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

local M = {
	s({ trig = "de" }, { t("@default("), i(0, "value"), t(")") }),
	s({ trig = "id" }, { t("id Int @id @default(autoincrement())") }),

	--[[
    model Name {
    }
--]]
	s({ trig = "mo" }, { t("model "), i(1, "ModelName"), t({ " {", "  " }), i(0), t({ "", "}" }) }),
	s({ trig = "au" }, { t("autoincrement()") }),
	--- @relation
	s({ trig = "re" }, { t('@relation("'), i(1, "RelationName"), t('")') }),
	--- @relation("name", fields: [referencedId], references: [id])
	s({ trig = "rel" }, {
		t('@relation("'),
		i(1, "RelationName"),
		t('"'),
		t(", fields: ["),
		i(2, "referencedId"),
		t("], references: ["),
		i(3, "id"),
		t("])"),
	}),
	s({ trig = "ar" }, { i(1, "name"), t(" "), i(2, "TypeName"), t("[]") }),
	s({ trig = "i" }, { i(1, "name"), t(" Int ") }),
	s({ trig = "i?" }, { i(1, "name"), t(" Int? ") }),
	s({ trig = "s" }, { i(1, "name"), t(" String "), i(2, " @db.VarChar") }),
	s({ trig = "s?" }, { i(1, "name"), t(" String? "), i(2, " @db.VarChar") }),
	s({ trig = "f" }, { i(1, "name"), t(" Float ") }),
	s({ trig = "f?" }, { i(1, "name"), t(" Float? ") }),
}

return M
