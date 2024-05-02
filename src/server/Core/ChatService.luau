local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local ChatService = {
	Name = "ChatService",
	Client = {
		OnMessage = Knit.CreateSignal(),
	},
}

function ChatService:KnitInit()
	function ChatService:SendMessage(message)
		self.Client.OnMessage:FireAll(message)
	end
end

return ChatService
