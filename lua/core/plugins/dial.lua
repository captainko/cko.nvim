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

	--- mapping dial functions to a specific group
	---@param group string?
	---@param bufnr number?
	local function create_dial_mappings(group, bufnr)
		bufnr = bufnr or vim.api.nvim_get_current_buf()
		nnoremap({ "<C-A>", dial.inc_normal(group), buffer = bufnr })
		nnoremap({ "<C-X>", dial.dec_normal(group), buffer = bufnr })
		vnoremap({ "<C-A>", dial.inc_visual(group), buffer = bufnr })
		vnoremap({ "<C-X>", dial.dec_visual(group), buffer = bufnr })
		vnoremap({ "g<C-A>", dial.inc_gvisual(group), buffer = bufnr })
		vnoremap({ "g<C-X>", dial.dec_gvisual(group), buffer = bufnr })
		-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-a>", require("dial.map").inc_normal(group), { noremap = false })
	end

	create_dial_mappings(nil, nil)

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

	---@param augends Augend[]
	---@return Augend[]
	local function with_default_augends(augends)
		return vim.list_extend(get_default_augends(), augends)
	end

	local FRONTEND_KEY = "frontend_group"
	local frontend_group = with_default_augends({
		augend.constant.new({
			elements = { "const", "let" },
			word = true,
			cyclic = true,
		}),
	})

	local BACKGROUND_KEY = "backend_group"
	local backend_augends = with_default_augends({
		augend.constant.new({
			elements = { "public", "private", "protected" },
			word = true,
			cyclic = true,
		}),
	})

	local GIT_COMMIT_KEY = "git_group"
	local git_commit_augends = with_default_augends({
		augend.constant.new({
			elements = { "feat", "refactor", "fix", "enhance" },
			word = true,
			cyclic = true,
		}),
	})

	local DEPENDENCY_KEY = "dependency_group"
	---@type Augend[]
	local dependency_augends = {
		augend.integer.alias.decimal,
		augend.integer.alias.hex,
		augend.constant.alias.bool,
		augend.semver.alias.semver,
	}

	require("dial.config").augends:register_group({
		-- default augends used when no group name is specified
		default = get_default_augends(),
		[FRONTEND_KEY] = frontend_group,
		[BACKGROUND_KEY] = backend_augends,
		[DEPENDENCY_KEY] = dependency_augends,
		[GIT_COMMIT_KEY] = git_commit_augends,
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "vue", "html", "typescript", "javascript" },
		callback = function(event)
			create_dial_mappings(FRONTEND_KEY, event.buf)
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "yaml", "toml", "json" },
		callback = function(event)
			create_dial_mappings(DEPENDENCY_KEY, event.buf)
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "gitcommit",
		callback = function(event)
			create_dial_mappings(GIT_COMMIT_KEY, event.buf)
		end,
	})
end

return M
