-- who will here be tonight
local RobloxFrameGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextBox = Instance.new("TextBox")
local UICorner_2 = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")
local UICorner_3 = Instance.new("UICorner")

--Properties:

RobloxFrameGui.Name = "RobloxFrameGui"
RobloxFrameGui.Parent = game.CoreGui
RobloxFrameGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = RobloxFrameGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Darker gray background
Frame.BackgroundTransparency = 0.0 --Removed transparency for a solid look
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 1 -- Added a subtle border
Frame.Position = UDim2.new(0.357859492, 0, 0.407114714, 0)
Frame.Size = UDim2.new(0.284118116, 0, 0.149927214, 0)
Frame.CornerRadius = UDim.new(0, 5) -- Added rounded corners


UICorner.Parent = Frame
UICorner.CornerRadius = UDim.new(0, 5) -- Matching rounded corners


TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Slightly lighter input field
TextBox.BackgroundTransparency = 0.0 -- Solid background
TextBox.BorderColor3 = Color3.fromRGB(60, 60, 60) -- Darker border for contrast
TextBox.BorderSizePixel = 1 -- Added a subtle border
TextBox.Position = UDim2.new(0.0561797768, 0, 0.448999196, 0)
TextBox.Size = UDim2.new(0.887640476, 0, 0.330097079, 0)
TextBox.Font = Enum.Font.Roboto -- Modern font
TextBox.PlaceholderText = "LICENSE"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(220, 220, 220) -- Lighter text for better contrast
TextBox.TextScaled = true
TextBox.TextSize = 14.000
TextBox.TextWrapped = true
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.CornerRadius = UDim.new(0, 5) -- Added rounded corners

UICorner_2.Parent = TextBox
UICorner_2.CornerRadius = UDim.new(0, 5) -- Matching rounded corners


TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(36, 40, 65) -- Kept this color as it provides a nice contrast
TextLabel.BackgroundTransparency = 0.0 -- Solid background
TextLabel.BorderColor3 = Color3.fromRGB(60, 60, 60) -- Darker border for contrast
TextLabel.BorderSizePixel = 1 -- Added a subtle border
TextLabel.Position = UDim2.new(0.219101131, 0, 0.106796116, 0)
TextLabel.Size = UDim2.new(0.561797738, 0, 0.233009711, 0)
TextLabel.Font = Enum.Font.Roboto -- Modern font
TextLabel.Text = "Enter your license."
TextLabel.TextColor3 = Color3.fromRGB(220, 220, 220) -- Lighter text for better contrast
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true
TextLabel.CornerRadius = UDim.new(0, 5) -- Added rounded corners

UICorner_3.Parent = TextLabel
UICorner_3.CornerRadius = UDim.new(0, 5) -- Matching rounded corners

return RobloxFrameGui
