-- CrystalUpgradeHandler.lua

local Players = game:GetService("Players")
local player  = Players.LocalPlayer

-- Ensure MainGui and CrystalContainer exist
local mainGui          = player:WaitForChild("PlayerGui"):WaitForChild("MainGui")
local crystalContainer = mainGui:WaitForChild("CrystalContainer")  -- must be an ImageLabel

-- 🧠 Reset crystal data
_G.CurrentCrystalData = {
	element     = nil,
	rarity      = nil,
	class       = nil,
	enchantment = nil,
}

--------------------------------------------------
-- 1) ELEMENT ASSIGNMENT
--------------------------------------------------
local possibleElements = {
	Fire     = { color = Color3.fromRGB(255, 85,   0), image = "rbxassetid://106112566721529" },
	Ice      = { color = Color3.fromRGB(85,  170, 255), image = "rbxassetid://85245860793344"  },
	Nature   = { color = Color3.fromRGB(0,   255, 128), image = "rbxassetid://135797885741049" },
	Shadow   = { color = Color3.fromRGB(128,   0, 128), image = "rbxassetid://119605374728317" },
	Electric = { color = Color3.fromRGB(255, 255,   0), image = "rbxassetid://136309960822579" },
	Void     = { color = Color3.fromRGB(80,   80,  80), image = "rbxassetid://127353217720899" },
}

