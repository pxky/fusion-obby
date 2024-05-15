local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local GroupService = game:GetService("GroupService")
local CollectionService = game:GetService("CollectionService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Checkpoints = CollectionService:GetTagged("Checkpoint")

local FreeSkipService = {
	Client = {
		IsInGroup = Knit.CreateSignal(),
		SkipRequest = Knit.CreateSignal(),
	},
}

FreeSkipService.TimeNeededForSkip = 1800
FreeSkipService.MaxFreeSkips = 3

function FreeSkipService:KnitInit()
	local DataService = Knit.GetService("DataService")
	local ObbyService = Knit.GetService("ObbyService")

	self.Client.IsInGroup:Connect(function(player: Player)
		local playerGroups = GroupService:GetGroupsAsync(player.UserId)
		local isInGroup = false
		for _, groupData in pairs(playerGroups) do
			if groupData["Id"] == game.CreatorId then
				isInGroup = true
				break
			end
		end
		FreeSkipService.Client.IsInGroup:Fire(player, isInGroup)
	end)

	task.spawn(function()
		while true do
			for _, player in pairs(Players:GetPlayers()) do
				if
					player.MembershipType == Enum.MembershipType.Premium
					or DataService:GetData(player, "FreeSkips") < FreeSkipService.MaxFreeSkips
				then
					DataService:UpdateData(player, "TimeSpentForSkip", function(currentTime)
						if currentTime >= FreeSkipService.TimeNeededForSkip then
							DataService:UpdateData(player, "FreeSkips", function(currentSkips)
								return currentSkips + 1
							end)
							return 0
						else
							return currentTime + 1
						end
					end)
				end
			end
			task.wait(1)
		end
	end)

	self.Client.SkipRequest:Connect(function(player: Player)
		local freeSkips = DataService:GetData(player, "FreeSkips")
		local stage = DataService:GetData(player, "Stage")
		if freeSkips < 1 or stage >= #Checkpoints - 1 then
			return
		end
		DataService:UpdateData(player, "FreeSkips", function(currentSkips)
			return currentSkips - 1
		end)
		ObbyService:SetStage(player, stage + 1)
	end)
end

return FreeSkipService
