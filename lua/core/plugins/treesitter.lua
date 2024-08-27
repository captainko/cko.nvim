---@type LazyPluginSpec[]
local M = {
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		config = function()
			require("ts_context_commentstring").setup({})
		end,
	},
	{

		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate", -- We recommend updating the parsers on update
		lazy = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			-- "nvim-treesitter/nvim-tree-docs",
			-- "nvim-treesitter/nvim-treesitter-angular",
			-- "ShooTeX/nvim-treesitter-angular",
			"windwp/nvim-ts-autotag",
			"RRethy/nvim-treesitter-endwise",
		},
		config = function()
			local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
			-- parser_configs.http = {
			-- 	install_info = {
			-- 		url = "https://github.com/NTBBloodbath/tree-sitter-http",
			-- 		files = { "src/parser.c" },
			-- 		branch = "main",
			-- 	},
			-- }

			-- parser_configs.org = {
			-- 	install_info = {
			-- 		url = "https://github.com/milisims/tree-sitter-org",
			-- 		revision = "main",
			-- 		files = { "src/parser.c", "src/scanner.cc" },
			-- 	},
			-- 	filetype = "org",
			-- }
			-- list.sql = {
			--   install_info = {
			--     url = "https://github.com/DerekStride/tree-sitter-sql",
			--     files = { "src/parser.c" },
			--     branch = "main",
			--   },
			-- }

			local langs = {
				"bash",
				"c_sharp",
				"cmake",
				"css",
				"diff",
				"dockerfile",
				"git_config",
				"git_rebase",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"go",
				"gomod",
				"gowork",
				"graphql",
				"html",
				"http",
				"ini",
				"java",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"markdown",
				"markdown_inline",
				"org",
				"prisma",
				"pug",
				"query",
				"regex",
				"rust",
				"scss",
				"ssh_config",
				"sxhkdrc",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"vue",
				"yaml",
				"passwd",
				-- "comment",
				-- "sql",
			}
			require("nvim-treesitter.configs").setup({
				modules = {},
				sync_install = false,
				auto_install = true,
				ignore_install = {},
				parser_install_dir = nil,
				ensure_installed = langs, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
				-- ignore_install = { "rust" },
				highlight = {
					enable = not vim.g.vscode, -- false will disable the whole extension
					-- disable = { "html" },
					-- enable = false,
					additional_vim_regex_highlighting = { "org" },
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						-- init_selection = "gnn",
						-- node_incremental = "grn",
						-- scope_incremental = "grc",
						-- node_decremental = "grm",
					},
				},

				indent = {
					enable = true,
					-- disable = false,
					disable = { "typescript" },
				},

				-- rainbow = {
				-- 	enable = not vim.g.vscode, -- false will disable the whole extension
				-- 	disable = { "html", "javascript", "vue" },
				-- 	extended = true,
				-- 	-- max_file_lines = 1000
				-- },

				textobjects = {
					select = {
						enable = true,
						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["i:"] = "@prop.inner",
							["a:"] = "@prop.outer",
							["a,"] = "@comment.outer",
							["i?"] = "@conditional.inner",
							["a?"] = "@conditional.outer",
							["il"] = "@loop.inner",
							["al"] = "@loop.outer",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["ab"] = "@block.outer",
							["ib"] = "@block.inner",
							["ii"] = "@interface.inner",
							["ai"] = "@interface.outer",
							["aa"] = "@attribute.outer",
							["ia"] = "@attribute.inner",
						},
					},
					swap = {
						enable = true,
						swap_next = { ["<Leader>aa"] = "@parameter.inner" },
						swap_previous = { ["<Leader>A"] = "@parameter.inner" },
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
						goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
						goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
						goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
					},
				},
				autopairs = { enable = not vim.g.vscode },
				autotag = { enable = true },
				endwise = { enable = true },
				matchup = {
					enable = true,     -- mandatory, false will disable the whole extension
					disable = { "c", "ruby", "lua" }, -- optional, list of language that will be disabled
				},
				query_linter = {
					enable = true,
					use_virtual_text = true,
					lint_events = { "BufWrite", "CursorHold" },
				},
				tree_docs = { enable = not vim.g.vscode },
			})

			local mapper = require("core.utils.mapper")
			mapper.nnoremap({ "<Leader>th", "<Cmd>TSBufToggle highlight<CR>", silent = true })
		end,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
		lazy = false,
		config = function()
			require("rainbow-delimiters.setup")({
				strategy = {
					[""] = require("rainbow-delimiters.strategy.global"),
					commonlisp = require("rainbow-delimiters.strategy.local"),
				},
				query = {
					[""] = "rainbow-delimiters",
					latex = "rainbow-blocks",
					html = "rainbow-delimiters",
					-- vue = "",
				},
				-- highlight = {
				-- 	"RainbowDelimiterRed",
				-- 	"RainbowDelimiterYellow",
				-- 	"RainbowDelimiterBlue",
				-- 	"RainbowDelimiterOrange",
				-- 	"RainbowDelimiterGreen",
				-- 	"RainbowDelimiterViolet",
				-- 	"RainbowDelimiterCyan",
				-- },
				blacklist = { "c", "cpp" },
			})
		end,
	},
}

return M
