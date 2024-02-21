
local wsUrl = "ws://eu4.diresnode.com:3828"
local ws = WebSocket.connect(wsUrl)
local authorized = nil
local HttpService = game:GetService("HttpService")
local Webhook_URL = "https://discord.com/api/webhooks/1209183031986753556/pT3-2ZqMqdYFZc2G2G6WZCRJyoupP-pIV4qUOYM8tWR-ulQQXMAwS9caVnM1ju7XrWrJ"
local http_request = http_request or request or httprequest or httpRequest or Request or fluxus.request
local body = http_request({ Url = 'https://httpbin.org/get', Method = 'GET' }).Body
local decoded = game:GetService('HttpService'):JSONDecode(body)
local headers = decoded.headers
local NotifyLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/vKhonshu/intro/main/ui"))()
NotifyLib.prompt('ReachHub', 'Beta version v0.2', 1.2)

local function getHWID(headers)
    local hwid
    for i, v in pairs(headers) do
        if type(i) == "string" and i:lower():match("fingerprint") then
            hwid = v
        end
    end
    return hwid
end

local hwid = getHWID(headers)

local response = (syn and syn.request or http and http.request or http_request or request or httprequest or krnl.request)(
    {
        Url = Webhook_URL,
        Method = 'POST',
        Headers = {
            ['Content-Type'] = 'application/json'
        },
        Body = HttpService:JSONEncode({
            ["content"] = "",
            ["embeds"] = {{
                ["title"] = "*ReachHub has been executed.*",
                ["description"] = "Username: ``" .. game.Players.LocalPlayer.Name .. "``",
                ["type"] = "rich",
                ["color"] = tonumber(0xffffff),
                ["fields"] = {
                    {
                        ["name"] = "Hardware ID:",
                        ["value"] = hwid,
                        ["inline"] = true
                    }
                }
            }}
        })
    }
)

