local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MessagingService = game:GetService("MessagingService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local TrollService = {
	Client = {
		TrollFired = Knit.CreateSignal(),
	},
}

TrollService.IsNuking = false

MessagingService:SubscribeAsync("Nuke All", function(message) end)

TrollService.TrollFunctions = {
	["Nuke"] = function(buyer: Player)
		print("nuke")
	end,
	["Nuke All"] = function(buyer: Player)
		print("nuke all")
	end,
}

function TrollService:FireTroll(buyer: Player, troll_name: string)
	self.Client.TrollFired:FireAll(troll_name)
	if self.TrollFunctions[troll_name] then
		self.TrollFunctions[troll_name](buyer)
	end
end

return TrollService
