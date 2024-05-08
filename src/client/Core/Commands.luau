local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient")) :: any

Cmdr:SetActivationKeys({ Enum.KeyCode.F2 })

return {}
