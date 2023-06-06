local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/cat"))() --you can go into the github link and copy all of it and modify it for yourself.
local Window = Library:CreateWindow("Ghostware", Vector2.new(492, 598), Enum.KeyCode.RightControl) --you can change your UI keybind
local AimingTab = Window:CreateTab("Semi Rage") --you can rename this tab to whatever you want --you can also change the tabs code, for example "AimingTab" can be changed to "FunnyCoolTab" etc.


local testSection = AimingTab:CreateSector("First Section", "left")  --you can  change the section code, for example "testsection" can be changed to "FunnyCoolSection" etc.

testSection:AddButton("Aimbot", function(IhateGayPeople)
    print("button")                 pcall(function()
        getgenv().Aimbot.Functions:Exit()
    end)
    
    --// Environment
    
    getgenv().Aimbot = {}
    local Environment = getgenv().Aimbot
    
    --// Services
    
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local HttpService = game:GetService("HttpService")
    local TweenService = game:GetService("TweenService")
    local StarterGui = game:GetService("StarterGui")
    local Players = game:GetService("Players")
    local Camera = game:GetService("Workspace").CurrentCamera
    
    --// Variables
    
    local LocalPlayer = Players.LocalPlayer
    local Title = "aimbot loaded."
    local FileNames = {"Aimbot", "Configuration.json", "Drawing.json"}
    local Typing, Running, Animation, RequiredDistance, ServiceConnections = false, false, nil, 2000, {}
    
    --// Support Functions
    
    local mousemoverel = mousemoverel or (Input and Input.MouseMove)
    local queueonteleport = queue_on_teleport or syn.queue_on_teleport
    
    --// Script Settings
    
    Environment.Settings = {
        SendNotifications = true,
        SaveSettings = true, -- Re-execute upon changing
        ReloadOnTeleport = true,
        Enabled = true,
        TeamCheck = false,
        AliveCheck = true,
        WallCheck = false, -- Laggy
        Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
        ThirdPerson = false, -- Uses mousemoverel instead of CFrame to support locking in third person (could be choppy)
        ThirdPersonSensitivity = 3, -- Boundary: 0.1 - 5
        TriggerKey = "MouseButton2",
        Toggle = false,
        LockPart = "Head" -- Body part to lock on
    }
    
    Environment.FOVSettings = {
        Enabled = true,
        Visible = true,
        Amount = 90,
        Color = "255, 255, 255",
        LockedColor = "255, 70, 70",
        Transparency = 0.5,
        Sides = 60,
        Thickness = 1,
        Filled = false
    }
    
    Environment.FOVCircle = Drawing.new("Circle")
    Environment.Locked = nil
    
    --// Core Functions
    
    local function Encode(Table)
        if Table and type(Table) == "table" then
            local EncodedTable = HttpService:JSONEncode(Table)
    
            return EncodedTable
        end
    end
    
    local function Decode(String)
        if String and type(String) == "string" then
            local DecodedTable = HttpService:JSONDecode(String)
    
            return DecodedTable
        end
    end
    
    local function GetColor(Color)
        local R = tonumber(string.match(Color, "([%d]+)[%s]*,[%s]*[%d]+[%s]*,[%s]*[%d]+"))
        local G = tonumber(string.match(Color, "[%d]+[%s]*,[%s]*([%d]+)[%s]*,[%s]*[%d]+"))
        local B = tonumber(string.match(Color, "[%d]+[%s]*,[%s]*[%d]+[%s]*,[%s]*([%d]+)"))
    
        return Color3.fromRGB(R, G, B)
    end
    
    local function SendNotification(TitleArg, DescriptionArg, DurationArg)
        if Environment.Settings.SendNotifications then
            StarterGui:SetCore("SendNotification", {
                Title = TitleArg,
                Text = DescriptionArg,
                Duration = DurationArg
            })
        end
    end
    
    --// Functions
    
    local function SaveSettings()
        if Environment.Settings.SaveSettings then
            if isfile(Title.."/"..FileNames[1].."/"..FileNames[2]) then
                writefile(Title.."/"..FileNames[1].."/"..FileNames[2], Encode(Environment.Settings))
            end
    
            if isfile(Title.."/"..FileNames[1].."/"..FileNames[3]) then
                writefile(Title.."/"..FileNames[1].."/"..FileNames[3], Encode(Environment.FOVSettings))
            end
        end
    end
    
    local function GetClosestPlayer()
        if not Environment.Locked then
            if Environment.FOVSettings.Enabled then
                RequiredDistance = Environment.FOVSettings.Amount
            else
                RequiredDistance = 2000
            end
    
            for _, v in next, Players:GetPlayers() do
                if v ~= LocalPlayer then
                    if v.Character and v.Character:FindFirstChild(Environment.Settings.LockPart) and v.Character:FindFirstChildOfClass("Humanoid") then
                        if Environment.Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
                        if Environment.Settings.AliveCheck and v.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then continue end
                        if Environment.Settings.WallCheck and #(Camera:GetPartsObscuringTarget({v.Character[Environment.Settings.LockPart].Position}, v.Character:GetDescendants())) > 0 then continue end
    
                        local Vector, OnScreen = Camera:WorldToViewportPoint(v.Character[Environment.Settings.LockPart].Position)
                        local Distance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(Vector.X, Vector.Y)).Magnitude
    
                        if Distance < RequiredDistance and OnScreen then
                            RequiredDistance = Distance
                            Environment.Locked = v
                        end
                    end
                end
            end
        elseif (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).X, Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).Y)).Magnitude > RequiredDistance then
            Environment.Locked = nil
            Animation:Cancel()
            Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
        end
    end
    
    --// Typing Check
    
    ServiceConnections.TypingStartedConnection = UserInputService.TextBoxFocused:Connect(function()
        Typing = true
    end)
    
    ServiceConnections.TypingEndedConnection = UserInputService.TextBoxFocusReleased:Connect(function()
        Typing = false
    end)
    
    --// Create, Save & Load Settings
    
    if Environment.Settings.SaveSettings then
        if not isfolder(Title) then
            makefolder(Title)
        end
    
        if not isfolder(Title.."/"..FileNames[1]) then
            makefolder(Title.."/"..FileNames[1])
        end
    
        if not isfile(Title.."/"..FileNames[1].."/"..FileNames[2]) then
            writefile(Title.."/"..FileNames[1].."/"..FileNames[2], Encode(Environment.Settings))
        else
            Environment.Settings = Decode(readfile(Title.."/"..FileNames[1].."/"..FileNames[2]))
        end
    
        if not isfile(Title.."/"..FileNames[1].."/"..FileNames[3]) then
            writefile(Title.."/"..FileNames[1].."/"..FileNames[3], Encode(Environment.FOVSettings))
        else
            Environment.Visuals = Decode(readfile(Title.."/"..FileNames[1].."/"..FileNames[3]))
        end
    
        coroutine.wrap(function()
            while wait(10) and Environment.Settings.SaveSettings do
                SaveSettings()
            end
        end)()
    else
        if isfolder(Title) then
            delfolder(Title)
        end
    end
    
    local function Load()
        ServiceConnections.RenderSteppedConnection = RunService.RenderStepped:Connect(function()
            if Environment.FOVSettings.Enabled and Environment.Settings.Enabled then
                Environment.FOVCircle.Radius = Environment.FOVSettings.Amount
                Environment.FOVCircle.Thickness = Environment.FOVSettings.Thickness
                Environment.FOVCircle.Filled = Environment.FOVSettings.Filled
                Environment.FOVCircle.NumSides = Environment.FOVSettings.Sides
                Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
                Environment.FOVCircle.Transparency = Environment.FOVSettings.Transparency
                Environment.FOVCircle.Visible = Environment.FOVSettings.Visible
                Environment.FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
            else
                Environment.FOVCircle.Visible = false
            end
    
            if Running and Environment.Settings.Enabled then
                GetClosestPlayer()
    
                if Environment.Settings.ThirdPerson then
                    Environment.Settings.ThirdPersonSensitivity = math.clamp(Environment.Settings.ThirdPersonSensitivity, 0.1, 5)
    
                    local Vector = Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position)
                    mousemoverel((Vector.X - UserInputService:GetMouseLocation().X) * Environment.Settings.ThirdPersonSensitivity, (Vector.Y - UserInputService:GetMouseLocation().Y) * Environment.Settings.ThirdPersonSensitivity)
                else
                    if Environment.Settings.Sensitivity > 0 then
                        Animation = TweenService:Create(Camera, TweenInfo.new(Environment.Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, Environment.Locked.Character[Environment.Settings.LockPart].Position)})
                        Animation:Play()
                    else
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Environment.Locked.Character[Environment.Settings.LockPart].Position)
                    end
                end
    
                Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.LockedColor)
            end
        end)
    
        ServiceConnections.InputBeganConnection = UserInputService.InputBegan:Connect(function(Input)
            if not Typing then
                pcall(function()
                    if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
                        if Environment.Settings.Toggle then
                            Running = not Running
    
                            if not Running then
                                Environment.Locked = nil
                                Animation:Cancel()
                                Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
                            end
                        else
                            Running = true
                        end
                    end
                end)
    
                pcall(function()
                    if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
                        if Environment.Settings.Toggle then
                            Running = not Running
    
                            if not Running then
                                Environment.Locked = nil
                                Animation:Cancel()
                                Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
                            end
                        else
                            Running = true
                        end
                    end
                end)
            end
        end)
    
        ServiceConnections.InputEndedConnection = UserInputService.InputEnded:Connect(function(Input)
            if not Typing then
                pcall(function()
                    if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
                        if not Environment.Settings.Toggle then
                            Running = false
                            Environment.Locked = nil
                            Animation:Cancel()
                            Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
                        end
                    end
                end)
    
                pcall(function()
                    if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
                        if not Environment.Settings.Toggle then
                            Running = false
                            Environment.Locked = nil
                            Animation:Cancel()
                            Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
                        end
                    end
                end)
            end
        end)
    end
    
    --// Functions
    
    Environment.Functions = {}
    
    function Environment.Functions:Exit()
        SaveSettings()
    
        for _, v in next, ServiceConnections do
            v:Disconnect()
        end
    
        if Environment.FOVCircle.Remove then Environment.FOVCircle:Remove() end
    
        getgenv().Aimbot.Functions = nil
        getgenv().Aimbot = nil
    end
    
    function Environment.Functions:Restart()
        SaveSettings()
    
        for _, v in next, ServiceConnections do
            v:Disconnect()
        end
    
        Load()
    end
    
    function Environment.Functions:ResetSettings()
        Environment.Settings = {
            SendNotifications = true,
            SaveSettings = true, -- Re-execute upon changing
            ReloadOnTeleport = true,
            Enabled = true,
            TeamCheck = false,
            AliveCheck = true,
            WallCheck = false,
            Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
            ThirdPerson = false,
            ThirdPersonSensitivity = 3,
            TriggerKey = "MouseButton2",
            Toggle = false,
            LockPart = "Head" -- Body part to lock on
        }
    
        Environment.FOVSettings = {
            Enabled = true,
            Visible = true,
            Amount = 90,
            Color = "255, 255, 255",
            LockedColor = "255, 70, 70",
            Transparency = 0.5,
            Sides = 60,
            Thickness = 1,
            Filled = false
        }
    end
    
    --// Support Check
    
    if not Drawing or not getgenv then
        SendNotification(Title, "Your exploit does not support this script", 3); return
    end
    
    --// Reload On Teleport
    
    if Environment.Settings.ReloadOnTeleport then
        if queueonteleport then
            queueonteleport(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Main.lua"))
        else
            SendNotification(Title, "Your exploit does not support \"syn.queue_on_teleport()\"")
        end
    end
    
    --// Load
    
    Load(); SendNotification(Title, "Aimbot script loaded.", 5)
end)


