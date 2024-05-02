local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Theme = require(script.Parent.Parent.Parent.UI.Theme)

local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value

return function(props)
	if props.Disabled == nil then
		props.Disabled = Value(false)
	elseif typeof(props.Disabled) == "boolean" then
		props.Disabled = Value(props.Disabled)
	end

	local isHovering = Value(false)
	local isHeldDown = Value(false)

	return New("ImageButton")({
		Name = "BaseButton",
		Image = "rbxassetid://15637224066",
		ImageColor3 = Theme.CurrentThemeColors.Background,
		PressedImage = "rbxassetid://15637224738",
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(512, 512, 512, 512),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder or 1,
		Size = UDim2.fromScale(1, 1),

		[Children] = {
			New("UIAspectRatioConstraint")({
				Name = "UIAspectRatioConstraint",
				AspectRatio = props.AspectRatio or 1,
			}),
			props[Children],
		},

		[OnEvent("Activated")] = function()
			if props.OnClick ~= nil and not props.Disabled:get(false) then
				props.OnClick()
			end
		end,

		[OnEvent("MouseButton1Down")] = function()
			isHeldDown:set(true)
		end,

		[OnEvent("MouseButton1Up")] = function()
			isHeldDown:set(false)
		end,

		[OnEvent("MouseEnter")] = function()
			isHovering:set(true)
		end,

		[OnEvent("MouseLeave")] = function()
			isHovering:set(false)
			isHeldDown:set(false)
		end,
	})
end
