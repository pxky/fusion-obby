local Classes = script.Parent.Parent
local IconButton = require(Classes.Control.IconButton)

return function(props)
	return IconButton({
		Name = "CloseButton",
		Icon = "rbxassetid://9545003266",
		BackgroundColor = Color3.fromRGB(200, 0, 0),

		AnchorPoint = Vector2.new(0.8, 0.2),
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.fromScale(0.15, 0.15),

		FixEffectsOnClick = true,
	})
end
