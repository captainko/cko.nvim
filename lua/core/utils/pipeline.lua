local async = require("plenary.async")
---@class Pipeline
---@field _tasks table
local Pipeline = {}

Pipeline.__index = Pipeline

function Pipeline:from_task(task)
	return setmetatable({ _tasks = { task } }, self)
end

function Pipeline:add_task(task)
	table.insert(self._tasks, task)
	return self
end
function Pipeline:after(pipeline)
	if type(pipeline) == "function" then
		pipeline = pipeline()
	end
	self._after = pipeline
	return self
end

function Pipeline:run(cb, err, seed_value)
	err = err or error
	async.void(function()
		local ok
		local results = seed_value

		local idx = 1
		repeat
			ok, results = self._tasks[idx](results)
			idx = idx + 1
		until not ok or idx > #self._tasks

		-- Err should ultimately stop execution
		if not ok then
			err(results)
			return
		end

		if self._after then
			self._after:run(cb, err, results)
		elseif cb then
			cb(ok, results)
		end
	end)()
end

return Pipeline
