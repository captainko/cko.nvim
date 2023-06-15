---@type LazyPlugin[]
local M = {
	{
		"goolord/alpha-nvim",
		lazy = false,
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},
	{
		"akinsho/bufferline.nvim",
		event = { "BufReadPre" },
		enabled = not vim.g.started_by_firenvim,
		config = function()
			local bufferline = require("bufferline")
			local icons = require("core.global.style").icons

			local mapper = require("core.utils.mapper")
			local nnoremap = mapper.nnoremap
			for i = 1, 9, 1 do
				nnoremap({ "<Leader>" .. i, B(bufferline.go_to_buffer, i) })
			end
			nnoremap({ "[b", "<Cmd>BufferLineCyclePrev<CR>" })
			nnoremap({ "]b", "<Cmd>BufferLineCycleNext<CR>" })
			nnoremap({ "<Leader>bcr", "<Cmd>BufferLineCloseRight<CR>" })
			nnoremap({ "<Leader>bcl", "<Cmd>BufferLineCloseLeft<CR>" })
			nnoremap({ "<Leader>bcr", "<Cmd>BufferLineCloseRight<CR>" })

			---@param diagnostic string
			local function get_icon(diagnostic)
				if diagnostic == "error" then
					return icons.error
				end
				if diagnostic == "warning" then
					return icons.warn
				end
				if diagnostic == "hint" or diagnostic == "other" then
					return icons.hint
				end
				return icons.info
			end

			local function diagnostics_indicator(_, _, diagnostics_dict, _)
				local result = ""

				for diagnostics, count in pairs(diagnostics_dict) do
					result = string.format("%s%s %d", result, get_icon(diagnostics), count)
				end

				return result
			end

			local function right_area()
				---@type table
				---@diagnostic disable-next-line: assign-type-mismatch
				local palette = require("onedark.colors")

				local results = {}
				local error = #vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })
				local warn = #vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.WARN })
				local info = #vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.INFO })
				local hint = #vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.HINT })

				---format icons and counts
				---@param icon string
				---@param count number
				---@return string
				local function fmt_icon(icon, count)
					return string.format(" %s %d", icon, count)
				end

				if error ~= 0 then
					table.insert(results, { text = fmt_icon(icons.error, error), fg = palette.red })
				end

				if warn ~= 0 then
					table.insert(results, { text = fmt_icon(icons.warn, warn), fg = palette.yellow })
				end

				if info ~= 0 then
					table.insert(results, { text = fmt_icon(icons.info, info), fg = palette.blue })
				end

				if hint ~= 0 then
					table.insert(results, { text = fmt_icon(icons.hint, hint), fg = palette.purple })
				end
				return results
			end

			bufferline.setup({
				options = {
					---@diagnostic disable-next-line: assign-type-mismatch
					numbers = function(opts)
						return string.format("[%s]", opts.ordinal)
					end,
					max_name_length = 22,
					tab_size = 22,
					---@diagnostic disable-next-line: assign-type-mismatch
					diagnostics = "nvim_lsp",
					diagnostics_indicator = diagnostics_indicator,
					diagnostics_update_in_insert = false,
					highlights = {
						-- background = { guibg = "#333" },
						-- fill = { guibg = { attribute = "bg", highlight = "TabLineFill" } },
						-- tab_selected = { guifg = { attribute = "fg", highlight = "WarningMsg" } },
					},
					custom_areas = { right = right_area },
				},
			})
		end,
	},
	{
		"Bekaboo/dropbar.nvim",
		event = { "VeryLazy" },
		config = function()
			local icons = require("lspkind")

			require("dropbar").setup({
				icons = icons.symbol_map,
				general = {
					update_events = {
						buf = {
							"BufModifiedSet",
							"FileChangedShellPost",
							"TextChanged",
							-- "TextChangedI",
						},
					},
				},
			})
		end,
	},
	{
		"j-hui/fidget.nvim",
		branch = "legacy",
		event = { "VeryLazy" },
		config = function()
			require("fidget").setup()
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			local palette = require("core.global.style").palette
			local override = {
				["component.ts"] = {
					icon = "",
					color = palette.dark_orange,
					name = "TsComponent",
				},
				["directive.ts"] = {
					icon = "ﲔ",
					color = palette.dark_blue,
					name = "TsDirective",
				},
				["decorator.ts"] = {
					icon = "@",
					-- icon = "",
					color = palette.light_red,
					name = "TsDecorator",
				},
				["guard.ts"] = { icon = "", color = palette.whitesmoke, name = "TsGuard" },
				["module.ts"] = {
					icon = "📦",
					color = palette.light_yellow,
					name = "TsModule",
				},
				["spec.ts"] = { icon = "", color = palette.green, name = "TsTest" },
				["snippets"] = { icon = " ", color = palette.green, name = "Snippet" },
				-- ["vue"] = { icon = "﵂", name = "Vue", color = palette.green },
			}

			require("nvim-web-devicons").setup({
				-- your personal icons can go here (to override)
				-- DevIcon will be appended to `name`
				-- override = vim.tbl_extend("keep",override ,devicons.get_icons()),
				override = override,
				-- globally enable default icons (default to false)
				-- will get overridden by `get_icons` option
				default = true,
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		enabled = true,
		lazy = false,
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					-- theme = "gruvbox-material",
					theme = "onedark",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = { "txt" },
					globalstatus = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						"branch",
						{
							"diff",
							colored = true,
							-- diff_color = {
							-- 	modified = "DiagnosticFloatingInfo",
							-- 	added = "DiagnosticFloating",
							-- 	removed = "ErrorFloat",
							-- },
						},
					},

					lualine_c = {
						{ "filename", file_status = true, path = 1 },
						-- 'require"lsp-status".status()',
					},
					lualine_x = {
						-- { navic.get_location, cond = navic.is_available },
						"encoding",
						"fileformat",
						"filetype",
					},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { { "filename", file_status = true, path = 1 } },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				extensions = { "quickfix", "fugitive", "nvim-tree", "toggleterm" },
			})
		end,
	},
}

return M
