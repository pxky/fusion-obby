local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local DataService
local ObbyService
local TrollService

Knit.OnStart():andThen(function()
	DataService = Knit.GetService("DataService")
	ObbyService = Knit.GetService("ObbyService")
	TrollService = Knit.GetService("TrollService")
end)

return {
	["Skip"] = {
		Id = 1896356347,
		Prerequisite = function(player)
			local Checkpoints = CollectionService:GetTagged("Checkpoint")
			local max_stage = #Checkpoints - 1
			local current_stage = DataService:GetData(player, "Stage")
			if current_stage < max_stage then
				return true
			else
				return false
			end
		end,
		Function = function(player)
			local current_stage = DataService:GetData(player, "Stage")
			ObbyService:SetStage(player, current_stage + 1)
		end,
	},
	["Nuke"] = {
		Id = 1896356484,
		Prerequisite = function(player)
			return not TrollService.IsNuking
		end,
		Function = function(player)
			TrollService:FireTroll(player, "Nuke")
		end,
	},
	["Nuke All"] = {
		Id = 1896356630,
		Prerequisite = function(player)
			return not TrollService.IsNuking
		end,
		Function = function(player)
			TrollService:FireTroll(player, "Nuke All")
		end,
	},
}
