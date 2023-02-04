return function()
	local dap = require("dap")
	dap.adapters.coreclr = {
		type = "executable",
		command = "netcoredbg",
		args = { "--interpreter=vscode" },
	}

	vim.g.dotnet_build_project = function()
		local default_path = vim.fn.getcwd() .. "/"
		if vim.g["dotnet_last_proj_path"] ~= nil then
			default_path = vim.g["dotnet_last_proj_path"]
		end
		local path = vim.fn.input({ prompt = "Path to your *proj file", default = default_path, completion = "file" })
		vim.g["dotnet_last_proj_path"] = path
		local cmd = "dotnet build -c Debug " .. path .. " > /dev/null"
		print("")
		print("Cmd to execute: " .. cmd)
		local f = os.execute(cmd)
		if f == 0 then
			print("\nBuild: ✔️ ")
		else
			print("\nBuild: ❌ (code: " .. f .. ")")
		end
	end

	vim.g.dotnet_get_dll_path = function()
		local function request()
			return vim.fn.input({
				prompt = "Path to dll",
				default = vim.fn.getcwd() .. "/bin/Debug/",
				completion = "file",
			})
		end

		if vim.g["dotnet_last_dll_path"] == nil then
			vim.g["dotnet_last_dll_path"] = request()
		else
			if vim.fn.confirm("Keep the last dll?\n" .. vim.g["dotnet_last_dll_path"], "&yes\n&no", 1) == 2 then
				vim.g["dotnet_last_dll_path"] = request()
			end
		end

		return vim.g["dotnet_last_dll_path"]
	end

	local config = {
		{
			type = "coreclr",
			name = "Default launch",
			request = "launch",
			console = "externalTerminal",

			env = {
				ASPNETCORE_ENVIRONMENT = "Development",
				ASPNETCORE_URLS = "https://localhost:7100;http://localhost:5016",
			},

			program = function()
				if vim.fn.confirm("Should I recompile first?", "&yes\n&no", 2) == 1 then
					vim.g.dotnet_build_project()
				end
				return vim.g.dotnet_get_dll_path()
			end,
		},
		{
			type = "coreclr",
			name = "Default Attach",
			request = "attach",
			processId = require("dap.utils").pick_process,
		},
	}

	dap.configurations.cs = vim.list_extend(config, dap.configurations.cs or {})
end
