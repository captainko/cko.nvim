---@type LazyPluginSpec
local M = {
	"rebelot/heirline.nvim",
	lazy = false,
	enabled = false,
}

M.config = function()
	local heirline = require("heirline")
	local utils = require("heirline.utils")
	local colors = require("onedark.colors")
	colors.bright_bg = colors.bg3
	heirline.load_colors(colors)

	local ViMode = {
		-- get vim current mode, this information will be required by the provider
		-- and the highlight functions, so we compute it only once per component
		-- evaluation and store it as a component attribute
		init = function(self)
			self.mode = vim.fn.mode(1) -- :h mode()

			-- execute this only once, this is required if you want the ViMode
			-- component to be updated on operator pending mode
			if not self.once then
				vim.api.nvim_create_autocmd("ModeChanged", {
					pattern = "*:*o",
					command = "redrawstatus",
				})
				self.once = true
			end
		end,
		-- Now we define some dictionaries to map the output of mode() to the
		-- corresponding string and color. We can put these into `static` to compute
		-- them at initialisation time.
		static = {
			mode_names = {
				["n"] = "NORMAL",
				["no"] = "O-PENDING",
				["nov"] = "O-PENDING",
				["noV"] = "O-PENDING",
				["no\22"] = "O-PENDING",
				["niI"] = "NORMAL",
				["niR"] = "NORMAL",
				["niV"] = "NORMAL",
				["nt"] = "NORMAL",
				["ntT"] = "NORMAL",
				["v"] = "VISUAL",
				["vs"] = "VISUAL",
				["V"] = "V-LINE",
				["Vs"] = "V-LINE",
				["\22"] = "V-BLOCK",
				["\22s"] = "V-BLOCK",
				["s"] = "SELECT",
				["S"] = "S-LINE",
				["\19"] = "S-BLOCK",
				["i"] = "INSERT",
				["ic"] = "INSERT",
				["ix"] = "INSERT",
				["R"] = "REPLACE",
				["Rc"] = "REPLACE",
				["Rx"] = "REPLACE",
				["Rv"] = "V-REPLACE",
				["Rvc"] = "V-REPLACE",
				["Rvx"] = "V-REPLACE",
				["c"] = "COMMAND",
				["cv"] = "EX",
				["ce"] = "EX",
				["r"] = "REPLACE",
				["rm"] = "MORE",
				["r?"] = "CONFIRM",
				["!"] = "SHELL",
				["t"] = "TERMINAL",
			},
			mode_colors = {
				n = "green",
				i = "cyan",
				v = "purple",
				V = "purple",
				["\22"] = "cyan",
				c = "orange",
				s = "green",
				S = "gureen",
				["\19"] = "purple",
				R = "orange",
				r = "orange",
				["!"] = "red",
				t = "red",
			},
		},
		-- We can now access the value of mode() that, by now, would have been
		-- computed by `init()` and use it to index our strings dictionary.
		-- note how `static` fields become just regular attributes once the
		-- component is instantiated.
		-- To be extra meticulous, we can also add some vim statusline syntax to
		-- control the padding and make sure our string is always at least 2
		-- characters long. Plus a nice Icon.
		provider = function(self)
			return " " .. self.mode_names[self.mode] .. " "
		end,
		-- Same goes for the highlight. Now the foreground will change according to the current mode.
		hl = function(self)
			local mode = self.mode:sub(1, 1) -- get only the first mode character
			return { fg = "black", bg = self.mode_colors[mode], bold = true }
		end,
		-- Re-evaluate the component only on ModeChanged event!
		-- This is not required in any way, but it's there, and it's a small
		-- performance improvement.
		update = {
			"ModeChanged",
		},
	}

	local StatusLine = utils.surround({ "", "" }, "bright_bg", { ViMode })

	require("heirline").setup({
		statusline = StatusLine,
	})
end
return M
