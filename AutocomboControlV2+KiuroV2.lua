-- Configurações de Tempo
local tempoRecargaZ_Fruta = 65 -- 1:05 min
local esperaGeral = 1          -- REDUZIDO PARA 1 SEGUNDO
local delayEquipar = 0.3       -- Troca de slot ultra rápida

-- Variáveis de Controle
_G.AutoFarmAtivo = false
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
Button.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Vermelho (Off)
Button.Text = "" 
Button.BorderSizePixel = 0
Button.Active = true
Button.Draggable = true 

Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = Button

-- Função para simular clique de tecla (VirtualInputManager)
local function clicar(tecla)
    if not _G.AutoFarmAtivo then return end
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, tecla, false, game)
    task.wait(0.05)
    vim:SendKeyEvent(false, tecla, false, game)
end

-- Lógica do Botão
Button.MouseButton1Click:Connect(function()
    _G.AutoFarmAtivo = not _G.AutoFarmAtivo
    Button.BackgroundColor3 = _G.AutoFarmAtivo and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    if _G.AutoFarmAtivo then print("Auto Farm Turbo: Ligado") else print("Auto Farm Turbo: Desligado") end
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
                task.wait(esperaGeral) -- Espera 1s
            end

            -- Ataques Rápidos da Fruta: X, V, C
            local teclasFruta = {Enum.KeyCode.X, Enum.KeyCode.V, Enum.KeyCode.C}
            for _, tecla in ipairs(teclasFruta) do
                if not _G.AutoFarmAtivo then break end
                clicar(tecla)
                task.wait(esperaGeral) -- Espera 1s após cada
            end

            -- --- ESPADA (SLOT 2) ---
            if _G.AutoFarmAtivo then
                clicar(Enum.KeyCode.Two)
                task.wait(delayEquipar)

                -- Ataques Rápidos da Espada: Z e X
                clicar(Enum.KeyCode.Z)
                task.wait(esperaGeral) -- Espera 1s
                
                if not _G.AutoFarmAtivo then continue end
                
                clicar(Enum.KeyCode.X)
                task.wait(esperaGeral) -- Espera 1s
            end
            
            -- O loop termina e já volta para a Fruta em milissegundos
        end
    end
end)

