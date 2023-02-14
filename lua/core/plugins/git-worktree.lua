---@type LazyPlugin
local M = {
	"ThePrimeagen/git-worktree.nvim",
	keys = {
		{
			"<Leader>gw",
			desc = "Show all work tree",
			function()
				require("telescope").extensions.git_worktree.git_worktrees()
			end,
		},
		{
			"<Leader>gW",
			desc = "Create a new work tree",
			function()
				require("telescope").extensions.git_worktree.create_git_worktree()
			end,
		},
	},
}

function M.config()
	require("git-worktree").setup({})
end

return M
