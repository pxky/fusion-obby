local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local UIClasses = StarterPlayerScripts.SRC.UI.Classes

local ScreenGui = require(UIClasses.View.ScreenGui)
local IconTextButton = require(UIClasses.Control.IconTextButton)

local New = Fusion.New
local Children = Fusion.Children

return ScreenGui({
	Name = "LeftSide",

	[Children] = {
		New("Frame")({
			Name = "Frame",
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 5, 0.5, 0),
			Size = UDim2.fromScale(0.15, 0.5),

			[Children] = {
				New("UIListLayout")({
					Name = "UIListLayout",
					Padding = UDim.new(0, 5),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),

				New("UIAspectRatioConstraint")({
					Name = "UIAspectRatioConstraint",
					AspectRatio = 0.25,
				}),

				IconTextButton({
					Text = "Shop",
					Icon = "rbxassetid://15282199149",
					LayoutOrder = 1,
				}),

				IconTextButton({
					Text = "Backpack",
					Icon = "rbxassetid://15350056439",
					LayoutOrder = 2,
				}),

				IconTextButton({
					Text = "Settings",
					Icon = "rbxassetid://15282200659",
					LayoutOrder = 3,
				}),
			},
		}),
	},
})
