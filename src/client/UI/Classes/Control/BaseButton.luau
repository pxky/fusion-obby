local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Globals = require(ReplicatedStorage.SRC.Util.Globals)

local Theme = require(script.Parent.Parent.Parent.Theme)
local Window = require(script.Parent.Parent.View.Window)

local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local Computed = Fusion.Computed
local Spring = Fusion.Spring

return function(props)
	if props.Disabled == nil then
		props.Disabled = Value(false)
	elseif typeof(props.Disabled) == "boolean" then
		props.Disabled = Value(props.Disabled)
	end

	local isHovering = Value(false)
	local isHeldDown = Value(false)

	return Window({
		Name = props.Name or "ButtonWindow",
		LayoutOrder = props.LayoutOrder or 1,

		[Children] = {
			New("ImageButton")({
				Image = "rbxassetid://15637224066",
				ImageColor3 = Theme.CurrentThemeColors.Background,
				PressedImage = "rbxassetid://15637224738",
				Rotation = Spring(
					Computed(function()
						return if isHovering:get() then math.random(5, 15) else 0
					end),
					25,
					0.25
				),

				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(512, 512, 512, 512),
				BackgroundTransparency = 1,

				Size = Spring(
					Computed(function()
						return if isHeldDown:get() then UDim2.fromScale(0.9, 0.9) else UDim2.fromScale(1, 1)
					end),
					50,
					0.75
				),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),

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
			}),
		},
	})
end
