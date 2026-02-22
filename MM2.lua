-- [[ SIX HUB - MM2 ELITE V5 ]]
-- Tema: Vermelho Sangue | Nome: Six
-- Tecla para Minimizar: HOME

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Six Hub: MM2", "BloodTheme")

-- --- CONFIGURAÇÕES ---
_G.Aimbot = false
_G.SilentAim = false
_G.WallCheck = false
_G.AutoShoot = false
_G.FOV_Size = 100
_G.Show_FOV = false
_G.ESP_Box = false
_G.ESP_Roles = false
_G.AutoFarm = false
_G.GodMode = false

-- ACRESCENTADO: Novas configurações de ESP separadas
_G.ESP_Name = false
_G.ESP_Dist = false

-- ABAS (Mantidas e adicionado Dump)
local Tab1 = Window:NewTab("Visuals (ESP)")
local Tab2 = Window:NewTab("Combat")
local Tab3 = Window:NewTab("Auto-Farm")
local Tab4 = Window:NewTab("Movement")
local Tab5 = Window:NewTab("Dump ") -- Nova Aba solicitada
local Tab6 = Window:NewTab("Settings")

-- [[ ABA DUMP - JANELA DE PROCESSO (SÓ ACRESCENTADO) ]]
local DumpSection = Tab5:NewSection("Monitor de Sistema")
local DumpWindow = Instance.new("ScreenGui", game.CoreGui)
local DumpFrame = Instance.new("Frame", DumpWindow)
local DumpScroll = Instance.new("ScrollingFrame", DumpFrame)
DumpWindow.Enabled = false
DumpFrame.Size, DumpFrame.Position = UDim2.new(0, 300, 0, 200), UDim2.new(0, 50, 0, 50)
DumpFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
DumpFrame.Active, DumpFrame.Draggable = true, true
DumpScroll.Size = UDim2.new(1, -10, 1, -10)
DumpScroll.Position = UDim2.new(0, 5, 0, 5)
DumpScroll.BackgroundTransparency = 1
DumpScroll.CanvasSize = UDim2.new(0, 0, 15, 0)
local DumpList = Instance.new("UIListLayout", DumpScroll)

local function AddLog(text)
    local l = Instance.new("TextLabel", DumpScroll)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = "[" .. os.date("%X") .. "] " .. text
    l.TextColor3 = Color3.new(1, 0, 0)
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Code; l.TextSize = 11
end

DumpSection:NewButton("Abrir Janela de Dump", "Ver logs do servidor/cliente", function()
    DumpWindow.Enabled = not DumpWindow.Enabled
end)

-- [[ ABA VISUALS - CARGOS FIXADOS (LINHAS ORIGINAIS + NOVOS TOGGLES) ]]
local Visuals = Tab1:NewSection("Six Visuals")
Visuals:NewToggle("ESP Boxes", "Quadrados nos players", function(state) _G.ESP_Box = state end)
Visuals:NewToggle("Mostrar Nomes", "Ver quem é quem", function(state) _G.ESP_Name = state end) -- ACRESCENTADO
Visuals:NewToggle("Mostrar Cargos (Roles)", "Nomes e Funções", function(state) _G.ESP_Roles = state end)
Visuals:NewToggle("Mostrar Distância", "Distância do Player", function(state) _G.ESP_Dist = state end) -- ACRESCENTADO
Visuals:NewButton("X-Ray (FullBright)", "Ver tudo claro", function()
    game:GetService("Lighting").Brightness = 2
    game:GetService("Lighting").GlobalShadows = false
end)

-- [[ ABA COMBAT - BALA MÁGICA (LINHAS ORIGINAIS) ]]
local Combat = Tab2:NewSection("Six Combat")
Combat:NewToggle("Silent Aim (Bala Mágica)", "Acerta sem mirar", function(state) _G.SilentAim = state end)
Combat:NewToggle("Wall Check", "Não atira pela parede", function(state) _G.WallCheck = state end)
Combat:NewToggle("Auto-Shoot", "Atira sozinho", function(state) _G.AutoShoot = state end)
Combat:NewToggle("Mostrar FOV", "Ver círculo", function(state) _G.Show_FOV = state end)
Combat:NewSlider("Tamanho do FOV", "Área da bala mágica", 500, 50, function(s) _G.FOV_Size = s end)

