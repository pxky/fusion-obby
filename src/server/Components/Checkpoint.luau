local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Checkpoint = {}
Checkpoint.__index = Checkpoint

function Checkpoint.New(part: BasePart)
	local self = setmetatable({
		Instance = part,
		StageNumber = tonumber(part.Name),
		DebounceList = {},
	}, Checkpoint)

	self:Init()
	return self
end

function Checkpoint:Init()
	Knit.OnStart():andThen(function()
		local ObbyService = Knit.GetService("ObbyService")

		self.Instance.Touched:Connect(function(hit)
			local Player = Players:GetPlayerFromCharacter(hit.Parent)
			if not Player or self.DebounceList[Player] then
				return
			end
			self.DebounceList[Player] = true
			task.delay(1, function()
				self.DebounceList[Player] = nil
			end)
			ObbyService:SetStage(Player, self)
		end)
	end)
end

return Checkpoint
