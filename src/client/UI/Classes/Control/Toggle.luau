local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local BaseButton = require(script.Parent.BaseButton)

local Children = Fusion.Children
local Spring = Fusion.Spring
local Value = Fusion.Value
local Computed = Fusion.Computed
local New = Fusion.New

local true_color = Color3.fromRGB(0, 200, 0)
local true_color_border = Color3.fromRGB(0, 150, 0)
local false_color = Color3.fromRGB(200, 0, 0)
local false_color_border = Color3.fromRGB(150, 0, 0)

local function generic_gradient_shadow()
	return New("UIGradient")({
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(175, 175, 175)),
		}),
		Rotation = 75,
	})
end

return function(props)
	props.Toggled = Value(false)

	return BaseButton({
		BackgroundColor3 = Spring(
			Computed(function()
				return if props.Toggled:get() then true_color else false_color
			end),
			50,
			1
		),
		Parent = props.Parent,
		BackgroundTransparency = 0,
		AspectRatio = 2,
		SliceCenter = Rect.new(256, 256, 768, 768),

		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
		Position = props.Position or UDim2.fromScale(0.5, 0.5),
		Size = props.Size or UDim2.fromScale(0.5, 0.5),

		ButtonImage = "",
		PressedImage = "",
		RotationEffect = 2,
		ShadowElavation = 0,

		[Children] = {
			New("UICorner")({
				CornerRadius = UDim.new(1, 0),
			}),

			New("UIStroke")({
				Thickness = 3,
				Color = Spring(
					Computed(function()
						return if props.Toggled:get() then true_color_border else false_color_border
					end),
					50,
					1
				),
			}),

			generic_gradient_shadow(),

			New("ImageLabel")({
				BackgroundTransparency = 0,

				Size = UDim2.fromScale(0.75, 0.75),
				Position = Spring(
					Computed(function()
						if props.Toggled:get() then
							return UDim2.fromScale(0.75, 0.5)
						else
							return UDim2.fromScale(0.25, 0.5)
						end
					end),
					50,
					0.25
				),
				AnchorPoint = Vector2.new(0.5, 0.5),

				[Children] = {
					New("UIAspectRatioConstraint")({
						AspectRatio = 1,
					}),

					New("UICorner")({
						CornerRadius = UDim.new(1, 0),
					}),

					generic_gradient_shadow(),
				},
			}),
		},

		OnClick = function()
			props.Toggled:set(not props.Toggled:get())
		end,
	})
end
