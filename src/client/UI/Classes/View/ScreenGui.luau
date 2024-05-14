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
		DisplayOrder = props.DisplayOrder or 1,

		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = props.ZIndexBehavior or Enum.ZIndexBehavior.Sibling,

		[Children] = props[Children],
	})
end
