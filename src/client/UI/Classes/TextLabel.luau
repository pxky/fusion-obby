local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local New = Fusion.New
local Children = Fusion.Children

type Props = {
	Text: string?,
	LayoutOrder: number?,
	Size: UDim2?,
	Position: UDim2?,
}

return function(props: Props)
	return New("TextLabel")({
		FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
		Text = props.Text,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextScaled = true,
		TextWrapped = true,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder or 1,
		Size = props.Size or UDim2.fromScale(1, 1),
		Position = props.Position or UDim2.fromScale(0.5, 0.5),

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
		},
	})
end
