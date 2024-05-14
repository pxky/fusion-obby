local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts.SRC

local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local UIClasses = StarterPlayerScripts.UI.Classes
local ScreenGui = require(UIClasses.View.ScreenGui)

local Value = Fusion.Value
local Children = Fusion.Children
local New = Fusion.New
local Tween = Fusion.Tween
local Spring = Fusion.Spring
local Observer = Fusion.Observer
local Computed = Fusion.Computed

local PurchaseController = {}

local IsPurchasing = Value(false)
local SpinningIconRotation = Value(0)

function PurchaseController:KnitInit()
	local PurchaseService = Knit.GetService("PurchaseService")
	local PopupController = Knit.GetController("PopupController")

	function PurchaseController:PromptProduct(productName: string)
		PurchaseService.PromptProduct:Fire(productName)
		IsPurchasing:set(true)
	end

	function PurchaseController:PromptGamepass(gamepassName: string)
		PurchaseService.PromptGamepass:Fire(gamepassName)
		IsPurchasing:set(true)
	end

	PurchaseService.PromptMessage:Connect(function(messageData: {})
		PopupController:ShowMessageAtBottom({
			Text = messageData["Message"],
			TextColor = if messageData["Success"] then Color3.fromRGB(0, 200, 0) else Color3.fromRGB(200, 0, 0),
		})
		task.wait(0.25)
		IsPurchasing:set(false)
	end)

	Observer(IsPurchasing):onChange(function()
		while IsPurchasing:get() do
			SpinningIconRotation:set(SpinningIconRotation:get() + 1800)
			task.wait(3)
		end
	end)
end

ScreenGui({
	Name = "PurchaseEffect",
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 100,

	[Children] = {
		New("CanvasGroup")({
			Name = "CanvasGroup",
			BackgroundTransparency = 1,
			GroupTransparency = Spring(
				Computed(function()
					return if IsPurchasing:get() then 0 else 1
				end),
				10
			),

			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),

			[Children] = {
				New("Frame")({
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 0.5,

					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(1, 1),
				}),

				New("ImageLabel")({
					Name = "SpinningIcon",
					BackgroundTransparency = 1,
					Image = "rbxassetid://17488504457",
					ImageColor3 = Color3.fromRGB(0, 0, 0),
					Rotation = Tween(
						SpinningIconRotation,
						TweenInfo.new(3, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut)
					),

					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.2, 0.2),
					ZIndex = 2,

					[Children] = {
						New("UIAspectRatioConstraint")({
							Name = "UIAspectRatioConstraint",
						}),

						New("ImageLabel")({
							Name = "ImageLabel",
							Image = "rbxassetid://17488504457",
							BackgroundTransparency = 1,

							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.45),
							Size = UDim2.fromScale(1, 1),
						}),
					},
				}),
			},
		}),
	},
})

return PurchaseController