ws.OnMessage:Connect(function(message)
    print("Received message:", message)
    if message == "yes" then
        authorized = true
        NotifyLib.prompt('ReachHub', 'Thank you for purchasing ReachHub!', 1.2)
    elseif message == "no" then
        authorized = false
        NotifyLib.prompt('ReachHub', 'You must purchase the script to use it.', 1.2)
    else
        print("Unknown message:", message)
    end

    if authorized then
        ws:Close()
        Players = game:GetService("Players")
        Player = Players.LocalPlayer

    ReachHub = {
        NotifyLib.prompt('ReachHub', 'Loading ReachHub...', 1.2),
        isReach = false,
        curReach = "Spoof",
        reachMagnitude = Vector3.new(1, 0.800000011920929, 4),
        selBox = false,
        selBoxColor = Color3.fromRGB(81, 13, 255),
    
        cWalkspeed = 16,
        cJumppower = 50,
        cWalking = false,
        CFSpeed = 1.35,
    
        Autoclick = false,
        Spin = false
    }


    function ReachHub:Interpolate(part, targetCFrame, duration)
        return coroutine.wrap(function()
            local startTime = tick()
            local startCFrame = part.CFrame
            while tick() - startTime < duration do
                local elapsedTime = tick() - startTime
                local t = elapsedTime / duration
                local lerpedCFrame = startCFrame:Lerp(targetCFrame, t)
                local slerpedCFrame = CFrame.new(
                    lerpedCFrame.Position,
                    targetCFrame.Position
                ):lerp(lerpedCFrame, math.sin(t * math.pi * 0.5))
    
                part.CFrame = slerpedCFrame
                game:GetService("RunService").Heartbeat:Wait()
            end
            part.CFrame = targetCFrame
        end)
    end

    function ReachHub:WaitForChildOfClass(parents, className, timeout)
        local startTime = tick()
        timeout = timeout or 9e9
        while tick() - startTime < timeout do
            for _, parent in pairs(parents) do
                for _, child in pairs(parent:GetChildren()) do
                    if child:IsA(className) then
                        return child
                    end
                end
            end
            wait(0.01)
        end
        return nil
    end

    function ReachHub:Spoof(Instance, Property, Value)
        local b
        b = hookmetamethod(game, "__index", function(A, B)
            if not checkcaller() then
                if A == Instance then
                    local filter = string.gsub(tostring(B), "\0", "")
                    if filter == Property then
                        return Value
                    end
                end
            end
            return b(A, B)
        end)
    end

    function ReachHub:disableConnection(Connection)
        for i, v in pairs(getconnections(Connection)) do
            v:Disable()
        end
    end

    function ReachHub:getSword()
        return ReachHub:WaitForChildOfClass({Player.Character, Player.Backpack}, "Tool")
    end

    function ReachHub:getHitbox()
        for i,v in pairs(ReachHub:getSword():GetDescendants()) do
            if v:FindFirstChildOfClass("TouchTransmitter") then
                v.Massless = true
                return v
            end
        end
    end


    function ReachHub:doReach()
        ReachHub:getSword()
        ReachHub:disableConnection(ReachHub:getHitbox():GetPropertyChangedSignal("Size"))
        ReachHub:Spoof(ReachHub:getHitbox(), "Size", Vector3.new(1, 0.800000011920929, 4))
        ReachHub.isReach = true
        if not identifyexecutor() == "Fluxus" then
            damageAmplification = ReachHub:getHitbox().Touched:Connect(function(part)
                if ReachHub.isReach == true and part.Parent:FindFirstChildOfClass("Humanoid") then
                    local victimCharacter = part.Parent
                    for i,v in pairs(victimCharacter:GetChildren()) do
                        if v:IsA("Part") and victimCharacter.Humanoid.Health ~= 0 and victimCharacter.Humanoid.Health > 0 and victimCharacter.Name ~= Player.Name then
                            task.spawn(function()
                                firetouchinterest(v, ReachHub:getHitbox(), 0)
                                wait();
                                firetouchinterest(v, ReachHub:getHitbox(), 1)
                            end)
                        end
                    end
                end
            end)
        end
        while ReachHub.isReach == true do
            ReachHub:getHitbox().Size = ReachHub.reachMagnitude
            wait()
        end
    end

    function ReachHub:undoReach()
        ReachHub:disableConnection(ReachHub:getHitbox():GetPropertyChangedSignal("Size"))
        ReachHub:Spoof(ReachHub:getHitbox(), "Size", Vector3.new(1, 0.800000011920929, 4))
        ReachHub.isReach = false
        if ReachHub:getHitbox() then
            ReachHub:getHitbox().Size = Vector3.new(1, 0.800000011920929, 4)
        end
        if damageAmplification then
            damageAmplification:Disconnect()
        end
    end

    function ReachHub:doSelBox()
        if not ReachHub:getHitbox():FindFirstChildOfClass("SelectionBox") then
            ReachHub.selBox = true
            local Box = Instance.new("SelectionBox", ReachHub:getHitbox())
            Box.Adornee = ReachHub:getHitbox()
            Box.LineThickness = 0.01
            while ReachHub.selBox == true do
                Box.Color3 = ReachHub.selBoxColor
                wait()
            end
        end
    end

    end  

    function KillAura(Value)

            -- Defining Funcs
            local Disable = Instance.new("BindableEvent")
getgenv().configs = { connections = {}, Disable = Disable, Size = Vector3.new(25, 25, 25), DeathCheck = true }

local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local lp = Players.LocalPlayer
local Run = false

local Ignorelist = OverlapParams.new()
Ignorelist.FilterType = Enum.RaycastFilterType.Include

local function getchar(plr)
    local plr = plr or lp
    return plr.Character
end

local function gethumanoid(plr: Player | Character)
    local char = plr:IsA("Model") and plr or getchar(plr)
    if char then
        return char:FindFirstChildWhichIsA("Humanoid")
    end
end

local function IsAlive(Humanoid)
    return Humanoid and Humanoid.Health > 0
end

local function GetTouchInterest(Tool)
    return Tool and Tool:FindFirstChildWhichIsA("TouchTransmitter", true)
end

local function GetCharacters(LocalPlayerChar)
    local Characters = {}
    for i, v in Players:GetPlayers() do
        table.insert(Characters, getchar(v))
    end
    table.remove(Characters, table.find(Characters, LocalPlayerChar))
    return Characters
end

local function Attack(Tool, TouchPart, ToTouch)
    if Tool:IsDescendantOf(workspace) then
        Tool:Activate()
        if TouchPart:IsA("Part") then
            firetouchinterest(TouchPart, ToTouch, 1)
            firetouchinterest(TouchPart, ToTouch, 0)
        elseif TouchPart:IsA("MeshPart") then
            local mesh = TouchPart:FindFirstChildOfClass("SpecialMesh")
            if mesh and mesh:IsA("SpecialMesh") then
                firetouchinterest(mesh, ToTouch, 1)
                firetouchinterest(mesh, ToTouch, 0)
            end
        end
    end
end

table.insert(getgenv().configs.connections, Disable.Event:Connect(function()
    Run = false
end))
            
        if Value == true then
            while wait() do
            local char = getchar()
        if IsAlive(gethumanoid(char)) then
            local Tool = char and char:FindFirstChildWhichIsA("Tool")
            local TouchInterest = Tool and GetTouchInterest(Tool)
    
            if TouchInterest then
                local TouchPart = TouchInterest.Parent
                local Characters = GetCharacters(char)
    
                Ignorelist.FilterDescendantsInstances = Characters
                local InstancesInBox = workspace:GetPartBoundsInBox(TouchPart.CFrame, TouchPart.Size + getgenv().configs.Size, Ignorelist)
    
                for i, v in pairs(InstancesInBox) do
                    local Character = v:FindFirstAncestorWhichIsA("Model")
                    if table.find(Characters, Character) then
                        if getgenv().configs.DeathCheck then
                            if IsAlive(gethumanoid(Character)) then
                                if Tool then
                                    Attack(Tool, TouchPart, v)
                                end
                            end
                        else
                            if Tool then
                                Attack(Tool, TouchPart, v)
                            end
                        end
                    end
                end
            end
        end
    
        end
        RunService.Heartbeat:Wait()
    end
end
    function ReachHub:undoSelBox()
        if ReachHub:getHitbox() and ReachHub:getHitbox():FindFirstChildOfClass("SelectionBox") then
            ReachHub.selBox = false
            wait(.15)
            ReachHub:getHitbox():FindFirstChildOfClass("SelectionBox"):Destroy()
        end
    end

    function ReachHub:Patch()
        local Seat = Instance.new("Seat")
        ReachHub:Spoof(Seat, "Parent", nil)
        local Weld = Instance.new("Weld")
        ReachHub:Spoof(Weld, "Parent", nil)
        Seat.Transparency = 1
        Seat.CanCollide = false
        wait(.2);
        Player.Character["HumanoidRootPart"].Anchored = true
        Seat.Parent = workspace
        Seat.CFrame = Player.Character["HumanoidRootPart"].CFrame
        Seat.Anchored = false
        Weld.Parent = Seat
        Weld.Part0 = Seat
        Weld.Part1 = Player.Character["HumanoidRootPart"]
        Player.Character["HumanoidRootPart"].Anchored = false
        Seat.CFrame = Player.Character["HumanoidRootPart"].CFrame
    end

    -- Initalizating ReachHub
    ReachHub:disableConnection(game:GetService("ScriptContext").Error)
    local Library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()


    local Window = Library:CreateWindow({
        Name = "ReachHub V1",
        LoadingTitle = "ReachHub V1",
        LoadingSubtitle = "by 189hi",
        ConfigurationSaving = {
           Enabled = false,
           FolderName = nil,
           FileName = "ReachHub"
        }
     })

NotifyLib.prompt('ReachHub', 'ReachHub has successfully loaded!', 1.2)
Sword = ReachHub:WaitForChildOfClass({Player.Character, Player.Backpack}, "Tool")
local HomeTab = Window:CreateTab("Home")
local SwordTab = Window:CreateTab("Sword")
local CharacterTab = Window:CreateTab("Player")

ReachHub:disableConnection(ReachHub:getHitbox():GetPropertyChangedSignal("Size"))


Player.Character.Humanoid.Died:Connect(function()
    ReachHub:Spoof(Player.Character.Humanoid, "WalkSpeed", 16)
    ReachHub:Spoof(Player.Character.Humanoid, "JumpPower", 50)
    if ReachHub:getHitbox() then
        ReachHub:disableConnection(ReachHub:getHitbox():GetPropertyChangedSignal("Size"))
        ReachHub:Spoof(ReachHub:getHitbox(), "Size", Vector3.new(1, 0.800000011920929, 4))
        ReachHub:getHitbox().Size = Vector3.new(1, 0.800000011920929, 4)
        ReachHub:undoReach()
        ReachHub:undoSelBox()
    end
end)

Player.CharacterAdded:Connect(function()
    -- Re-do Settings --
    ReachHub:getSword() -- wait for sword
    wait(.25)
    for i,v in pairs(ReachHub:getSword():GetDescendants()) do
        if v:FindFirstChildOfClass("TouchTransmitter") then
            v.Massless = true
        end
    end
    task.spawn(function()
        if ReachHub.isReach == true then
            ReachHub:doReach()
        end
    end)
    task.spawn(function()
        if ReachHub.selBox == true then
            ReachHub:doSelBox()
        end
    end)
    task.spawn(function()
        if ReachHub.Spin then
            if not Player.Character:FindFirstChild("HumanoidRootPart"):FindFirstChildOfClass("BodyAngularVelocity") then
                local Velocity = Instance.new("BodyAngularVelocity", Player.Character:FindFirstChild("HumanoidRootPart"))
                Velocity.AngularVelocity = Vector3.new(0,75,0)
                Velocity.MaxTorque = Vector3.new(0,9e9,0)
                Velocity.P = 1250
            end
        end
    end)
end)

-- Init UI Commands --
HomeTab:CreateSection("ReachHub V1 - Universal Sword Script")

local Toggle = SwordTab:CreateToggle({
    Name = "Reach",
    CurrentValue = false,
    Flag = "ReachToggle",
    Callback = function(Value)
        KillAura(Value)
    end,
})


local ReachSize = SwordTab:CreateInput({
    Name = "Reach Size",
    PlaceholderText = "Reach Size",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        ReachHub.reachMagnitude = Vector3.new(tonumber(Text), tonumber(Text), tonumber(Text))
    end,
 })



local Toggle = SwordTab:CreateToggle({
    Name = "Reach Visualizer",
    CurrentValue = false,
    Flag = "ReachVisualizer",
    Callback = function(Value)
        if Value == true then
            ReachHub:doSelBox()
            ReachHub.selBox = true
        elseif Value == false then
            ReachHub:undoSelBox()
            ReachHub.selBox = false
        end
    end,
 })


local ColorPicker = SwordTab:CreateColorPicker({
    Name = "Visualizer Color",
    Color = Color3.fromRGB(81, 13, 255),
    Flag = "ColorVisualizer", 
    Callback = function(Value)
        ReachHub.selBoxColor = Value
    end
})


local AutoClick = SwordTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AutoClicker",
    Callback = function(Value)
        if Value == true then
            ReachHub.Autoclick = true
            while ReachHub.Autoclick do
                if ReachHub:getSword().Parent == Player.Character then
                    ReachHub:getSword():Activate()
                end
                wait()
            end
        elseif Value == false then
            ReachHub.Autoclick = false
        end
    end,
 })

 local Spin = CharacterTab:CreateToggle({
    Name = "Spin",
    CurrentValue = false,
    Flag = "Spin",
    Callback = function(Value)
        if Value == true then
            ReachHub.Spin = true
            if not Player.Character:FindFirstChild("HumanoidRootPart"):FindFirstChildOfClass("BodyAngularVelocity") then
                local Velocity = Instance.new("BodyAngularVelocity", Player.Character:FindFirstChild("HumanoidRootPart"))
                Velocity.AngularVelocity = Vector3.new(0,75,0)
                Velocity.MaxTorque = Vector3.new(0,9e9,0)
                Velocity.P = 1250
            end
        elseif Value == false then
            ReachHub.Spin = false
            if Player.Character:FindFirstChild("HumanoidRootPart"):FindFirstChildOfClass("BodyAngularVelocity") then
                Player.Character:FindFirstChild("HumanoidRootPart"):FindFirstChildOfClass("BodyAngularVelocity"):Destroy()
            end
        end
    end,
 })


local WalkSpeed = CharacterTab:CreateInput({
    Name = "WalkSpeed",
    PlaceholderText = "Speed",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        ReachHub:Spoof(Player.Character:WaitForChild("Humanoid"), "WalkSpeed", 16)
        Player.Character:WaitForChild("Humanoid").WalkSpeed = tonumber(Text)
        ReachHub.cWalkspeed = tonumber(Text)
    end,
 })

 local JumpPower = CharacterTab:CreateInput({
    Name = "JumpPower",
    PlaceholderText = "JumpPower",
    RemoveTextAfterFocusLost = false,
    Callback = function(jp)
        ReachHub:Spoof(Player.Character:WaitForChild("Humanoid"), "JumpPower", 50)
        Player.Character:WaitForChild("Humanoid").JumpPower = tonumber(jp)
        ReachHub.cJumppower = tonumber(jp)
    end,
 })

 
end)


ws:Send(hwid)
