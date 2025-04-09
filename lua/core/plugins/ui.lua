---@type LazyPluginSpec[]
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
				nnoremap({ "<Leader>" .. i, B(bufferline.go_to, i) })
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
					-- highlights = {
					-- 	-- background = { guibg = "#333" },
					-- 	-- fill = { guibg = { attribute = "bg", highlight = "TabLineFill" } },
					-- 	-- tab_selected = { guifg = { attribute = "fg", highlight = "WarningMsg" } },
					-- },
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
				bar = {
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
		-- branch = "legacy",
		event = { "VeryLazy" },
		config = function()
			require("fidget").setup({
				progress = {
					suppress_on_insert = true,
				},
				-- Options related to integrating with other plugins
				integration = {
					["nvim-tree"] = {
						enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
					},
				},
			})
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
	{
		-- only needed if you want to use the commands with "_with_window_picker" suffix
		"s1n7ax/nvim-window-picker",
		config = function()
			require("window-picker").setup({
				autoselect_one = true,
				include_current = false,
				filter_rules = {
					-- filter using buffer options
					bo = {
						-- if the file type is one of following, the window will be ignored
						filetype = { "neo-tree", "neo-tree-popup", "notify" },

						-- if the buffer type is one of following, the window will be ignored
						buftype = { "terminal", "quickfix" },
					},
				},
				other_win_hl_color = "#e35e4f",
			})
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = { "Neotree" },
		enabled = false,
		-- branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"s1n7ax/nvim-window-picker",
		},
		keys = {
			{
				"<Leader><c-n>",
				"<Cmd>Neotree reveal right toggle<CR>",
			},
			-- {
			-- 	"<Leader>to",
			-- 	"<Cmd>Neotree document_symbols left toggle<CR>",
			-- },
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
				enable_refresh_on_write = true, -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.
				popup_border_style = "rounded",
				enable_git_status = true,
				enable_diagnostics = true,
				open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
				sort_case_insensitive = false,                         -- used when sorting files and directories in the tree
				sort_function = nil,                                   -- use a custom function for sorting files and directories in the tree

				-- sort_function = function (a,b)
				--       if a.type == b.type then
				--           return a.path > b.path
				--       else
				--           return a.type > b.type
				--       end
				--   end , -- this sorts files and directories descendantly
				default_component_configs = {
					container = {
						enable_character_fade = true,
					},
					indent = {
						indent_size = 2,
						padding = 1, -- extra padding on left hand side
						-- indent guides
						with_markers = true,
						indent_marker = "│",
						last_indent_marker = "└",
						highlight = "NeoTreeIndentMarker",
						-- expander config, needed for nesting files
						with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
						expander_collapsed = "",
						expander_expanded = "",
						expander_highlight = "NeoTreeExpander",
					},
					icon = {
						folder_closed = "",
						folder_open = "",
						folder_empty = "ﰊ",
						-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
						-- then these will never be used.
						default = "*",
						highlight = "NeoTreeFileIcon",
					},
					modified = {
						symbol = "[+]",
						highlight = "NeoTreeModified",
					},
					name = {
						trailing_slash = false,
						use_git_status_colors = true,
						highlight = "NeoTreeFileName",
					},
					git_status = {
						symbols = {
							-- Change type
							added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
							modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
							deleted = "✖", -- this can only be used in the git_status source
							renamed = "", -- this can only be used in the git_status source
							-- Status type
							untracked = "",
							ignored = "",
							unstaged = "",
							staged = "",
							conflict = "",
						},
					},
				},
				-- A list of functions, each representing a global custom command
				-- that will be available in all sources (if not overridden in `opts[source_name].commands`)
				-- see `:h neo-tree-global-custom-commands`
				commands = {},
				window = {
					position = "left",
					width = 40,
					mapping_options = {
						noremap = true,
						nowait = true,
					},
					mappings = {
						["<space>"] = {
							"toggle_node",
							nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
						},
						["<2-LeftMouse>"] = "open",
						["<cr>"] = "open",
						["<esc>"] = "revert_preview",
						["P"] = { "toggle_preview", config = { use_float = true } },
						["l"] = "focus_preview",
						["S"] = "open_split",
						["s"] = "open_vsplit",
						-- ["S"] = "split_with_window_picker",
						-- ["s"] = "vsplit_with_window_picker",
						["t"] = "open_tabnew",
						-- ["<cr>"] = "open_drop",
						-- ["t"] = "open_tab_drop",
						["w"] = "open_with_window_picker",
						--["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
						["C"] = "close_node",
						-- ['C'] = 'close_all_subnodes',
						["z"] = "close_all_nodes",
						--["Z"] = "expand_all_nodes",
						["a"] = {
							"add",
							-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
							-- some commands may take optional config options, see `:h neo-tree-mappings` for details
							config = {
								show_path = "absolute", -- "none", "relative", "absolute"
							},
						},
						["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
						["d"] = "delete",
						["r"] = "rename",
						["y"] = "copy_to_clipboard",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
						["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
						-- ["c"] = {
						--  "copy",
						--  config = {
						--    show_path = "none" -- "none", "relative", "absolute"
						--  }
						--}
						["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
						["q"] = "close_window",
						["R"] = "refresh",
						["?"] = "show_help",
						["<"] = "prev_source",
						[">"] = "next_source",
					},
				},
				nesting_rules = {},

				sources = {
					"filesystem",
					"buffers",
					"git_status",
					-- "document_symbols",
				},
				filesystem = {
					filtered_items = {
						visible = false, -- when true, they will just be displayed differently than normal items
						hide_dotfiles = false,
						hide_gitignored = true,
						hide_hidden = true, -- only works on Windows for hidden files/directories
						hide_by_name = {
							--"node_modules"
						},
						hide_by_pattern = { -- uses glob style patterns
							--"*.meta",
							--"*/src/*/tsconfig.json",
						},
						always_show = { -- remains visible even if other settings would normally hide it
							--".gitignored",
						},
						never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
							--".DS_Store",
							--"thumbs.db"
						},
						never_show_by_pattern = { -- uses glob style patterns
							--".null-ls_*",
						},
					},
					follow_current_file = true, -- This will find and focus the file in the active buffer every
					-- time the current file is changed while the tree is open.
					group_empty_dirs = true, -- when true, empty folders will be grouped together
					hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
					-- in whatever position is specified in window.position
					-- "open_current",  -- netrw disabled, opening a directory opens within the
					-- window like netrw would, regardless of window.position
					-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
					use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
					-- instead of relying on nvim autocmd events.
					window = {
						mappings = {
							["<bs>"] = "navigate_up",
							["."] = "set_root",
							["H"] = "toggle_hidden",
							["/"] = "fuzzy_finder",
							["D"] = "fuzzy_finder_directory",
							["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
							-- ["D"] = "fuzzy_sorter_directory",
							["f"] = "filter_on_submit",
							["<c-x>"] = "clear_filter",
							["[g"] = "prev_git_modified",
							["]g"] = "next_git_modified",
						},
						fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
							["<down>"] = "move_cursor_down",
							["<C-n>"] = "move_cursor_down",
							["<up>"] = "move_cursor_up",
							["<C-p>"] = "move_cursor_up",
						},
					},

					commands = {}, -- Add a custom command or override a global one using the same function name
				},
				buffers = {
					follow_current_file = true, -- This will find and focus the file in the active buffer every
					-- time the current file is changed while the tree is open.
					group_empty_dirs = true, -- when true, empty folders will be grouped together
					show_unloaded = true,
					window = {
						mappings = {
							["bd"] = "buffer_delete",
							["<bs>"] = "navigate_up",
							["."] = "set_root",
						},
					},
				},
				git_status = {
					window = {
						position = "float",
						mappings = {
							["A"] = "git_add_all",
							["gu"] = "git_unstage_file",
							["ga"] = "git_add_file",
							["gr"] = "git_revert_file",
							["gc"] = "git_commit",
							["gp"] = "git_push",
							["gg"] = "git_commit_and_push",
						},
					},
				},
			})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		enabled = true,
		keys = {
			{
				"<Leader><c-n>",
				function()
					require("nvim-tree.api").tree.toggle(false, true)
				end,
			},
		},
		dependencies = { "antosha417/nvim-lsp-file-operations" },
		config = function()
			local icons = require("core.global.style").icons

			icons = {
				error = icons.error,
				warning = icons.warn,
				info = icons.info,
				hint = icons.hint,
			}

			local function custom_callback(callback_name)
				return ("<Cmd>lua require('core.plugins.nvim-tree.utils').%s()<CR>"):format(callback_name)
			end

			-- this is passed in the call to setup

			require("nvim-tree").setup({
				-- project nvim
				sync_root_with_cwd = true,
				respect_buf_cwd = false,
				prefer_startup_root = true,
				update_focused_file = {
					enable = true,
					update_root = true,
				},
				-- project nvim ~
				disable_netrw = false,
				hijack_netrw = true,
				-- auto_close = false,
				auto_reload_on_write = false,
				open_on_tab = false,
				hijack_cursor = true,
				git = { enable = true, ignore = false, timeout = 500 },
				update_cwd = true,
				diagnostics = { enable = true, icons = icons },
				system_open = { cmd = nil, args = {} },
				actions = {
					open_file = {
						resize_window = true,
						window_picker = {
							exclude = { filetype = { "qf", "help", "terminal", "toggleterm" } },
						},
					},
				},

				view = {
					-- width = 35,
					width = {
						min = 35,
						max = "40%",
					},
					side = "right",
					-- mappings = {
					-- 	custom_only = false,
					-- 	list = {
					-- 		{ key = "<C-f>", cb = custom_callback("launch_find_files") },
					-- 		{ key = "<C-g>", cb = custom_callback("launch_live_grep") },
					-- 	},
					-- },
				},

				renderer = {
					add_trailing = false,
					group_empty = true,
					highlight_opened_files = "name",
					icons = {
						glyphs = {
							default = "",
							symlink = "",
							git = {
								unstaged = "✗",
								staged = "✓",
								unmerged = "",
								renamed = "➜",
								untracked = "★",
								deleted = "",
								ignored = "◌",
							},
							folder = {
								default = "",
								open = "",
								empty = "",
								empty_open = "",
								symlink = "",
								symlink_open = "",
							},
						},
					},
				},
			})
		end,
	},
}

return M
