local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local New = Fusion.New
local Children = Fusion.Children

return function(props)
	return New("ScreenGui")({
		Name = props.Name or "gui",
		Parent = Players.LocalPlayer.PlayerGui,
		Enabled = props.Enabled or true,

		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

		[Children] = props[Children],
	})
end
