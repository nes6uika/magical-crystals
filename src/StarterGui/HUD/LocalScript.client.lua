-- StarterGui/HUD/LocalScript
local Players    = game:GetService("Players")
local player     = Players.LocalPlayer
local gui        = script.Parent
local moneyLabel = gui:WaitForChild("MoneyLabel")

-- wait for the leaderstats to exist
local leaderstats = player:WaitForChild("leaderstats")
local money       = leaderstats:WaitForChild("Money")

-- function to update the label text
local function update()
	moneyLabel.Text = "Money: " .. money.Value
end

-- update immediately
update()

-- and whenever it changes
money:GetPropertyChangedSignal("Value"):Connect(update)
