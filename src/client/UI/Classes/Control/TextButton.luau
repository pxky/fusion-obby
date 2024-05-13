local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Classes = script.Parent.Parent
local BaseButton = require(Classes.Control.BaseButton)
local TextLabel = require(Classes.View.TextLabel)

local Children = Fusion.Children

return function(props)
	props[Children] = props[Children] or {}
	table.insert(props[Children], {
		TextLabel({
			Text = props.Text,
			Size = UDim2.fromScale(0.875, 0.875),
			Position = UDim2.fromScale(0.5, 0.45),
		}),
	})

	return BaseButton(props)
end
