-- who will here be tonight
local RobloxFrameGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextBox = Instance.new("TextBox")
local UICorner_2 = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")
local UICorner_3 = Instance.new("UICorner")
local CopyButton = Instance.new("TextButton")  -- Create the Copy CIFL button

-- Properties:

RobloxFrameGui.Name = "RobloxFrameGui"
RobloxFrameGui.Parent = game.CoreGui
RobloxFrameGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = RobloxFrameGui
Frame.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
Frame.BackgroundTransparency = 0.200
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.357859492, 0, 0.407114714, 0)
Frame.Size = UDim2.new(0.284118116, 0, 0.149927214, 0)

UICorner.Parent = Frame

TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
TextBox.BackgroundTransparency = 0.200
TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(0.0561797768, 0, 0.448999196, 0)
TextBox.Size = UDim2.new(0.887640476, 0, 0.330097079, 0)
TextBox.Font = Enum.Font.Unknown
TextBox.PlaceholderText = "LICENSE"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextScaled = true
TextBox.TextSize = 14.000
TextBox.TextWrapped = true
TextBox.TextXAlignment = Enum.TextXAlignment.Left

UICorner_2.Parent = TextBox

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(36, 40, 65)
TextLabel.BackgroundTransparency = 0.200
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.219101131, 0, 0.106796116, 0)
TextLabel.Size = UDim2.new(0.561797738, 0, 0.233009711, 0)
TextLabel.Font = Enum.Font.Unknown
TextLabel.Text = "Enter your license."
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

UICorner_3.Parent = TextLabel

-- Copy CIFL Button
CopyButton.Name = "CopyCIFLButton"
CopyButton.Parent = Frame
CopyButton.BackgroundColor3 = Color3.fromRGB(36, 40, 65)
CopyButton.BackgroundTransparency = 0.200
CopyButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
CopyButton.BorderSizePixel = 0
CopyButton.Position = UDim2.new(0.219101131, 0, 0.75, 0)  -- Position below the text label
CopyButton.Size = UDim2.new(0.561797738, 0, 0.233009711, 0)
CopyButton.Font = Enum.Font.Unknown
CopyButton.Text = "Copy CIFL"
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.TextScaled = true
CopyButton.TextSize = 14.000
CopyButton.TextWrapped = true

-- Add functionality to the button
CopyButton.MouseButton1Click:Connect(function()
    setclipboard(game:GetService("RbxAnalyticsService"):GetClientId():reverse())  -- Copy ClientId to clipboard
end)

return RobloxFrameGui