testSection:AddButton("Named esp", function(Ihatejews)
    print("Disable with Q")  local function API_Check()
        if Drawing == nil then
            return "No"
        else
            return "Yes"
        end
    end
    
    local Find_Required = API_Check()
    
    if Find_Required == "No" then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Ghostware";
            Text = "ESP script could not be loaded because your exploit is unsupported.";
            Duration = math.huge;
            Button1 = "OK"
        })
    
        return
    end
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera
    
    local Typing = false
    
    _G.SendNotifications = true   -- If set to true then the script would notify you frequently on any changes applied and when loaded / errored. (If a game can detect this, it is recommended to set it to false)
    _G.DefaultSettings = false   -- If set to true then the ESP script would run with default settings regardless of any changes you made.
    
    _G.TeamCheck = false   -- If set to true then the script would create ESP only for the enemy team members.
    
    _G.ESPVisible = true   -- If set to true then the ESP will be visible and vice versa.
    _G.TextColor = Color3.fromRGB(255, 187, 212)   -- The color that the boxes would appear as.
    _G.TextSize = 14   -- The size of the text.
    _G.Center = true   -- If set to true then the script would be located at the center of the label.
    _G.Outline = true   -- If set to true then the text would have an outline.
    _G.OutlineColor = Color3.fromRGB(0, 0, 0)   -- The outline color of the text.
    _G.TextTransparency = 0.7   -- The transparency of the text.
    _G.TextFont = Drawing.Fonts.UI   -- The font of the text. (UI, System, Plex, Monospace) 
    
    _G.DisableKey = Enum.KeyCode.Q   -- The key that disables / enables the ESP.
    
    local function CreateESP()
        for _, v in next, Players:GetPlayers() do
            if v.Name ~= Players.LocalPlayer.Name then
                local ESP = Drawing.new("Text")
    
                RunService.RenderStepped:Connect(function()
                    if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                        local Vector, OnScreen = Camera:WorldToViewportPoint(workspace[v.Name]:WaitForChild("Head", math.huge).Position)
    
                        ESP.Size = _G.TextSize
                        ESP.Center = _G.Center
                        ESP.Outline = _G.Outline
                        ESP.OutlineColor = _G.OutlineColor
                        ESP.Color = _G.TextColor
                        ESP.Transparency = _G.TextTransparency
                        ESP.Font = _G.TextFont
    
                        if OnScreen == true then
                            local Part1 = workspace:WaitForChild(v.Name, math.huge):WaitForChild("HumanoidRootPart", math.huge).Position
                            local Part2 = workspace:WaitForChild(Players.LocalPlayer.Name, math.huge):WaitForChild("HumanoidRootPart", math.huge).Position or 0
                            local Dist = (Part1 - Part2).Magnitude
                            ESP.Position = Vector2.new(Vector.X, Vector.Y - 25)
                            ESP.Text = ("("..tostring(math.floor(tonumber(Dist)))..") "..v.Name.." ["..workspace[v.Name].Humanoid.Health.."]")
                            if _G.TeamCheck == true then 
                                if Players.LocalPlayer.Team ~= v.Team then
                                    ESP.Visible = _G.ESPVisible
                                else
                                    ESP.Visible = false
                                end
                            else
                                ESP.Visible = _G.ESPVisible
                            end
                        else
                            ESP.Visible = false
                        end
                    else
                        ESP.Visible = false
                    end
                end)
    
                Players.PlayerRemoving:Connect(function()
                    ESP.Visible = false
                end)
            end
        end
    
        Players.PlayerAdded:Connect(function(Player)
            Player.CharacterAdded:Connect(function(v)
                if v.Name ~= Players.LocalPlayer.Name then 
                    local ESP = Drawing.new("Text")
        
                    RunService.RenderStepped:Connect(function()
                        if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                            local Vector, OnScreen = Camera:WorldToViewportPoint(workspace[v.Name]:WaitForChild("Head", math.huge).Position)
        
                            ESP.Size = _G.TextSize
                            ESP.Center = _G.Center
                            ESP.Outline = _G.Outline
                            ESP.OutlineColor = _G.OutlineColor
                            ESP.Color = _G.TextColor
                            ESP.Transparency = _G.TextTransparency
        
                            if OnScreen == true then
                                local Part1 = workspace:WaitForChild(v.Name, math.huge):WaitForChild("HumanoidRootPart", math.huge).Position
                            local Part2 = workspace:WaitForChild(Players.LocalPlayer.Name, math.huge):WaitForChild("HumanoidRootPart", math.huge).Position or 0
                                local Dist = (Part1 - Part2).Magnitude
                                ESP.Position = Vector2.new(Vector.X, Vector.Y - 25)
                                ESP.Text = ("("..tostring(math.floor(tonumber(Dist)))..") "..v.Name.." ["..workspace[v.Name].Humanoid.Health.."]")
                                if _G.TeamCheck == true then 
                                    if Players.LocalPlayer.Team ~= Player.Team then
                                        ESP.Visible = _G.ESPVisible
                                    else
                                        ESP.Visible = false
                                    end
                                else
                                    ESP.Visible = _G.ESPVisible
                                end
                            else
                                ESP.Visible = false
                            end
                        else
                            ESP.Visible = false
                        end
                    end)
        
                    Players.PlayerRemoving:Connect(function()
                        ESP.Visible = false
                    end)
                end
            end)
        end)
    end
    
    if _G.DefaultSettings == true then
        _G.TeamCheck = false
        _G.ESPVisible = true
        _G.TextColor = Color3.fromRGB(40, 90, 255)
        _G.TextSize = 14
        _G.Center = true
        _G.Outline = false
        _G.OutlineColor = Color3.fromRGB(0, 0, 0)
        _G.DisableKey = Enum.KeyCode.Q
        _G.TextTransparency = 0.75
    end
    
    UserInputService.TextBoxFocused:Connect(function()
        Typing = true
    end)
    
    UserInputService.TextBoxFocusReleased:Connect(function()
        Typing = false
    end)
    
    UserInputService.InputBegan:Connect(function(Input)
        if Input.KeyCode == _G.DisableKey and Typing == false then
            _G.ESPVisible = not _G.ESPVisible
            
            if _G.SendNotifications == true then
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Ghostware";
                    Text = "The ESP's visibility is now set to "..tostring(_G.ESPVisible)..".";
                    Duration = 5;
                })
            end
        end
    end)
    
    local Success, Errored = pcall(function()
        CreateESP()
    end)
    
    if Success and not Errored then
        if _G.SendNotifications == true then
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Ghostware";
                Text = "ESP script has loaded.";
                Duration = 5;
            })
        end
    elseif Errored and not Success then
        if _G.SendNotifications == true then
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Ghostware";
                Text = "ESP script has errored while loading, please check the developer console! (F9)";
                Duration = 5;
            })
        end
        TestService:Message("The ESP script has errored notify me in the discord :")
        warn(Errored)
        print("!! IF THE ERROR IS A FALSE POSITIVE (says that a player cannot be found) THEN DO NOT BOTHER !!")
    end
    
    end)

    testSection:AddButton("Fullbright", function(Ihatejews)
        print("hi")   game.Lighting.FogEnd = 100000
        game.Lighting.FogStart = 0
        game.Lighting.ClockTime = 14
        game.Lighting.Brightness = 2
        game.Lighting.GlobalShadows = false

    end)


    testSection:AddButton("", function(Ihatejews)
        print("hi")   

    end)



    ToggleBind:AddKeybind()

AimingTab:CreateConfigSystem("right") --this is the config system
