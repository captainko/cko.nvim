local u = require("lspconfig.util")
---@type string[][]
local root_files = {
	{
		"mvnw", --[[Maven]]
	},
	-- Single-module projects
	{ "src", ".idea", ".git" },
	{
		-- "target",
		-- ".classpath",
		-- "build.xml", -- Ant
		"pom.xml", -- Maven
		"settings.gradle", -- Gradle
		"settings.gradle.kts", -- Gradle
	},
	-- Multi-module projects
	{ "build.gradle", "build.gradle.kts" },
}

local profile_settings = nil
local runtimes = {}

if vim.fn.has("linux") then
	runtimes = {
		{ name = "JavaSE-1.7", path = vim.fs.normalize("~/.sdkman/candidates/java/7.0.342-zulu/") },
		{ name = "JavaSE-1.8", path = vim.fs.normalize("~/.sdkman/candidates/java/8.0.302-open/") },
		{ name = "JavaSE-11", path = vim.fs.normalize("~/.sdkman/candidates/java/11.0.12-open/") },
		{ name = "JavaSE-17", path = vim.fs.normalize("~/.sdkman/candidates/java/17.0.2-open/") },
	}
	profile_settings = {
		profile = "GoogleStyle",
		url = vim.fs.normalize("~/.config/jdtls/GoogleStyle.xml"),
	}
end

local M = {
	settings = {
		java = {
			format = {
				enabled = true,
				settings = profile_settings,
			},
			configuration = {
				runtimes = runtimes,
			},
		},
	},
	-- single_file_support = false,
	root_dir = function(fname)
		for _, patterns in ipairs(root_files) do
			local root = u.root_pattern(unpack(patterns))(fname)
			if root then
				return root
			end
		end
	end,
}

return M
