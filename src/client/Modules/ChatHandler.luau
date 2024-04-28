local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)

local ChatHandler = {}

ChatHandler.ChatTags = {
    [309352419] = { -- ielanie
		{
			TagText = "Bnuuy",
			TagColor = Color3.fromRGB(180, 128, 255),
		},
	},
	[138655565] = { -- caspxerr
		{
			TagText = "casbrr",
			TagColor = Color3.fromRGB(207, 140, 82),
		},
	},
    [3569305331] = { -- poky
		{
			TagText = `🌌`,
			TagColor = Color3.fromRGB(106, 80, 220),
		},
		{
			TagText = "🐈",
			TagColor = Color3.fromRGB(243, 140, 255),
		},
	},
}

function ChatHandler:ConvertColorToHEXString(color: Color3)
	return "#" .. string.format("%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
end



TextChatService.OnIncomingMessage = function(message: TextChatMessage)
	local props = Instance.new("TextChatMessageProperties")
	if message.TextSource then
		local player = Players:GetPlayerByUserId(message.TextSource.UserId)
        local tag_string = ""

        if player:GetAttribute("VIP") == true then
            tag_string = tag_string .. `<font color="rgb(225,255,0)">[VIP]</font>`
		end
        if ChatHandler.ChatTags[player.UserId] then
            for _, tag_data in pairs(ChatHandler.ChatTags[player.UserId]) do
                tag_string = tag_string .. `<font color="{ChatHandler:ConvertColorToHEXString(tag_data.TagColor)}">[{tag_data.TagText}]</font>`
            end
        end
        
        props.PrefixText = `{tag_string} {message.PrefixText}`
	end
	return props
end

Knit.OnStart():andThen(function()
    local ChatService = Knit.GetService("ChatService")
	
	ChatService.OnMessage:Connect(function(message)
		TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(`<font color="rgb(150,150,150)">[Server]: </font>` .. message)
	end)
end)

return ChatHandler
