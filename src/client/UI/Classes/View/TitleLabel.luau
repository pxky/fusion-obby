local TextLabel = require(script.Parent.TextLabel)

return function(props)
	props.Name = "Title"
	props.AnchorPoint = Vector2.new(0.05, 0.5)
	props.Size = UDim2.fromScale(0.5, 0.15)
	props.Position = UDim2.fromScale(0, 0.025)
	return TextLabel(props)
end