local function assignElement()
	print("AssignCrystalElement()")
	local keys = {}
	for k in pairs(possibleElements) do table.insert(keys, k) end
	local choice = keys[math.random(#keys)]
	local data   = possibleElements[choice]

	_G.CurrentCrystalData.element = choice

	if crystalContainer:IsA("ImageLabel") then
		crystalContainer.Image       = data.image
		crystalContainer.ImageColor3 = data.color
	end

	local popup = Instance.new("TextLabel")
	popup.Text                  = "Element: " .. choice
	popup.Font                  = Enum.Font.FredokaOne
	popup.TextSize              = 22
	popup.TextColor3            = Color3.new(1,1,1)
	popup.TextStrokeTransparency= 0.5
	popup.BackgroundTransparency= 1
	popup.Size                  = UDim2.new(0,150,0,30)
	popup.Position              = UDim2.new(0.5,0,0,-40)
	popup.AnchorPoint           = Vector2.new(0.5,1)
	popup.ZIndex                = 999
	popup.Parent                = crystalContainer

	task.delay(1.5, function()
		for i = 0, 1, 0.05 do
			popup.TextTransparency       = i
			popup.TextStrokeTransparency = 0.5 + i*0.5
			task.wait(0.03)
		end
		popup:Destroy()
	end)
end
_G.AssignCrystalElement = assignElement

--------------------------------------------------
-- 2) RARITY ASSIGNMENT (25 tiers, weighted)
--------------------------------------------------
local rarityRates = {
	Common        = 40.00,
	Uncommon      = 20.00,
	Rare          = 15.00,
	Epic           = 8.00,
	Legendary      = 5.00,
	Mythic         = 3.00,
	Heroic         = 2.00,
	Fabled         = 1.50,
	Arcane         = 1.00,
	Runic          = 1.00,
	Celestial      = 0.70,
	Astral         = 0.50,
	Starlit        = 0.40,
	Cosmic         = 0.30,
	Eternal        = 0.30,
	Primordial     = 0.20,
	Primal         = 0.20,
	Radiant        = 0.20,
	Divine         = 0.15,
	Infernal       = 0.15,
	Shadowforged   = 0.10,
	Voidborn       = 0.10,
	Dawnbringer    = 0.05,
	Twilight       = 0.05,
	Godly          = 0.10,
}

-- prepare lists
local rarityNames, rarityWeights = {}, {}
for name, w in pairs(rarityRates) do
	table.insert(rarityNames, name)
	table.insert(rarityWeights, w)
end

local function pickRarity()
	local total = 0
	for _, w in ipairs(rarityWeights) do total += w end
	local roll = math.random() * total
	local cum  = 0
	for i, w in ipairs(rarityWeights) do
		cum += w
		if roll <= cum then
			return rarityNames[i]
		end
	end
	return rarityNames[#rarityNames]
end

local function assignRarity()
	print("AssignCrystalRarity()")
	local choice = pickRarity()
	_G.CurrentCrystalData.rarity = choice

	-- popup
	local popup = Instance.new("TextLabel")
	popup.Text                  = "Rarity: " .. choice
	popup.Font                  = Enum.Font.FredokaOne
	popup.TextSize              = 22
	popup.TextColor3            = Color3.new(1,1,1)
	popup.TextStrokeTransparency= 0.5
	popup.BackgroundTransparency= 1
	popup.Size                  = UDim2.new(0,150,0,30)
	popup.Position              = UDim2.new(0.5,0,0,-40)
	popup.AnchorPoint           = Vector2.new(0.5,1)
	popup.ZIndex                = 999
	popup.Parent                = crystalContainer

	task.delay(1.5, function()
		for i = 0, 1, 0.05 do
			popup.TextTransparency       = i
			popup.TextStrokeTransparency = 0.5 + i*0.5
			task.wait(0.03)
		end
		popup:Destroy()
	end)
end
_G.AssignCrystalRarity = assignRarity

--------------------------------------------------
-- 3) CLASS ASSIGNMENT (10 archetypes)
--------------------------------------------------
local classList = {
	"Spellblade",
	"Beastwarden",
	"Chronomancer",
	"Stormcaller",
	"Shadowdancer",
	"Runeweaver",
	"Soulbinder",
	"Ironclad",
	"Wildspeaker",
	"Dreamwalker",
}

local function assignClass()
	print("AssignCrystalClass()")
	local choice = classList[math.random(#classList)]
	_G.CurrentCrystalData.class = choice

	local popup = Instance.new("TextLabel")
	popup.Text                  = "Class: " .. choice
	popup.Font                  = Enum.Font.FredokaOne
	popup.TextSize              = 22
	popup.TextColor3            = Color3.new(1,1,1)
	popup.TextStrokeTransparency= 0.5
	popup.BackgroundTransparency= 1
	popup.Size                  = UDim2.new(0,150,0,30)
	popup.Position              = UDim2.new(0.5,0,0,-40)
	popup.AnchorPoint           = Vector2.new(0.5,1)
	popup.ZIndex                = 999
	popup.Parent                = crystalContainer

	task.delay(1.5, function()
		for i = 0, 1, 0.05 do
			popup.TextTransparency       = i
			popup.TextStrokeTransparency = 0.5 + i*0.5
			task.wait(0.03)
		end
		popup:Destroy()
	end)
end
_G.AssignCrystalClass = assignClass

--------------------------------------------------
-- 4) ENCHANTMENT ASSIGNMENT (10 suffixes)
--------------------------------------------------
local enchantList = {
	"Flame-kissed",
	"Frost-woven",
	"Venom-tipped",
	"Shock-charged",
	"Aetherial",
	"Lifebound",
	"Umbral",
	"Prismatic",
	"Celestial",
	"Void-touched",
}

local function assignEnchantment()
	print("AssignCrystalEnchantment()")
	local choice = enchantList[math.random(#enchantList)]
	_G.CurrentCrystalData.enchantment = choice

	local popup = Instance.new("TextLabel")
	popup.Text                  = "Enchant: " .. choice
	popup.Font                  = Enum.Font.FredokaOne
	popup.TextSize              = 22
	popup.TextColor3            = Color3.new(1,1,1)
	popup.TextStrokeTransparency= 0.5
	popup.BackgroundTransparency= 1
	popup.Size                  = UDim2.new(0,150,0,30)
	popup.Position              = UDim2.new(0.5,0,0,-40)
	popup.AnchorPoint           = Vector2.new(0.5,1)
	popup.ZIndex                = 999
	popup.Parent                = crystalContainer

	task.delay(1.5, function()
		for i = 0, 1, 0.05 do
			popup.TextTransparency       = i
			popup.TextStrokeTransparency = 0.5 + i*0.5
			task.wait(0.03)
		end
		popup:Destroy()
	end)
end
_G.AssignCrystalEnchantment = assignEnchantment

print("✅ CrystalUpgradeHandler loaded with Element, Rarity, Class & Enchantment.")
