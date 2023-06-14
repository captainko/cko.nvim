---@type LazyPlugin[]
local M = {
	{
		"navarasu/onedark.nvim",
		lazy = false,
		config = function()
			require("onedark").setup({
				transparent = true,
				highlights = {
					SignColumn = { bg = "$bg0" },
					ColorColumn = { bg = "$bg0" },
					CursorLineNr = { fg = "$orange" },
					Normal = { bg = "$none" },
					Terminal = { bg = "$bg0" },
					FoldColumn = { bg = "$bg1" },
					Folded = { bg = "$bg1" },
					GitSignsAdd = { bg = "$bg0" },
					GitSignsChange = { bg = "$bg0" },
					GitSignsDelete = { bg = "$bg0" },
					GitSignsStagedAdd = { fg = "$blue", bg = "$bg0" },
					GitSignsStagedChange = { fg = "$green", bg = "$bg0" },
					GitSignsStagedDelete = { fg = "$red", bg = "$bg0" },
					DiagnosticError = { bg = "$bg0" },
					DiagnosticWarn = { bg = "$bg0" },
					DiagnosticInfo = { bg = "$bg0" },
					DiagnosticHint = { bg = "$bg0" },
					DiagnosticVirtualTextError = { bg = "$none" },
					DiagnosticVirtualTextWarn = { bg = "$none" },
					DiagnosticVirtualTextInfo = { bg = "$none" },
					DiagnosticVirtualTextHint = { bg = "$none" },
					["@type.qualifier"] = { fg = "$purple" },
					["@storageClass"] = { fg = "$purple" },
					["@interface"] = { fg = "$yellow", fmt = "bold" },
					["@lsp.type.property"] = { fg = "$cyan" },
					["@lsp.typemod.variable.defaultLibrary"] = { fg = "$yellow" },
					TSOperator = { fg = "$purple" },
					NvimTreeNormal = { bg = "$bg0" },
					NeoTreeNormal = { bg = "$bg0" },
					NeoTreeNormalNC = { bg = "$bg0" },
					helpCommand = { fg = "$blue" },
					helpExample = { fg = "$blue" },
					jsonTSLabel = { fg = "$blue" },
				},
			})

			require("onedark").load()
		end,
	},
}

return M
