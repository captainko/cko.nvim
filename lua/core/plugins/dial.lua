---@type LazyPlugin
local M = {
	"monaqa/dial.nvim",
	event = { "CursorMoved" },
}

function M.config()
	local dial = require("dial.map")
	local augend = require("dial.augend")
	local mapper = require("core.utils.mapper")
	local nnoremap = mapper.nnoremap
	local vnoremap = mapper.vnoremap

	nnoremap({ "<C-A>", dial.inc_normal() })
	nnoremap({ "<C-X>", dial.dec_normal() })
	vnoremap({ "<C-A>", dial.inc_visual() })
	vnoremap({ "<C-X>", dial.dec_visual() })
	vnoremap({ "g<C-A>", dial.inc_gvisual() })
	vnoremap({ "g<C-X>", dial.dec_gvisual() })

	local default_augends = {
		augend.integer.alias.decimal,
		augend.integer.alias.hex,
		augend.date.alias["%Y/%m/%d"],
		augend.constant.alias.bool,
		augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
		augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true, preserve_case = true }),
		augend.constant.new({ elements = { "yes", "no" }, word = true, cyclic = true, preserve_case = true }),
		augend.constant.new({ elements = { "TODO", "WARN" }, word = true, cyclic = true }),
		-- switch quotes
		-- augend.paren.new({
		-- 	patterns = { { "'", "'" }, { '"', '"' } },
		-- 	nested = false,
		-- 	escape_char = [[\]],
		-- 	cyclic = true,
		-- }),
	}

	require("dial.config").augends:register_group({ default = default_augends })

	---@type table<string, Augend[]>
	local filetype_map = {}

	---@param augends Augend[]
	---@return Augend[]
	local function add_default_augends(augends)
		return vim.list_extend(augends, default_augends)
	end

	---add augends to filetype_map
	---@param filetype string|string[]
	---@param augends Augend[]
	local function add_to_filetype_map(filetype, augends)
		local filetypes = (type(filetype) == "string" and { filetype }) or filetype --[[@as string[] ]]
		for _, ft in ipairs(filetypes) do
			filetype_map[ft] = vim.list_extend(filetype_map[ft] or {}, augends)
		end
	end

	add_to_filetype_map(
		{ "javascript", "typescript", "vue", "html" },
		add_default_augends({
			augend.constant.new({
				elements = { "const", "let" },
				word = true,
				cyclic = true,
			}),
			augend.constant.new({
				elements = { "boolean", "string", "number", "object" },
				word = true,
				cyclic = true,
			}),
			augend.constant.new({
				elements = { "Boolean", "String", "Number", "Object", "Array" },
				word = true,
				cyclic = true,
			}),
			-- Border Vision
			augend.constant.new({
				elements = { "Consignee", "Consignor" },
				word = false,
				cyclic = true,
				preserve_case = true,
			}),
		})
	)

	add_to_filetype_map(
		{ "java", "typescript", "csharp" },
		add_default_augends({
			augend.constant.new({
				elements = { "public", "private", "protected" },
				word = true,
				cyclic = true,
			}),
		})
	)

	add_to_filetype_map({ "yaml", "toml", "json" }, {
		augend.integer.alias.decimal,
		augend.integer.alias.hex,
		augend.constant.alias.bool,
		augend.semver.alias.semver,
	})

	add_to_filetype_map(
		"gitcommit",
		add_default_augends({
			augend.constant.new({
				elements = { "feat", "refactor", "fix", "enhance", "chore" },
				word = true,
				cyclic = true,
			}),
		})
	)

	require("dial.config").augends:on_filetype(filetype_map)
end

return M
