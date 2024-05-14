local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local LightingHandler = require(script.Parent.LightingHandler)

local TrollHandler = {}

TrollHandler.Functions = {
	["Nuke"] = function()
		print("SILLY NUKE VFX")
		LightingHandler:SetLighting(ReplicatedStorage.LightingProfiles.Nuke)
		-- play warning sound
		-- show warning notification

		-- wait a couple seconds

		-- play explosion sound
		-- show mushroom cloud
		-- screen shake

		-- wait a second

		-- kill all

		task.wait(3)
		LightingHandler:SetDefaultLighting()
	end,
}

Knit.OnStart():andThen(function()
	local TrollService = Knit.GetService("TrollService")

	TrollService.TrollFired:Connect(function(troll_name: string)
		if TrollHandler.Functions[troll_name] then
			TrollHandler.Functions[troll_name]()
		end
	end)
end)

return TrollHandler
