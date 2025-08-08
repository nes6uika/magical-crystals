local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Find the Inventory GUI in PlayerGui
local inventoryGui = playerGui:FindFirstChild("Inventory")
if not inventoryGui then
    return
end

-- This script is a child of the Inventory button
local openButton = script.Parent

openButton.MouseButton1Click:Connect(function()
    inventoryGui.Enabled = true
end)

