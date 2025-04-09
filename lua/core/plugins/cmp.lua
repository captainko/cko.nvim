---@diagnostic disable: missing-fields
---@type LazyPluginSpec[]
local M = {
	{
		"tzachar/cmp-tabnine",
		build = "./install.sh",
	},
	{
		"hrsh7th/nvim-cmp",
		enabled = not vim.g.vscode,
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"onsails/lspkind-nvim",
			"hrsh7th/cmp-nvim-lsp", --- lspconfig need this
			"f3fora/cmp-spell",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-calc",
			-- "hrsh7th/cmp-nvim-lsp-signature-help",
			{ "hrsh7th/cmp-copilot", after = "nvim-cmp" },
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-cmdline", -- cmd complete
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			-- { "tzachar/cmp-fuzzy-buffer", dependencies = { "tzachar/fuzzy.nvim" } },
			"tzachar/cmp-tabnine",
		},
		config = function()
			local cmp = require("cmp")

			-- NOTE: for references
			-- local check_back_space = function()
			--   local col = fn.col "." - 1
			--   return col == 0 or fn.getline("."):sub(col, col):match "%s" ~= nil
			-- end

			local menu = {
				nvim_lsp = "[LSP]",
				-- ultisnips = "[UltiSnips]",
				-- gh_pr = "[PR]",
				jira = "[Jira]",
				emoji = "[Emoji]",
				path = "[Path]",
				calc = "[Calc]",
				spell = "[Spell]",
				-- orgmode = "[Org]",
				buffer = "[Buffer]",
				fuzzy_buffer = "[Fuzzy]",
				-- ["vim-dadbod-comletion"] = "[DB]",
				luasnip = "[LuaSnip]",
				cmp_tabnine = "[Tab9]",
				npm = "[NPM]",
				crates = "[Crates]",
				-- neorg = '[Neorg]',
			}

			local function has_words_before()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			local function tab(fallback)
				local luasnip = require("luasnip")

				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif cmp.visible() then
					cmp.select_next_item()
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end

			local function s_tab(fallback)
				local luasnip = require("luasnip")

				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				elseif cmp.visible() then
					cmp.select_prev_item()
				else
					fallback()
				end
			end

			local function get_buffer_source()
				return {
					name = "buffer",
					priority = 7,
					option = {
						-- show recommends from other buffers
						get_bufnrs = function()
							local bufs = {}
							for _, win in ipairs(vim.api.nvim_list_wins()) do
								bufs[vim.api.nvim_win_get_buf(win)] = true
							end
							return vim.tbl_keys(bufs)
						end,
					},
				}
			end

			local compare = cmp.config.compare
			cmp.setup({
				experimental = { ghost_text = {} },
				preselect = cmp.PreselectMode.None,
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				-- cmp.mapping.preset.insert
				mapping = {
					["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
					["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
					-- tab for expand source
					["<Tab>"] = cmp.mapping(tab, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(s_tab, { "i", "s" }),
					["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
					["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
					["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
				},
				-- window = { documentation = {} },
				formatting = {
					deprecated = true,
					format = require("lspkind").cmp_format({ with_text = true, menu = menu }),
				},
				sorting = {
					comparators = {
						compare.offset,
						compare.exact,
						compare.score,

						-- copied from cmp-under, but I don't think I need the plugin for this.
						-- I might add some more of my own.
						function(entry1, entry2)
							local _, entry1_under = entry1.completion_item.label:find("^_+")
							local _, entry2_under = entry2.completion_item.label:find("^_+")
							entry1_under = entry1_under or 0
							entry2_under = entry2_under or 0
							if entry1_under > entry2_under then
								return false
							elseif entry1_under < entry2_under then
								return true
							end
						end,

						compare.kind,
						compare.sort_text,
						compare.length,
						compare.order,
						-- require("cmp_tabnine.compare"),
						-- compare.recently_used,
						-- compare.offset,
						-- compare.exact,
						-- compare.score,
						-- compare.kind,
						-- compare.sort_text,
						-- compare.length,
						-- compare.order,

						---@diagnostic disable-next-line: assign-type-mismatch
						-- compare.locality,
						---@diagnostic disable-next-line: assign-type-mismatch
						-- compare.recently_used,
						-- compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
						-- compare.offset,
						-- compare.order,
					},
				},
				-- sources = {
				-- 	{ name = "nvim_lsp_signature_help" },
				-- 	{ name = "calc" },
				-- 	{ name = "path" },
				-- 	{ name = "luasnip", max_item_count = 4 },
				-- 	{ name = "nvim_lsp", priority = 10 },
				-- 	-- { name = "gh_pr" },
				-- 	-- { name = "jira" },
				-- 	{ name = "cmp_tabnine", max_item_count = 2 },
				-- 	-- { name = "fuzzy_buffer", max_item_count = 3 },
				-- 	source_buffer,
				-- 	-- { name = "spell", max_item_count = 3 },
				-- },
				sources = cmp.config.sources({

					-- { name = "cmp_tabnine", priority = 8 },
					{ name = "nvim_lsp_signature_help", priority = 11 },
					{ name = "nvim_lsp",                priority = 10 },
					-- { name = "nvim_lsp_signature_help", priority = 8 },
					get_buffer_source(),
					{ name = "luasnip",      max_item_count = 4, priority = 7 },
					{ name = "spell",        keywork_length = 3, priority = 5 },
					{ name = "path",         priority = 4 },
					{ name = "fuzzy_buffer", max_item_count = 3, priority = 4 },
					{ name = "calc",         priority = 3 },

					-- { name = "calc" },
					-- { name = "path" },
					-- { name = "luasnip", max_item_count = 4 },
					-- { name = "nvim_lsp", priority = 10 },
					-- -- { name = "gh_pr" },
					-- -- { name = "jira" },
					-- { name = "cmp_tabnine", max_item_count = 2 },
					-- { name = "fuzzy_buffer", max_item_count = 3 },
					-- source_buffer,
					-- { name = "spell", max_item_count = 3 },
				}),
			})

			-- Use buffer source for `/`.
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "nvim_lsp_document_symbol" },
				}, { { name = "path" } }, {
					{ name = "buffer" }, --[[ { name = "fuzzy_buffer", max_item_count = 3 } ]]
				}),
			})

			-- Use cmdline & path source for ':'.
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
					{ name = "cmdline" },
					-- { name = "fuzzy_buffer", max_item_count = 3, priority = 1 },
				}),
			})

			cmp.setup.filetype("gitcommit", {
				sources = {
					get_buffer_source(),
					{ name = "cmp_tabnine", max_item_count = 2, priority = 8 },
					{ name = "luasnip",     max_item_count = 4 },
					{ name = "tab",         max_item_count = 4 },
					{ name = "path" },
					{ name = "jira" },
				},
			})

			cmp.setup.filetype({ "json", "jsonc" }, {
				sources = {
					{ name = "npm" },
					{ name = "nvim_lsp", priority = 3 },
					{ name = "luasnip",  max_item_count = 4 },
					{ name = "path" },
					get_buffer_source(),
				},
			})

			require("core.plugins.cmp.sources.cmp_jira")
		end,
	},
}

return M
