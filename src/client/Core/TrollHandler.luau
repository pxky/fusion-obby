local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Player = game:GetService("Players").LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Shake = require(ReplicatedStorage.Packages.Shake)

local LightingHandler = require(script.Parent.LightingHandler)
local PopupController = require(script.Parent.PopupController)

local Spring = Fusion.Spring
local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Computed = Fusion.Computed

local TrollHandler = {}

local function createNukeEffect(props)
	return New("Part")({
		Name = "NukePart",
		Anchored = true,
		CanCollide = false,
		Size = Vector3.new(1, 1, 1),
		Transparency = 1,

		[Children] = {
			New("BillboardGui")({
				Name = "BillboardGui",
				Active = true,
				LightInfluence = 1,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				Size = Spring(
					Computed(function()
						return props.nuke_size:get()
					end),
					1,
					1
				),

				[Children] = {
					New("ImageLabel")({
						Name = "ImageLabel",
						Image = "rbxassetid://131389096",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						ImageTransparency = Spring(
							Computed(function()
								return props.nuke_transparency:get()
							end),
							3,
							1
						),
						Position = UDim2.fromScale(0.5, 0),
						Size = UDim2.fromScale(1, 1),
					}),
				},
			}),
		},
	})
end

TrollHandler.Functions = {
	["Nuke"] = function(buyer: string)
		local nuke_size = Value(UDim2.fromScale(0, 0))
		local nuke_transparency = Value(0)
		local effect_part = createNukeEffect({
			["nuke_size"] = nuke_size,
			["nuke_transparency"] = nuke_transparency,
		})
		SoundService.Effects.IncomingNuke:Play()
		PopupController:ShowMessageAtTop({
			Text = `☢️ !! {buyer} launched a Nuke !! ☢️`,
			TextColor = Color3.fromRGB(255, 255, 0),
		})
		task.wait(3)
		SoundService.Effects.NukeExplosion:Play()
		task.wait(3)
		SoundService.Effects.IncomingNuke:Stop()
		LightingHandler:SetLighting(ReplicatedStorage.LightingProfiles.Nuke)
		effect_part.Parent = workspace.Effects
		local playerChar = Player.Character or Player.CharacterAdded:Wait()
		effect_part.Position = playerChar:WaitForChild("HumanoidRootPart").Position - Vector3.new(0, 3, 0)
		nuke_size:set(UDim2.fromScale(50, 50))

		local NukeShake = Shake.new()
		NukeShake.Amplitude = 5
		NukeShake.Frequency = 0.1
		NukeShake.FadeInTime = 0
		NukeShake.SustainTime = 3
		NukeShake.RotationInfluence = Vector3.new(0.1, 0.1, 0.1)
		local camCF = workspace.CurrentCamera.CFrame
		NukeShake:Start()
		NukeShake:BindToRenderStep("Nuke", Enum.RenderPriority.Last.Value, function(pos, rot, done)
			local distance = (effect_part.Position - camCF.Position).Magnitude / 100
			pos = Shake.InverseSquare(pos, distance)
			rot = Shake.InverseSquare(rot, distance)
			workspace.CurrentCamera.CFrame = camCF * CFrame.new(pos) * CFrame.Angles(rot.X, rot.Y, rot.Z)
			if done then
				workspace.CurrentCamera.CFrame = camCF
			end
		end)

		task.wait(1)
		playerChar:WaitForChild("Humanoid").Health = 0
		task.wait(4)
		nuke_transparency:set(1)
		NukeShake:Stop()
		task.wait(3)
		effect_part:Destroy()
		SoundService.Effects.NukeExplosion:Stop()
		LightingHandler:SetDefaultLighting()
	end,
}

Knit.OnStart():andThen(function()
	local TrollService = Knit.GetService("TrollService")

	TrollService.TrollFired:Connect(function(troll_name: string, buyerName: string)
		if TrollHandler.Functions[troll_name] then
			TrollHandler.Functions[troll_name](buyerName)
		end
	end)
end)

return TrollHandler
