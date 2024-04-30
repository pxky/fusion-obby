local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Observer = Fusion.Observer
local Computed = Fusion.Computed
local Spring = Fusion.Spring

local ButtonBase = require(ReplicatedStorage.SRC.Components.UI.BaseButton)

local DifficultyColors = {
	[1] = Color3.fromRGB(13, 105, 172),
	[21] = Color3.fromRGB(91, 154, 76),
	[48] = Color3.fromRGB(255, 176, 0),
}

local DifficultyColorValue = Value(Color3.fromRGB(255, 255, 255))
local StageCounterValue = Value(0)

local ArrowButtonFunction

Knit.OnStart():andThen(function()
	local ObbyService = Knit.GetService("ObbyService")
	local DataController = Knit.GetController("DataController")
	local CurrentStageValue = DataController:GetDataValue("CurrentStage")

	ArrowButtonFunction = function(stage)
		ObbyService.SelectStage:Fire(stage)
	end

	Observer(CurrentStageValue):onChange(function()
		local color = nil
		for index, _ in pairs(DifficultyColors) do
			if CurrentStageValue:get() >= index then
				color = DifficultyColors[index]
			end
		end
		if color == nil then
			color = Color3.fromRGB(255, 255, 255)
		end
		DifficultyColorValue:set(color)
		StageCounterValue:set(CurrentStageValue:get())
	end)
end)

local function ArrowIcon(props)
	return New("ImageLabel")({
		Name = "ArrowIcon",
		Image = props.Image,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = props.Position,
		Size = UDim2.fromScale(0.8, 0.8),
	})
end

local function ArrowButton(props)
	return ButtonBase({
		Name = props.Name,
		BackgroundColor = Spring(DifficultyColorValue, 0.5, 0.5),
		LayoutOrder = props.LayoutOrder,

		[Children] = {
			props[Children],
		},

		OnClick = function()
			if typeof(ArrowButtonFunction) == "function" then
				ArrowButtonFunction(StageCounterValue:get() + props.StageOffsetAmount)
			end
		end,
	})
end

return New("ScreenGui")({
	Name = "Topbar",
	Parent = Players.LocalPlayer.PlayerGui,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	IgnoreGuiInset = true,

	[Children] = {
		New("Frame")({
			Name = "Frame",
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.new(0.5, 0, 0, 5),
			Size = UDim2.fromScale(0.5, 0.1),

			[Children] = {
				New("TextLabel")({
					Name = "StageCounter",
					FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
					Text = Computed(function()
						return "Stage: " .. StageCounterValue:get()
					end),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = 3,
					Size = UDim2.fromScale(0.3, 1),

					[Children] = {
						New("UIStroke")({
							Name = "UIStroke",
							Thickness = 3,
						}),

						New("UIGradient")({
							Name = "UIGradient",
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
								ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 255)),
								ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150)),
							}),
							Rotation = 90,
						}),

						New("UIPadding")({
							Name = "UIPadding",
							PaddingLeft = UDim.new(0.05, 0),
							PaddingRight = UDim.new(0.05, 0),
						}),
					},
				}),

				New("UIListLayout")({
					Name = "UIListLayout",
					Padding = UDim.new(0, 5),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),

				New("UIAspectRatioConstraint")({
					Name = "UIAspectRatioConstraint",
					AspectRatio = 10,
				}),

				ArrowButton({
					Name = "Next",
					LayoutOrder = 4,
					StageOffsetAmount = 1,

					[Children] = {
						ArrowIcon({
							Image = "rbxassetid://16178930246",
							Position = UDim2.fromScale(0.55, 0.475),
						}),
					},
				}),

				ArrowButton({
					Name = "NextExtra",
					LayoutOrder = 5,
					StageOffsetAmount = 10,

					[Children] = {
						ArrowIcon({
							Image = "rbxassetid://16178930246",
							Position = UDim2.fromScale(0.65, 0.475),
						}),
						ArrowIcon({
							Image = "rbxassetid://16178930246",
							Position = UDim2.fromScale(0.4, 0.475),
						}),
					},
				}),

				ArrowButton({
					Name = "Prev",
					LayoutOrder = 2,
					StageOffsetAmount = -1,

					[Children] = {
						ArrowIcon({
							Image = "rbxassetid://16178923469",
							Position = UDim2.fromScale(0.45, 0.475),
						}),
					},
				}),

				ArrowButton({
					Name = "PrevExtra",
					LayoutOrder = 1,
					StageOffsetAmount = -10,

					[Children] = {
						ArrowIcon({
							Image = "rbxassetid://16178923469",
							Position = UDim2.fromScale(0.35, 0.475),
						}),
						ArrowIcon({
							Image = "rbxassetid://16178923469",
							Position = UDim2.fromScale(0.6, 0.475),
						}),
					},
				}),
			},
		}),
	},
})
