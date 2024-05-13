local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

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

	local size = UDim2.fromScale(1, 1)
	local pressed_size = UDim2.fromScale(0.9, 0.9)

	local Button = New("ImageButton")({
		Image = props.ButtonImage or "rbxassetid://15637224066",
		ImageColor3 = Spring(
			Computed(function()
				local button_color = props.BackgroundColor or Theme.CurrentThemeColors.Background
				if typeof(button_color) == "table" and button_color["type"] == "State" then
					button_color = button_color:get()
				end
				if props.Disabled:get() then
					return Color3.fromRGB(50, 50, 50)
				else
					if isHeldDown:get() then
						button_color = button_color:Lerp(Color3.new(0, 0, 0), 0.25)
					elseif isHovering:get() then
						button_color = button_color:Lerp(Color3.new(1, 1, 1), 0.25)
					end
					return button_color
				end
			end),
			20
		),
		BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(255, 255, 255),
		PressedImage = props.PressedImage or "rbxassetid://15637224738",
		Rotation = Spring(
			Computed(function()
				return if isHovering:get() then props.RotationEffect or 10 else 0
			end),
			25,
			0.25
		),

		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = props.SliceCenter or Rect.new(512, 512, 512, 512),
		BackgroundTransparency = props.BackgroundTransparency or 1,

		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = Spring(
			Computed(function()
				return if isHeldDown:get() then pressed_size else size
			end),
			50,
			0.75
		),

		[Children] = {
			props[Children],
		},

		[OnEvent("Activated")] = function()
			if props.OnClick ~= nil and not props.Disabled:get(false) then
				props.OnClick()
				-- if the gui is disabled the effects dont update.
				if props.FixEffectsOnClick then
					isHovering:set(false)
					isHeldDown:set(false)
				end
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

	return Window({
		Name = props.Name or "ButtonWindow",
		ZIndex = props.ZIndex or 1,
		LayoutOrder = props.LayoutOrder or 1,
		AspectRatio = props.AspectRatio or 1,

		Size = props.Size or UDim2.fromScale(1, 1),
		Position = props.Position or UDim2.fromScale(0.5, 0.5),
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),

		ShadowElavation = props.ShadowElavation or 4,

		[Children] = {
			Button,
		},
	})
end
