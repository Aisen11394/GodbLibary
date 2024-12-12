-- UI Library

local UI = {}
UI.__index = UI

-- Default settings
UI.currentTheme = "Default"
UI.themes = {
    Default = {Background = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(138, 43, 226)},
    Bloody = {Background = Color3.fromRGB(50, 0, 0), Accent = Color3.fromRGB(200, 0, 0)},
    White = {Background = Color3.fromRGB(230, 230, 230), Accent = Color3.fromRGB(180, 180, 180)},
}

UI.mainFrame = nil
UI.toggleButton = nil

local userStatus = "Guest"  -- Default status is Guest

-- Create the main UI frame and toggle button
function UI:CreateUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0, -400, 0.5, -250)
    mainFrame.BackgroundColor3 = UI.themes[UI.currentTheme].Background
    mainFrame.Visible = false
    mainFrame.Parent = screenGui

    -- Create the toggle button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 50)
    toggleButton.Position = UDim2.new(0, 10, 0.5, -25)
    toggleButton.BackgroundColor3 = UI.themes[UI.currentTheme].Accent
    toggleButton.Text = ">"
    toggleButton.Parent = screenGui

    UI.mainFrame = mainFrame
    UI.toggleButton = toggleButton

    -- Toggle animation for opening/closing the UI
    toggleButton.MouseButton1Click:Connect(function()
        local targetPosition = mainFrame.Visible and UDim2.new(0, -400, 0.5, -250) or UDim2.new(0, 50, 0.5, -250)
        mainFrame.Visible = true
        local tween = game:GetService("TweenService"):Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = targetPosition})
        tween:Play()
        tween.Completed:Wait()
        mainFrame.Visible = mainFrame.Position.X.Offset > 0
        toggleButton.Text = mainFrame.Visible and "<" or ">"
    end)

    return mainFrame
end

-- Change the theme of the UI
function UI:ChangeTheme(themeName)
    if UI.themes[themeName] then
        UI.currentTheme = themeName
        UI.mainFrame.BackgroundColor3 = UI.themes[themeName].Background
        UI.toggleButton.BackgroundColor3 = UI.themes[themeName].Accent
    end
end

-- Authentication system: Guest, Premium, Owner
function UI:Authenticate(status)
    userStatus = status
end

-- Add a button to the UI
function UI:AddButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 50)
    button.BackgroundColor3 = UI.themes[UI.currentTheme].Accent
    button.Text = text
    button.Font = Enum.Font.SourceSans
    button.TextSize = 20
    button.Parent = UI.mainFrame

    button.MouseButton1Click:Connect(callback)

    return button
end

-- Add a text box to the UI
function UI:AddTextBox(name, placeholder, callback)
    local textBoxFrame = Instance.new("Frame")
    textBoxFrame.Size = UDim2.new(1, -10, 0, 40)
    textBoxFrame.Position = UDim2.new(0, 5, 0, 210)
    textBoxFrame.BackgroundColor3 = UI.themes[UI.currentTheme].Background
    textBoxFrame.Parent = UI.mainFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = name
    label.TextColor3 = UI.themes[UI.currentTheme].Accent
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 20
    label.Parent = textBoxFrame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.7, -10, 1, 0)
    textBox.Position = UDim2.new(0.3, 10, 0, 0)
    textBox.Text = ""
    textBox.PlaceholderText = placeholder
    textBox.BackgroundColor3 = UI.themes[UI.currentTheme].Accent
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.SourceSans
    textBox.TextSize = 20
    textBox.Parent = textBoxFrame

    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(textBox.Text)
        end
    end)

    return textBoxFrame
end

-- Add a toggle switch to the UI
function UI:AddToggle(text, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -10, 0, 40)
    toggleFrame.Position = UDim2.new(0, 5, 0, 250)
    toggleFrame.BackgroundColor3 = UI.themes[UI.currentTheme].Background
    toggleFrame.Parent = UI.mainFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.TextColor3 = UI.themes[UI.currentTheme].Accent
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 20
    label.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.2, 0, 1, 0)
    toggleButton.Position = UDim2.new(0.7, 10, 0, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    toggleButton.Text = "OFF"
    toggleButton.Parent = toggleFrame

    local isToggled = false
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        toggleButton.Text = isToggled and "ON" or "OFF"
        toggleButton.BackgroundColor3 = isToggled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        callback(isToggled)
    end)

    return toggleFrame
end

-- Add a slider to the UI
function UI:AddSlider(text, minValue, maxValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -10, 0, 50)
    sliderFrame.Position = UDim2.new(0, 5, 0, 290)
    sliderFrame.BackgroundColor3 = UI.themes[UI.currentTheme].Background
    sliderFrame.Parent = UI.mainFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.TextColor3 = UI.themes[UI.currentTheme].Accent
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 20
    label.Parent = sliderFrame

    local slider = Instance.new("TextBox")
    slider.Size = UDim2.new(0.6, 0, 1, 0)
    slider.Position = UDim2.new(0.3, 10, 0, 0)
    slider.Text = "0"
    slider.PlaceholderText = tostring(minValue)
    slider.BackgroundColor3 = UI.themes[UI.currentTheme].Accent
    slider.TextColor3 = Color3.fromRGB(255, 255, 255)
    slider.Font = Enum.Font.SourceSans
    slider.TextSize = 20
    slider.Parent = sliderFrame

    slider.FocusLost:Connect(function()
        local value = tonumber(slider.Text)
        if value and value >= minValue and value <= maxValue then
            callback(value)
        end
    end)

    return sliderFrame
end

-- Registration function with status and password validation
function UI:Register()
    local isRegistered = false

    -- Add password input
    UI:AddTextBox("Password", "Enter your password", function(input)
        if userStatus == "Premium" and input == "premium2024" then
            userStatus = "Premium"
            isRegistered = true
        elseif userStatus == "Owner" and input == "ownerbest12" then
            userStatus = "Owner"
            isRegistered = true
        elseif userStatus == "Guest" then
            isRegistered = true
        else
            print("Incorrect password!")
        end

        -- If registration is successful, display status
        if isRegistered then
            UI:AddTextBox("Status", "Status: " .. userStatus, function() end)
        end
    end)

    return isRegistered
end

-- Returning the UI object
return UI
