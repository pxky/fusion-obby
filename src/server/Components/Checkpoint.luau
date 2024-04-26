local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local ObbyService = require(ServerScriptService.Services.ObbyService)

local Checkpoint = {}
Checkpoint.__index = Checkpoint

function Checkpoint.New(part: BasePart)
    local self = setmetatable({
        Instance = part,
        StageNumber = tonumber(part.Name),
        DebounceList = {},
    }, Checkpoint)

    self:Init()
    return self
end

function Checkpoint:Init()
    self.Instance.Touched:Connect(function(hit)
        local Player = Players:GetPlayerFromCharacter(hit.Parent)
        if not Player or self.DebounceList[Player] then
            return
        end
        self.DebounceList[Player] = true
        task.delay(1, function() 
            self.DebounceList[Player] = nil
        end)
        ObbyService:SetStage(Player, self)
    end)
end

return Checkpoint
