local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Checkpoints = CollectionService:GetTagged("Checkpoint")

local ObbyService = {
	Client = {
		SelectStage = Knit.CreateSignal(),
	},
}

function ObbyService:GetCheckpointPart(number: number)
	local key -- table.find is broken
	for k, v in pairs(Checkpoints) do
		if v.Name == tostring(number) then
			key = k
			break
		end
	end
	return Checkpoints[key]
end

function ObbyService:TpToPart(Player: Player, Instance: BasePart)
	RunService.Stepped:Wait()
    local playerCharacter = Player.Character or Player.CharacterAdded:Wait()
    playerCharacter:PivotTo(Instance.CFrame + Vector3.new(0, 3, 0))
end

function ObbyService:KnitInit()
	local DataService = Knit.GetService("DataService")
	
	function ObbyService:SetStage(Player: Player, Stage)
		local PlayerStage = DataService:GetData(Player, "Stage")
		if PlayerStage + 1 == Stage.StageNumber then
			PlayerStage += 1
			DataService:SetData(Player, "Stage", PlayerStage)
		end
		DataService:SetData(Player, "CurrentStage", math.clamp(Stage.StageNumber, 0, PlayerStage))
	end

	Players.PlayerAdded:Connect(function(Player: Player)
		local stage_number = DataService:GetData(Player, "Stage")
		self:TpToPart(Player, ObbyService:GetCheckpointPart(stage_number))

		Player.CharacterAdded:Connect(function()
			local stage_number = DataService:GetData(Player, "CurrentStage")
			self:TpToPart(Player, ObbyService:GetCheckpointPart(stage_number))
		end)
	end)
end

return ObbyService
