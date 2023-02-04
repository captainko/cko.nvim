local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local isn = ls.indent_snippet_node
local f = ls.function_node
local u = require("core.utils")
-- local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local M = {

	-- =============================================================================
	-- Utils
	-- =============================================================================

	s(
		{ trig = "lo", name = "localize", dscr = "const api = this.service.api;" },
		fmt("const {} = {};", {
			f(function(args)
				local result = (args[1] and args[1][1]) or "default"
				local split = vim.fn.split(result, "\\.")
				result = split[#split] or result
				return result
			end, { 1 }),
			i(1, "default"),
		})
	),

	s({ trig = "p", name = "print", dscr = 'p(variables, "variables");' }, fmt('p({}, "{}")', { i(1), rep(1) })),

	s({ trig = "db", name = "debugger", dscr = "debugger;" }, t("debugger;")),

	s({ trig = "dp" }, {
		t({
			"function p<T>(value: T, label = 'value') {",
			"	return console.log(label, value), value;",
			"}",
		}),
	}),

	-- =============================================================================
	-- Objects
	-- =============================================================================
	s({ trig = "nd", dscr = "new Date()" }, { t("new Date()") }),
	--[[
	key: {
		value
	} --]]
	s({ trig = "ob" }, { t({ "{", "" }), t("  "), i(0, "<value>"), t({ "", "}" }) }),
	s({ trig = "ko" }, {
		i(1, "key"),
		t({ ": {", "" }),
		t("  "),
		i(0, "<value>"),
		t({ "", "" }),
		t({ "}", "" }),
	}),
	--[[ key: <value> ]]
	s({ trig = "kv" }, { i(1, "key"), t({ ": " }), i(0, "<value>") }),
	--[[ key: "<value>" ]]
	s({ trig = "ks" }, { i(1, "key"), t({ ": " }), t("'"), i(0, "<value>"), t("'") }),

	-- =============================================================================
	-- Moleculer
	-- =============================================================================

	-- s({ trig = "ag" }, {
	-- 	t { "@Action({", "  name: \"" },
	-- 	i(1, "ActName"),
	-- 	t { "\"", "})", "act" },
	-- 	f(function(args)
	-- 		return u.upper_first(args[1][1])
	-- 	end, { 1 }),
	-- 	t "(ctx: Context<unknown>)",
	-- 	t { " {", "  " },
	-- 	i(0),
	-- 	t { "", "}" },
	-- }),
	-- -- graphql: { mutation: "createTableName(input: CreateTableNameInput!): CreateTableNamePayload"}
	-- s({ trig = "mc" }, {
	-- 	t { "graphql: {", "" },
	-- 	t "mutation: \"create",
	-- 	i(1, "TableName"),
	-- 	t "(input: Create",
	-- 	f(function(args)
	-- 		return args[1][1]
	-- 	end, { 1 }),
	-- 	t "Input!): Create",
	-- 	f(function(args)
	-- 		return args[1][1]
	-- 	end, { 1 }),
	-- 	t "Payload\"",
	-- 	t { "", "}", "" },
	-- }),
	-- --- graphql{ mutation: "updateTableNameById(input: UpdateTableNameByIdInput!): UpdateTableNamePayload"}
	-- s({ trig = "mu" }, {
	-- 	t { "graphql: {", "" },
	-- 	t "  mutation: \"update",
	-- 	i(1, "TableName"),
	-- 	t "ById(input: Update",
	-- 	f(function(args)
	-- 		return args[1][1]
	-- 	end, { 1 }),
	-- 	t "ByIdInput!): Update",
	-- 	f(function(args)
	-- 		return args[1][1]
	-- 	end, { 1 }),
	-- 	t "Payload\"",
	-- 	t { "", "}", "" },
	-- }),

	-- -- const tableNameGQLActNames = ['allJobPos', 'tableName', 'createJobPo', 'updateJobPoById'] as const
	-- -- export const tableNameGQLActions = createAction(tableNameGQLActNames)
	-- -- export const tableNameGQLEvents = createActionGroup('table-name-gql', tableNameGQLActNames)
	-- s({ trig = "an" }, {
	-- 	-- const tableNameGQLActNames = ['allJobPos', 'tableName', 'createJobPo', 'updateJobPoById'] as const
	-- 	t "const ",
	-- 	i(1, "tableName"),
	-- 	t "GQLActNames",
	-- 	t " = [ \"all",
	-- 	f(function(args)
	-- 		return u.upper_first(args[1][1])
	-- 	end, { 1 }),
	-- 	t "s\", \"", -- append 's'
	-- 	f(function(args)
	-- 		return args[1][1]
	-- 	end, { 1 }),
	-- 	t "\", \"create",
	-- 	f(function(args)
	-- 		return u.upper_first(args[1][1])
	-- 	end, { 1 }),
	-- 	t "\", \"update",
	-- 	f(function(args)
	-- 		return u.upper_first(args[1][1])
	-- 	end, { 1 }),
	-- 	t "ById\"",
	-- 	t { " ] as const", "" },
	-- 	-- export const tableNameGQLActions = createAction(tableNameGQLActNames)
	-- 	t "export const ",
	-- 	f(function(args)
	-- 		return args[1][1]
	-- 	end, { 1 }),
	-- 	t("GQLActions = createAction("),
	-- 	f(function(args)
	-- 		return args[1][1] .. "GQLActNames"
	-- 	end, { 1 }),
	-- 	t { ")", "" },
	-- 	-- export const tableNameGQLEvents = createActionGroup('table-name-gql', tableNameGQLActNames)
	-- 	t "export const ",
	-- 	f(function(args)
	-- 		return args[1][1]
	-- 	end, { 1 }),
	-- 	t "GQLEvents = createActionGroup(\"",
	-- 	i(2, "table-name"),
	-- 	t "-gql\", ",
	-- 	f(function(args)
	-- 		return args[1][1] .. "GQLActNames"
	-- 	end, { 1 }),
	-- 	t { ")", "" },
	-- }),

	-- -- const tableNameDBActNames = [...prismaDefaultActNames] as const
	-- -- export const tableNameDBActions = createAction(tableNameDBActNames)
	-- -- export const tableNameDBEvents = createActionGroup('table-name-db', tableNameDBActNames)
	-- s({ trig = "ad" }, {
	-- 	-- const tableNameDBActNames = [...prismaDefaultActNames] as const
	-- 	t "const ",
	-- 	i(1, "tableName"),
	-- 	t "DBActNames",
	-- 	t { " = [...prismaDefaultActNames] as const", "export const " },
	-- 	-- export const tableNameDBActions = createAction(tableNameDBActNames)
	-- 	f(function(args)
	-- 		return args[1][1]
	-- 	end, { 1 }),
	-- 	t("DBActions = createAction("),
	-- 	f(function(args)
	-- 		return args[1][1] .. "DBActNames"
	-- 	end, { 1 }),
	-- 	t { ")", "" },
	-- 	-- export const tableNameDBEvents = createActionGroup('table-name-gql', tableNameDBActNames)
	-- 	t "export const ",
	-- 	f(function(args)
	-- 		return args[1][1]
	-- 	end, { 1 }),
	-- 	t "DBEvents = createActionGroup(\"",
	-- 	i(2, "table-name"),
	-- 	t "-db\", ",
	-- 	f(function(args)
	-- 		return args[1][1] .. "DBActNames"
	-- 	end, { 1 }),
	-- 	t { ")", "" },
	-- }),
}

return M
