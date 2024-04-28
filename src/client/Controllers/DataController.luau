local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local DataController = {}

DataController.PlayerData = {}

function DataController:GetDataValue(key)
    local data = DataController.PlayerData[key]
	while not data do
		RunService.Heartbeat:Wait()
		data = DataController.PlayerData[key]
	end
	assert(DataController.PlayerData[key], `{key} data key does not exist.`)
	return DataController.PlayerData[key]
end

function DataController:SetData(key, value)
    if not DataController.PlayerData[key] then
        DataController.PlayerData[key] = Fusion.Value(value)
    else
        DataController.PlayerData[key]:set(value)
    end
end

function DataController:KnitStart()
    local DataService = Knit.GetService("DataService")

    DataService:GetOwnData():andThen(function(data)
        for key, value in pairs(data) do
            DataController:SetData(key, value)
        end
    end)

    DataService.OwnDataUpdated:Connect(function(key, value)
        DataController:SetData(key, value)
    end)
end

return DataController
 