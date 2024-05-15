local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MessagingService = game:GetService("MessagingService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local TrollService = {
	Client = {
		TrollFired = Knit.CreateSignal(),
	},
}

TrollService.IsNuking = false

function TrollService:FireTroll(buyer: Player, troll_name: string)
	self.Client.TrollFired:FireAll(troll_name, buyer)
	if self.TrollFunctions[troll_name] then
		self.TrollFunctions[troll_name](buyer.Name)
	end
end

MessagingService:SubscribeAsync("Nuke All", function(message)
	TrollService:FireTroll(message.Data, "Nuke")
end)

local function nukeFired()
	TrollService.IsNuking = true
	task.wait(10)
	TrollService.IsNuking = false
end

TrollService.TrollFunctions = {
	["Nuke"] = function(buyer: Player)
		nukeFired()
	end,
	["Nuke All"] = function(buyer: Player)
		MessagingService:PublishAsync("Nuke All", buyer)
		nukeFired()
	end,
}

return TrollService
