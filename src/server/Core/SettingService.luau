local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local SettingService = {
	Client = {
		UpdateSettings = Knit.CreateSignal(),
	},
}

function SettingService:KnitInit()
	local DataService = Knit.GetService("DataService")

	function SettingService:UpdateSettings(player: Player, settings: {})
		local currentData = DataService:GetData(player, "Settings")
		for setting, settingValue in pairs(currentData) do
			if settingValue ~= settings[setting] then
				if typeof(currentData[setting]) == typeof(settings[setting]) then
					currentData[setting] = settings[setting]
				end
			end
		end
		DataService:SetData(player, "Settings", currentData)
	end

	SettingService.Client.UpdateSettings:Connect(function(player: Player, settingTable)
		self:UpdateSettings(player, settingTable)
	end)
end

return SettingService
