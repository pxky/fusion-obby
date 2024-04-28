local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local CheckpointArrow = ReplicatedStorage.Effects:WaitForChild("CheckpointArrow")

local Arrow = {}

local arrow_hover_info = TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, 0, true)
local arrow_move_info = TweenInfo.new(0.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
local is_arrow_moving = false

function Arrow:TweenToCheckpoint(name: string)
	is_arrow_moving = true
	local checkpoint = workspace.Checkpoints:FindFirstChild(name)
	if not checkpoint then
		CheckpointArrow.Parent = ReplicatedStorage.Effects
		return
	end
	local moveToSpawnTween = TweenService:Create(
        CheckpointArrow.PrimaryPart, 
        arrow_move_info, 
        {CFrame = checkpoint.CFrame + Vector3.new(0, 5, 0)}
    )
	moveToSpawnTween:Play()
	moveToSpawnTween.Completed:Wait()
	is_arrow_moving = false
end

Knit.OnStart():andThen(function()
    local DataController = Knit.GetController("DataController")
    local StageValue = DataController:GetDataValue("Stage")

    CheckpointArrow.Parent = workspace.Effects

    Fusion.Observer(StageValue):onChange(function()
        Arrow:TweenToCheckpoint(StageValue:get() + 1)
    end)
    Arrow:TweenToCheckpoint(StageValue:get() + 1)

    RunService.RenderStepped:Connect(function(deltaTime)
        CheckpointArrow.PrimaryPart.Orientation += Vector3.new(0, 45 * deltaTime, 0)
    end)
    task.spawn(function()
        while true do
            task.wait()
            if is_arrow_moving == true then
                continue
            end
            local hoverTweenUp = TweenService:Create(
                CheckpointArrow.PrimaryPart, 
                arrow_hover_info, 
                {CFrame = CheckpointArrow.PrimaryPart.CFrame + Vector3.new(0, 3, 0)}
            )
            hoverTweenUp:Play()
            hoverTweenUp.Completed:Wait()
        end
    end)
end)

return Arrow
