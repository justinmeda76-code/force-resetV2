-- Create the ScreenGui container (keeps it active across deaths)
local player = game:GetService("Players").LocalPlayer
local sgui = Instance.new("ScreenGui")
sgui.Name = "CustomResetGui"
sgui.ResetOnSpawn = false  -- Keeps the button on screen when you respawn
sgui.Parent = player:WaitForChild("PlayerGui")

-- Create the Reset Button
local button = Instance.new("TextButton")
button.Name = "ResetButton"
button.Size = UDim2.new(0, 100, 0, 40)
button.Position = UDim2.new(0.9, 0, 0.4, 0) -- Placed on the right side of the screen
button.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Dark Red
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "RESET"
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Active = true -- Required for UI dragging
button.Parent = sgui

-- Add rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = button

-- --- DRAGGING FUNCTIONALITY ---
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = button.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- --- RESET ACTION ---
button.MouseButton1Click:Connect(function()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0 -- Bypasses disabled menu restrictions
        end
    end
end)
