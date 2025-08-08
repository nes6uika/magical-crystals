local character = script.Parent
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0

    humanoid.Changed:Connect(function(property)
        if property == "WalkSpeed" then
            humanoid.WalkSpeed = 0
        elseif property == "JumpPower" then
            humanoid.JumpPower = 0
        end
    end)
end