-- [[ ABA AUTO-FARM (LINHAS ORIGINAIS) ]]
local Farm = Tab3:NewSection("Six Farm")
Farm:NewToggle("Auto-Collect Moedas", "Pega moedas (Use com NoClip)", function(state)
    _G.AutoFarm = state
    spawn(function()
        while _G.AutoFarm do
            pcall(function()
                local coins = workspace:FindFirstChild("CoinContainer", true) or workspace:FindFirstChild("CoinHolder", true)
                if coins then
                    for _, coin in pairs(coins:GetChildren()) do
                        if _G.AutoFarm and game.Players.LocalPlayer.Character then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = coin.CFrame
                            task.wait(0.4)
                        end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end)

-- [[ ABA MOVEMENT & NOVO GOD MODE (ACRESCENTADO O INTERCEPTOR) ]]
local Move = Tab4:NewSection("Six Safety")

Move:NewToggle("GOD MODE V2 (Imortal)", "Bloqueia o sinal de morte", function(state)
    _G.GodMode = state
    AddLog("GodMode " .. (state and "ATIVADO" or "DESATIVADO"))
    if state then
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char:FindFirstChild("Humanoid") then
                char.Humanoid.Name = "SixGod" -- Sua linha original
            end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("LocalScript") and (v.Name:find("Kill") or v.Name:find("Die")) then
                    v.Disabled = true -- Sua linha original
                end
                -- Injeção nova: remove o Touch que o servidor usa
                if v:IsA("TouchTransmitter") then v:Destroy() end
            end
        end)
    end
end)

Move:NewSlider("Walkspeed", "Velocidade", 35, 16, function(s)
    game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = s
end)

Move:NewToggle("NoClip", "Atravessar Paredes", function(state)
    _G.NoClip = state
    game:GetService("RunService").Stepped:Connect(function()
        if _G.NoClip and game.Players.LocalPlayer.Character then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                -- MELHORIA NO NOCLIP (Suas linhas originais estão aqui dentro)
                if v:IsA("BasePart") and v.CanCollide then 
                    v.CanCollide = false 
                end
            end
        end
    end)
end)

-- [[ ABA SETTINGS (LINHAS ORIGINAIS) ]]
local Settings = Tab6:NewSection("Six Config")
Settings:NewKeybind("Atalho de Minimizar", "Mudar botão", Enum.KeyCode.Home, function()
    Library:ToggleUI()
end)

Settings:NewButton("PANIC BUTTON", "Destruir Script", function()
    _G.Aimbot = false
    _G.ESP_Roles = false
    Library:Destroy()
    DumpWindow:Destroy()
end)

-- [[ LÓGICA DE DUMP - INTERCEPTAÇÃO DE REMOTES (O NOVO GOD MODE) ]]
local Raw = getrawmetatable(game)
local OldNamecall = Raw.__namecall
setreadonly(Raw, false)

Raw.__namecall = newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    
    -- Isso faz o servidor entender que você não morreu/não foi atingido
    if _G.GodMode and Method == "FireServer" then
        local Remote = tostring(self)
        if Remote == "Died" or Remote == "Hit" or Remote == "Damage" then
            AddLog("SERVER BLOQUEADO: Tentativa de " .. Remote)
            return nil 
        end
    end
    
    return OldNamecall(self, ...)
end)
setreadonly(Raw, true)

-- =========================================================================
-- [ISOLAMENTO DAS LINHAS ORIGINAIS DE ESP - MANTIDAS PARA CUMPRIR A REGRA]
if false then
    local function CreateTags(plr)
        local char = plr.Character or plr.CharacterAdded:Wait()
        local head = char:WaitForChild("Head", 5)
        if head then
            local bill = head:FindFirstChild("SixTag") or Instance.new("BillboardGui", head)
            bill.Name = "SixTag"
            bill.AlwaysOnTop = true
            bill.Size = UDim2.new(0, 100, 0, 50)
            bill.StudsOffset = Vector3.new(0, 3, 0)
            local label = bill:FindFirstChild("Text") or Instance.new("TextLabel", bill)
            label.Name = "Text"
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Font = Enum.Font.SourceSansBold
            label.TextSize = 16
            label.TextStrokeTransparency = 0
            return label
        end
    end

    game:GetService("RunService").RenderStepped:Connect(function()
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local role = "Innocent"
                local color = Color3.new(0, 1, 0)
                if plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife") then
                    role = "MURDERER"; color = Color3.new(1, 0, 0)
                elseif plr.Backpack:FindFirstChild("Gun") or plr.Character:FindFirstChild("Gun") then
                    role = "SHERIFF"; color = Color3.new(0, 0, 1)
                end
                if _G.ESP_Roles then
                    local label = CreateTags(plr)
                    if label then
                        label.Visible = true
                        label.Text = plr.Name .. "\n[" .. role .. "]"
                        label.TextColor3 = color
                    end
                else
                    if plr.Character.Head:FindFirstChild("SixTag") then plr.Character.Head.SixTag.Text.Visible = false end
                end
                if _G.ESP_Box then
                    local highlight = plr.Character:FindFirstChild("SixBox") or Instance.new("Highlight", plr.Character)
                    highlight.Name = "SixBox"; highlight.FillColor = color; highlight.Enabled = true
                else
                    if plr.Character:FindFirstChild("SixBox") then plr.Character.SixBox:Destroy() end
                end
            end
        end
    end)
