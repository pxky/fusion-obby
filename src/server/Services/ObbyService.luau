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
    local playerCharacter = Player.Character or Player.CharacterAdded:Wait()
    playerCharacter:PivotTo(Instance.CFrame + Vector3.new(0, 3, 0))
end

function ObbyService:KnitInit()
	local DataService = Knit.GetService("DataService")
	
	function ObbyService:SetStage(Player: Player, Stage)
		local PlayerStage = DataService:GetData(Player, "Stage")
		print(PlayerStage, Stage.StageNumber)
		if PlayerStage + 1 == Stage.StageNumber then
			PlayerStage += 1
			DataService:SetData(Player, "Stage", PlayerStage)
		end
		DataService:SetData(Player, "CurrentStage", math.clamp(Stage.StageNumber, 0, PlayerStage))
	end

	workspace.ChildAdded:Connect(function(child: Instance)
		local Player = Players:GetPlayerFromCharacter(child)
		if not Player then
			return
		end
		local stage_number = DataService:GetData(Player, "CurrentStage")
		RunService.Stepped:Wait()
		child.Parent = workspace.Players or workspace
		self:TpToPart(Player, ObbyService:GetCheckpointPart(stage_number))
	end)
end

return ObbyService
