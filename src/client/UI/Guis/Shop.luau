local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local UIClasses = StarterPlayerScripts.SRC.UI.Classes

local ScreenGui = require(UIClasses.View.ScreenGui)
local CloseButton = require(UIClasses.Control.CloseButton)
local TitleLabel = require(UIClasses.View.TitleLabel)
local Frame = require(UIClasses.View.Frame)

local Children = Fusion.Children
local New = Fusion.New
local Value = Fusion.Value

local shop = {}

local CategoryButtons = Value({})

shop.GuiEnabled = Value(false)
shop.CurrentCategory = Value("halos")

ScreenGui({
	Name = "Shop",
	Enabled = shop.GuiEnabled,

	[Children] = {
		Frame({
			AspectRatio = 2,
			Size = UDim2.fromScale(0.75, 0.5),

			[Children] = {
				TitleLabel({
					Text = "Shop",
				}),
				CloseButton({
					OnClick = function()
						shop.GuiEnabled:set(false)
					end,
				}),

				New("Frame")({
					Name = "CategoryButtons",
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.53, 0.075),
					Size = UDim2.fromScale(0.8, 0.2),

					[Children] = {
						New("UIListLayout")({
							Name = "UIListLayout",
							Padding = UDim.new(0.025, 0),
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Center,
						}),

						CategoryButtons,
					},
				}),
			},
		}),
	},
})

return shop