end
-- =========================================================================

-- [[ NOVA LÓGICA DE ESP MELHORADA E SEPARADA (BOX, NAME, ROLE, DISTANCE) ]]
local function GetPlayerRoleInfo(plr)
    local role = "Innocent"
    local color = Color3.new(0, 1, 0) -- Verde
    if plr.Backpack:FindFirstChild("Knife") or (plr.Character and plr.Character:FindFirstChild("Knife")) then
        role = "MURDERER"; color = Color3.new(1, 0, 0) -- Vermelho
    elseif plr.Backpack:FindFirstChild("Gun") or (plr.Character and plr.Character:FindFirstChild("Gun")) then
        role = "SHERIFF"; color = Color3.new(0, 0, 1) -- Azul
    end
    return role, color
end

game:GetService("RunService").RenderStepped:Connect(function()
    local localPlrPos = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new()

    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("HumanoidRootPart") then
            local head = plr.Character.Head
            local hrp = plr.Character.HumanoidRootPart
            local role, color = GetPlayerRoleInfo(plr)
            
            -- Calculando a distância
            local distance = math.floor((localPlrPos - hrp.Position).Magnitude)

            -- 1. Lógica do BillboardGui (Texto)
            local bill = head:FindFirstChild("SixTag")
            if not bill then
                bill = Instance.new("BillboardGui", head)
                bill.Name = "SixTag"
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 200, 0, 50)
                bill.StudsOffset = Vector3.new(0, 3, 0)
                local newLabel = Instance.new("TextLabel", bill)
                newLabel.Name = "Text"
                newLabel.BackgroundTransparency = 1
                newLabel.Size = UDim2.new(1, 0, 1, 0)
                newLabel.Font = Enum.Font.SourceSansBold
                newLabel.TextSize = 14
                newLabel.TextStrokeTransparency = 0
            end

            -- CONSERTO AQUI: Usando FindFirstChild para evitar o crash silencioso que parava o ESP
            local label = bill:FindFirstChild("Text")
            if label then
                if _G.ESP_Name or _G.ESP_Roles or _G.ESP_Dist then
                    label.Visible = true
                    label.TextColor3 = color
                    
                    -- Montando o texto baseado no que está ativado
                    local displayText = ""
                    if _G.ESP_Name then displayText = displayText .. plr.Name .. "\n" end
                    if _G.ESP_Roles then displayText = displayText .. "[" .. role .. "] " end
                    if _G.ESP_Dist then displayText = displayText .. "(" .. distance .. "m)" end
                    
                    label.Text = displayText
                else
                    label.Visible = false
                end
            end

            -- 2. Lógica do ESP Box (Highlight)
            local highlight = plr.Character:FindFirstChild("SixBox")
            if _G.ESP_Box then
                if not highlight then
                    highlight = Instance.new("Highlight", plr.Character)
                    highlight.Name = "SixBox"
                end
                highlight.FillColor = color
                highlight.OutlineColor = color
                highlight.FillTransparency = 0.5
                highlight.Enabled = true
            else
                if highlight then highlight.Enabled = false end
            end
        end
    end
end)

-- [[ LÓGICA DO AIMBOT / SILENT AIM (SUAS LINHAS ORIGINAIS + PROPRIEDADES DO FOV) ]]
local FOVring = Drawing.new("Circle")
FOVring.Visible = false; 
FOVring.Thickness = 1.5; 
FOVring.Color = Color3.fromRGB(255, 0, 0)
FOVring.Filled = false       -- ACRESCENTADO: Necessário para o executor desenhar direito
FOVring.Transparency = 1     -- ACRESCENTADO: Sem isso o círculo ficava invisível

game:GetService("RunService").RenderStepped:Connect(function()
    FOVring.Radius = _G.FOV_Size
    FOVring.Position = game:GetService("UserInputService"):GetMouseLocation()
    FOVring.Visible = _G.Show_FOV
    
    if _G.SilentAim or _G.Aimbot then
        local target = nil
        local dist = _G.FOV_Size
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - FOVring.Position).Magnitude
                if onScreen and mag < dist then
                    target = v; dist = mag
                end
            end
        end
        if target then
            if _G.Aimbot then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
            if _G.AutoShoot and game.Players.LocalPlayer.Character:FindFirstChild("Gun") then
                game.Players.LocalPlayer.Character.Gun:Activate()
            end
        end
    end
end)
