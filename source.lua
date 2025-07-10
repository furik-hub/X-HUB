local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Удаляем старый GUI если существует
if game:GetService("CoreGui"):FindFirstChild("DupeGUI") then
    game:GetService("CoreGui").DupeGUI:Destroy()
end
if player:FindFirstChild("PlayerGui"):FindFirstChild("DupeGUI") then
    player.PlayerGui.DupeGUI:Destroy()
end

-- Создаем интерфейс
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DupeGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game:GetService("CoreGui")

-- Звук клика
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://5419098671"
clickSound.Volume = 0.5
clickSound.Parent = SoundService

local function playClick()
    clickSound:Play()
end

-- Главный фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 580, 0, 380)
mainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Тень
local shadow = Instance.new("ImageLabel")
shadow.BackgroundTransparency = 1
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(100, 0, 150)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame

-- Верхняя панель
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 38)
topBar.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 8)
topBarCorner.Parent = topBar

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "RAVA X HUB"
title.TextColor3 = Color3.fromRGB(220, 180, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- Функция создания кнопок
local function createIconButton(offset, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(1, offset, 0.5, -15)
    btn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.AutoButtonColor = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn
    
    return btn
end

-- Кнопка закрытия
local closeBtn = createIconButton(-40, "✕")
closeBtn.Parent = topBar

closeBtn.MouseButton1Click:Connect(function()
    playClick()
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {Transparency = 1}):Play()
    wait(0.3)
    screenGui:Destroy()
end)

-- Кнопка сворачивания
local minimizeBtn = createIconButton(-80, "–")
minimizeBtn.Parent = topBar

local minimized = false
local savedState = {}

minimizeBtn.MouseButton1Click:Connect(function()
    playClick()
    minimized = not minimized

    for _, child in ipairs(mainFrame:GetChildren()) do
        if child ~= topBar and child:IsA("GuiObject") then
            if minimized then
                savedState[child] = child.Visible
                child.Visible = false
            else
                if savedState[child] ~= nil then
                    child.Visible = savedState[child]
                end
            end
        end
    end

    local targetSize = minimized and UDim2.new(0, 200, 0, 50) or UDim2.new(0, 580, 0, 380)
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
        Size = targetSize
    }):Play()
end)

-- Панель вкладок
local tabPanel = Instance.new("Frame")
tabPanel.Position = UDim2.new(0, 0, 0, 38)
tabPanel.Size = UDim2.new(0, 150, 1, -38)
tabPanel.BackgroundColor3 = Color3.fromRGB(50, 0, 75)
tabPanel.BorderSizePixel = 0
tabPanel.Parent = mainFrame

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 8)
tabCorner.Parent = tabPanel

-- Контентная область
local contentFrame = Instance.new("Frame")
contentFrame.Position = UDim2.new(0, 150, 0, 38)
contentFrame.Size = UDim2.new(1, -150, 1, -38)
contentFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
contentFrame.BackgroundTransparency = 0.05
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentFrame

-- Функция добавления в инвентарь
local function addToInventory(itemName)
    local tool = Instance.new("Tool")
    tool.Name = itemName
    tool.RequiresHandle = false
    tool.Parent = player:WaitForChild("Backpack")
end

-- Список предметов
local itemsList = {
    Cosmetics = {"Sign Grate", "Bamboo Wind Chime", "Brown Stone Pillar", "Log"},
    Fruits = {"Grapes [0.73KG]", "Candy Blossom [1.15KG]", "Beanstalk [0.90KG]", "Mango [1.00KG]"},
    Pets = {"Frog [6.30KG] [16 Age]", "T-Rex [8.10KG] [17 Age]", "Echo Frog [9.10KG] [14 Age]", "Raccoon [14.23KG] [16 Age]"},
    Dupes = {"x1", "x10", "x100", "x1000"},
    Dupe = {},
    Share = {}
}

-- Собираем все предметы в один список
local allItems = {}
for _, list in pairs(itemsList) do
    for _, item in pairs(list) do
        table.insert(allItems, item)
    end
end

-- Создаем вкладки
local tabButtons, tabFrames = {}, {}
local tabIndex = 0

