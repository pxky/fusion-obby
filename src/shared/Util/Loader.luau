local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Component = require(ReplicatedStorage.SRC.Util.Component)

local Loader = {}

function Loader:load_modules(directory: Folder, index_type: string | nil, callback)
	for _, module in ipairs(directory:GetDescendants()) do
		if not module:IsA("ModuleScript") then
			continue
		end
		local code = require(module)
		if typeof(index_type) == "string" then
			code[index_type] = module.Name
		end
		if typeof(callback) == "function" then
			callback(code)
		end
	end
end

if RunService:IsServer() then
	local ServerScriptService = game:GetService("ServerScriptService").SRC
	Loader:load_modules(ServerScriptService.Services, "Name", function(code)
		Knit.CreateService(code)
	end)
	Loader:load_modules(ServerScriptService.Components, "Tag", function(code)
		Component.LoadCode(code)
	end)
	Loader:load_modules(ServerScriptService.Modules, nil, nil)
else
	local StarterPlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts.SRC
	Loader:load_modules(StarterPlayerScripts.Controllers, "Name", function(code)
		Knit.CreateController(code)
	end)
	Loader:load_modules(StarterPlayerScripts.Components, "Tag", function(code)
		Component.LoadCode(code)
	end)
	Loader:load_modules(StarterPlayerScripts.Modules, nil, nil)
end

Knit.Start():catch(warn)

return Loader
