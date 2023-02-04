local prev_file
local M = {}

local function open_alter_file(alter)
	prev_file = vim.fn.expand("%")
	prev_file = vim.fn.substitute(prev_file, [[\(.spec\)]], "", nil)
	-- print(vim.fn.substitute("component.spec.ts", [[\(component\|module\|controller\|repository\|entity\|service\)\(spec.\)\?.\w\+$]], "module.ts",nil));
	vim.api.nvim_command(
		"find "
			.. vim.fn.substitute(
				prev_file,
				[[\(component\|module\|controller\|repository\|entity\|service\).\w\+$]],
				alter,
				nil
			)
	)
end

local function open_svc_file(alter)
	prev_file = vim.fn.expand("%")
	vim.api.nvim_command("find " .. vim.fn.substitute(prev_file, [[-\(gql\|db\).svc.ts$]], alter, nil))
end
M.open_alter_file = open_alter_file

function M.component_html()
	open_alter_file("component.html")
end

function M.module_ts()
	open_alter_file("module.ts")
end

function M.component_ts()
	open_alter_file("component.ts")
end

function M.service_ts()
	open_alter_file("service.ts")
end

function M.switch_svc()
	local fname = vim.fn.expand("%:t")
	local found = string.find(fname, "%-db.svc.ts$")
	if found then
		open_svc_file("-gql.svc.ts")
	else
		open_svc_file("-db.svc.ts")
	end
end

function M.component_style()
	if pcall(open_alter_file, "component.scss") then
		return
	end

	open_alter_file("component.css")
end

function M.repository_ts()
	open_alter_file("repository.ts")
end

function M.entity_ts()
	open_alter_file("entity.ts")
end

function M.controller_ts()
	open_alter_file("controller.ts")
end

function M.test_ts()
	open_alter_file("component.spec.ts")
end

return M
