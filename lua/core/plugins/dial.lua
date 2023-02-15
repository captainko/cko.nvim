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

	local function get_default_augends()
		return {
			augend.integer.alias.decimal,
			augend.integer.alias.hex,
			augend.date.alias["%Y/%m/%d"],
			augend.constant.alias.bool,
			augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
			augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }),
			augend.constant.new({ elements = { "yes", "no" }, word = true, cyclic = true }),
		}
	end

	local frontend_group_text = "frontend_group"
	local frontend_group = vim.list_extend(get_default_augends(), {
		augend.constant.new({
			elements = { "const", "let" },
			word = true,
			cyclic = true,
		}),
	})

	local backend_group_text = "backend_group"
	local backend_group = vim.list_extend(get_default_augends(), {
		augend.constant.new({
			elements = { "public", "private", "protected" },
			word = true,
			cyclic = true,
		}),
	})

	local dependency_group_text = "dependency_group"
	local dependency_group = {
		augend.integer.alias.decimal,
		augend.integer.alias.hex,
		augend.constant.alias.bool,
		augend.semver.alias.semver,
	}

	require("dial.config").augends:register_group({
		-- default augends used when no group name is specified
		default = get_default_augends(),
		[frontend_group_text] = frontend_group,
		[backend_group_text] = backend_group,
		[dependency_group_text] = dependency_group,
	})

	--- mapping dial functions to a specific group
	---@param group string
	---@param bufnr number
	local function mapped(group, bufnr)
		bufnr = bufnr or vim.api.nvim_get_current_buf()
		nnoremap({ "<C-A>", dial.inc_normal(group), buffer = bufnr })
		nnoremap({ "<C-X>", dial.dec_normal(group), buffer = bufnr })
		vnoremap({ "<C-A>", dial.inc_visual(group), buffer = bufnr })
		vnoremap({ "<C-X>", dial.dec_visual(group), buffer = bufnr })
		vnoremap({ "g<C-A>", dial.inc_gvisual(group), buffer = bufnr })
		vnoremap({ "g<C-X>", dial.dec_gvisual(group), buffer = bufnr })
		-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-a>", require("dial.map").inc_normal(group), { noremap = false })
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "vue", "html", "typescript", "javascript" },
		callback = function(event)
			mapped(frontend_group_text, event.buf)
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "yaml", "toml", "json" },
		callback = function(event)
			mapped(dependency_group_text, event.buf)
		end,
	})
end

return M
