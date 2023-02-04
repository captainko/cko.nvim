local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local M = {
	-- s({
	-- 	trig = "use",
	-- 	name = "packer use",
	-- 	dscr = { "packer use plugin block", "e.g.", "use {'author/plugin'}" },
	-- }, {
	-- 	t("use { '"),
	-- 	i(1, "author/plugin"),
	-- 	t("' "),
	-- 	i(2, { ", config = function()", "", "end" }),
	-- 	t("}"),
	-- }),

	s(
		{ trig = "lo", name = "localize" },
		fmt("local {} = {}", {
			f(function(args)
				local result = (args[1] and args[1][1]) or "default"
				local split = vim.fn.split(result, "\\.")
				result = split[#split] or result
				return result
			end, { 1 }),
			i(1, "default"),
		})
	),

	s(
		{ trig = "lr", name = "require" },
		fmt("local {} = require('{}')", {
			f(function(args)
				local result = (args[1] and args[1][1]) or "default"
				local split = vim.fn.split(result, "\\.")
				result = split[#split] or result
				return result
			end, { 1 }),
			i(1, "default"),
		})
	),

	s(
		{ trig = "lp", name = "LazyPlugin" },
		fmt(
			[[---@type LazyPlugin
local M = {{
	"{}"
}}

function M.config()
	{}
end

return M
			]],
			{
				i(1, "contributor/repo"),
				i(2, "-- run config"),
			}
		)
	),
}

return M
