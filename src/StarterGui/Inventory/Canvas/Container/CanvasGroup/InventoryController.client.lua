-- InventoryController.lua
local Players = game:GetService("Players")
local player  = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Inventory screen
local inventoryGui   = playerGui:WaitForChild("Inventory")
local mainContainer  = inventoryGui:WaitForChild("Canvas")
	:WaitForChild("Container")
	:WaitForChild("Main")
local inventorySlots = mainContainer:WaitForChild("Container")
local sidePanel      = mainContainer:WaitForChild("SidePanel")

-- NEW preview inside your Inventory window
local previewFrame   = sidePanel:WaitForChild("PreviewFrame")
local crystalPreview = previewFrame:WaitForChild("CrystalPreview")

-- wait for the global upgrade-handlers to exist
repeat task.wait() until
typeof(_G.AssignCrystalElement)     == "function" and
	typeof(_G.AssignCrystalRarity)      == "function" and
	typeof(_G.AssignCrystalClass)       == "function" and
	typeof(_G.AssignCrystalEnchantment) == "function"

-- helper: deselect everything
local function deselectAllSlots()
	for _, slot in ipairs(inventorySlots:GetChildren()) do
		local stroke = slot:FindFirstChild("Stroke", true)
		if stroke then
			local uiStroke = stroke:FindFirstChildOfClass("UIStroke")
			if uiStroke then uiStroke.Enabled = false end
		end
	end
end

-- clear both the preview and the stats
local function clearSelectionDisplay()
	crystalPreview.Visible = false
	local txt  = sidePanel:FindFirstChild("Text")
	local icon = sidePanel:FindFirstChild("Icon")
	if txt  then txt.Text  = "Element: None\nRarity: None\nClass: None\nEnchantment: None" end
	if icon and icon:IsA("ImageLabel") then icon.Image = "" end
end

-- called when you sell a crystal slot
local function removeSlotAndClear(slotFrame)
	slotFrame:Destroy()
	clearSelectionDisplay()
end

-- ==== SINGLE-SELL HOOK ====
local function onSell()
	print("🛒 [InventoryController] Sell button pressed!")
	for _, slot in ipairs(inventorySlots:GetChildren()) do
		local stroke = slot:FindFirstChild("Stroke", true)
		if stroke then
			local uiStroke = stroke:FindFirstChildOfClass("UIStroke")
			if uiStroke and uiStroke.Enabled then
				-- grab its CrystalImage and Rarity
				local img    = slot:FindFirstChild("CrystalImage", true)
				local rarity = img and img:GetAttribute("Rarity") or "Common"
				local price  = rarityPrices[rarity] or 10
				print("🛍️ Selling a", rarity, "crystal for", price)

				-- give player money
				local ls = player:FindFirstChild("leaderstats")
				if ls then
					local money = ls:FindFirstChild("Money")
					if money then
						money.Value += price
						print("💰 New money:", money.Value)
					end
				end

				-- remove the slot & clear UI
				removeSlotAndClear(slot)
				return
			end
		end
	end
	print("⚠️ No slot selected to sell!")
end

-- find + wire up
do
	-- deep-search under SidePanel
	local sellBtn = sidePanel:FindFirstChild("Sell", true)
	if not sellBtn or not sellBtn:IsA("GuiButton") then
		warn("[InventoryController] Sell button not found under SidePanel!")
	else
		-- make sure it can be clicked
		sellBtn.Active      = true
		sellBtn.Selectable  = true
		sellBtn.ZIndex      = (sellBtn.ZIndex or 1) + 10

		print("[InventoryController] SellBtn found?", sellBtn, sellBtn.ClassName)
		sellBtn.MouseButton1Click:Connect(onSell)
		sellBtn.Activated:Connect(onSell)
	end
end


do
	local sellBtn = sidePanel:FindFirstChild("Sell")
	if sellBtn then
		-- make sure it can receive input:
		sellBtn.Active      = true
		sellBtn.Selectable  = true
		sellBtn.ZIndex      = 10

		print("SellBtn found?", sellBtn, sellBtn.ClassName)
		sellBtn.MouseButton1Click:Connect(function()
			print(">> SELL CLICKED!")
			-- your existing sell logic…
		end)
	end
end

-- ==== Global hook for CrystalSpawner ====
function _G.AddCrystalToInventory()
	local template = inventorySlots:FindFirstChild("Slot1")
	if not template then
		warn("Slot1 missing, cannot add crystal")
		return
	end

	local newSlot = template:Clone()
	newSlot.Name    = "Slot"
	newSlot.Visible = true
	newSlot.Parent  = inventorySlots

	-- turn off stroke
	local stroke = newSlot:FindFirstChild("Stroke", true)
	if stroke then
		local uiStroke = stroke:FindFirstChildOfClass("UIStroke")
		if uiStroke then uiStroke.Enabled = false end
	end

	-- clone in the crystal image
	local crystalImg = playerGui:WaitForChild("MainGui")
		:WaitForChild("CrystalContainer")
		:Clone()
	crystalImg.Name                   = "CrystalImage"
	crystalImg.AnchorPoint            = Vector2.new(0.5, 0.5)
	crystalImg.Position               = UDim2.new(0.5, 0, 0.5, 0)
	crystalImg.Size                   = UDim2.new(1, 0, 1, 0)
	crystalImg.BackgroundTransparency = 1
	crystalImg.Parent                 = newSlot
	crystalImg.Visible                = true

	-- carry over attributes
	local cd = _G.CurrentCrystalData
	crystalImg:SetAttribute("Element",     cd.element)
	crystalImg:SetAttribute("Rarity",      cd.rarity)
	crystalImg:SetAttribute("Class",       cd.class)
	crystalImg:SetAttribute("Enchantment", cd.enchantment)
	crystalImg:SetAttribute("ImageId",     crystalImg.Image)
	crystalImg:SetAttribute("Color",       crystalImg.ImageColor3)

	-- clicking selects + shows preview
	newSlot.MouseButton1Click:Connect(function()
		deselectAllSlots()
		if stroke then
			local uiStroke = stroke:FindFirstChildOfClass("UIStroke")
			if uiStroke then uiStroke.Enabled = true end
		end

		-- update Inventory preview
		crystalPreview.Image       = crystalImg:GetAttribute("ImageId")
		crystalPreview.ImageColor3 = crystalImg:GetAttribute("Color")
		crystalPreview.Visible     = true

		-- update side-panel stats
		local txt  = sidePanel:FindFirstChild("Text")
		local icon = sidePanel:FindFirstChild("Icon")
		if txt then
			txt.Text = string.format(
				"Element: %s\nRarity: %s\nClass: %s\nEnchantment: %s",
				crystalImg:GetAttribute("Element")     or "None",
				crystalImg:GetAttribute("Rarity")      or "None",
				crystalImg:GetAttribute("Class")       or "None",
				crystalImg:GetAttribute("Enchantment") or "None"
			)
		end
		if icon and icon:IsA("ImageLabel") then
			icon.Image       = crystalImg:GetAttribute("ImageId")
			icon.ImageColor3 = crystalImg:GetAttribute("Color")
		end
	end)
end
