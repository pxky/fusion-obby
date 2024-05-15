local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local StarterPlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts.SRC

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local UIClasses = StarterPlayerScripts.UI.Classes

local ScreenGui = require(UIClasses.View.ScreenGui)

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Spring = Fusion.Spring
local Computed = Fusion.Computed

local PopupController = {}

local TopPopups = Value({})
local BottomPopups = Value({})

function PopupController:ShowMessageAtTop(props)
	local top_popups = TopPopups:get()
	local new_popup = PopupController:PopupFrame(props)
	table.insert(top_popups, new_popup)
	new_popup.GroupTransparency = 1
	TopPopups:set(top_popups)
	SoundService.Effects.PopupAppear:Play()
end

function PopupController:ShowMessageAtBottom(props)
	local bottom_popups = BottomPopups:get()
	local new_popup = PopupController:PopupFrame(props)
	table.insert(bottom_popups, new_popup)
	new_popup.GroupTransparency = 1
	BottomPopups:set(bottom_popups)
	SoundService.Effects.PopupAppear:Play()
end

function PopupController:PopupFrame(props)
	local isEnabled = Value(false)
	local popup = New("CanvasGroup")({
		BackgroundTransparency = 1,
		GroupTransparency = Spring(
			Computed(function()
				return if isEnabled:get() then 0 else 1
			end),
			25
		),
		Size = UDim2.fromScale(1, 1),

		[Children] = {
			New("TextLabel")({
				Name = "TextShadow",
				FontFace = Font.new("rbxasset://fonts/families/Nunito.json"),
				Text = props.Text or "text placeholder",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextScaled = true,
				BackgroundTransparency = 1,

				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.75, 0.75),

				[Children] = {
					New("TextLabel")({
						FontFace = Font.new("rbxasset://fonts/families/Nunito.json"),
						Text = props.Text or "text placeholder",
						TextColor3 = props.TextColor or Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						BackgroundTransparency = 1,

						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, -2),
						Size = UDim2.fromScale(1, 1),

						[Children] = {
							New("UIGradient")({
								Name = "UIGradient",
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
									ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
									ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100)),
								}),
								Rotation = 90,
							}),
						},
					}),
				},
			}),
		},
	})
	isEnabled:set(true)
	task.delay(3, function()
		isEnabled:set(false)
		task.wait(1)
		popup:Destroy()
	end)

	return popup
end

ScreenGui({
	Name = "Popups",

	[Children] = {
		New("Frame")({
			Name = "Top",
			BackgroundTransparency = 1,

			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0.2),
			Size = UDim2.fromScale(0.5, 0.1),

			[Children] = {
				New("UIListLayout")({
					Name = "UIListLayout",
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top,
				}),

				New("UIAspectRatioConstraint")({
					Name = "UIAspectRatioConstraint",
					AspectRatio = 10,
				}),

				TopPopups,
			},
		}),
		New("Frame")({
			Name = "Bottom",
			BackgroundTransparency = 1,

			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.fromScale(0.5, 0.85),
			Size = UDim2.fromScale(0.5, 0.1),

			[Children] = {
				New("UIListLayout")({
					Name = "UIListLayout",
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
				}),

				New("UIAspectRatioConstraint")({
					Name = "UIAspectRatioConstraint",
					AspectRatio = 10,
				}),

				BottomPopups,
			},
		}),
	},
})

return PopupController
