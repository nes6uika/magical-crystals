local Players = game:GetService("Players")
local player = Players.LocalPlayer
local inventoryGui = player:WaitForChild("PlayerGui"):WaitForChild("Inventory")

-- Slot container and side panel
local container = inventoryGui:WaitForChild("Canvas"):WaitForChild("Container"):WaitForChild("Main"):WaitForChild("Container")
local sidePanel = inventoryGui:WaitForChild("Canvas"):WaitForChild("Container"):WaitForChild("Main"):WaitForChild("SidePanel")

-- Stats display in SidePanel
local stats = sidePanel:WaitForChild("Stats")
local iconDisplay = stats:FindFirstChild("Tab"):FindFirstChild("Icon") -- change path if needed

-- Slot template
local slotTemplate = container:FindFirstChild("Slot1") -- Rename if you use SlotTemplate

-- Inventory tracker
local collectedCrystals = {}

-- Function to create new slot
local function addCrystalToInventory(imageId, elementName)
	local newSlot = slotTemplate:Clone()
	newSlot.Name = "Slot_" .. #collectedCrystals + 1
	newSlot.Visible = true
	newSlot.Parent = container

	local image = newSlot:FindFirstChild("CrystalImage")
	if image then
		image.Image = imageId
	end

	-- Save crystal data
	local crystalData = {
		element = elementName,
		imageId = imageId,
		slot = newSlot
	}
	table.insert(collectedCrystals, crystalData)

	-- Click event
	newSlot.MouseButton1Click:Connect(function()
		print("Selected crystal:", elementName)
		iconDisplay.Image = imageId -- Update icon in right panel

		-- You can add more info later like:
		-- stats.Level.Text = "Lv 1"
		-- stats.XP.Text = "0/10 XP"
	end)
end

-- addCrystalToInventory("rbxassetid://106112566721529", "Fire")
