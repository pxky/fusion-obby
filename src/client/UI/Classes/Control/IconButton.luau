local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Classes = script.Parent.Parent
local BaseButton = require(Classes.Control.BaseButton)

local New = Fusion.New
local Children = Fusion.Children

return function(props)
	props[Children] = {
		New("ImageLabel")({
			Image = props.Icon,
			BackgroundTransparency = 1,

			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = props.IconSize or UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.4),
		}),
	}

	return BaseButton(props)
end
