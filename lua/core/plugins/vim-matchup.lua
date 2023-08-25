---@type LazyPluginSpec
local M = {
	"andymass/vim-matchup",
	event = { "CursorMoved" },
}

function M.config()
	local g = vim.g
	g.matchup_matchpref = { html = { tagnameonly = true } }

	g.matchup_matchparen_hi_surround_always = 1
	g.matchup_matchparen_deferred_show_delay = 320
	g.matchup_matchparen_deferred = 1
	g.matchup_matchparen_hi_background = 1
end

return M
