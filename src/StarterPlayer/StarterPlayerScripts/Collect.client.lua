local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local inventoryGui = playerGui:WaitForChild("Inventory")
local slot1 = inventoryGui:WaitForChild("Canvas")
	:WaitForChild("Container")
	:WaitForChild("Main")
	:WaitForChild("Container")
	:WaitForChild("Slot1")

-- Get the existing CrystalImage inside the slot
local crystalImage = slot1:WaitForChild("CrystalImage")

local function addCrystalToSlot1(iconAssetId)
	crystalImage.Image = iconAssetId
	crystalImage.Visible = true -- Make sure it is visible when adding
end

-- Example: listen to RemoteEvent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectCrystalEvent = ReplicatedStorage:WaitForChild("CollectCrystalEvent")

CollectCrystalEvent.OnClientEvent:Connect(function(crystalIconId)
	addCrystalToSlot1(crystalIconId)
end)
