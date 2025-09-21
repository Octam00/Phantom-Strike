--// Hub Futurista com ESP + KillAll + Notificações (Octam)

local players = game:GetService("Players")
local local_player = players.LocalPlayer
local replicated_storage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variáveis globais
getgenv().killall = false
getgenv().espEnabled = false

-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FuturisticHub"
ScreenGui.Parent = game.CoreGui

-- Função de notificação (canto inferior direito)
local function showNotification(msg, color)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 260, 0, 40)
    notif.Position = UDim2.new(1, -20, 1, -20) -- canto inferior direito
    notif.AnchorPoint = Vector2.new(1, 1)
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    notif.BorderColor3 = color or Color3.fromRGB(255, 0, 0)
    notif.BorderSizePixel = 2
    notif.Text = msg
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 18
    notif.Parent = ScreenGui
    notif.BackgroundTransparency = 1
    notif.TextTransparency = 1

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif

    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Parent = notif

    -- efeito de aparecer
    TweenService:Create(notif, TweenInfo.new(0.3), {
        BackgroundTransparency = 0.2,
        TextTransparency = 0
    }):Play()

    -- sumir após 2 segundos
    task.delay(2, function()
        TweenService:Create(notif, TweenInfo.new(0.3), {
            BackgroundTransparency = 1,
            TextTransparency = 1
        }):Play()
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- Frame principal
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 160)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
Frame.Parent = ScreenGui

-- UI futurista
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = Frame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 0))
})
UIGradient.Rotation = 90
UIGradient.Parent = Frame

-- Draggable (Hub)
Frame.Active = true
Frame.Draggable = true

-- Botões futuristas
local function createButton(text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 30)
    btn.Position = UDim2.new(0.5, -90, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = Frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 1.5
    stroke.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
    end)

    return btn
end

-- KillAll Button
local KillAllBtn = createButton("Ativar Kill All", 20)
KillAllBtn.MouseButton1Click:Connect(function()
    getgenv().killall = not getgenv().killall
    KillAllBtn.Text = getgenv().killall and "Desativar Kill All" or "Ativar Kill All"
    showNotification(getgenv().killall and "Kill All ativado" or "Kill All desativado", getgenv().killall and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0))
end)

-- ESP Button
local ESPBtn = createButton("Ativar ESP", 60)
ESPBtn.MouseButton1Click:Connect(function()
    getgenv().espEnabled = not getgenv().espEnabled
    ESPBtn.Text = getgenv().espEnabled and "Desativar ESP" or "Ativar ESP"
    showNotification(getgenv().espEnabled and "ESP ativado" or "ESP desativado", Color3.fromRGB(0,200,255))
end)

-- Ocultar Hub Button
local HideBtn = createButton("Ocultar Hub", 100)

-- Botão Mostrar Hub (móvel)
local ReturnBtn = Instance.new("TextButton")
ReturnBtn.Size = UDim2.new(0, 120, 0, 30)
ReturnBtn.Position = UDim2.new(0.5, -60, 0.5, -15)
ReturnBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ReturnBtn.Text = "Mostrar Hub"
ReturnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ReturnBtn.Font = Enum.Font.GothamBold
ReturnBtn.TextSize = 16
ReturnBtn.Visible = false
ReturnBtn.Parent = ScreenGui
ReturnBtn.Active = true
ReturnBtn.Draggable = true -- agora é arrastável
local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 6)
corner2.Parent = ReturnBtn

-- Salvar posição do Hub
local lastPosition = Frame.Position

HideBtn.MouseButton1Click:Connect(function()
    lastPosition = Frame.Position
    Frame.Visible = false
    ReturnBtn.Visible = true
    showNotification("Hub ocultado", Color3.fromRGB(255,0,0))
end)

ReturnBtn.MouseButton1Click:Connect(function()
    Frame.Visible = true
    Frame.Position = lastPosition
    ReturnBtn.Visible = false
    showNotification("Hub mostrado", Color3.fromRGB(0,255,0))
end)

-- Tecla H
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.H then
        if Frame.Visible then
            lastPosition = Frame.Position
            Frame.Visible = false
            ReturnBtn.Visible = true
            showNotification("Hub ocultado (H)", Color3.fromRGB(255,0,0))
        else
            Frame.Visible = true
            Frame.Position = lastPosition
            ReturnBtn.Visible = false
            showNotification("Hub mostrado (H)", Color3.fromRGB(0,255,0))
        end
    end
end)

-- Kill All Loop
task.spawn(function()
    while task.wait() do
        if getgenv().killall then
            for _, v in next, players:GetPlayers() do
                if v ~= local_player and local_player.Character and local_player.Character:FindFirstChildOfClass("Tool") and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and not v.Character:FindFirstChildOfClass("ForceField") then
                    replicated_storage:WaitForChild("RemoteTriggers"):WaitForChild("Bolster"):FireServer(v.Character.Humanoid, v.Character:FindFirstChildOfClass("Tool"))
                end
            end
        end
    end
end)

-- ESP Loop
task.spawn(function()
    while task.wait(1) do
        if getgenv().espEnabled then
            for _, v in next, players:GetPlayers() do
                if v ~= local_player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    -- Highlight vermelho
                    if not v.Character:FindFirstChild("ESP_Highlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ESP_Highlight"
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.Parent = v.Character
                    end
                    -- Billboard com nome e HP
                    if not v.Character:FindFirstChild("ESP_Billboard") then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "ESP_Billboard"
                        billboard.Size = UDim2.new(0, 100, 0, 30)
                        billboard.Adornee = v.Character.HumanoidRootPart
                        billboard.AlwaysOnTop = true
                        billboard.Parent = v.Character

                        local text = Instance.new("TextLabel")
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.TextColor3 = Color3.fromRGB(255, 255, 255)
                        text.TextStrokeTransparency = 0.5
                        text.Font = Enum.Font.GothamBold
                        text.TextSize = 12
                        text.Name = "Info"
                        text.Parent = billboard
                    end

                    -- Atualizar HP
                    local humanoid = v.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        v.Character.ESP_Billboard.Info.Text = v.Name .. " | HP: " .. math.floor(humanoid.Health)
                    end
                end
            end
        else
            -- Destruir ESP quando desativado
            for _, v in next, players:GetPlayers() do
                if v.Character then
                    if v.Character:FindFirstChild("ESP_Highlight") then
                        v.Character.ESP_Highlight:Destroy()
                    end
                    if v.Character:FindFirstChild("ESP_Billboard") then
                        v.Character.ESP_Billboard:Destroy()
                    end
                end
            end
        end
    end
end)
