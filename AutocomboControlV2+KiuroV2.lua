-- Configurações de Tempo
local tempoRecargaZ_Fruta = 65 -- 1:05 min
local esperaGeral = 1          -- 1 segundo entre ataques
local delayEquipar = 0.3       -- Troca de slot rápida

-- Variáveis de Controle (Inicia Ativo por Padrão)
_G.AutoFarmAtivo = true
local ultimoZ_Fruta = 0

-- Criando a Interface (GUI) - Botão 20x20 Redondo
local ScreenGui = Instance.new("ScreenGui")
local Button = Instance.new("TextButton")
local Corner = Instance.new("UICorner")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "MiniControlPanel_Turbo"

Button.Parent = ScreenGui
Button.Size = UDim2.new(0, 20, 0, 20) 
Button.Position = UDim2.new(0.5, 0, 0.1, 0)
Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- Inicia Verde (Ativo)
Button.Text = "" 
Button.BorderSizePixel = 0
Button.Active = true
Button.Draggable = true 

Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = Button

-- Função para simular clique de tecla
local function clicar(tecla)
    if not _G.AutoFarmAtivo then return end
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, tecla, false, game)
    task.wait(0.05)
    vim:SendKeyEvent(false, tecla, false, game)
end

-- Lógica do Botão (Ligar/Desligar)
Button.MouseButton1Click:Connect(function()
    _G.AutoFarmAtivo = not _G.AutoFarmAtivo
    Button.BackgroundColor3 = _G.AutoFarmAtivo and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

-- Loop de Combate Principal
task.spawn(function()
    while true do
        task.wait(0.1)
        
        if _G.AutoFarmAtivo then
            -- --- FRUTA CONTROL (SLOT 1) ---
            clicar(Enum.KeyCode.One)
            task.wait(delayEquipar)

            -- Verifica o Z (Regra de 1:05 min)
            local agora = os.time()
            if agora - ultimoZ_Fruta >= tempoRecargaZ_Fruta then
                clicar(Enum.KeyCode.Z)
                ultimoZ_Fruta = os.time()
                task.wait(esperaGeral)
            end

            -- Ataques Rápidos da Fruta: X, V, C
            local teclasFruta = {Enum.KeyCode.X, Enum.KeyCode.V, Enum.KeyCode.C}
            for _, tecla in ipairs(teclasFruta) do
                if not _G.AutoFarmAtivo then break end
                clicar(tecla)
                task.wait(esperaGeral)
            end

            -- --- ESPADA (SLOT 2) ---
            if _G.AutoFarmAtivo then
                clicar(Enum.KeyCode.Two)
                task.wait(delayEquipar)

                -- Ataques Rápidos da Espada: Z e X
                clicar(Enum.KeyCode.Z)
                task.wait(esperaGeral)
                
                if not _G.AutoFarmAtivo then continue end
                
                clicar(Enum.KeyCode.X)
                task.wait(esperaGeral)
            end
        end
    end
end)
