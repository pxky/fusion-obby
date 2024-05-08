local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

return function(context, player: Player, stage: number)
	local ObbyService = Knit.GetService("ObbyService")

	ObbyService:SetStage(player, stage)

	return "Set players stage!"
end
