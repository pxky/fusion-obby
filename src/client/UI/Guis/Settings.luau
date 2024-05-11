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
local Observer = Fusion.Observer
local Value = Fusion.Value

local SettingFrames = Value({})

local ScrollingFrame = New("ScrollingFrame")({
	AutomaticCanvasSize = "Y",
	CanvasSize = UDim2.new(0, 0, 0, 0),
	BackgroundTransparency = 1,
	ScrollBarThickness = 8,
	ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
	VerticalScrollBarInset = Enum.ScrollBarInset.Always,

	Size = UDim2.fromScale(1, 1),

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

	Observer(SettingValue):onChange(function()
		SettingService.UpdateSettings(SettingValue:get())
	end)

	local function SettingFrame(setting, value)
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

				if typeof(value) == "boolean"
					then Toggle({
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.fromScale(0.975, 0.5),
						Size = UDim2.fromScale(0.25, 0.9),
					})
					else TextLabel({
						Text = tostring(value),
						TextXAlignment = "Right",

						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.fromScale(0.975, 0.5),
						Size = UDim2.fromScale(0.25, 0.9),
					}),
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
