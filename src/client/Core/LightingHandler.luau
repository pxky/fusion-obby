local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local Observer = Fusion.Observer

local LightingHandler = {}

LightingHandler.DefaultLightingFolder = Fusion.Value(nil)

Knit.OnStart():andThen(function()
	local DataController = Knit.GetController("DataController")
	local SettingsValue = DataController:GetDataValue("Settings")

	local function getDefaultLightingFolder()
		local isNightTime = SettingsValue:get()["Night Time"]
		if isNightTime then
			return ReplicatedStorage.LightingProfiles.Nighttime
		else
			return ReplicatedStorage.LightingProfiles.Daytime
		end
	end
	Observer(SettingsValue):onChange(function()
		LightingHandler.DefaultLightingFolder:set(getDefaultLightingFolder())
	end)
	LightingHandler.DefaultLightingFolder:set(getDefaultLightingFolder())
end)

function LightingHandler:SetLighting(folder: Instance)
	if RunService:IsStudio() then
		for _, child in Lighting:GetChildren() do
			child.Parent = nil
		end
	else
		Lighting:ClearAllChildren()
	end
	for _, v in folder:GetChildren() do
		v:Clone().Parent = Lighting
	end
	for attrName, attrValue in folder:GetAttributes() do
		local success, err = pcall(function()
			Lighting[attrName] = attrValue
		end)

		if not success then
			warn(`failed to set lighting property "{attrName}": {err}`)
		end
	end
end

function LightingHandler:SetDefaultLighting()
	self:SetLighting(self.DefaultLightingFolder:get())
end

return LightingHandler
