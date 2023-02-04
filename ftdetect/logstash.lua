vim.api.nvim_create_autocmd({
	"BufNewFile",
	"BufRead",
}, {
	pattern = { "*.conf" },
	callback = function()
		---@type string[]
		local lines = vim.fn.getline(1, 1000)
		for _, line in pairs(lines) do
			if string.match(line, "^[ \t]*input[ \t]*{") then
				vim.bo.filetype = "logstash"
				break
			end
		end
	end,
})
