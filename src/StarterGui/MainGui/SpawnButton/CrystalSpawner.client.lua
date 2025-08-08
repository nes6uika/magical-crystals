-- CrystalSpawner (cooldown + continuous progress-fill + global hand-off)

local TweenService = game:GetService("TweenService")
local Players      = game:GetService("Players")

local button           = script.Parent
local mainGui          = button.Parent
local crystalContainer = mainGui:WaitForChild("CrystalContainer")

-- Progress bar UI
local progressBg   = mainGui:WaitForChild("UpgradeProgressBg")
local progressFill = progressBg:WaitForChild("UpgradeProgressFill")
progressFill.AnchorPoint = Vector2.new(0,0)
progressFill.Position    = UDim2.new(0,0,0,0)
progressFill.Size        = UDim2.new(0,0,1,0)

-- Inventory GUI refs
local player         = Players.LocalPlayer
local inventoryGui   = player:WaitForChild("PlayerGui"):WaitForChild("Inventory")
local inventorySlots = inventoryGui:WaitForChild("Canvas")
	:WaitForChild("Container")
	:WaitForChild("Main")
	:WaitForChild("Container")
local sidePanel      = inventoryGui:WaitForChild("Canvas")
	:WaitForChild("Container")
	:WaitForChild("Main")
	:WaitForChild("SidePanel")

-- wait for all four upgrade‐handlers to exist
repeat task.wait() until
typeof(_G.AssignCrystalElement)     == "function" and
	typeof(_G.AssignCrystalRarity)      == "function" and
	typeof(_G.AssignCrystalClass)       == "function" and
	typeof(_G.AssignCrystalEnchantment) == "function"

-- wait for the inventory hook
repeat task.wait() until typeof(_G.AddCrystalToInventory) == "function"

-- station positions + timing
local stations = {
	UDim2.new(0.12,  0, 0.376, 0),
	UDim2.new(0.363, 0, 0.376, 0),
	UDim2.new(0.622, 0, 0.376, 0),
	UDim2.new(0.883, 0, 0.376, 0),
}
local tweenTime = 0.6
local waitTime  = 1
local totalTime = #stations * (tweenTime + waitTime)

crystalContainer.AnchorPoint = Vector2.new(0.5, 0.5)
local isSpawning = false

-- move tween
local function moveTo(pos)
	local ti = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tw = TweenService:Create(crystalContainer, ti, { Position = pos })
	tw:Play(); tw.Completed:Wait()
end

-- cleanup
local function cleanup()
	crystalContainer.Visible   = false
	isSpawning                 = false
	button.Active              = true
	button.AutoButtonColor     = true
	progressFill.Size          = UDim2.new(0,0,1,0)
end

button.MouseButton1Click:Connect(function()
	if isSpawning then return end
	isSpawning             = true
	button.Active          = false
	button.AutoButtonColor = false

	-- reset crystal + data
	_G.CurrentCrystalData = { element=nil, rarity=nil, class=nil, enchantment=nil }
	crystalContainer.Image       = "rbxassetid://101303383406990"
	crystalContainer.ImageColor3 = Color3.new(1,1,1)
	crystalContainer.Visible     = true

	-- start continuous fill tween
	progressFill.Size = UDim2.new(0,0,1,0)
	TweenService:Create(
		progressFill,
		TweenInfo.new(totalTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
		{ Size = UDim2.new(1,0,1,0) }
	):Play()

	-- station handlers
	local handlers = {
		[1] = _G.AssignCrystalElement,
		[2] = _G.AssignCrystalRarity,
		[3] = _G.AssignCrystalClass,
		[4] = _G.AssignCrystalEnchantment,
	}

	for i, pos in ipairs(stations) do
		moveTo(pos)
		task.wait(waitTime)
		handlers[i]()
		if i == #stations then
			_G.AddCrystalToInventory()
			cleanup()
		end
	end
end)
