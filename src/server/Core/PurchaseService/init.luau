local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Gamepasses = require(script.Gamepasses)
local Products = require(script.Products)

local PurchaseService = {
	Client = {
		PromptProduct = Knit.CreateSignal(),
		PromptGamepass = Knit.CreateSignal(),

		PromptMessage = Knit.CreateSignal(),
	},
}

function PurchaseService:CanBuyPurchasable(player: Player, purchasableData: {})
	if
		not purchasableData
		or purchasableData["Purchasable"] == false
		or purchasableData["Prerequisite"](player) == false
	then
		self.Client.PromptMessage:Fire(player, {
			["Success"] = false,
			["Message"] = "Purchase failed... You can't buy this right now :(",
		})
		return false
	else
		return true
	end
end

function PurchaseService:PromptProduct(player: Player, productName: string)
	local data = Products[productName]
	if PurchaseService:CanBuyPurchasable(player, data) then
		MarketplaceService:PromptProductPurchase(player, data["Id"])
	end
end

function PurchaseService:PromptGamepass(player: Player, gamepassName: string)
	local data = Gamepasses[gamepassName]
	if PurchaseService:CanBuyPurchasable(player, data) then
		MarketplaceService:PromptGamePassPurchase(player, data["Id"])
	end
end

function PurchaseService:CheckAllGamepasses(player)
	for gamepass, gamepassData in pairs(Gamepasses) do
		pcall(function()
			if MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamepassData.Id) then
				PurchaseService:GiveGamepass(player, gamepass)
			end
		end)
	end
end

function PurchaseService:GiveGamepass(player, gamepassName)
	if Gamepasses[gamepassName]["Function"] then
		Gamepasses[gamepassName]["Function"](player)
	else
		warn(gamepassName, "not a valid gamepass")
	end
end

function PurchaseService:GiveProduct(player, productName)
	if Products[productName]["Function"] then
		Products[productName]["Function"](player)
	else
		warn(productName, "not a valid product")
	end
end

function PurchaseService:KnitStart()
	MarketplaceService.ProcessReceipt = function(receiptInfo)
		local player = Players:GetPlayerByUserId(receiptInfo["PlayerId"])
		for productName, productData in pairs(Products) do
			if productData["Id"] ~= receiptInfo["ProductId"] then
				continue
			end
			self.Client.PromptMessage:Fire(player, {
				["Success"] = true,
				["Message"] = `You have successfully purchased ${productName}!`,
			})
			self:GiveProduct(player, productName)
			return Enum.ProductPurchaseDecision.PurchaseGranted
		end
		self.Client.PromptMessage:Fire(player, {
			["Success"] = false,
			["Message"] = "Purchase failed... Something went wrong :(",
		})
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamepassId, wasPurchased)
		if wasPurchased == true then
			for gamepassName, gamepassData in pairs(Gamepasses) do
				if gamepassData["Id"] ~= gamepassId then
					continue
				end
				self.Client.PromptMessage:Fire(player, {
					["Success"] = true,
					["Message"] = `You have successfully purchased ${gamepassName}!`,
				})
				self:GiveGamepass(player, gamepassName)
				break
			end
		else
			self.Client.PromptMessage:Fire(player, {
				["Success"] = false,
				["Message"] = "Purchase failed :(",
			})
		end
	end)

	for _, player in pairs(Players:GetPlayers()) do
		PurchaseService:CheckAllGamepasses(player)
	end
	Players.PlayerAdded:Connect(function(player)
		PurchaseService:CheckAllGamepasses(player)
	end)

	self.Client.PromptProduct:Connect(function(player, productName)
		PurchaseService:PromptProduct(player, productName)
	end)
	self.Client.PromptGamepass:Connect(function(player, gamepassName)
		PurchaseService:PromptGamepass(player, gamepassName)
	end)
end

return PurchaseService
