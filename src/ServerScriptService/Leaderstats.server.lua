-- ServerScriptService/Leaderstats
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	-- Create a folder named “leaderstats” – Roblox auto-displays any IntValues inside it on the default scoreboard
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	-- Create the Money IntValue
	local money = Instance.new("IntValue")
	money.Name = "Money"
	money.Value = 0       -- starting money; you can change this or wire it up to your economy
	money.Parent = leaderstats
end)
