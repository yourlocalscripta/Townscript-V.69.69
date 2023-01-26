local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Ghost Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})
local Tab = Window:MakeTab({
	Name = "Cheats",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Cheats"
})

OrionLib:MakeNotification({
	Name = "Hi exploiter!",
	Content = "Script loaded have fun reaking havoc on town",
	Image = "rbxassetid://4483345998",
	Time = 5
})

Tab:AddButton({
	Name = "aimbot",
	Callback = function()
      		print("button pressed")
      		local dwCamera = workspace.CurrentCamera
local dwRunService = game:GetService("RunService")
local dwUIS = game:GetService("UserInputService")
local dwEntities = game:GetService("Players")
local dwLocalPlayer = dwEntities.LocalPlayer
local dwMouse = dwLocalPlayer:GetMouse()

local settings = {
    Aimbot = true,
    Aiming = false,
    Aimbot_AimPart = "Head",
    Aimbot_TeamCheck = false,
    Aimbot_Draw_FOV = true,
    Aimbot_FOV_Radius = 200,
    Aimbot_FOV_Color = Color3.fromRGB(255,255,255)
}

local fovcircle = Drawing.new("Circle")
fovcircle.Visible = settings.Aimbot_Draw_FOV
fovcircle.Radius = settings.Aimbot_FOV_Radius
fovcircle.Color = settings.Aimbot_FOV_Color
fovcircle.Thickness = 1
fovcircle.Filled = false
fovcircle.Transparency = 1

fovcircle.Position = Vector2.new(dwCamera.ViewportSize.X / 2, dwCamera.ViewportSize.Y / 2)

dwUIS.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then
        settings.Aiming = true
    end
end)

dwUIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then
        settings.Aiming = false
    end
end)

dwRunService.RenderStepped:Connect(function()
    
    local dist = math.huge
    local closest_char = nil

    if settings.Aiming then

        for i,v in next, dwEntities:GetChildren() do 

            if v ~= dwLocalPlayer and
            v.Character and
            v.Character:FindFirstChild("HumanoidRootPart") and
            v.Character:FindFirstChild("Humanoid") and
            v.Character:FindFirstChild("Humanoid").Health > 0 then

                if settings.Aimbot_TeamCheck == true and
                v.Team ~= dwLocalPlayer.Team or
                settings.Aimbot_TeamCheck == false then

                    local char = v.Character
                    local char_part_pos, is_onscreen = dwCamera:WorldToViewportPoint(char[settings.Aimbot_AimPart].Position)

                    if is_onscreen then

                        local mag = (Vector2.new(dwMouse.X, dwMouse.Y) - Vector2.new(char_part_pos.X, char_part_pos.Y)).Magnitude

                        if mag < dist and mag < settings.Aimbot_FOV_Radius then

                            dist = mag
                            closest_char = char

                        end
                    end
                end
            end
        end

        if closest_char ~= nil and
        closest_char:FindFirstChild("HumanoidRootPart") and
        closest_char:FindFirstChild("Humanoid") and
        closest_char:FindFirstChild("Humanoid").Health > 0 then

            dwCamera.CFrame = CFrame.new(dwCamera.CFrame.Position, closest_char[settings.Aimbot_AimPart].Position)
        end
    end
end)
  	end    
})

Tab:AddButton({
	Name = "ESP",
	Callback = function()
      		print("button pressed")
      		getgenv().enabled = true --Toggle on/off
getgenv().filluseteamcolor = false --Toggle fill color using player team color on/off
getgenv().outlineuseteamcolor = false --Toggle outline color using player team color on/off
getgenv().fillcolor = Color3.new(0, 0, 0) --Change fill color, no need to edit if using team color
getgenv().outlinecolor = Color3.new(1, 1, 1) --Change outline color, no need to edit if using team color
getgenv().filltrans = 0.6 --Change fill transparency
getgenv().outlinetrans = 0 --Change outline transparency
 
loadstring(game:HttpGet("https://raw.githubusercontent.com/zntly/highlight-esp/main/esp.lua"))()
  	end    
})

Tab:AddButton({
	Name = "Fullbright!",
	Callback = function()
      		print("love u bb")
      		    local Light = game:GetService("Lighting")
 
function dofullbright()
Light.Ambient = Color3.new(1, 1, 1)
Light.ColorShift_Bottom = Color3.new(1, 1, 1)
Light.ColorShift_Top = Color3.new(1, 1, 1)
end
 
dofullbright()
 
Light.LightingChanged:Connect(dofullbright)
  	end    
})

Tab:AddButton({
	Name = "Crosshair",
	Callback = function()
      		print("button pressed")
      		    getgenv().CrosshairSettings = {
    Color = Color3.fromRGB(255,0,0),
    RainbowColor = false,
    Opacity = 1,
    Length = 6, -- Length of each line
    Thickness = 1.2, -- Thickness of each line
    Offset = 3, -- Offset from the middle point
    Dot = false, -- not recommended
    FollowCursor = true, -- Crosshair follows the cursor
    HideMouseIcon = true, -- Hides the mouse icon, set to 0 to ignore
    HideGameCrosshair = true, -- Hides the current game's crosshair (if its supported)
    ToggleKey = Enum.KeyCode.RightAlt, -- Toggles crosshair visibility
} -- v1.2.1
loadstring(game:HttpGet("https://raw.githubusercontent.com/zzerexx/scripts/main/CustomCrosshair.lua", true))()
  end    
})

Tab:AddButton({
	Name = "Rejoin server",
	Callback = function()
      		print("button pressed")
      		local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
     
    local Rejoin = coroutine.create(function()
        local Success, ErrorMessage = pcall(function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
     
        if ErrorMessage and not Success then
            warn(ErrorMessage)
        end
    end)
     
    coroutine.resume(Rejoin)
  	end    
})

Tab:AddButton({
	Name = "Invisble (reset to disable",
	Callback = function()
      		print("button pressed")
      		char = game.Players.LocalPlayer.Character
    hum = char:FindFirstChildWhichIsA("Humanoid")
     
    function scan(p)
        for i,v in pairs(p:GetChildren()) do
            if v:IsA("BasePart") then
                v.Transparency = 1
            end
            if v:IsA("Decal") then
                v.Transparency = 1
            end
            scan(v)
        end
    end
     
    while true do
        if hum.Health <= 0 then break end
        scan(char)
        wait()
    end
end    
})






