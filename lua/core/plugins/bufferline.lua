---@type LazyPlugin
local M = {
	"akinsho/bufferline.nvim",
	lazy = false,
}

function M.config()
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
			table.insert(results, { text = fmt_icon(icons.error, error), guifg = palette.red })
		end

		if warn ~= 0 then
			table.insert(results, {
				text = fmt_icon(icons.warn, warn),
				guifg = palette.yellow,
			})
		end

		if info ~= 0 then
			table.insert(results, { text = fmt_icon(icons.info, info), guifg = palette.blue })
		end

		if hint ~= 0 then
			table.insert(results, {
				text = fmt_icon(icons.hint, hint),
				guifg = palette.purple,
			})
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
end

return M