for tabName, items in pairs(itemsList) do
    tabIndex += 1
    
    -- Кнопка вкладки
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 36)
    btn.Position = UDim2.new(0, 10, 0, (tabIndex - 1) * 42 + 10)
    btn.Text = tabName
    btn.BackgroundColor3 = Color3.fromRGB(70, 0, 105)
    btn.TextColor3 = Color3.fromRGB(220, 180, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.AutoButtonColor = true
    btn.Parent = tabPanel
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    table.insert(tabButtons, btn)
    
    -- Фрейм контента для вкладки
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = tabName == "Fruits"
    frame.Parent = contentFrame
    
    tabFrames[tabName] = frame
    
    -- Обработчик клика по вкладке
    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(tabFrames) do f.Visible = false end
        for _, b in pairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(70, 0, 105) end
        frame.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
        playClick()
    end)
    
    -- Вкладка Dupe
    if tabName == "Dupe" then
        local info = Instance.new("TextLabel")
        info.Size = UDim2.new(0, 360, 0, 40)
        info.Position = UDim2.new(0.5, -180, 0, 10)
        info.BackgroundTransparency = 1
        info.TextColor3 = Color3.fromRGB(255, 100, 100)
        info.Font = Enum.Font.Gotham
        info.TextSize = 15
        info.Text = "🔴 Предмет не обнаружен"
        info.TextXAlignment = Enum.TextXAlignment.Center
        info.Parent = frame

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 300, 0, 44)
        button.Position = UDim2.new(0.5, -150, 0, 60)
        button.Text = "Добавить в инвентарь"
        button.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
        button.TextColor3 = Color3.fromRGB(220, 180, 255)
        button.Font = Enum.Font.GothamMedium
        button.TextSize = 16
        button.Parent = frame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button

        button.MouseButton1Click:Connect(function()
            playClick()
            local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Clone().Parent = player.Backpack end
        end)

        RunService.RenderStepped:Connect(function()
            local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
            if tool then
                info.Text = "🟢 В руке: " .. tool.Name
                info.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                info.Text = "🔴 Предмет не обнаружен"
                info.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end)
    
    -- Вкладка Share
    elseif tabName == "Share" then
        local box = Instance.new("TextBox")
        box.PlaceholderText = "🔍 Введите название"
        box.Size = UDim2.new(0, 300, 0, 44)
        box.Position = UDim2.new(0.5, -150, 0, 10)
        box.Font = Enum.Font.Gotham
        box.TextSize = 16
        box.BackgroundColor3 = Color3.fromRGB(70, 0, 105)
        box.TextColor3 = Color3.fromRGB(220, 180, 255)
        box.ClearTextOnFocus = false
        box.Parent = frame
        
        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 6)
        boxCorner.Parent = box

        local resultLabel = Instance.new("TextLabel")
        resultLabel.Size = UDim2.new(1, -20, 0, 30)
        resultLabel.Position = UDim2.new(0.5, -150, 0, 60)
        resultLabel.BackgroundTransparency = 1
        resultLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
        resultLabel.Font = Enum.Font.Gotham
        resultLabel.TextSize = 14
        resultLabel.TextXAlignment = Enum.TextXAlignment.Left
        resultLabel.Text = ""
        resultLabel.Parent = frame

        local addBtn = Instance.new("TextButton")
        addBtn.Size = UDim2.new(0, 300, 0, 44)
        addBtn.Position = UDim2.new(0.5, -150, 0, 100)
        addBtn.Text = "Добавить в инвентарь"
        addBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
        addBtn.TextColor3 = Color3.fromRGB(220, 180, 255)
        addBtn.Font = Enum.Font.GothamMedium
        addBtn.TextSize = 16
        addBtn.Parent = frame
        
        local addBtnCorner = Instance.new("UICorner")
        addBtnCorner.CornerRadius = UDim.new(0, 6)
        addBtnCorner.Parent = addBtn

        local currentMatch = nil
        box:GetPropertyChangedSignal("Text"):Connect(function()
            local text = box.Text:lower()
            currentMatch = nil
            for _, item in ipairs(allItems) do
                if item:lower():find(text, 1, true) then
                    resultLabel.Text = "Найдено: " .. item
                    currentMatch = item
                    break
                end
            end
            if not currentMatch then resultLabel.Text = "Ничего не найдено" end
        end)

        addBtn.MouseButton1Click:Connect(function()
            if currentMatch then
                addToInventory(currentMatch)
                playClick()
            end
        end)
    
    -- Остальные вкладки
    else
        for i, item in ipairs(items) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Size = UDim2.new(1, -40, 0, 44)
            itemBtn.Position = UDim2.new(0, 20, 0, (i - 1) * 50 + 10)
            itemBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
            itemBtn.TextColor3 = Color3.fromRGB(220, 180, 255)
            itemBtn.Text = item
            itemBtn.Font = Enum.Font.GothamMedium
            itemBtn.TextSize = 14
            itemBtn.Parent = frame
            
            local itemCorner = Instance.new("UICorner")
            itemCorner.CornerRadius = UDim.new(0, 6)
            itemCorner.Parent = itemBtn

            itemBtn.MouseButton1Click:Connect(function()
                playClick()
                if tabName == "Dupes" then
                    local multiplier = tonumber(item:sub(2)) or 1
                    local backpack = player:FindFirstChild("Backpack")
                    if backpack then
                        local originals = {}
                        for _, tool in ipairs(backpack:GetChildren()) do
                            table.insert(originals, tool:Clone())
                        end
                        for _, tool in ipairs(originals) do
                            for _ = 1, multiplier do
                                tool:Clone().Parent = backpack
                            end
                        end
                    end
                else
                    addToInventory(item)
                end
            end)
        end
    end
end
