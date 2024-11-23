local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local flying = false
local flySpeed = 50
local walkSpeed = 16
local jumpPower = 50

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "BaconGangGUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true

local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.BorderSizePixel = 0
Title.Text = "BaconGang GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold

local FlyButton = Instance.new("TextButton", MainFrame)
FlyButton.Size = UDim2.new(0.8, 0, 0, 40)
FlyButton.Position = UDim2.new(0.1, 0, 0.15, 0)
FlyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FlyButton.Text = "Toggle Fly"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 16
FlyButton.Font = Enum.Font.SourceSans

local SpeedButton = Instance.new("TextButton", MainFrame)
SpeedButton.Size = UDim2.new(0.8, 0, 0, 40)
SpeedButton.Position = UDim2.new(0.1, 0, 0.25, 0)
SpeedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedButton.Text = "Speed: 16"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.TextSize = 16
SpeedButton.Font = Enum.Font.SourceSans

local JumpPowerButton = Instance.new("TextButton", MainFrame)
JumpPowerButton.Size = UDim2.new(0.8, 0, 0, 40)
JumpPowerButton.Position = UDim2.new(0.1, 0, 0.35, 0)
JumpPowerButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
JumpPowerButton.Text = "Jump Power: 50"
JumpPowerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpPowerButton.TextSize = 16
JumpPowerButton.Font = Enum.Font.SourceSans

local ESPButton = Instance.new("TextButton", MainFrame)
ESPButton.Size = UDim2.new(0.8, 0, 0, 40)
ESPButton.Position = UDim2.new(0.1, 0, 0.45, 0)
ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ESPButton.Text = "Toggle ESP"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextSize = 16
ESPButton.Font = Enum.Font.SourceSans

local OptionsLabel = Instance.new("TextLabel", MainFrame)
OptionsLabel.Size = UDim2.new(1, 0, 0, 30)
OptionsLabel.Position = UDim2.new(0, 0, 0.55, 0)
OptionsLabel.BackgroundTransparency = 1
OptionsLabel.Text = "More Options Coming Soon"
OptionsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
OptionsLabel.TextSize = 16
OptionsLabel.Font = Enum.Font.SourceSansItalic
OptionsLabel.TextXAlignment = Enum.TextXAlignment.Center

local function toggleFly()
    flying = not flying
    local bodyVelocity
    if flying then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = Character:FindFirstChild("HumanoidRootPart")

        RunService.RenderStepped:Connect(function()
            if flying then
                local moveDirection = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + Vector3.new(0, 1, 0)
                end
                if moveDirection.Magnitude > 0 then
                    bodyVelocity.Velocity = moveDirection.Unit * flySpeed
                end
            else
                bodyVelocity:Destroy()
            end
        end)
    elseif bodyVelocity then
        bodyVelocity:Destroy()
    end
end

FlyButton.MouseButton1Click:Connect(toggleFly)

local function modifySpeed()
    walkSpeed = walkSpeed + 4
    if walkSpeed > 50 then walkSpeed = 16 end
    LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
    SpeedButton.Text = "Speed: " .. walkSpeed
end

SpeedButton.MouseButton1Click:Connect(modifySpeed)

local function modifyJumpPower()
    jumpPower = jumpPower + 10
    if jumpPower > 150 then jumpPower = 50 end
    LocalPlayer.Character.Humanoid.JumpPower = jumpPower
    JumpPowerButton.Text = "Jump Power: " .. jumpPower
end

JumpPowerButton.MouseButton1Click:Connect(modifyJumpPower)

local espActive = false
local function toggleESP()
    espActive = not espActive
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character

            if espActive then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ESP"
                billboard.Adornee = character.HumanoidRootPart
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255, 0, 0)
                label.Text = player.Name .. " (" .. math.floor((character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) .. " studs)"
                label.TextSize = 14
                label.Font = Enum.Font.SourceSansBold
                label.Parent = billboard
                                billboard.Parent = character.HumanoidRootPart

                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESPBox"
                box.Adornee = character
                box.Size = character:GetExtentsSize()
                box.Color3 = Color3.fromRGB(255, 0, 0)
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Parent = character.HumanoidRootPart
            else
                if character:FindFirstChild("ESP") then
                    character.ESP:Destroy()
                end
                if character:FindFirstChild("ESPBox") then
                    character.ESPBox:Destroy()
                end
            end
        end
    end
end

ESPButton.MouseButton1Click:Connect(toggleESP)

local NameInputLabel = Instance.new("TextLabel", MainFrame)
NameInputLabel.Size = UDim2.new(1, 0, 0, 30)
NameInputLabel.Position = UDim2.new(0, 0, 0.65, 0)
NameInputLabel.BackgroundTransparency = 1
NameInputLabel.Text = "Enter Player's Name"
NameInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NameInputLabel.TextSize = 16
NameInputLabel.Font = Enum.Font.SourceSansItalic
NameInputLabel.TextXAlignment = Enum.TextXAlignment.Center

local NameInput = Instance.new("TextBox", MainFrame)
NameInput.Size = UDim2.new(0.8, 0, 0, 40)
NameInput.Position = UDim2.new(0.1, 0, 0.75, 0)
NameInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NameInput.Text = ""
NameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
NameInput.TextSize = 16
NameInput.Font = Enum.Font.SourceSans

local TeleportButton = Instance.new("TextButton", MainFrame)
TeleportButton.Size = UDim2.new(0.8, 0, 0, 40)
TeleportButton.Position = UDim2.new(0.1, 0, 0.85, 0)
TeleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TeleportButton.Text = "Teleport"
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.TextSize = 16
TeleportButton.Font = Enum.Font.SourceSans

local function teleportToPlayer()
    local targetName = NameInput.Text
    local targetPlayer = nil

    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower() == targetName:lower() then
            targetPlayer = player
            break
        end
    end

    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
        print("Teleported to " .. targetPlayer.Name)
    else
        print("Player not found!")
    end
end

TeleportButton.MouseButton1Click:Connect(teleportToPlayer)

print("The GUI has been loaded properly, have fun nigger.")
