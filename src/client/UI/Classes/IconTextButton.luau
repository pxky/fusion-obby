local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Components = script.Parent
local BaseButton = require(Components.BaseButton)
local TextLabel = require(Components.TextLabel)

local New = Fusion.New
local Children = Fusion.Children

return function(props)
	props[Children] = {
		New("ImageLabel")({
			BackgroundTransparency = 1,
			Image = props.Icon,

			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.4),
		}),

		TextLabel({
			Text = props.Text,
			Size = UDim2.fromScale(0.875, 0.3),
			Position = UDim2.fromScale(0.5, 0.775),
		}),
	}

	return BaseButton(props)
end
