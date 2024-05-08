local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local UIClasses = StarterPlayerScripts.SRC.UI.Classes

local ScreenGui = require(UIClasses.View.ScreenGui)
local Window = require(UIClasses.View.Window)
local Frame = require(UIClasses.View.Frame)

local Children = Fusion.Children

return ScreenGui({
	Name = "Settings",

	[Children] = {
		Window({
			Size = UDim2.fromScale(0.5, 0.5),

			[Children] = {
				Frame({}),
			},
		}),
	},
})
