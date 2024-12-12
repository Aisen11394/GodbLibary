-- Godb Library: Advanced UI

local Godb = {}
Godb.__index = Godb

-- Default settings
Godb.currentTheme = "Default"
Godb.themes = {
    Default = {Background = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(138, 43, 226)},
    Bloody = {Background = Color3.fromRGB(50, 0, 0), Accent = Color3.fromRGB(200, 0, 0)},
    White = {Background = Color3.fromRGB(230, 230, 230), Accent = Color3.fromRGB(180, 180, 180)},
}

Godb.mainFrame = nil
Godb.toggleButton = nil

local userStatus = "Guest"  -- Default status is Guest

-- Function to create the main UI
function Godb:CreateUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 600)
    mainFrame.Position = UDim2.new(0, -500, 0.5, -300)
    mainFrame.BackgroundColor3 = Godb.themes[Godb.currentTheme].Background
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    mainFrame.BorderRadius = UDim.new(0, 20)  -- Rounded corners

    -- Create the toggle button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 60, 0, 60)
    toggleButton.Position = UDim2.new(0, 10, 0.5, -30)
    toggleButton.BackgroundColor3 = Godb.themes[Godb.currentTheme].Accent
    toggleButton.Text = ">"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 30
    toggleButton.Parent = screenGui
    toggleButton.BorderRadius = UDim.new(0, 20)

    Godb.mainFrame = mainFrame
    Godb.toggleButton = toggleButton

    -- Toggle animation
    toggleButton.MouseButton1Click:Connect(function()
        local targetPosition = mainFrame.Visible and UDim2.new(0, -500, 0.5, -300) or UDim2.new(0, 60, 0.5, -300)
        mainFrame.Visible = true
        local tween = game:GetService("TweenService"):Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = targetPosition})
        tween:Play()
        tween.Completed:Wait()
        mainFrame.Visible = mainFrame.Position.X.Offset > 0
        toggleButton.Text = mainFrame.Visible and "<" or ">"
    end)

    return mainFrame
end

-- Function to change theme
function Godb:ChangeTheme(themeName)
    if Godb.themes[themeName] then
        Godb.currentTheme = themeName
        Godb.mainFrame.BackgroundColor3 = Godb.themes[themeName].Background
        Godb.toggleButton.BackgroundColor3 = Godb.themes[themeName].Accent
    end
end

-- Authentication system: Guest, Premium, Owner
function Godb:Authenticate(status)
    userStatus = status
end

-- Add a button with rounded corners and smooth effects
function Godb:AddButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 60)
    button.BackgroundColor3 = Godb.themes[Godb.currentTheme].Accent
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 24
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = Godb.mainFrame
    button.BorderRadius = UDim.new(0, 20)

    -- Smooth hover effect
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = button.BackgroundColor3:Lerp(Color3.fromRGB(180, 180, 180), 0.2)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Godb.themes[Godb.currentTheme].Accent
    end)

    button.MouseButton1Click:Connect(callback)

    return button
end

-- Add a text box with rounded corners
function Godb:AddTextBox(name, placeholder, callback)
    local textBoxFrame = Instance.new("Frame")
    textBoxFrame.Size = UDim2.new(1, -10, 0, 60)
    textBoxFrame.Position = UDim2.new(0, 5, 0, 220)
    textBoxFrame.BackgroundColor3 = Godb.themes[Godb.currentTheme].Background
    textBoxFrame.Parent = Godb.mainFrame
    textBoxFrame.BorderRadius = UDim.new(0, 15)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = name
    label.TextColor3 = Godb.themes[Godb.currentTheme].Accent
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 22
    label.Parent = textBoxFrame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.7, -10, 1, 0)
    textBox.Position = UDim2.new(0.3, 10, 0, 0)
    textBox.Text = ""
    textBox.PlaceholderText = placeholder
    textBox.BackgroundColor3 = Godb.themes[Godb.currentTheme].Accent
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 22
    textBox.Parent = textBoxFrame
    textBox.BorderRadius = UDim.new(0, 15)

    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(textBox.Text)
        end
    end)

    return textBoxFrame
end

-- Add a toggle switch
function Godb:AddToggle(text, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -10, 0, 60)
    toggleFrame.Position = UDim2.new(0, 5, 0, 280)
    toggleFrame.BackgroundColor3 = Godb.themes[Godb.currentTheme].Background
    toggleFrame.Parent = Godb.mainFrame
    toggleFrame.BorderRadius = UDim.new(0, 15)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.TextColor3 = Godb.themes[Godb.currentTheme].Accent
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 22
    label.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.2, 0, 1, 0)
    toggleButton.Position = UDim2.new(0.7, 10, 0, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    toggleButton.Text = "OFF"
    toggleButton.Parent = toggleFrame
    toggleButton.BorderRadius = UDim.new(0, 15)

    local isToggled = false
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        toggleButton.Text = isToggled and "ON" or "OFF"
        toggleButton.BackgroundColor3 = isToggled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        callback(isToggled)
    end)

    return toggleFrame
end

-- Example Usage for Registering and Authenticating Users
function Godb:Register()
    -- Authentication logic for Guest, Premium, Owner
    local status = userStatus
    if status == "Premium" then
        Godb:AddTextBox("Password", "Enter your password", function(input)
            if input == "premium123" then
                userStatus = "Premium"
                print("Premium User Access Granted!")
            else
                print("Incorrect Password for Premium Access!")
            end
        end)
    elseif status == "Owner" then
        Godb:AddTextBox("Password", "Enter your password", function(input)
            if input == "owner123" then
                userStatus = "Owner"
                print("Owner User Access Granted!")
            else
                print("Incorrect Password for Owner Access!")
            end
        end)
    else
        print("Guest Access granted")
    end
end

return Godb
