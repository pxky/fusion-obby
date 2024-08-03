local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ObbyData = require(ReplicatedStorage.SRC.ObbyData)

local Value = Fusion.Value
local Observer = Fusion.Observer
local Spring = Fusion.Spring

local theme = {}
theme.DifficultyColorValueNoSpring = Value(Color3.fromRGB(255, 255, 255))
theme.DifficultyColorValue = Spring(theme.DifficultyColorValueNoSpring, 1, 1)

theme.Themes = {
	["Dark"] = {
		Background = Color3.fromRGB(25, 25, 50),
	},
	["Stage Colors"] = { -- automatically updating colors based on stage
		Background = theme.DifficultyColorValue,
	},
}

theme.CurrentTheme = Value("Stage Colors")
theme.CurrentThemeColors = {}

local function set_theme()
	for color_name, color_value in pairs(theme.Themes[theme.CurrentTheme:get()]) do
		if not theme.CurrentThemeColors[color_name] then
			if color_value["type"] == "State" then
				theme.CurrentThemeColors[color_name] = color_value
				continue -- theme.DifficultyColorValue is already a state !!
			end
			theme.CurrentThemeColors[color_name] = Value(color_value)
		else
			theme.CurrentThemeColors[color_name]:set(color_value)
		end
	end
end

Observer(theme.CurrentTheme):onChange(function()
	set_theme()
end)
set_theme()

Knit.OnStart():andThen(function()
	local DataController = Knit.GetController("DataController")
	local CurrentStageValue = DataController:GetDataValue("CurrentStage")

	Observer(CurrentStageValue):onChange(function()
		local color, biggest_number = nil, 0
		for index, _ in pairs(ObbyData.DifficultyColors) do
			if index > biggest_number and CurrentStageValue:get() >= index then
				biggest_number = index
				color = ObbyData.DifficultyColors[index]
			end
		end
		if color == nil then
			color = Color3.fromRGB(255, 255, 255)
		end
		theme.DifficultyColorValueNoSpring:set(color)
	end)
end)

return theme
