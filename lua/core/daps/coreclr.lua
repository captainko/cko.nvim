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
		local path = vim.fn.input({
			prompt = "Path to your *proj file",
			default = default_path,
			completion = "file",
		})
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

	vim.g.dotnet_get_dll_path = function(coro)
		local function request(co)
			local opts = {}

			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local conf = require("telescope.config").values
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			pickers.new(opts, {
				prompt_title = "Debug DLL",
				finder = finders.new_oneshot_job({
					"fd",
					"--hidden",
					"--no-ignore",
					"--full-path",
					"--glob",
					"**/bin/Debug/**/*.dll",
				}, {}),
				sorter = conf.generic_sorter(opts),
				attach_mappings = function(buffer_number)
					actions.select_default:replace(function()
						actions.close(buffer_number)
						local path = action_state.get_selected_entry()[1]
						vim.g["dotnet_last_dll_path"] = path
						coroutine.resume(co, path)
					end)
					return true
				end,
			}):find()
		end

		if vim.g["dotnet_last_dll_path"] == nil then
			return request(coro)
		else
			if vim.fn.confirm("Keep the last dll?\n" .. vim.g["dotnet_last_dll_path"],
					"&yes\n&no", 1) == 2 then
				return request(coro)
			end
		end

		coroutine.resume(coro, vim.g["dotnet_last_dll_path"])
		-- if vim.fn.confirm("Keep the last dll?\n" .. vim.g["dotnet_last_dll_path"], "&yes\n&no", 1) == 2 then
		-- 	vim.g["dotnet_last_dll_path"] = request(coro)
		-- end
		-- return vim.g["dotnet_last_dll_path"]
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
				return coroutine.create(function(coro)
					if vim.fn.confirm("Should I recompile first?", "&yes\n&no", 2) == 1 then
						vim.g.dotnet_build_project()
					end
					vim.g.dotnet_get_dll_path(coro)
				end)

				-- if vim.fn.confirm("Should I recompile first?", "&yes\n&no", 2) == 1 then
				-- 	vim.g.dotnet_build_project()
				-- end
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
