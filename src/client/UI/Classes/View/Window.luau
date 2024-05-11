local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Shadow = require(script.Parent.Parent.Shadow)

local Children = Fusion.Children
local New = Fusion.New

return function(props)
	local Frame = New("Frame")({
		Name = props.Name or "Window",
		Parent = props.Parent,
		LayoutOrder = props.LayoutOrder or 1,

		BackgroundTransparency = 1,
		ZIndex = props.ZIndex or 1,
		Visible = props.Visible or true,

		Size = props.Size or UDim2.fromScale(1, 1),
		Position = props.Position or UDim2.fromScale(0.5, 0.5),
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),

		[Children] = {
			props[Children],

			New("UIAspectRatioConstraint")({
				Name = "UIAspectRatioConstraint",
				AspectRatio = props.AspectRatio or 1,
			}),
		},
	})

	Shadow({
		Parent = Frame,
		Elevation = props.ShadowElavation or 4,
		ZIndex = 0,
	})

	return Frame
end
