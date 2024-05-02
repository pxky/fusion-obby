--[[
	DataService.luau
		For use with Knit framework. Module for handling player data with built in leaderstats using profile service.
	Members:
		- DataService.Profiles: table<Player, Profile>
		- DataService.Client: table
		- DataService.Client.OwnDataUpdated: Signal<Player, string, any>
		- DataService.Template: table
		- DataService.Leaderstats: table<string, string>
	Functions:
		- DataService.Client:GetOwnData(player: Player): table
		- DataService:GetProfile(player: Player): Profile
		- DataService:GetData(player: Player, key: string): any
		- DataService:SetData(player: Player, key: string, value: any): nil
		- DataService:UpdateData(player: Player, key: string, callback: (oldData: any) -> any): nil
		- DataService:KnitInit(): nil
		- DataService:Setup(player: Player): nil
		- DataService:Cleanup(player: Player): nil
		- DataService:KnitStart(): nil
]]

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

DataService.Leaderstats = {
	Stage = "IntValue",
}

local profileStore = ProfileService.GetProfileStore("_datastore", DataService.Template)

----- Private Functions -----

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
	self.Client.OwnDataUpdated:Fire(player, key, value)
	self:UpdateLeaderstat(player, key, value)
end

function DataService:UpdateData(player: Player, key, callback)
	local oldData = self:GetData(player, key)
	local newData = callback(oldData)
	self:SetData(player, key, newData)
	self.Client.OwnDataUpdated:Fire(player, key, newData)
	self:UpdateLeaderstat(player, key, newData)
end

function DataService:SetupLeaderstats(player: Player)
	local profile = self:GetProfile(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	for statName: string, valueType: string in pairs(self.Leaderstats) do
		local valueInstance = Instance.new(valueType)
		valueInstance.Name = statName
		valueInstance.Parent = leaderstats
		valueInstance.Value = profile.Data[statName]
	end
end

function DataService:UpdateLeaderstat(player: Player, statName: string, value: any)
	if not self.Leaderstats[statName] then
		return
	end
	local leaderstats = player:FindFirstChild("leaderstats")
	assert(leaderstats, `Leaderstats does not exist in {player.Name}.`)
	local valueInstance = leaderstats:FindFirstChild(statName)
	assert(valueInstance, `{statName} does not exist in {player.Name}'s leaderstats.`)
	valueInstance.Value = value
end

----- Public Functions -----

function DataService.Client:GetOwnData(player: Player)
	return DataService:GetProfile(player).Data
end

----- Initialize -----

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
				self:SetupLeaderstats(player)
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
