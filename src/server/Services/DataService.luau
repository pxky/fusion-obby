local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local ProfileService = require(ReplicatedStorage.Packages.ProfileService)

local DataService = {
	Profiles = {},
	Client = {
		OwnDataUpdated = Knit.CreateSignal(),
	},
}

DataService.Template = {
	Stage = 0,
	CurrentStage = 0,
}

local profileStore = ProfileService.GetProfileStore("_datastore", DataService.Template)

function DataService:GetProfile(player: Player)
	local profile = DataService.Profiles[player]
	while not profile do
		RunService.Heartbeat:Wait()
		profile = DataService.Profiles[player]
	end
	assert(DataService.Profiles[player], `{player.Name}'s profile does not exist.`)
	return profile
end

function DataService:GetData(player: Player, key)
	local profile = self:GetProfile(player)
	assert(profile.Data[key], `{key} does not exist in {player.Name}'s profile.`)
	return profile.Data[key]
end

function DataService:SetData(player: Player, key, value)
	local profile = self:GetProfile(player)
	assert(profile.Data[key], `{key} does not exist in {player.Name}'s profile.`)
	assert(type(profile.Data[key]) == type(value))
	profile.Data[key] = value
end

function DataService:UpdateData(player: Player, key, callback)
	local oldData = self:GetData(player, key)
	local newData = callback(oldData)
	self:SetData(player, key, newData)
end

function DataService.Client:GetOwnData(player: Player, key)
	return DataService:GetData(player, key)
end

function DataService:KnitInit()
	function DataService:Setup(player: Player)
		local profile = profileStore:LoadProfileAsync("Player_" .. player.UserId)
		if profile ~= nil then
			profile:AddUserId(player.UserId)
			profile:Reconcile()
			profile:ListenToRelease(function()
				DataService.Profiles[player] = nil
				player:Kick()
			end)
			if player:IsDescendantOf(PlayerService) then
				DataService.Profiles[player] = profile
				-- setup leaderstats
			else
				profile:Release()
			end
		else
			player:Kick()
		end
	end
	
	function DataService:Cleanup(player: Player)
		local profile = DataService.Profiles[player]
		if profile ~= nil then
			profile:Release()
		end
	end
end

function DataService:KnitStart()
	for _, player in PlayerService:GetPlayers() do
		self:Setup(player)
	end
	PlayerService.PlayerAdded:Connect(function(player)
		self:Setup(player)
	end)
	PlayerService.PlayerRemoving:Connect(function(player)
		self:Cleanup(player)
	end)
end

return DataService
