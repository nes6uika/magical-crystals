local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local starTemplate = script.Parent:WaitForChild("StarsFolder"):WaitForChild("StarTemplate")
local gui = script.Parent

local starsPerBatch = 10
local spawnInterval = 0.3

-- Make stars larger again for better visibility
local minSize, maxSize = 1, 3 -- increased for more visible stars
local minOpacity, maxOpacity = 0.2, 0.6
-- Increase lifetime for even smoother movement
local minLifetime, maxLifetime = 5, 10 -- longer for smoother, slower movement
local maxDriftDistance = 16 -- slightly increased for more visible drift

local function lerp(a, b, t)
	return a + (b - a) * t
end

local function spawnStar()
	task.spawn(function()
		local star = starTemplate:Clone()
		star.Visible = true

		-- Use float for size
		local size = math.random() * (maxSize - minSize) + minSize
		star.Size = UDim2.new(0, size, 0, size)

		local startX = math.random() * (gui.AbsoluteSize.X - size)
		local startY = math.random() * (gui.AbsoluteSize.Y - size)
		star.Position = UDim2.new(0, startX, 0, startY)

		local baseOpacity = math.random() * (maxOpacity - minOpacity) + minOpacity
		star.ImageTransparency = 1  -- Start fully transparent

		star.Parent = gui.StarsFolder

		local lifetime = math.random() * (maxLifetime - minLifetime) + minLifetime

		local driftX = math.clamp(startX + (math.random() * 2 - 1) * maxDriftDistance, 0, gui.AbsoluteSize.X - size)
		local driftY = math.clamp(startY + (math.random() * 2 - 1) * maxDriftDistance, 0, gui.AbsoluteSize.Y - size)

		local fadeInTime = 0.5
		local fadeOutTime = 0.5
		local visibleTime = math.max(0, lifetime - fadeInTime - fadeOutTime)

		local fadeInTween = TweenService:Create(star, TweenInfo.new(fadeInTime), {ImageTransparency = 1 - baseOpacity})
		local fadeOutTween = TweenService:Create(star, TweenInfo.new(fadeOutTime), {ImageTransparency = 1})

		-- Smooth movement using RenderStepped
		local startTime = tick()
		local endTime = startTime + lifetime
		local initialPos = Vector2.new(startX, startY)
		local targetPos = Vector2.new(driftX, driftY)

		local running = true
		local function onStep()
			if not running then return end
			local now = tick()
			local t = math.clamp((now - startTime) / lifetime, 0, 1)
			-- Use a smoother Sine InOut easing
			local easedT = 0.5 - 0.5 * math.cos(math.pi * t)
			local newX = lerp(initialPos.X, targetPos.X, easedT)
			local newY = lerp(initialPos.Y, targetPos.Y, easedT)
			star.Position = UDim2.new(0, newX, 0, newY)
			if t >= 1 then
				running = false
			end
		end

		local conn = RunService.RenderStepped:Connect(onStep)

		fadeInTween:Play()
		fadeInTween.Completed:Wait()

		task.wait(visibleTime)

		fadeOutTween:Play()
		fadeOutTween.Completed:Wait()

		running = false
		if conn then
			conn:Disconnect()
		end

		star:Destroy()
	end)
end

while true do
	for i = 1, starsPerBatch do
		spawnStar()
	end
	task.wait(spawnInterval)
end

