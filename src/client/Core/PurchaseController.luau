local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts.SRC

local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local UIClasses = StarterPlayerScripts.UI.Classes
local ScreenGui = require(UIClasses.View.ScreenGui)

local Value = Fusion.Value
local Children = Fusion.Children

local PurchaseController = {}

local IsPurchasing = Value(false)

function PurchaseController:KnitInit()
	local PurchaseService = Knit.GetService("PurchaseService")

	function PurchaseController:PromptProduct(productName: string)
		print("prompting: " .. productName)
		PurchaseService:PromptProduct(productName)
		IsPurchasing:set(true)
	end

	function PurchaseController:PromptGamepass(gamepassName: string)
		print("prompting: " .. gamepassName)
		PurchaseService:PromptGamepass(gamepassName)
		IsPurchasing:set(true)
	end

	PurchaseService.PromptMessage:Connect(function(messageData: {})
		print(messageData)
		IsPurchasing:set(messageData["Success"])
	end)
end

ScreenGui({
	Name = "PurchaseEffect",
	Enabled = IsPurchasing,

	[Children] = {
		-- todo
	},
})

return PurchaseController
