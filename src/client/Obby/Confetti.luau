local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local ConfettiPart = ReplicatedStorage.Effects:WaitForChild("StarConfetti")
local ParticleEmitter = ConfettiPart:WaitForChild("ParticleEmitter")

local Confetti = {}

function Confetti:Burst(amount: number)
	ParticleEmitter:Emit(amount)
end

Knit.OnStart():andThen(function()
	local DataController = Knit.GetController("DataController")
	local StageValue = DataController:GetDataValue("Stage")

	ParticleEmitter.Enabled = false
	ConfettiPart.Parent = workspace.Effects

	Fusion.Observer(StageValue):onChange(function()
		ConfettiPart.CFrame = workspace.Checkpoints:FindFirstChild(StageValue:get()).CFrame
		Confetti:Burst(50)
		SoundService.Effects.CheckpointCleared:Play()
	end)
end)

return Confetti
