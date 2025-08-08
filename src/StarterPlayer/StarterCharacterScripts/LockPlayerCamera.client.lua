local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local CAMERA_OFFSET = Vector3.new(0, 5, -10) -- 5 studs up, 10 studs behind

local function lockThirdPersonCamera(character)
    local camera = workspace.CurrentCamera
    if not camera then return end
    camera.CameraType = Enum.CameraType.Scriptable

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    -- Disconnect previous connection if exists
    if script:FindFirstChild("CameraConn") then
        local conn = script.CameraConn.Value
        if conn then
            conn:Disconnect()
        end
        script.CameraConn:Destroy()
    end

    local conn = RunService.RenderStepped:Connect(function()
        if humanoidRootPart and camera then
            camera.CFrame = CFrame.new(
                humanoidRootPart.Position + CAMERA_OFFSET,
                humanoidRootPart.Position
            )
        end
    end)

    -- Store connection so we can disconnect later if needed
    local connValue = Instance.new("ObjectValue")
    connValue.Name = "CameraConn"
    connValue.Value = conn
    connValue.Parent = script
end

local function onCharacterAdded(character)
    lockThirdPersonCamera(character)
end

player.CharacterAdded:Connect(onCharacterAdded)

-- If character already exists
if player.Character then
    lockThirdPersonCamera(player.Character)
end

