local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local UIClasses = StarterPlayerScripts.SRC.UI.Classes

local ScreenGui = require(UIClasses.View.ScreenGui)
local CloseButton = require(UIClasses.Control.CloseButton)
local TitleLabel = require(UIClasses.View.TitleLabel)
local TextLabel = require(UIClasses.View.TextLabel)
local Toggle = require(UIClasses.Control.Toggle)
local Frame = require(UIClasses.View.Frame)

local Children = Fusion.Children
local New = Fusion.New
local Value = Fusion.Value

local SettingFrames = Value({})

local SettingFunctions = {
	["Night Time"] = function(value)
		if value then
			game.Lighting.ClockTime = 5
		else
			game.Lighting.ClockTime = 15
		end
	end,
	["Shadows Enabled"] = function(value)
		game:GetService("Lighting").GlobalShadows = value
	end,
}

local ScrollingFrame = New("ScrollingFrame")({
	AutomaticCanvasSize = "Y",
	CanvasSize = UDim2.new(0, 0, 0, 0),
	BackgroundTransparency = 1,
	ScrollBarThickness = 8,
	ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
	VerticalScrollBarInset = Enum.ScrollBarInset.Always,

	Size = UDim2.fromScale(1, 0.975),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),

	[Children] = {
		New("UIListLayout")({
			SortOrder = "Name",
			FillDirection = "Vertical",
			Padding = UDim.new(0.025, 0),
		}),

		SettingFrames,
	},
})

Knit.OnStart():andThen(function()
	local SettingService = Knit.GetService("SettingService")
	local DataController = Knit.GetController("DataController")
	local SettingValue = DataController:GetDataValue("Settings")

	local function SettingFrame(setting, value)
		local settingControl
		local settingType = typeof(value)

		local function update(newValue)
			local setting_table = SettingValue:get()
			setting_table[setting] = newValue
			SettingValue:set(setting_table)
			if SettingFunctions[setting] then
				SettingFunctions[setting](newValue)
			end
			SettingService.UpdateSettings:Fire(setting_table)
		end
		update(value)

		if settingType == "boolean" then
			settingControl = Toggle({
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.fromScale(0.975, 0.5),
				Size = UDim2.fromScale(0.25, 0.9),

				OnClick = update,
				Toggled = value,
			})
		else
			--[[
				settingControl = TextBox({
				Text = tostring(value),
				TextXAlignment = "Right",

				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.fromScale(0.975, 0.5),
				Size = UDim2.fromScale(0.25, 0.9),
			})
			]]
		end

		local Frame = New("Frame")({
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0.15),

			[Children] = {
				TextLabel({
					Text = tostring(setting),
					TextXAlignment = "Left",

					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0.025, 0.5),
					Size = UDim2.fromScale(0.65, 0.75),
				}),

				settingControl,
			},
		})

		return Frame
	end

	local frames = {}
	for setting, value in pairs(SettingValue:get()) do
		table.insert(frames, SettingFrame(setting, value))
	end
	SettingFrames:set(frames)
end)

local Gui = ScreenGui({
	Name = "Settings",
})

Frame({
	Parent = Gui,
	Size = UDim2.fromScale(0.5, 0.5),

	[Children] = {
		CloseButton({
			CloseGui = Gui,
		}),
		TitleLabel({
			Text = "Settings",
		}),
		New("CanvasGroup")({ -- fix clipping
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0.95, 0.875),
			Position = UDim2.fromScale(0.025, 0.1),

			[Children] = {
				ScrollingFrame,
			},
		}),
	},
})

return {}
