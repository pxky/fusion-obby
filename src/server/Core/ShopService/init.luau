local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local DataService = require(script.Parent.DataService)

local ShopService = {
	Client = {
		RequestPurchase = Knit.CreateSignal(),
	},
}

ShopService.PurchasableIndex = {}
local function indexPurchasables(module: ModuleScript)
	if #module:GetChildren() == 0 then
		for name, purchasableData in pairs(require(module)) do
			if not ShopService.PurchasableIndex[name] then
				ShopService.PurchasableIndex[name] = purchasableData
			else
				warn(name, "already exists in purchasable index")
			end
		end
	else
		for _, subModule in ipairs(module:GetChildren()) do
			indexPurchasables(subModule)
		end
	end
end
indexPurchasables(script.Purchasables)

function ShopService:CanBuyPurchasable(player: Player, purchasableName)
	local purchasableData = ShopService.PurchasableIndex[purchasableName]
	if not purchasableData then
		return false, "Purchasable does not exist."
	end
	if purchasableData.Price > DataService:GetData(player, "Coins") then
		return false, "Not enough coins."
	end
	return true
end

function ShopService:BuyPurchasable(player, purchasableName)
	local purchasableData = ShopService.PurchasableIndex[purchasableName]
	DataService:UpdateData(player, "Coins", function(currentCoins)
		return currentCoins - purchasableData.Price
	end)
	DataService:UpdateData(player, "Inventory", function(currentInventory)
		if not currentInventory[purchasableName] then
			currentInventory[purchasableName] = 0
		end
		currentInventory[purchasableName] += 1
		return currentInventory
	end)
end

function ShopService:KnitStart()
	self.Client.RequestPurchase:Connect(function(player: Player, wantedPurchasable: string)
		if not self:CanBuyPurchasable(player, wantedPurchasable) then
			return
		end
		self:BuyPurchasable(player, wantedPurchasable)
	end)
end

return ShopService
