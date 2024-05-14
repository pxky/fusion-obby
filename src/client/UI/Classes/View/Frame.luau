local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Theme = require(script.Parent.Parent.Parent.Theme)

local Window = require(script.Parent.Window)

local New = Fusion.New
local Children = Fusion.Children

return function(props)
	props[Children] = {
		New("ImageLabel")({
			Name = "Background",
			Image = "rbxassetid://15637223145",
			ImageColor3 = Theme.CurrentThemeColors.Background,
			BackgroundTransparency = 1,

			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(512, 512, 512, 512),
			SliceScale = 0.1,

			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ZIndex = 1,

			[Children] = props[Children],
		}),
	}
	return Window(props)
end
