local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts
local ContextActionService = game:GetService("ContextActionService")
local CollectionService = game:GetService("CollectionService")
local Player = game:GetService("Players").LocalPlayer

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local Checkpoints = CollectionService:GetTagged("Checkpoint")
local UIClasses = StarterPlayerScripts.SRC.UI.Classes
local ScreenGui = require(UIClasses.View.ScreenGui)
local Frame = require(UIClasses.View.Frame)
local IconTextButton = require(UIClasses.Control.IconTextButton)
local TextButton = require(UIClasses.Control.TextButton)

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value

local CurrentStageValue = Value(0)
local NukeControlVisible = Value(false)

local function ResetCharacter()
	local character = Player.Character or Player.CharacterAdded:Wait()
	local root_part = character:FindFirstChild("HumanoidRootPart")
	local checkpoint = Checkpoints[table.find(Checkpoints, CurrentStageValue:get())]
	for i, v in pairs(Checkpoints) do
		if tonumber(v.Name) == CurrentStageValue:get() then
			checkpoint = v
		end
	end
	if root_part and checkpoint then
		root_part.CFrame = checkpoint.CFrame + Vector3.new(0, 3, 0)
		character:FindFirstChild("Humanoid").Health = 100
	end
end

Knit.OnStart():andThen(function()
	local DataController = Knit.GetController("DataController")
	CurrentStageValue = DataController:GetDataValue("CurrentStage")
end)

ContextActionService:BindAction("RToReset", function(_, inputState)
	if inputState ~= Enum.UserInputState.Begin then
		return
	end
	ResetCharacter()
end, false, Enum.KeyCode.R)

return ScreenGui({
	Name = "UtilBar",

	[Children] = {
		New("Frame")({
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0.5, 0, 0.11, 5),
			Size = UDim2.fromScale(0.5, 0.1),

			[Children] = {
				New("UIListLayout")({
					Name = "UIListLayout",
					Padding = UDim.new(0, 5),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),

				New("UIAspectRatioConstraint")({
					Name = "UIAspectRatioConstraint",
					AspectRatio = 10,
				}),

				IconTextButton({
					Text = "Skip Stage",
					Icon = "rbxassetid://16213594570",
					LayoutOrder = 2,
				}),

				IconTextButton({
					Text = "FREE Skip",
					Icon = "rbxassetid://16213594570",
					LayoutOrder = 3,
				}),

				IconTextButton({
					Text = "Reset",
					Icon = "rbxassetid://17480482424",
					LayoutOrder = 4,

					OnClick = ResetCharacter,
				}),

				IconTextButton({
					Text = "Nuke",
					Icon = "rbxassetid://13794127980",
					LayoutOrder = 1,

					OnClick = function()
						NukeControlVisible:set(not NukeControlVisible:get())
					end,

					[Children] = {
						Frame({
							Name = "NukeControl",
							Visible = NukeControlVisible,
							AspectRatio = 2.5,

							AnchorPoint = Vector2.new(0.5, 0),
							Position = UDim2.fromScale(0.5, 1.05),
							Size = UDim2.fromScale(3, 2),

							[Children] = {
								TextButton({
									Text = "☢️ This Server ☢️",
									ZIndex = 2,
									BackgroundColor = Color3.fromRGB(100, 200, 100),
									AspectRatio = 6,
									RotationEffect = 2,

									Position = UDim2.fromScale(0.5, 0.275),
									Size = UDim2.fromScale(0.95, 0.45),
								}),
								TextButton({
									Text = "☢️ ALL Servers ☢️",
									ZIndex = 2,
									BackgroundColor = Color3.fromRGB(50, 50, 50),
									AspectRatio = 6,
									RotationEffect = 2,

									Position = UDim2.fromScale(0.5, 0.725),
									Size = UDim2.fromScale(0.95, 0.45),
								}),
							},
						}),
					},
				}),
			},
		}),
	},
})
