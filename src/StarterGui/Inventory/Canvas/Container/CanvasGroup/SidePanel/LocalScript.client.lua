local inventoryGui = script.Parent
local slotsContainer = inventoryGui:WaitForChild("Canvas"):WaitForChild("Container"):WaitForChild("Main"):WaitForChild("Container")
local selectedFrame = inventoryGui:WaitForChild("SelectedCrystalFrame")

local selectedImage = selectedFrame:WaitForChild("SelectedCrystalImage")
local elementLabel = selectedFrame:WaitForChild("ElementLabel")
local rarityLabel = selectedFrame:WaitForChild("RarityLabel")
local classLabel = selectedFrame:WaitForChild("ClassLabel")
local enchantLabel = selectedFrame:WaitForChild("EnchantmentLabel")

-- Loop through all slots
for i = 1, 9 do
	local slot = slotsContainer:FindFirstChild("Slot"..i)
	if slot then
		slot.MouseButton1Click:Connect(function()
			local crystal = slot:FindFirstChild("CrystalImage")
			if crystal then
				-- Update image
				selectedImage.Image = crystal.Image
				selectedImage.ImageColor3 = crystal.ImageColor3

				-- Update labels
				local data = crystal:GetAttribute("CrystalData")
				if data then
					local crystalData = game.HttpService:JSONDecode(data)
					elementLabel.Text = "Element: " .. (crystalData.element or "N/A")
					rarityLabel.Text = "Rarity: " .. (crystalData.rarity or "N/A")
					classLabel.Text = "Class: " .. (crystalData.class or "N/A")
					enchantLabel.Text = "Enchantment: " .. (crystalData.enchantment or "N/A")
				end
			end
		end)
	end
end
