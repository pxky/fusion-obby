local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Classes = script.Parent.Parent
local BaseButton = require(Classes.Control.BaseButton)
local TextLabel = require(Classes.View.TextLabel)

local New = Fusion.New
local Children = Fusion.Children

return function(props)
	props[Children] = props[Children] or {}
	table.insert(props[Children], {
		New("ImageLabel")({
			BackgroundTransparency = 1,
			Image = props.Icon,
			ImageRectSize = props.IconRectSize or Vector2.new(0, 0),
			ImageRectOffset = props.IconRectOffset or Vector2.new(0, 0),

			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.4),
		}),

		TextLabel({
			Text = props.Text,
			Size = UDim2.fromScale(0.875, 0.3),
			Position = UDim2.fromScale(0.5, 0.775),
		}),
	})

	return BaseButton(props)
end
