local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts
local ContextActionService = game:GetService("ContextActionService")
local CollectionService = game:GetService("CollectionService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local Player = game:GetService("Players").LocalPlayer

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local Checkpoints = CollectionService:GetTagged("Checkpoint")
local UIClasses = StarterPlayerScripts.SRC.UI.Classes
local ScreenGui = require(UIClasses.View.ScreenGui)
local Frame = require(UIClasses.View.Frame)
local TitleLabel = require(UIClasses.View.TitleLabel)
local TextLabel = require(UIClasses.View.TextLabel)
local CloseButton = require(UIClasses.Control.CloseButton)
local IconTextButton = require(UIClasses.Control.IconTextButton)
local TextButton = require(UIClasses.Control.TextButton)

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Observer = Fusion.Observer
local Computed = Fusion.Computed

local DataController
local PurchaseController
local DisableSkips = Value(false)
local CurrentStageValue = Value(0)
local NukeControlVisible = Value(false)

local FreeSkipGuiEnabled = Value(false)
local hasJoinedGroup = Value(false)
local hasLikedGame = Value(false)
local hasFavoritedGame = Value(false)
local hasCompletedVerification = Computed(function()
	if hasJoinedGroup:get() and hasLikedGame:get() and hasFavoritedGame:get() then
		return true
	else
		return false
	end
end)

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
	DataController = Knit.GetController("DataController")
	PurchaseController = Knit.GetController("PurchaseController")
	local FreeSkipService = Knit.GetService("FreeSkipService")
	local FreeSkipsValue = DataController:GetDataValue("FreeSkips")
	local TimeSpentForSkipValue = DataController:GetDataValue("TimeSpentForSkip")

	Observer(DataController:GetDataValue("Stage")):onChange(function()
		DisableSkips:set(DataController:GetDataValue("Stage"):get() >= #Checkpoints - 1)
	end)
	Observer(DataController:GetDataValue("CurrentStage")):onChange(function()
		CurrentStageValue:set(DataController:GetDataValue("CurrentStage"):get())
	end)

	local function dashboardFrame(props)
		return New("Frame")({
			Name = props.Name,
			Visible = props.Visible,
			BackgroundTransparency = 1,

			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.9, 0.8),

			[Children] = props[Children],
		})
	end

	FreeSkipService.IsInGroup:Connect(function(result)
		if result == true then
			hasJoinedGroup:set(true)
			task.wait(2)
			hasLikedGame:set(true)
		end
	end)

	local function formatTime(sec)
		local minutes = math.floor((sec % 3600) / 60)
		local seconds = sec % 60
		return string.format("%02d:%02d", minutes, seconds)
	end

	ScreenGui({
		Name = "FreeSkips",
		Enabled = FreeSkipGuiEnabled,

		[Children] = {
			Frame({
				Name = "FreeSkips",
				Size = UDim2.fromScale(0.75, 0.5),
				AspectRatio = 1.5,

				[Children] = {
					TitleLabel({
						Text = "Free Skips!",
					}),
					CloseButton({
						OnClick = function()
							FreeSkipGuiEnabled:set(false)
						end,
					}),

					dashboardFrame({
						Name = "Verification",
						Visible = Computed(function()
							return not hasCompletedVerification:get()
						end),

						[Children] = {
							TextLabel({
								Text = "1. Join the group!",
								TextXAlignment = Enum.TextXAlignment.Left,
								Position = UDim2.fromScale(0.4, 0.2),
								Size = UDim2.fromScale(0.7, 0.2),
							}),
							TextLabel({
								Text = "2. Favorite the game!",
								Position = UDim2.fromScale(0.4, 0.4),
								Size = UDim2.fromScale(0.7, 0.2),
								TextXAlignment = Enum.TextXAlignment.Left,
							}),
							TextLabel({
								Text = "3. Like the game!",
								Position = UDim2.fromScale(0.4, 0.6),
								Size = UDim2.fromScale(0.7, 0.2),
								TextXAlignment = Enum.TextXAlignment.Left,
							}),

							TextLabel({
								Text = Computed(function()
									return if hasJoinedGroup:get() then "✅" else "❌"
								end),
								Position = UDim2.fromScale(0.9, 0.2),
								Size = UDim2.fromScale(0.2, 0.2),
							}),
							TextLabel({
								Text = Computed(function()
									return if hasFavoritedGame:get() then "✅" else "❌"
								end),
								Position = UDim2.fromScale(0.9, 0.4),
								Size = UDim2.fromScale(0.2, 0.2),
							}),
							TextLabel({
								Text = Computed(function()
									return if hasLikedGame:get() then "✅" else "❌"
								end),
								Position = UDim2.fromScale(0.9, 0.6),
								Size = UDim2.fromScale(0.2, 0.2),
							}),

							TextButton({
								Text = "Verify!",
								BackgroundColor = Color3.fromRGB(0, 255, 0),
								AspectRatio = 5,
								Position = UDim2.fromScale(0.5, 0.875),
								Size = UDim2.fromScale(0.8, 0.3),
								RotationEffect = 2,

								OnClick = function()
									FreeSkipService.IsInGroup:Fire()

									pcall(function()
										AvatarEditorService:PromptSetFavorite(
											game.PlaceId,
											Enum.AvatarItemType.Asset,
											true
										)
										task.delay(4, function()
											hasFavoritedGame:set(true)
										end)
									end)
								end,
							}),
						},
					}),

					dashboardFrame({
						Name = "Dashboard",
						Visible = Computed(function()
							return hasCompletedVerification:get()
						end),

						[Children] = {
							TextLabel({
								Text = Computed(function()
									return `You have {FreeSkipsValue:get()} free skips!`
								end),
								Position = UDim2.fromScale(0.5, 0.1),
								Size = UDim2.fromScale(0.9, 0.2),
							}),
							TextLabel({
								Text = Computed(function()
									return `Time until next skip: {formatTime(1800 - TimeSpentForSkipValue:get())}`
								end),
								Position = UDim2.fromScale(0.5, 0.3),
								Size = UDim2.fromScale(0.9, 0.2),
							}),
							TextLabel({
								Text = "Free skip every 30 minutes. Maximum of 3 skips or unlimited if you have premium!",
								TextColor = Color3.fromRGB(150, 150, 150),
								Position = UDim2.fromScale(0.5, 0.55),
								Size = UDim2.fromScale(0.9, 0.3),
							}),

							TextButton({
								Text = "Skip!",
								BackgroundColor = Color3.fromRGB(0, 100, 255),
								AspectRatio = 5,
								Position = UDim2.fromScale(0.5, 0.875),
								Size = UDim2.fromScale(0.8, 0.3),
								RotationEffect = 2,

								OnClick = function()
									FreeSkipService.SkipRequest:Fire()
								end,
							}),
						},
					}),
				},
			}),
		},
	})
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

					OnClick = function()
						PurchaseController:PromptProduct("Skip")
					end,
					Disabled = DisableSkips,
				}),

				IconTextButton({
					Text = "FREE Skip",
					Icon = "rbxassetid://16213594570",
					LayoutOrder = 3,
					Disabled = DisableSkips,

					OnClick = function()
						FreeSkipGuiEnabled:set(not FreeSkipGuiEnabled:get())
					end,
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

									OnClick = function()
										PurchaseController:PromptProduct("Nuke")
									end,
								}),
								TextButton({
									Text = "☢️ ALL Servers ☢️",
									ZIndex = 2,
									BackgroundColor = Color3.fromRGB(50, 50, 50),
									AspectRatio = 6,
									RotationEffect = 2,

									Position = UDim2.fromScale(0.5, 0.725),
									Size = UDim2.fromScale(0.95, 0.45),

									OnClick = function()
										PurchaseController:PromptProduct("Nuke All")
									end,
								}),
							},
						}),
					},
				}),
			},
		}),
	},
})
