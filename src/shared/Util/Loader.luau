local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Component = require(ReplicatedStorage.SRC.Util.Component)

local Loader = {
	CachedModules = {},
}

function Loader:load_modules(directory: Folder, callback: (ModuleScript, any) -> nil)
	for _, module in pairs(directory:GetDescendants()) do
		if not module:IsA("ModuleScript") then
			continue
		end

		local success, err = pcall(function()
			local code = require(module)
			if module.Name:match("Component$") then
				code.Tag = module.Name:gsub("Component", "")
				Component.LoadCode(code)
			end

			callback(module, code)
			Loader.CachedModules[module.Name] = code
		end)
		if not success then
			warn(err)
		end
	end
end

if RunService:IsServer() then
	local ServerScriptService = game:GetService("ServerScriptService"):WaitForChild("SRC")

	Loader:load_modules(ServerScriptService, function(module, code)
		if module.Name:match("Service$") then
			code.Name = module.Name
			Knit.CreateService(code)
		end
	end)
else
	local StarterPlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts.SRC

	Loader:load_modules(StarterPlayerScripts, function(module, code)
		if module.Name:match("Controller$") then
			code.Name = module.Name
			Knit.CreateController(code)
		end
	end)
end

Knit.Start():catch(warn)

return Loader
