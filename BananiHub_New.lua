--// ==========================================================
--// 🍌 BANANIHUB 🍌
--// L = Open / Close
--// ==========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local PlaceInfo = {
    Name = "Unknown Experience",
    IconImageAssetId = 0,
    Creator = "Unknown",
}

pcall(function()
    local Info = MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset)
    PlaceInfo.Name = Info.Name or PlaceInfo.Name
    PlaceInfo.IconImageAssetId = Info.IconImageAssetId or 0

    if Info.Creator and Info.Creator.Name then
        PlaceInfo.Creator = Info.Creator.Name
    end

end)

local BANANIHUB_VERSION = "1.1.0"
local UIToggleKey = Enum.KeyCode.L
local BANANIHUB_VERSION_URL =
    "https://raw.githubusercontent.com/Chr1z218/Rayfield/refs/heads/main/bananihub-version.txt"

--==============================================================
-- RAYFIELD
--==============================================================

local DEFAULT_GRAY_THEME = {
    TextColor = Color3.fromRGB(240, 240, 240),
    Background = Color3.fromRGB(38, 38, 38),
    Topbar = Color3.fromRGB(48, 48, 48),
    Shadow = Color3.fromRGB(22, 22, 22),

    NotificationBackground = Color3.fromRGB(32, 32, 32),
    NotificationActionsBackground = Color3.fromRGB(225, 225, 225),

    TabBackground = Color3.fromRGB(52, 52, 52),
    TabStroke = Color3.fromRGB(72, 72, 72),
    TabBackgroundSelected = Color3.fromRGB(215, 215, 215),
    TabTextColor = Color3.fromRGB(230, 230, 230),
    SelectedTabTextColor = Color3.fromRGB(40, 40, 40),

    ElementBackground = Color3.fromRGB(44, 44, 44),
    ElementBackgroundHover = Color3.fromRGB(52, 52, 52),
    SecondaryElementBackground = Color3.fromRGB(36, 36, 36),
    ElementStroke = Color3.fromRGB(64, 64, 64),
    SecondaryElementStroke = Color3.fromRGB(52, 52, 52),

    SliderBackground = Color3.fromRGB(74, 74, 74),
    SliderProgress = Color3.fromRGB(210, 210, 210),
    SliderStroke = Color3.fromRGB(235, 235, 235),

    ToggleBackground = Color3.fromRGB(38, 38, 38),
    ToggleEnabled = Color3.fromRGB(215, 215, 215),
    ToggleDisabled = Color3.fromRGB(105, 105, 105),
    ToggleEnabledStroke = Color3.fromRGB(240, 240, 240),
    ToggleDisabledStroke = Color3.fromRGB(135, 135, 135),
    ToggleEnabledOuterStroke = Color3.fromRGB(160, 160, 160),
    ToggleDisabledOuterStroke = Color3.fromRGB(72, 72, 72),

    DropdownSelected = Color3.fromRGB(56, 56, 56),
    DropdownUnselected = Color3.fromRGB(42, 42, 42),

    InputBackground = Color3.fromRGB(40, 40, 40),
    InputStroke = Color3.fromRGB(72, 72, 72),
    PlaceholderColor = Color3.fromRGB(165, 165, 165)
}

local function ClearOldBananiUI()
    local Containers = {}

    if gethui then
        local Success, Result = pcall(gethui)
        if Success and Result then
            table.insert(Containers, Result)
        end
    end

    table.insert(Containers, game:GetService("CoreGui"))

    for _, Container in ipairs(Containers) do
        for _, Child in ipairs(Container:GetChildren()) do
            if Child.Name == "BananiUI"
                or Child.Name == "BananiUI-Old"
                or Child.Name == "Rayfield"
                or Child.Name == "Rayfield-Old"
                or Child.Name == "BANANIHUB" then

                pcall(function()
                    Child:Destroy()
                end)
            end
        end
    end

    if getgenv then
        getgenv().rayfieldCached = nil
        getgenv().BANANIHUB_LOADED = nil
    end
end

ClearOldBananiUI()


local Rayfield = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Chr1z218/BananiUi/refs/heads/main/source.lua"
))()

if getgenv then
    getgenv().BANANIHUB_LOADED = true
end

local Window = Rayfield:CreateWindow({
    Name = "🍌 BANANIHUB 🍌",
    LoadingTitle = "🍌 BANANIHUB 🍌",
    LoadingSubtitle = "Banana Powered",
    Theme = DEFAULT_GRAY_THEME,

    ConfigurationSaving = {
        Enabled = false,
        FolderName = "BANANIHUB",
        FileName = "Settings"
    },

    Discord = {
        Enabled = false
    },

    KeySystem = false
})

--==============================================================
-- VARIABLES
--==============================================================

local FlyEnabled = false
local NoclipEnabled = false
local FastWalkEnabled = false
local HighJumpEnabled = false
local InfiniteJumpEnabled = false
local AutoJumpEnabled = false
local FreezeEnabled = false
local FullbrightEnabled = false
local AntiFlingEnabled = false
local AntiAFKEnabled = false
local ChamsEnabled = false
local NPCChamsEnabled = false
local HitboxEnabled = false
local LowGraphicsEnabled = false
local FreecamEnabled = false
local CameraShakeEnabled = false
local Spectating = false
local AntiVoidEnabled = false
local AntiRagdollEnabled = false
local SpiderClimbEnabled = false
local BoxESPEnabled = false
local HealthESPEnabled = false

local FlySpeed = 50
local WalkSpeed = 16
local JumpPower = 50
local FreecamSpeed = 50
local CameraFOV = Camera.FieldOfView
local CameraShakeStrength = 0.3
local ChamsFillTransparency = 0.5
local ChamsOutlineTransparency = 0
local ChamsFillColor = Color3.fromRGB(255, 221, 0)
local ChamsOutlineColor = Color3.fromRGB(255, 255, 255)
local ChamsTeamColorsEnabled = false

local SavedPosition = nil
local PreviousPosition = nil
local SelectedPlayer = nil
local SpectatorTarget = nil

local FlyConnection
local AutoJumpConnection
local NoclipConnection
local StatusConnection
local ChamsConnection
local NPCChamsConnection
local HitboxConnection
local FreecamConnection
local CameraShakeConnection
local SpectatorConnection
local ServerStatusConnection
local StatsStatusConnection
local AntiVoidConnection
local AntiRagdollConnection
local SpiderClimbConnection
local ESPConnection
local Unloaded = false

local OriginalTransparency = {}
local OriginalLocalTransparency = {}
local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale
}
local OriginalGraphics = {}
local FreecamCFrame = Camera.CFrame
local FreecamRotation = Vector2.zero
local FreecamMouseConnection

local Waypoints = {}
local WaypointDropdown
local DeleteWaypointDropdown
local PlayerDropdown
local SpectatorDropdown
local Dashboard
local SpectatorInfo
local ServerInformation
local StatsInformation
local StatsAvatarLabel
local HelpInformation
local StatsPlayerDropdown
local SelectedStatsPlayer = Player
local ChamsSettingsCreated = false
local CustomThemeName = "Banana"
local SelectedThemeFile = nil
local ThemeFileDropdown
local CustomTheme = {
    TextColor = Color3.fromRGB(255, 248, 214),
    Background = Color3.fromRGB(28, 24, 12),
    Topbar = Color3.fromRGB(42, 35, 14),
    Shadow = Color3.fromRGB(10, 8, 3),
    NotificationBackground = Color3.fromRGB(35, 29, 12),
    NotificationActionsBackground = Color3.fromRGB(255, 224, 72),
    TabBackground = Color3.fromRGB(55, 46, 17),
    TabStroke = Color3.fromRGB(104, 85, 20),
    TabBackgroundSelected = Color3.fromRGB(255, 218, 54),
    TabTextColor = Color3.fromRGB(255, 242, 181),
    SelectedTabTextColor = Color3.fromRGB(44, 34, 3),
    ElementBackground = Color3.fromRGB(45, 37, 14),
    ElementBackgroundHover = Color3.fromRGB(58, 48, 18),
    SecondaryElementBackground = Color3.fromRGB(37, 31, 12),
    ElementStroke = Color3.fromRGB(91, 73, 19),
    SecondaryElementStroke = Color3.fromRGB(71, 58, 17),
    SliderBackground = Color3.fromRGB(112, 89, 19),
    SliderProgress = Color3.fromRGB(255, 214, 43),
    SliderStroke = Color3.fromRGB(255, 231, 107),
    ToggleBackground = Color3.fromRGB(50, 41, 14),
    ToggleEnabled = Color3.fromRGB(255, 210, 34),
    ToggleDisabled = Color3.fromRGB(100, 89, 58),
    ToggleEnabledStroke = Color3.fromRGB(255, 231, 103),
    ToggleDisabledStroke = Color3.fromRGB(127, 113, 74),
    ToggleEnabledOuterStroke = Color3.fromRGB(177, 139, 22),
    ToggleDisabledOuterStroke = Color3.fromRGB(75, 65, 38),
    DropdownSelected = Color3.fromRGB(67, 55, 18),
    DropdownUnselected = Color3.fromRGB(45, 37, 14),
    InputBackground = Color3.fromRGB(41, 34, 13),
    InputStroke = Color3.fromRGB(100, 82, 20),
    PlaceholderColor = Color3.fromRGB(191, 169, 93)
}

--==============================================================
-- HELPERS
--==============================================================

local function CenterText(Text, Width)
    Text = tostring(Text or "")
    Width = Width or 42
    local Padding = math.max(0, math.floor((Width - #Text) / 2))
    return string.rep(" ", Padding) .. Text
end

local function FormatNumber(Value)
    Value = tonumber(Value) or 0

    if Value >= 1_000_000_000 then
        return string.format("%.1fB", Value / 1_000_000_000)
    elseif Value >= 1_000_000 then
        return string.format("%.1fM", Value / 1_000_000)
    elseif Value >= 1_000 then
        return string.format("%.1fK", Value / 1_000)
    end

    return tostring(math.floor(Value))
end

local function Character()
    return Player.Character
end

local function Humanoid()
    local C = Character()
    return C and C:FindFirstChildOfClass("Humanoid")
end

local function Root()
    local C = Character()
    return C and C:FindFirstChild("HumanoidRootPart")
end

local function Notify(Title, Content)
    Rayfield:Notify({
        Title = Title,
        Content = Content,
        Duration = 3
    })
end

local function GetDisplayNames(Filter)
    local List = {}
    local LowerFilter = string.lower(Filter or "")

    for _, P in ipairs(Players:GetPlayers()) do
        if P ~= Player then
            local SearchText = string.lower(P.DisplayName .. " " .. P.Name)
            if LowerFilter == "" or string.find(SearchText, LowerFilter, 1, true) then
                table.insert(List, P.DisplayName)
            end
        end
    end

    table.sort(List)
    return List
end

local function FindPlayerByDisplayName(Name)
    for _, P in ipairs(Players:GetPlayers()) do
        if P.DisplayName == Name or P.Name == Name then
            return P
        end
    end
    return nil
end

local function CharacterState(H)
    if not H then return "N/A" end
    return tostring(H:GetState()):gsub("Enum.HumanoidStateType.", "")
end

local function HealthBar(H)
    if not H or H.MaxHealth <= 0 then
        return "🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥 N/A"
    end

    local Ratio = math.clamp(H.Health / H.MaxHealth, 0, 1)
    local Filled = math.floor(Ratio * 10 + 0.5)
    local Empty = 10 - Filled
    local Block

    if Ratio > 0.60 then
        Block = "🟩"
    elseif Ratio > 0.30 then
        Block = "🟨"
    else
        Block = "🟥"
    end

    return string.rep(Block, Filled)
        .. string.rep("⬛", Empty)
        .. " "
        .. math.floor(H.Health)
        .. "/"
        .. math.floor(H.MaxHealth)
end

local function GetPing()
    local Success, Value = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
    end)
    return Success and Value or "N/A"
end

local function GetPlayerFromModel(Model)
    return Players:GetPlayerFromCharacter(Model)
end

local function IsNPC(Model)
    return Model:IsA("Model")
        and Model:FindFirstChildOfClass("Humanoid")
        and not GetPlayerFromModel(Model)
end

--==============================================================
-- WAYPOINT STORAGE
--==============================================================

local WaypointFile = "BANANIHUB_Waypoints_" .. tostring(game.PlaceId) .. ".json"

local function EncodeCFrame(CF)
    return {CF:GetComponents()}
end

local function DecodeCFrame(Data)
    if type(Data) ~= "table" or #Data < 12 then return nil end
    return CFrame.new(table.unpack(Data))
end

local function LoadWaypoints()
    Waypoints = {}
    if isfile and readfile and isfile(WaypointFile) then
        local Success, Data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile(WaypointFile))
        end)
        if Success and type(Data) == "table" then
            Waypoints = Data
        end
    end
end

local function SaveWaypoints()
    if writefile then
        pcall(function()
            local Encoded = game:GetService("HttpService"):JSONEncode(Waypoints)
            writefile(WaypointFile, Encoded)
        end)
    end
end

local function GetWaypointNames()
    local Names = {}
    for Name in pairs(Waypoints) do
        table.insert(Names, Name)
    end
    table.sort(Names)
    return Names
end

local function RefreshWaypoints()
    local Names = GetWaypointNames()
    if WaypointDropdown then WaypointDropdown:Refresh(Names) end
    if DeleteWaypointDropdown then DeleteWaypointDropdown:Refresh(Names) end
end

LoadWaypoints()

--==============================================================
-- FLY
--==============================================================

local function StopFly()
    FlyEnabled = false
    if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil end

    local R = Root()
    if R then
        local Velocity = R:FindFirstChild("BananiFlyVelocity")
        local Gyro = R:FindFirstChild("BananiFlyGyro")
        if Velocity then Velocity:Destroy() end
        if Gyro then Gyro:Destroy() end
    end
end

local function StartFly()
    StopFly()
    local R = Root()
    if not R then return end

    FlyEnabled = true
    local Velocity = Instance.new("BodyVelocity")
    Velocity.Name = "BananiFlyVelocity"
    Velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    Velocity.Parent = R

    local Gyro = Instance.new("BodyGyro")
    Gyro.Name = "BananiFlyGyro"
    Gyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    Gyro.P = 90000
    Gyro.Parent = R

    FlyConnection = RunService.RenderStepped:Connect(function()
        if not FlyEnabled or not R.Parent then StopFly() return end

        local Direction = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then Direction += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then Direction -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then Direction -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then Direction += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Direction += Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Direction -= Vector3.yAxis end
        if Direction.Magnitude > 0 then Direction = Direction.Unit end

        Velocity.Velocity = Direction * FlySpeed
        Gyro.CFrame = Camera.CFrame
    end)
end

--==============================================================
-- MOVEMENT / PLAYER STATE
--==============================================================

NoclipConnection = RunService.Stepped:Connect(function()
    if not NoclipEnabled then return end
    local C = Character()
    if not C then return end
    for _, Object in ipairs(C:GetDescendants()) do
        if Object:IsA("BasePart") then Object.CanCollide = false end
    end
end)

local function UpdateMovement()
    local H = Humanoid()
    if not H then return end
    if FreezeEnabled then
        H.WalkSpeed = 0
        H.JumpPower = 0
        H.AutoRotate = false
    else
        H.WalkSpeed = FastWalkEnabled and WalkSpeed or 16
        H.JumpPower = HighJumpEnabled and JumpPower or 50
        H.AutoRotate = true
    end
end

local AutoJumpCooldown = false
AutoJumpConnection = RunService.Heartbeat:Connect(function()
    if not AutoJumpEnabled then return end
    local H = Humanoid()
    if not H or H.Health <= 0 then return end
    if H.FloorMaterial ~= Enum.Material.Air and not AutoJumpCooldown then
        AutoJumpCooldown = true
        H:ChangeState(Enum.HumanoidStateType.Jumping)
        task.delay(0.25, function() AutoJumpCooldown = false end)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local H = Humanoid()
        if H then H:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Heartbeat:Connect(function()
    if not AntiFlingEnabled then return end
    local R = Root()
    if R and (R.AssemblyLinearVelocity.Magnitude > 250 or R.AssemblyAngularVelocity.Magnitude > 100) then
        R.AssemblyLinearVelocity = Vector3.zero
        R.AssemblyAngularVelocity = Vector3.zero
    end
end)

Player.Idled:Connect(function()
    if AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

--==============================================================
-- LIGHTING / VISUALS
--==============================================================

local function SetFullbright(Value)
    FullbrightEnabled = Value
    if Value then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.FogEnd = OriginalLighting.FogEnd
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
    end
end

local function ApplyHighlight(Model, Name, TargetPlayer)
    local Highlight = Model:FindFirstChild(Name)

    if not Highlight then
        Highlight = Instance.new("Highlight")
        Highlight.Name = Name
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.Parent = Model
    end

    local FillColor = ChamsFillColor
    local OutlineColor = ChamsOutlineColor

    if Name == "BananiPlayerChams"
        and ChamsTeamColorsEnabled
        and TargetPlayer
        and TargetPlayer.Team then

        FillColor = TargetPlayer.TeamColor.Color
        OutlineColor = TargetPlayer.TeamColor.Color
    end

    Highlight.FillColor = FillColor
    Highlight.OutlineColor = OutlineColor
    Highlight.FillTransparency = ChamsFillTransparency
    Highlight.OutlineTransparency = ChamsOutlineTransparency
end

local function ClearHighlights(Name)
    for _, Object in ipairs(workspace:GetDescendants()) do
        if Object:IsA("Highlight") and Object.Name == Name then Object:Destroy() end
    end
end

local function SetChams(Value)
    ChamsEnabled = Value
    if ChamsConnection then ChamsConnection:Disconnect() ChamsConnection = nil end
    if not Value then ClearHighlights("BananiPlayerChams") return end

    ChamsConnection = RunService.Heartbeat:Connect(function()
        for _, P in ipairs(Players:GetPlayers()) do
            if P ~= Player and P.Character then ApplyHighlight(P.Character, "BananiPlayerChams", P) end
        end
    end)
end

local function SetNPCChams(Value)
    NPCChamsEnabled = Value
    if NPCChamsConnection then NPCChamsConnection:Disconnect() NPCChamsConnection = nil end
    if not Value then ClearHighlights("BananiNPCChams") return end

    NPCChamsConnection = RunService.Heartbeat:Connect(function()
        for _, Model in ipairs(workspace:GetDescendants()) do
            if IsNPC(Model) then ApplyHighlight(Model, "BananiNPCChams") end
        end
    end)
end

local function SetHitboxes(Value)
    HitboxEnabled = Value
    if HitboxConnection then HitboxConnection:Disconnect() HitboxConnection = nil end

    local function Clear()
        for _, Object in ipairs(workspace:GetDescendants()) do
            if Object:IsA("BoxHandleAdornment") and Object.Name == "BananiHitbox" then Object:Destroy() end
        end
    end

    if not Value then Clear() return end
    HitboxConnection = RunService.Heartbeat:Connect(function()
        for _, P in ipairs(Players:GetPlayers()) do
            if P ~= Player and P.Character then
                local R = P.Character:FindFirstChild("HumanoidRootPart")
                if R and not R:FindFirstChild("BananiHitbox") then
                    local Box = Instance.new("BoxHandleAdornment")
                    Box.Name = "BananiHitbox"
                    Box.Adornee = R
                    Box.AlwaysOnTop = true
                    Box.ZIndex = 10
                    Box.Size = R.Size
                    Box.Transparency = 0.5
                    Box.Color3 = ChamsFillColor
                    Box.Parent = R
                end
            end
        end
    end)
end

local function SetLowGraphics(Value)
    LowGraphicsEnabled = Value
    if Value then OriginalGraphics = {} end

    for _, Object in ipairs(workspace:GetDescendants()) do
        if Object:IsA("BasePart") then
            if Value then
                OriginalGraphics[Object] = {Material = Object.Material, Reflectance = Object.Reflectance}
                Object.Material = Enum.Material.SmoothPlastic
                Object.Reflectance = 0
            elseif OriginalGraphics[Object] then
                Object.Material = OriginalGraphics[Object].Material
                Object.Reflectance = OriginalGraphics[Object].Reflectance
            end
        elseif Object:IsA("ParticleEmitter") or Object:IsA("Trail") or Object:IsA("Beam") then
            if Value then
                OriginalGraphics[Object] = {Enabled = Object.Enabled}
                Object.Enabled = false
            elseif OriginalGraphics[Object] then
                Object.Enabled = OriginalGraphics[Object].Enabled
            end
        end
    end

    Lighting.GlobalShadows = not Value and OriginalLighting.GlobalShadows or false
    Lighting.EnvironmentDiffuseScale = Value and 0 or OriginalLighting.EnvironmentDiffuseScale
    Lighting.EnvironmentSpecularScale = Value and 0 or OriginalLighting.EnvironmentSpecularScale
    if not Value then OriginalGraphics = {} end
end


local StopSpectating

local CharacterAnchorState = nil

local function SetCharacterLocked(Value)
    local R = Root()
    if not R then return end

    if Value then
        if CharacterAnchorState == nil then
            CharacterAnchorState = R.Anchored
        end
        R.Anchored = true
        R.AssemblyLinearVelocity = Vector3.zero
        R.AssemblyAngularVelocity = Vector3.zero
    else
        R.Anchored = CharacterAnchorState == true
        CharacterAnchorState = nil
    end
end

--==============================================================
-- FREECAM
--==============================================================

local FreecamLooking = false

local function StopFreecam()
    FreecamEnabled = false
    FreecamLooking = false

    if FreecamConnection then
        FreecamConnection:Disconnect()
        FreecamConnection = nil
    end

    if FreecamMouseConnection then
        FreecamMouseConnection:Disconnect()
        FreecamMouseConnection = nil
    end

    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    Camera.CameraType = Enum.CameraType.Custom

    local H = Humanoid()
    if H and not Spectating then
        Camera.CameraSubject = H
    end

    if not Spectating then
        SetCharacterLocked(false)
    end
end

local function StartFreecam()
    StopSpectating()
    StopFreecam()

    SetCharacterLocked(true)
    FreecamEnabled = true
    FreecamCFrame = Camera.CFrame

    local X, Y = FreecamCFrame:ToOrientation()
    FreecamRotation = Vector2.new(X, Y)

    Camera.CameraType = Enum.CameraType.Scriptable
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default

    FreecamMouseConnection = UserInputService.InputBegan:Connect(function(Input, Processed)
        if Processed or not FreecamEnabled then return end

        if Input.UserInputType == Enum.UserInputType.MouseButton2 then
            FreecamLooking = true
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
        end
    end)

    local EndConnection
    EndConnection = UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton2 then
            FreecamLooking = false
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    end)

    local ChangedConnection
    ChangedConnection = UserInputService.InputChanged:Connect(function(Input)
        if not FreecamEnabled or not FreecamLooking then return end

        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            FreecamRotation -= Vector2.new(Input.Delta.Y, Input.Delta.X) * 0.0028
            FreecamRotation = Vector2.new(
                math.clamp(FreecamRotation.X, -1.55, 1.55),
                FreecamRotation.Y
            )
        end
    end)

    FreecamConnection = RunService.RenderStepped:Connect(function(Delta)
        if not FreecamEnabled then
            if EndConnection then EndConnection:Disconnect() end
            if ChangedConnection then ChangedConnection:Disconnect() end
            return
        end

        local Rotation = CFrame.fromOrientation(
            FreecamRotation.X,
            FreecamRotation.Y,
            0
        )

        local Direction = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then Direction += Rotation.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then Direction -= Rotation.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then Direction -= Rotation.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then Direction += Rotation.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then Direction += Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then Direction -= Vector3.yAxis end

        if Direction.Magnitude > 0 then
            Direction = Direction.Unit
        end

        local Position = FreecamCFrame.Position + Direction * FreecamSpeed * Delta
        FreecamCFrame = CFrame.new(Position) * Rotation
        Camera.CFrame = FreecamCFrame
    end)
end

local function SetCameraShake(Value)
    CameraShakeEnabled = Value
    if CameraShakeConnection then CameraShakeConnection:Disconnect() CameraShakeConnection = nil end
    if not Value then return end

    CameraShakeConnection = RunService.RenderStepped:Connect(function()
        if CameraShakeEnabled and not FreecamEnabled then
            local Offset = Vector3.new(
                (math.random() - 0.5) * CameraShakeStrength,
                (math.random() - 0.5) * CameraShakeStrength,
                0
            )
            Camera.CFrame = Camera.CFrame * CFrame.new(Offset)
        end
    end)
end

StopSpectating = function()
    Spectating = false

    if SpectatorConnection then
        SpectatorConnection:Disconnect()
        SpectatorConnection = nil
    end

    Camera.CameraType = Enum.CameraType.Custom

    local H = Humanoid()
    if H and not FreecamEnabled then
        Camera.CameraSubject = H
    end

    if not FreecamEnabled then
        SetCharacterLocked(false)
    end

    if SpectatorInfo then
        local SelectedText = SpectatorTarget
            and ("Selected: " .. SpectatorTarget.DisplayName .. " (@" .. SpectatorTarget.Name .. ")")
            or "Select a player above."

        SpectatorInfo:Set({
            Title = "Spectator",
            Content = SelectedText
        })
    end
end

local function StartSpectating(Target)
    if not Target or Target == Player then
        Notify("Spectator", "Select another player first.")
        return
    end

    StopFreecam()
    StopSpectating()
    SetCharacterLocked(true)

    SpectatorTarget = Target
    Spectating = true

    SpectatorConnection = RunService.RenderStepped:Connect(function()
        if not Spectating or not SpectatorTarget or not SpectatorTarget.Parent then
            StopSpectating()
            return
        end

        local TargetCharacter = SpectatorTarget.Character
        local TargetHumanoid = TargetCharacter and TargetCharacter:FindFirstChildOfClass("Humanoid")
        local TargetRoot = TargetCharacter and TargetCharacter:FindFirstChild("HumanoidRootPart")
        local MyRoot = Root()

        if TargetHumanoid then
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = TargetHumanoid
        end

        if SpectatorInfo then
            local Distance = MyRoot and TargetRoot
                and math.floor((MyRoot.Position - TargetRoot.Position).Magnitude)
                or 0

            local Health = TargetHumanoid
                and (math.floor(TargetHumanoid.Health) .. "/" .. math.floor(TargetHumanoid.MaxHealth))
                or "N/A"

            local Speed = TargetHumanoid and math.floor(TargetHumanoid.WalkSpeed) or "N/A"

            SpectatorInfo:Set({
                Title = "👀 " .. SpectatorTarget.DisplayName,
                Content =
                    "Username: @" .. SpectatorTarget.Name
                    .. "\nHealth: " .. Health
                    .. "\nDistance: " .. tostring(Distance) .. " studs"
                    .. "\nState: " .. CharacterState(TargetHumanoid)
                    .. "\nWalkSpeed: " .. tostring(Speed)
                    .. "\nAccount Age: " .. tostring(SpectatorTarget.AccountAge) .. " days"
                    .. "\nUser ID: " .. tostring(SpectatorTarget.UserId)
            })
        end
    end)
end

--==============================================================
-- PLAYER LIST REFRESH
--==============================================================

local function RefreshPlayers()
    local Names = GetDisplayNames()

    if PlayerDropdown then
        PlayerDropdown:Refresh(Names)
    end

    if SpectatorDropdown then
        SpectatorDropdown:Refresh(Names)
    end

    if StatsPlayerDropdown then
        local StatsNames = {Player.DisplayName}
        for _, Name in ipairs(Names) do
            table.insert(StatsNames, Name)
        end
        StatsPlayerDropdown:Refresh(StatsNames)
    end

    if SelectedPlayer and not FindPlayerByDisplayName(SelectedPlayer) then
        SelectedPlayer = nil
    end

    if SpectatorTarget and not SpectatorTarget.Parent then
        SpectatorTarget = nil
    end
end

Players.PlayerAdded:Connect(function() task.wait(0.2) RefreshPlayers() end)
Players.PlayerRemoving:Connect(function() task.wait(0.2) RefreshPlayers() end)


--==============================================================
-- EXTRA PLAYER PROTECTION / MOVEMENT
--==============================================================

local LastSafeCFrame = nil
local AntiVoidHeight = -50

local function SetAntiVoid(Value)
    AntiVoidEnabled = Value

    if AntiVoidConnection then
        AntiVoidConnection:Disconnect()
        AntiVoidConnection = nil
    end

    if not Value then return end

    AntiVoidConnection = RunService.Heartbeat:Connect(function()
        local R = Root()
        local H = Humanoid()
        if not R or not H or H.Health <= 0 then return end

        if H.FloorMaterial ~= Enum.Material.Air and R.Position.Y > AntiVoidHeight + 15 then
            LastSafeCFrame = R.CFrame
        elseif R.Position.Y <= AntiVoidHeight and LastSafeCFrame then
            R.AssemblyLinearVelocity = Vector3.zero
            R.AssemblyAngularVelocity = Vector3.zero
            R.CFrame = LastSafeCFrame + Vector3.new(0, 4, 0)
            Notify("Anti Void", "Returned you to your last safe position.")
        end
    end)
end

local function SetAntiRagdoll(Value)
    AntiRagdollEnabled = Value

    if AntiRagdollConnection then
        AntiRagdollConnection:Disconnect()
        AntiRagdollConnection = nil
    end

    if not Value then return end

    AntiRagdollConnection = RunService.Heartbeat:Connect(function()
        local H = Humanoid()
        if not H or H.Health <= 0 then return end

        H.PlatformStand = false
        H.Sit = false

        local State = H:GetState()
        if State == Enum.HumanoidStateType.Ragdoll
            or State == Enum.HumanoidStateType.FallingDown
            or State == Enum.HumanoidStateType.Physics then

            H:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function SetSpiderClimb(Value)
    SpiderClimbEnabled = Value

    if SpiderClimbConnection then
        SpiderClimbConnection:Disconnect()
        SpiderClimbConnection = nil
    end

    if not Value then return end

    SpiderClimbConnection = RunService.Heartbeat:Connect(function()
        local R = Root()
        local H = Humanoid()
        local C = Character()
        if not R or not H or not C then return end

        local Params = RaycastParams.new()
        Params.FilterType = Enum.RaycastFilterType.Exclude
        Params.FilterDescendantsInstances = {C}

        local Result = workspace:Raycast(
            R.Position,
            R.CFrame.LookVector * 3.5,
            Params
        )

        if Result and UserInputService:IsKeyDown(Enum.KeyCode.W) then
            R.AssemblyLinearVelocity = Vector3.new(
                R.AssemblyLinearVelocity.X,
                32,
                R.AssemblyLinearVelocity.Z
            )
            H:ChangeState(Enum.HumanoidStateType.Climbing)
        end
    end)
end

--==============================================================
-- BOX / HEALTH ESP
--==============================================================

local function RemoveESPFromCharacter(CharacterModel)
    if not CharacterModel then return end

    local RootPart = CharacterModel:FindFirstChild("HumanoidRootPart")
    if RootPart then
        local Existing = RootPart:FindFirstChild("BananiESP")
        if Existing then Existing:Destroy() end
    end
end

local function UpdatePlayerESP(Target)
    if Target == Player then return end

    local C = Target.Character
    local R = C and C:FindFirstChild("HumanoidRootPart")
    local H = C and C:FindFirstChildOfClass("Humanoid")

    if not C or not R or not H then
        RemoveESPFromCharacter(C)
        return
    end

    if not BoxESPEnabled and not HealthESPEnabled then
        RemoveESPFromCharacter(C)
        return
    end

    local Billboard = R:FindFirstChild("BananiESP")

    if not Billboard then
        Billboard = Instance.new("BillboardGui")
        Billboard.Name = "BananiESP"
        Billboard.AlwaysOnTop = true
        Billboard.Size = UDim2.fromOffset(70, 100)
        Billboard.StudsOffset = Vector3.new(0, 0.5, 0)
        Billboard.Adornee = R
        Billboard.Parent = R

        local Box = Instance.new("Frame")
        Box.Name = "Box"
        Box.AnchorPoint = Vector2.new(0.5, 0.5)
        Box.Position = UDim2.fromScale(0.5, 0.5)
        Box.Size = UDim2.fromOffset(38, 76)
        Box.BackgroundTransparency = 1
        Box.Parent = Billboard

        local Stroke = Instance.new("UIStroke")
        Stroke.Name = "BoxStroke"
        Stroke.Thickness = 1
        Stroke.Color = Color3.fromRGB(255, 221, 0)
        Stroke.Parent = Box

        local HealthBack = Instance.new("Frame")
        HealthBack.Name = "HealthBack"
        HealthBack.Position = UDim2.new(0, 10, 0, 12)
        HealthBack.Size = UDim2.fromOffset(3, 76)
        HealthBack.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        HealthBack.BorderSizePixel = 0
        HealthBack.Parent = Billboard

        local HealthFill = Instance.new("Frame")
        HealthFill.Name = "HealthFill"
        HealthFill.AnchorPoint = Vector2.new(0, 1)
        HealthFill.Position = UDim2.fromScale(0, 1)
        HealthFill.Size = UDim2.fromScale(1, 1)
        HealthFill.BorderSizePixel = 0
        HealthFill.Parent = HealthBack

        local HealthText = Instance.new("TextLabel")
        HealthText.Name = "HealthText"
        HealthText.BackgroundTransparency = 1
        HealthText.Position = UDim2.new(0, 0, 1, -12)
        HealthText.Size = UDim2.new(1, 0, 0, 12)
        HealthText.Font = Enum.Font.GothamBold
        HealthText.TextSize = 9
        HealthText.TextColor3 = Color3.new(1, 1, 1)
        HealthText.TextStrokeTransparency = 0.3
        HealthText.Parent = Billboard
    end

    local Box = Billboard:FindFirstChild("Box")
    local HealthBack = Billboard:FindFirstChild("HealthBack")
    local HealthText = Billboard:FindFirstChild("HealthText")

    if Box then Box.Visible = BoxESPEnabled end
    if HealthBack then HealthBack.Visible = HealthESPEnabled end
    if HealthText then HealthText.Visible = HealthESPEnabled end

    if HealthESPEnabled and HealthBack and HealthText then
        local Ratio = math.clamp(H.Health / math.max(H.MaxHealth, 1), 0, 1)
        local Fill = HealthBack:FindFirstChild("HealthFill")

        if Fill then
            Fill.Size = UDim2.fromScale(1, Ratio)
            Fill.BackgroundColor3 =
                Color3.fromRGB(255, 60, 60):Lerp(
                    Color3.fromRGB(70, 255, 100),
                    Ratio
                )
        end

        HealthText.Text =
            Target.DisplayName
            .. "  "
            .. math.floor(H.Health)
            .. "/"
            .. math.floor(H.MaxHealth)
    end
end

local function SetPlayerESP()
    if ESPConnection then
        ESPConnection:Disconnect()
        ESPConnection = nil
    end

    if not BoxESPEnabled and not HealthESPEnabled then
        for _, Target in ipairs(Players:GetPlayers()) do
            RemoveESPFromCharacter(Target.Character)
        end
        return
    end

    ESPConnection = RunService.RenderStepped:Connect(function()
        for _, Target in ipairs(Players:GetPlayers()) do
            UpdatePlayerESP(Target)
        end
    end)
end


--==============================================================
-- HOME
--==============================================================

local HomeTab = Window:CreateTab("Home", 4483362458)
HomeTab:CreateSection("Experience")

HomeTab:CreateParagraph({
    Title = CenterText(PlaceInfo.Name, 44),
    Content =
        "Creator: " .. PlaceInfo.Creator
        .. "\nCurrent Version: " .. BANANIHUB_VERSION
})

HomeTab:CreateSection("📊 Live Dashboard")

Dashboard = HomeTab:CreateParagraph({
    Title = "🍌 BANANIHUB 🍌",
    Content = "Loading..."
})

local SessionStart = os.clock()
local FrameCount = 0
local LastFPSUpdate = os.clock()
local CurrentFPS = 0

RunService.RenderStepped:Connect(function()
    FrameCount += 1
end)

StatusConnection = RunService.Heartbeat:Connect(function()
    local Now = os.clock()

    if Now - LastFPSUpdate >= 1 then
        CurrentFPS = math.floor(FrameCount / (Now - LastFPSUpdate))
        FrameCount = 0
        LastFPSUpdate = Now
    end

    local H = Humanoid()
    local SessionSeconds = math.floor(os.clock() - SessionStart)
    local Minutes = math.floor(SessionSeconds / 60)
    local Seconds = SessionSeconds % 60

    Dashboard:Set({
        Title = "🍌 BANANIHUB 🍌",
        Content =
            "👤 Player: " .. Player.DisplayName
            .. "\n❤️ HP: " .. HealthBar(H)
            .. "\n🎞️ FPS: " .. tostring(CurrentFPS)
            .. "\n📶 Ping: " .. GetPing()
            .. "\n🧍 State: " .. CharacterState(H)
            .. "\n👥 Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
            .. "\n⏱️ Session: " .. string.format("%02d:%02d", Minutes, Seconds)
    })
end)

--==============================================================
-- PLAYER TAB
--==============================================================

local PlayerTab = Window:CreateTab("Player", 4483362458)

PlayerTab:CreateSection("👤 Character")
PlayerTab:CreateButton({
    Name = "🔄 Respawn",
    Callback = function()
        local H = Humanoid()
        if H then H.Health = 0 end
    end
})

PlayerTab:CreateSection("⚡ Movement")
PlayerTab:CreateToggle({
    Name = "✈️ Fly",
    Flag = "Player_Fly",
    CurrentValue = false,
    Callback = function(Value)
        if Value then StartFly() else StopFly() end
    end
})
PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Flag = "Player_FlySpeed",
    Range = {10, 150},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(Value)
        FlySpeed = Value
    end
})
PlayerTab:CreateToggle({
    Name = "🚧 Noclip",
    Flag = "Player_Noclip",
    CurrentValue = false,
    Callback = function(Value)
        NoclipEnabled = Value
    end
})
PlayerTab:CreateToggle({
    Name = "🕷️ Spider Climb",
    Flag = "Player_SpiderClimb",
    CurrentValue = false,
    Callback = SetSpiderClimb
})
PlayerTab:CreateToggle({
    Name = "⚡ Fast Walk",
    Flag = "Player_FastWalk",
    CurrentValue = false,
    Callback = function(Value)
        FastWalkEnabled = Value
        UpdateMovement()
    end
})
PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Flag = "Player_WalkSpeed",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        WalkSpeed = Value
        UpdateMovement()
    end
})
PlayerTab:CreateToggle({
    Name = "🦘 High Jump",
    Flag = "Player_HighJump",
    CurrentValue = false,
    Callback = function(Value)
        HighJumpEnabled = Value
        UpdateMovement()
    end
})
PlayerTab:CreateSlider({
    Name = "Jump Power",
    Flag = "Player_JumpPower",
    Range = {50, 150},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(Value)
        JumpPower = Value
        UpdateMovement()
    end
})
PlayerTab:CreateToggle({
    Name = "♾️ Infinite Jump",
    Flag = "Player_InfiniteJump",
    CurrentValue = false,
    Callback = function(Value)
        InfiniteJumpEnabled = Value
    end
})
PlayerTab:CreateToggle({
    Name = "🤸 Auto Jump",
    Flag = "Player_AutoJump",
    CurrentValue = false,
    Callback = function(Value)
        AutoJumpEnabled = Value
    end
})
PlayerTab:CreateToggle({
    Name = "🧊 Freeze",
    Flag = "Player_Freeze",
    CurrentValue = false,
    Callback = function(Value)
        FreezeEnabled = Value
        UpdateMovement()
    end
})

PlayerTab:CreateSection("🛡️ Protection")
PlayerTab:CreateToggle({
    Name = "🕳️ Anti Void",
    Flag = "Player_AntiVoid",
    CurrentValue = false,
    Callback = SetAntiVoid
})
PlayerTab:CreateToggle({
    Name = "🧍 Anti Ragdoll",
    Flag = "Player_AntiRagdoll",
    CurrentValue = false,
    Callback = SetAntiRagdoll
})
PlayerTab:CreateToggle({
    Name = "🛡️ Anti-Fling",
    Flag = "Player_AntiFling",
    CurrentValue = false,
    Callback = function(Value)
        AntiFlingEnabled = Value
    end
})
PlayerTab:CreateToggle({
    Name = "💤 Anti-AFK",
    Flag = "Player_AntiAFK",
    CurrentValue = false,
    Callback = function(Value)
        AntiAFKEnabled = Value
    end
})

local TeleportToolName = "Banani Teleporter"

local function RemoveTeleportTool()
    local Backpack = Player:FindFirstChildOfClass("Backpack")
    local C = Character()

    local BackpackTool = Backpack and Backpack:FindFirstChild(TeleportToolName)
    local EquippedTool = C and C:FindFirstChild(TeleportToolName)

    if BackpackTool then BackpackTool:Destroy() end
    if EquippedTool then EquippedTool:Destroy() end
end

local function GiveTeleportTool()
    local Backpack = Player:FindFirstChildOfClass("Backpack")

    if not Backpack then
        Notify("Teleport Tool", "Your Backpack is not ready.")
        return
    end

    RemoveTeleportTool()

    local Tool = Instance.new("Tool")
    Tool.Name = TeleportToolName
    Tool.ToolTip = "Click anywhere to teleport"
    Tool.RequiresHandle = false
    Tool.CanBeDropped = false
    Tool.Parent = Backpack

    local Mouse = Player:GetMouse()
    local Cooldown = false

    Tool.Activated:Connect(function()
        if Cooldown then return end

        local R = Root()
        if not R or not Mouse.Hit then return end

        Cooldown = true
        PreviousPosition = R.CFrame
        R.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))

        task.delay(0.25, function()
            Cooldown = false
        end)
    end)

    Notify("🍌 Teleport Tool", "Equip Banani Teleporter and click anywhere.")
end

--==============================================================
-- TELEPORT TAB
--==============================================================

local TeleportTab = Window:CreateTab("Teleport", 4483362458)

TeleportTab:CreateSection("🖱️ Banani Teleporter")
TeleportTab:CreateParagraph({
    Title = "Banani Teleporter",
    Content = "Adds a tool to your hotbar. Equip it and click anywhere to teleport."
})
TeleportTab:CreateButton({
    Name = "🍌 Give Teleport Tool",
    Callback = GiveTeleportTool
})
TeleportTab:CreateButton({
    Name = "🗑️ Remove Teleport Tool",
    Callback = RemoveTeleportTool
})

TeleportTab:CreateSection("👥 Player Teleport")

local Names = GetDisplayNames()
PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = Names,
    CurrentOption = Names[1] and {Names[1]} or {},
    SearchBarEnabled = true,
    Callback = function(Option) SelectedPlayer = type(Option) == "table" and Option[1] or Option end
})

TeleportTab:CreateButton({
    Name = "📍 Teleport To Player",
    Callback = function()
        local Target = SelectedPlayer and FindPlayerByDisplayName(SelectedPlayer)
        local TargetRoot = Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart")
        local R = Root()
        if R and TargetRoot then
            PreviousPosition = R.CFrame
            R.CFrame = TargetRoot.CFrame + Vector3.new(0, 3, 0)
        end
    end
})


TeleportTab:CreateSection("⚡ Quick Positions")
TeleportTab:CreateButton({Name = "💾 Save Current Position", Callback = function() local R = Root() if R then SavedPosition = R.CFrame Notify("📍 Position Saved", "Temporary position saved.") end end})
TeleportTab:CreateButton({Name = "📍 Teleport To Saved Position", Callback = function() local R = Root() if R and SavedPosition then PreviousPosition = R.CFrame R.CFrame = SavedPosition end end})
TeleportTab:CreateButton({Name = "↩️ Previous Position", Callback = function() local R = Root() if R and PreviousPosition then local Current = R.CFrame R.CFrame = PreviousPosition PreviousPosition = Current end end})

TeleportTab:CreateSection("🗂️ Named Waypoints")
local WaypointName = ""
local SelectedWaypoint = nil
local SelectedDeleteWaypoint = nil

TeleportTab:CreateInput({
    Name = "Waypoint Name",
    PlaceholderText = "Example: Shop",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) WaypointName = Text end
})

TeleportTab:CreateButton({
    Name = "➕ Save Named Waypoint",
    Callback = function()
        local R = Root()
        local CleanName = tostring(WaypointName):match("^%s*(.-)%s*$")
        if not R or CleanName == "" then Notify("Waypoint", "Enter a waypoint name first.") return end
        Waypoints[CleanName] = EncodeCFrame(R.CFrame)
        SaveWaypoints()
        RefreshWaypoints()
        Notify("Waypoint Saved", CleanName .. " saved for PlaceId " .. game.PlaceId)
    end
})

WaypointDropdown = TeleportTab:CreateDropdown({
    Name = "Waypoint Selector",
    Options = GetWaypointNames(),
    CurrentOption = {},
    Callback = function(Option) SelectedWaypoint = type(Option) == "table" and Option[1] or Option end
})

TeleportTab:CreateButton({
    Name = "📍 Teleport To Waypoint",
    Callback = function()
        local R = Root()
        local CF = SelectedWaypoint and DecodeCFrame(Waypoints[SelectedWaypoint])
        if R and CF then PreviousPosition = R.CFrame R.CFrame = CF end
    end
})

DeleteWaypointDropdown = TeleportTab:CreateDropdown({
    Name = "Delete Selector",
    Options = GetWaypointNames(),
    CurrentOption = {},
    Callback = function(Option) SelectedDeleteWaypoint = type(Option) == "table" and Option[1] or Option end
})

TeleportTab:CreateButton({
    Name = "🗑️ Delete Waypoint",
    Callback = function()
        if SelectedDeleteWaypoint and Waypoints[SelectedDeleteWaypoint] then
            local Deleted = SelectedDeleteWaypoint
            Waypoints[Deleted] = nil
            SelectedDeleteWaypoint = nil
            SaveWaypoints()
            RefreshWaypoints()
            Notify("Waypoint Deleted", Deleted)
        end
    end
})

--==============================================================
-- VISUALS TAB
--==============================================================

local VisualsTab = Window:CreateTab("Visuals", 4483362458)

VisualsTab:CreateSection("👁️ Lighting")
VisualsTab:CreateToggle({
    Name = "🌙 Fullbright",
    Flag = "Visuals_Fullbright",
    CurrentValue = false,
    Callback = SetFullbright
})
VisualsTab:CreateToggle({
    Name = "☀️ Day",
    CurrentValue = false,
    Callback = function(Value)
        if Value then Lighting.ClockTime = 14 end
    end
})
VisualsTab:CreateToggle({
    Name = "🌙 Night",
    CurrentValue = false,
    Callback = function(Value)
        if Value then Lighting.ClockTime = 0 end
    end
})
VisualsTab:CreateSlider({
    Name = "💡 Brightness",
    Flag = "Visuals_Brightness",
    Range = {0, 10},
    Increment = 0.5,
    CurrentValue = Lighting.Brightness,
    Callback = function(Value)
        Lighting.Brightness = Value
    end
})
VisualsTab:CreateToggle({
    Name = "🌫️ Fog",
    Flag = "Visuals_Fog",
    CurrentValue = true,
    Callback = function(Value)
        Lighting.FogEnd = Value and 1000 or 100000
    end
})
VisualsTab:CreateToggle({
    Name = "Low Graphics",
    Flag = "Visuals_LowGraphics",
    CurrentValue = false,
    Callback = SetLowGraphics
})

VisualsTab:CreateSection("✨ Chams")
VisualsTab:CreateToggle({
    Name = "Player Chams",
    Flag = "Visuals_PlayerChams",
    CurrentValue = false,
    Callback = function(Value)
        SetChams(Value)

        if Value and not ChamsSettingsCreated then
            ChamsSettingsCreated = true

            VisualsTab:CreateSection("🎨 Chams Settings")
            VisualsTab:CreateToggle({
                Name = "Team Color Chams",
                CurrentValue = false,
                Callback = function(Enabled)
                    ChamsTeamColorsEnabled = Enabled
                end
            })
            VisualsTab:CreateColorPicker({
                Name = "Fill Color",
                Color = ChamsFillColor,
                Callback = function(Color)
                    ChamsFillColor = Color
                end
            })
            VisualsTab:CreateColorPicker({
                Name = "Outline Color",
                Color = ChamsOutlineColor,
                Callback = function(Color)
                    ChamsOutlineColor = Color
                end
            })
            VisualsTab:CreateSlider({
                Name = "Fill Transparency",
                Range = {0, 1},
                Increment = 0.05,
                CurrentValue = 0.5,
                Callback = function(Value)
                    ChamsFillTransparency = Value
                end
            })
            VisualsTab:CreateSlider({
                Name = "Outline Transparency",
                Range = {0, 1},
                Increment = 0.05,
                CurrentValue = 0,
                Callback = function(Value)
                    ChamsOutlineTransparency = Value
                end
            })
        end
    end
})
VisualsTab:CreateToggle({
    Name = "NPC Highlights",
    Flag = "Visuals_NPCChams",
    CurrentValue = false,
    Callback = SetNPCChams
})
VisualsTab:CreateToggle({
    Name = "Hitbox Visualization",
    Flag = "Visuals_Hitboxes",
    CurrentValue = false,
    Callback = SetHitboxes
})

VisualsTab:CreateSection("🎯 Player ESP")
VisualsTab:CreateToggle({
    Name = "Box ESP",
    Flag = "Visuals_BoxESP",
    CurrentValue = false,
    Callback = function(Value)
        BoxESPEnabled = Value
        SetPlayerESP()
    end
})
VisualsTab:CreateToggle({
    Name = "Health ESP",
    Flag = "Visuals_HealthESP",
    CurrentValue = false,
    Callback = function(Value)
        HealthESPEnabled = Value
        SetPlayerESP()
    end
})

--==============================================================
-- FREECAM TAB
--==============================================================

local FreecamTab = Window:CreateTab("Freecam", 4483362458)
FreecamTab:CreateSection("🎥 Movable Freecam")
FreecamTab:CreateParagraph({Title = "Controls", Content = "WASD = move\nQ/E = down/up\nHold right-click or two-finger click and drag to look"})
FreecamTab:CreateToggle({Name = "🎥 Freecam",
    Flag = "Freecam_Enabled", CurrentValue = false, Callback = function(V) if V then StartFreecam() else StopFreecam() end end})
FreecamTab:CreateSlider({Name = "Freecam Speed",
    Flag = "Freecam_Speed", Range = {5, 200}, Increment = 5, CurrentValue = 50, Callback = function(V) FreecamSpeed = V end})

--==============================================================
-- SPECTATOR TAB
--==============================================================

local SpectatorTab = Window:CreateTab("Spectator", 4483362458)
SpectatorTab:CreateSection("👀 Player Selection")

SpectatorDropdown = SpectatorTab:CreateDropdown({
    Name = "Search or Select Player",
    Options = GetDisplayNames(),
    CurrentOption = {},
    SearchBarEnabled = true,

    Callback = function(Option)
        local Name = type(Option) == "table" and Option[1] or Option
        local Target = FindPlayerByDisplayName(Name)

        if Target then
            SpectatorTarget = Target

            if SpectatorInfo and not Spectating then
                SpectatorInfo:Set({
                    Title = "Spectator",
                    Content = "Selected: " .. Target.DisplayName .. " (@" .. Target.Name .. ")"
                })
            end
        end
    end
})

SpectatorTab:CreateSection("🎥 Spectate Controls")
SpectatorTab:CreateToggle({
    Name = "👀 Spectate",
    CurrentValue = false,

    Callback = function(Value)
        if Value then
            StartSpectating(SpectatorTarget)
        else
            StopSpectating()
        end
    end
})

SpectatorTab:CreateSection("📊 Live Player Information")
SpectatorInfo = SpectatorTab:CreateParagraph({
    Title = "Spectator",
    Content = "Select a player above."
})


local function GetEquippedTool(Target)
    local CharacterModel = Target.Character
    if not CharacterModel then return "None" end

    for _, Child in ipairs(CharacterModel:GetChildren()) do
        if Child:IsA("Tool") then
            return Child.Name
        end
    end

    return "None"
end

local function GetBackpackItems(Target)
    local Backpack = Target:FindFirstChildOfClass("Backpack")
    if not Backpack then return "Unavailable" end

    local Items = {}

    for _, Child in ipairs(Backpack:GetChildren()) do
        if Child:IsA("Tool") then
            table.insert(Items, Child.Name)
        end
    end

    table.sort(Items)

    if #Items == 0 then
        return "Empty"
    end

    return table.concat(Items, ", ")
end

local function GetPlayerStats(Target)
    local Lines = {}
    local Seen = {}

    local function ReadContainer(Container)
        if not Container then return end

        for _, Stat in ipairs(Container:GetChildren()) do
            if Stat:IsA("ValueBase") and not Seen[Stat] then
                Seen[Stat] = true
                table.insert(Lines, Stat.Name .. ": " .. tostring(Stat.Value))
            end
        end
    end

    ReadContainer(Target:FindFirstChild("leaderstats"))
    ReadContainer(Target:FindFirstChild("Stats"))
    ReadContainer(Target:FindFirstChild("Data"))
    ReadContainer(Target:FindFirstChild("PlayerData"))

    if #Lines == 0 then
        return "No public currency or stats found."
    end

    table.sort(Lines)
    return table.concat(Lines, "\n")
end

local function FormatAccountAge(Days)
    Days = math.max(0, math.floor(tonumber(Days) or 0))

    local Years = math.floor(Days / 365)
    local RemainingAfterYears = Days % 365
    local Months = math.floor(RemainingAfterYears / 30)
    local RemainingDays = RemainingAfterYears % 30

    local Parts = {}
    if Years > 0 then
        table.insert(Parts, Years .. (Years == 1 and " year" or " years"))
    end
    if Months > 0 then
        table.insert(Parts, Months .. (Months == 1 and " month" or " months"))
    end
    if RemainingDays > 0 or #Parts == 0 then
        table.insert(Parts, RemainingDays .. (RemainingDays == 1 and " day" or " days"))
    end

    return tostring(Days) .. " days / " .. table.concat(Parts, ", ")
end

local function GetAvatarThumbnail(Target)
    local Success, Thumbnail = pcall(function()
        return Players:GetUserThumbnailAsync(
            Target.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size420x420
        )
    end)

    return Success and Thumbnail or "Unavailable"
end

--==============================================================
-- STATS TAB
--==============================================================

local StatsTab = Window:CreateTab("Stats", 4483362458)
StatsTab:CreateSection("📊 Player Selection")

local StatsOptions = {Player.DisplayName}
for _, Name in ipairs(GetDisplayNames()) do
    table.insert(StatsOptions, Name)
end

StatsPlayerDropdown = StatsTab:CreateDropdown({
    Name = "Search or Select Player",
    Options = StatsOptions,
    CurrentOption = {Player.DisplayName},
    SearchBarEnabled = true,

    Callback = function(Option)
        local Name = type(Option) == "table" and Option[1] or Option

        if Name == Player.DisplayName or Name == Player.Name then
            SelectedStatsPlayer = Player
        else
            SelectedStatsPlayer = FindPlayerByDisplayName(Name) or SelectedStatsPlayer
        end
    end
})

StatsTab:CreateSection("👤 Player Profile")
StatsAvatarLabel = StatsTab:CreateLabel(
    "Avatar",
    GetAvatarThumbnail(Player)
)

StatsInformation = StatsTab:CreateParagraph({
    Title = "Player Stats",
    Content = "Loading..."
})

StatsStatusConnection = RunService.Heartbeat:Connect(function()
    local Target = SelectedStatsPlayer

    if not Target or not Target.Parent then
        SelectedStatsPlayer = Player
        Target = Player
    end

    local TargetCharacter = Target.Character
    local H = TargetCharacter and TargetCharacter:FindFirstChildOfClass("Humanoid")
    local TargetRoot = TargetCharacter and TargetCharacter:FindFirstChild("HumanoidRootPart")
    local MyRoot = Root()

    local Health = H
        and (math.floor(H.Health) .. "/" .. math.floor(H.MaxHealth))
        or "N/A"

    local Distance = MyRoot and TargetRoot
        and (math.floor((MyRoot.Position - TargetRoot.Position).Magnitude) .. " studs")
        or "N/A"

    local Thumbnail = GetAvatarThumbnail(Target)

    if StatsAvatarLabel then
        StatsAvatarLabel:Set("Avatar: " .. Target.DisplayName, Thumbnail)
    end

    StatsInformation:Set({
        Title = "📊 " .. Target.DisplayName,
        Content =
            "Username: @" .. Target.Name
            .. "\nUser ID: " .. tostring(Target.UserId)
            .. "\nAccount Age: " .. FormatAccountAge(Target.AccountAge)
            .. "\nHealth: " .. Health
            .. "\nTeam: " .. (Target.Team and Target.Team.Name or "None")
                        .. "\n\n💰 Currency / Stats"
            .. "\n" .. GetPlayerStats(Target)
    })
end)


local function GetPublicServers()
    local URL =
        "https://games.roblox.com/v1/games/"
        .. game.PlaceId
        .. "/servers/Public?sortOrder=Asc&limit=100"

    local Success, Result = pcall(function()
        return game:HttpGet(URL)
    end)

    if not Success then return nil end

    local DecodeSuccess, Data = pcall(function()
        return HttpService:JSONDecode(Result)
    end)

    return DecodeSuccess and Data.data or nil
end

local function ServerHop(Mode)
    local Servers = GetPublicServers()

    if not Servers then
        Notify("Server Hop", "Could not load the server list.")
        return
    end

    local Available = {}

    for _, Server in ipairs(Servers) do
        if Server.id ~= game.JobId and Server.playing < Server.maxPlayers then
            table.insert(Available, Server)
        end
    end

    if #Available == 0 then
        Notify("Server Hop", "No available servers were found.")
        return
    end

    if Mode == "Smallest" then
        table.sort(Available, function(A, B)
            return A.playing < B.playing
        end)
    elseif Mode == "Fullest" then
        table.sort(Available, function(A, B)
            return A.playing > B.playing
        end)
    else
        local RandomIndex = math.random(1, #Available)
        Available[1], Available[RandomIndex] =
            Available[RandomIndex], Available[1]
    end

    TeleportService:TeleportToPlaceInstance(
        game.PlaceId,
        Available[1].id,
        Player
    )
end

local function CheckForUpdates()
    local Success, Latest = pcall(function()
        return game:HttpGet(BANANIHUB_VERSION_URL)
    end)

    if not Success or not Latest then
        Notify(
            "Update Checker",
            "Could not check updates. Add bananihub-version.txt to your GitHub repository."
        )
        return
    end

    Latest = tostring(Latest):match("^%s*(.-)%s*$")

    if Latest == BANANIHUB_VERSION then
        Notify("Update Checker", "You are using the latest version: " .. BANANIHUB_VERSION)
    else
        Notify(
            "Update Available",
            "Installed: " .. BANANIHUB_VERSION .. " | Latest: " .. Latest
        )
    end
end

--==============================================================
-- BANANI AI / HELP TAB
--==============================================================

local HelpTab = Window:CreateTab("Banani AI", 4483362458)
HelpTab:CreateSection("🍌 Built-In Helper")

local HelpTopics = {
    ["Fly"] = "Enable Fly in Player > Movement. Use WASD to move, Space to go up, and Left Control to go down.",
    ["Noclip"] = "Noclip lets your character pass through collidable parts while enabled.",
    ["Spider Climb"] = "Enable Spider Climb in Player > Movement. Face a wall and hold W to climb upward.",
    ["Fast Walk"] = "Fast Walk uses the Walk Speed slider while enabled.",
    ["High Jump"] = "High Jump uses the Jump Power slider while enabled.",
    ["Infinite Jump"] = "Infinite Jump lets you jump again while already in the air.",
    ["Auto Jump"] = "Auto Jump jumps automatically whenever your character is on the ground.",
    ["Freeze"] = "Freeze sets movement and jumping to zero until disabled.",
    ["Anti Void"] = "Anti Void saves your last safe grounded position and returns you there if you fall below the map.",
    ["Anti Ragdoll"] = "Anti Ragdoll attempts to recover your character from ragdoll, physics, and falling-down states.",
    ["Anti-Fling"] = "Anti-Fling clears extreme character velocity to reduce accidental flinging.",
    ["Anti-AFK"] = "Anti-AFK sends a small local input when Roblox detects that you are idle.",
    ["Teleport Tool"] = "Open Teleport, give yourself the Banani Teleporter, equip it from your hotbar, then click a location.",
    ["Named Waypoints"] = "Save named locations per PlaceId, then select, teleport to, or delete them later.",
    ["Fullbright"] = "Fullbright increases brightness, removes most fog, and disables shadows locally.",
    ["Low Graphics"] = "Low Graphics reduces materials, particles, beams, trails, reflections, and shadows to improve performance.",
    ["Player Chams"] = "Player Chams highlights other player characters. Enable it once to reveal the extra chams settings.",
    ["NPC Highlights"] = "NPC Highlights highlights humanoid models that are not player characters.",
    ["Hitbox Visualization"] = "Hitbox Visualization outlines player root parts for debugging and visibility.",
    ["Box ESP"] = "Box ESP draws a small box around visible player characters on your screen.",
    ["Health ESP"] = "Health ESP shows a small health bar and health number near visible player characters.",
    ["Freecam"] = "Enable Freecam, use WASD to move, Q and E for down and up, and hold right-click while moving the mouse to look around.",
    ["Spectator"] = "Choose a player once, then toggle Spectate on or off without reselecting them.",
    ["Stats"] = "Stats shows the selected player's avatar, display name, username, health, team, distance, equipped tool, backpack items, age, and leaderstats.",
    ["Server Tools"] = "Server tools show the current place information and provide rejoin, copy, and server-hop actions.",
    ["Themes"] = "Choose Banana, Midnight, Purple, Ocean, Matrix, or Crimson in Settings.",
    ["Configs"] = "Enter a config name, save it, then choose it later to load or overwrite."
}

local SelectedHelpTopic = "Spider Climb"

HelpTab:CreateDropdown({
    Name = "Ask About a Feature",
    Options = {
        "Fly",
        "Noclip",
        "Spider Climb",
        "Fast Walk",
        "High Jump",
        "Infinite Jump",
        "Auto Jump",
        "Freeze",
        "Anti Void",
        "Anti Ragdoll",
        "Anti-Fling",
        "Anti-AFK",
        "Teleport Tool",
        "Named Waypoints",
        "Fullbright",
        "Low Graphics",
        "Player Chams",
        "NPC Highlights",
        "Hitbox Visualization",
        "Box ESP",
        "Health ESP",
        "Freecam",
        "Spectator",
        "Stats",
        "Server Tools",
        "Themes",
        "Configs"
    },
    CurrentOption = {"Spider Climb"},
    SearchBarEnabled = true,

    Callback = function(Option)
        SelectedHelpTopic =
            type(Option) == "table"
            and Option[1]
            or Option

        if HelpInformation then
            HelpInformation:Set({
                Title = "🍌 " .. SelectedHelpTopic,
                Content = HelpTopics[SelectedHelpTopic] or "No explanation is available."
            })
        end
    end
})

HelpInformation = HelpTab:CreateParagraph({
    Title = "🍌 Spider Climb",
    Content = HelpTopics["Spider Climb"]
})


--==============================================================
-- SERVER TAB
--==============================================================

local ServerTab = Window:CreateTab("Server", 4483362458)
ServerTab:CreateSection("Experience")

ServerTab:CreateParagraph({
    Title = CenterText(PlaceInfo.Name, 44),
    Content = "Version: " .. BANANIHUB_VERSION
})

ServerTab:CreateButton({
    Name = "🔎 Check for Updates",
    Callback = CheckForUpdates
})

ServerTab:CreateSection("🌐 Server Information")

ServerInformation = ServerTab:CreateParagraph({
    Title = "Server Information",
    Content = "Loading..."
})

ServerStatusConnection = RunService.Heartbeat:Connect(function()
    ServerInformation:Set({
        Title = "🌐 Server Information",
        Content =
            "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
            .. "\nPlace ID: " .. tostring(game.PlaceId)
            .. "\nUniverse ID: " .. tostring(game.GameId)
            .. "\nJob ID: " .. tostring(game.JobId)
    })
end)

ServerTab:CreateSection("📋 Copy Information")

ServerTab:CreateButton({
    Name = "📋 Copy Job ID",
    Callback = function()
        if setclipboard then
            setclipboard(tostring(game.JobId))
            Notify("Copied", "Job ID copied.")
        else
            Notify("Copy", "Clipboard access is unsupported.")
        end
    end
})

ServerTab:CreateButton({
    Name = "📋 Copy Place ID",
    Callback = function()
        if setclipboard then
            setclipboard(tostring(game.PlaceId))
            Notify("Copied", "Place ID copied.")
        else
            Notify("Copy", "Clipboard access is unsupported.")
        end
    end
})

ServerTab:CreateButton({
    Name = "📋 Copy Universe ID",
    Callback = function()
        if setclipboard then
            setclipboard(tostring(game.GameId))
            Notify("Copied", "Universe ID copied.")
        else
            Notify("Copy", "Clipboard access is unsupported.")
        end
    end
})

ServerTab:CreateSection("🔄 Server Actions")
ServerTab:CreateParagraph({
    Title = "Server Join Note",
    Content = "After changing servers, run BANANIHUB again from your normal loader."
})

ServerTab:CreateButton({
    Name = "🔄 Rejoin",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            game.JobId,
            Player
        )
    end
})

ServerTab:CreateButton({
    Name = "🌐 Random Server Hop",
    Callback = function()
        ServerHop("Random")
    end
})

ServerTab:CreateButton({
    Name = "👤 Small Server Hop",
    Callback = function()
        ServerHop("Smallest")
    end
})

ServerTab:CreateButton({
    Name = "👥 Join Fullest Server",
    Callback = function()
        ServerHop("Fullest")
    end
})


local SetUIBlur

local function UnloadBananiHub()
    if Unloaded then return end
    Unloaded = true

    pcall(StopFly)
    pcall(StopFreecam)
    pcall(StopSpectating)
    pcall(function() SetCameraShake(false) end)
    pcall(function() SetChams(false) end)
    pcall(function() SetNPCChams(false) end)
    pcall(function() SetHitboxes(false) end)
    pcall(function() SetLowGraphics(false) end)
    pcall(function() SetFullbright(false) end)
    pcall(function() SetAntiVoid(false) end)
    pcall(function() SetAntiRagdoll(false) end)
    pcall(function() SetSpiderClimb(false) end)

    BoxESPEnabled = false
    HealthESPEnabled = false
    pcall(SetPlayerESP)
    pcall(RemoveTeleportTool)

    NoclipEnabled = false
    AutoJumpEnabled = false
    InfiniteJumpEnabled = false
    AntiFlingEnabled = false
    AntiAFKEnabled = false
    FreezeEnabled = false
    FastWalkEnabled = false
    HighJumpEnabled = false

    pcall(UpdateMovement)
    pcall(function() SetCharacterLocked(false) end)

    local Connections = {
        FlyConnection,
        AutoJumpConnection,
        NoclipConnection,
        StatusConnection,
        ChamsConnection,
        NPCChamsConnection,
        HitboxConnection,
        FreecamConnection,
        FreecamMouseConnection,
        CameraShakeConnection,
        SpectatorConnection,
        ServerStatusConnection,
        StatsStatusConnection,
        AntiVoidConnection,
        AntiRagdollConnection,
        SpiderClimbConnection,
        ESPConnection
    }

    for _, Connection in ipairs(Connections) do
        if Connection then
            pcall(function()
                Connection:Disconnect()
            end)
        end
    end

    pcall(function()
        for _, Target in ipairs(Players:GetPlayers()) do
            RemoveESPFromCharacter(Target.Character)
        end
    end)

    pcall(function()
        ClearHighlights("BananiPlayerChams")
        ClearHighlights("BananiNPCChams")
    end)

    pcall(function()
        for _, Object in ipairs(workspace:GetDescendants()) do
            if Object.Name == "BananiHitbox"
                or Object.Name == "BananiESP"
                or Object.Name == "BananiFlyVelocity"
                or Object.Name == "BananiFlyGyro" then

                Object:Destroy()
            end
        end
    end)

    Camera.CameraType = Enum.CameraType.Custom
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default

    local H = Humanoid()
    if H then
        Camera.CameraSubject = H
    end

    -- Destroy the UI exactly once.
    local Destroyed = false

    if Rayfield and Rayfield.Destroy then
        Destroyed = pcall(function()
            Rayfield:Destroy()
        end)
    elseif Rayfield and Rayfield.Unload then
        Destroyed = pcall(function()
            Rayfield:Unload()
        end)
    end

    -- Clear only leftover UI objects after the library destroy finishes.
    task.defer(function()
        ClearOldBananiUI()

        if getgenv then
            getgenv().BANANIHUB_LOADED = nil
            getgenv().rayfieldCached = nil
        end
    end)
end



local NamedConfigFolder = "BANANIHUB/NamedConfigs"
local SelectedConfigName = ""
local SelectedConfigToLoad = nil
local ConfigDropdown

local function EnsureNamedConfigFolder()
    if makefolder and isfolder then
        if not isfolder("BANANIHUB") then
            makefolder("BANANIHUB")
        end
        if not isfolder(NamedConfigFolder) then
            makefolder(NamedConfigFolder)
        end
    end
end

local function CleanConfigName(Name)
    local Clean = tostring(Name or ""):match("^%s*(.-)%s*$")
    Clean = Clean:gsub("[^%w%-%_ ]", "")
    return Clean
end

local function GetNamedConfigs()
    EnsureNamedConfigFolder()
    local Names = {}

    if listfiles then
        local Success, Files = pcall(listfiles, NamedConfigFolder)
        if Success and type(Files) == "table" then
            for _, FilePath in ipairs(Files) do
                local Name = tostring(FilePath):match("([^/\\]+)%.json$")
                if Name then table.insert(Names, Name) end
            end
        end
    end

    table.sort(Names)
    return Names
end

local function RefreshConfigDropdown()
    if ConfigDropdown then
        ConfigDropdown:Refresh(GetNamedConfigs())
    end
end

local function PackConfigValue(Value)
    if typeof(Value) == "Color3" then
        return {
            __type = "Color3",
            R = math.floor(Value.R * 255 + 0.5),
            G = math.floor(Value.G * 255 + 0.5),
            B = math.floor(Value.B * 255 + 0.5)
        }
    end
    return Value
end

local function UnpackConfigValue(Value)
    if type(Value) == "table" and Value.__type == "Color3" then
        return Color3.fromRGB(Value.R or 255, Value.G or 255, Value.B or 255)
    end
    return Value
end

local function CaptureCurrentConfig()
    local Data = {}

    for FlagName, Flag in pairs(Rayfield.Flags or {}) do
        local Value = Flag.CurrentValue
            or Flag.CurrentKeybind
            or Flag.CurrentOption
            or Flag.Color

        if typeof(Flag.CurrentValue) == "boolean" then
            Value = Flag.CurrentValue
        end

        if Value ~= nil then
            Data[FlagName] = PackConfigValue(Value)
        end
    end

    return HttpService:JSONEncode(Data)
end

local function SaveNamedConfig(Overwrite)
    EnsureNamedConfigFolder()

    local Name = CleanConfigName(
        Overwrite and SelectedConfigToLoad or SelectedConfigName
    )

    if Name == "" then
        Notify("Configs", "Enter or select a config name first.")
        return
    end

    if not writefile then
        Notify("Configs", "Your executor does not support file saving.")
        return
    end

    writefile(
        NamedConfigFolder .. "/" .. Name .. ".json",
        CaptureCurrentConfig()
    )

    SelectedConfigToLoad = Name
    RefreshConfigDropdown()
    Notify("Configs", Overwrite and ("Overwrote " .. Name) or ("Saved " .. Name))
end

local function LoadNamedConfig()
    local Name = CleanConfigName(SelectedConfigToLoad)

    if Name == "" then
        Notify("Configs", "Select a config first.")
        return
    end

    local Path = NamedConfigFolder .. "/" .. Name .. ".json"

    if not readfile or not isfile or not isfile(Path) then
        Notify("Configs", "That config could not be found.")
        return
    end

    local Success, Data = pcall(function()
        return HttpService:JSONDecode(readfile(Path))
    end)

    if not Success or type(Data) ~= "table" then
        Notify("Configs", "That config is damaged or invalid.")
        return
    end

    for FlagName, PackedValue in pairs(Data) do
        local Flag = Rayfield.Flags and Rayfield.Flags[FlagName]
        if Flag and Flag.Set then
            pcall(function()
                Flag:Set(UnpackConfigValue(PackedValue))
            end)
        end
    end

    Notify("Configs", "Loaded " .. Name)
end


local ThemeFolder = "BANANIHUB/Themes"

local function EnsureThemeFolder()
    if not makefolder or not isfolder then return end

    if not isfolder("BANANIHUB") then
        makefolder("BANANIHUB")
    end

    if not isfolder(ThemeFolder) then
        makefolder(ThemeFolder)
    end
end

local function PackThemeColor(Color)
    return {
        R = math.floor(Color.R * 255 + 0.5),
        G = math.floor(Color.G * 255 + 0.5),
        B = math.floor(Color.B * 255 + 0.5)
    }
end

local function UnpackThemeColor(Data)
    if type(Data) ~= "table" then
        return Color3.new(1, 1, 1)
    end

    return Color3.fromRGB(
        tonumber(Data.R) or 255,
        tonumber(Data.G) or 255,
        tonumber(Data.B) or 255
    )
end

local function SerializeTheme(Theme)
    local Packed = {}

    for Key, Value in pairs(Theme) do
        if typeof(Value) == "Color3" then
            Packed[Key] = PackThemeColor(Value)
        end
    end

    return HttpService:JSONEncode(Packed)
end

local function DeserializeTheme(Data)
    local Success, Decoded = pcall(function()
        return HttpService:JSONDecode(Data)
    end)

    if not Success or type(Decoded) ~= "table" then
        return nil
    end

    local Theme = {}

    for Key, Value in pairs(Decoded) do
        Theme[Key] = UnpackThemeColor(Value)
    end

    return Theme
end

local function CleanThemeName(Name)
    local Clean = tostring(Name or ""):match("^%s*(.-)%s*$")
    Clean = Clean:gsub("[^%w%-%_ ]", "")
    return Clean
end

local function GetThemeFiles()
    EnsureThemeFolder()
    local Names = {}

    if listfiles then
        local Success, Files = pcall(listfiles, ThemeFolder)

        if Success and type(Files) == "table" then
            for _, FilePath in ipairs(Files) do
                local Name = tostring(FilePath):match("([^/\\]+)%.theme$")

                if Name then
                    table.insert(Names, Name)
                end
            end
        end
    end

    table.sort(Names)
    return Names
end

local function RefreshThemeFiles()
    if ThemeFileDropdown then
        ThemeFileDropdown:Refresh(GetThemeFiles())
    end
end

local function ApplyCustomTheme()
    if Window.ModifyTheme then
        Window.ModifyTheme(CustomTheme)
    end
end

local function ExportTheme()
    EnsureThemeFolder()

    local Name = CleanThemeName(CustomThemeName)

    if Name == "" then
        Notify("Theme Export", "Enter a theme name first.")
        return
    end

    if not writefile then
        Notify("Theme Export", "Your executor does not support file saving.")
        return
    end

    writefile(
        ThemeFolder .. "/" .. Name .. ".theme",
        SerializeTheme(CustomTheme)
    )

    SelectedThemeFile = Name
    RefreshThemeFiles()
    Notify("Theme Export", Name .. ".theme saved.")
end

local function ImportTheme()
    local Name = CleanThemeName(SelectedThemeFile)

    if Name == "" then
        Notify("Theme Import", "Select a theme first.")
        return
    end

    local Path = ThemeFolder .. "/" .. Name .. ".theme"

    if not readfile or not isfile or not isfile(Path) then
        Notify("Theme Import", "That theme file could not be found.")
        return
    end

    local Theme = DeserializeTheme(readfile(Path))

    if not Theme then
        Notify("Theme Import", "The selected theme file is invalid.")
        return
    end

    for Key, Value in pairs(Theme) do
        CustomTheme[Key] = Value
    end

    ApplyCustomTheme()
    Notify("Theme Import", Name .. ".theme loaded.")
end


--==============================================================
-- CHANGELOG TAB
--==============================================================

local ChangelogTab = Window:CreateTab("Changelog", 4483362458)
ChangelogTab:CreateSection("📜 Version History")

ChangelogTab:CreateParagraph({
    Title = "v1.0",
    Content =
        "• Added Freecam"
        .. "\n• Added Stats"
        .. "\n• Added Themes"
})

ChangelogTab:CreateParagraph({
    Title = "v1.1",
    Content =
        "• Added teleport tools and named waypoints"
        .. "\n• Added spectator tools"
        .. "\n• Added server utilities"
        .. "\n• Added player protections"
        .. "\n• Added named configs"
})

ChangelogTab:CreateParagraph({
    Title = "v1.2",
    Content =
        "• Added Theme Editor"
        .. "\n• Added theme import and export"
        .. "\n• Added built-in help"
        .. "\n• Improved unload cleanup"
})

ChangelogTab:CreateParagraph({
    Title = "v1.3",
    Content =
        "• Renamed the black theme to Default"
        .. "\n• Restored the grayish dark default colors"
        .. "\n• Removed broken game pictures"
        .. "\n• Centered one game name in Home and Server"
        .. "\n• Removed duplicate game-name displays"
})

ChangelogTab:CreateParagraph({
    Title = "v1.4",
    Content =
        "• Made Default use the gray theme immediately on startup"
        .. "\n• Fixed unloading so the UI is destroyed once"
        .. "\n• Cleared leftover BananiUI objects after unload"
        .. "\n• Fixed loading BananiHub again after unloading"
})

--==============================================================
-- SETTINGS / L KEY
--==============================================================

local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateSection("🎨 Interface Customization")
SettingsTab:CreateParagraph({
    Title = "Default Theme",
    Content = "The default theme uses a grayish dark-mode style with charcoal panels and soft gray accents."
})
local ThemeDescriptions = {
    ["Default"] = "Grayish dark mode with charcoal panels, soft gray controls, and clean white text.",
    ["🍌 Banana"] = "Dark brown and banana-yellow styling made for BANANIHUB.",
    ["🌙 Midnight"] = "Deep navy panels with cool blue highlights.",
    ["🟣 Purple"] = "Dark amethyst colors with purple accents.",
    ["🌊 Ocean"] = "Dark teal colors inspired by the ocean.",
    ["🟢 Matrix"] = "Black and neon green terminal-style colors.",
    ["🔴 Crimson"] = "Dark red panels with bright crimson highlights."
}

local ThemeDescription = SettingsTab:CreateParagraph({
    Title = "Default",
    Content = ThemeDescriptions["Default"]
})

SettingsTab:CreateDropdown({
    Name = "UI Theme",
    Flag = "Settings_Theme",
    Options = {
        "Default",
        "🍌 Banana",
        "🌙 Midnight",
        "🟣 Purple",
        "🌊 Ocean",
        "🟢 Matrix",
        "🔴 Crimson"
    },
    CurrentOption = {"Default"},

    Callback = function(Option)
        local Name =
            type(Option) == "table"
            and Option[1]
            or Option

        if ThemeDescription then
            ThemeDescription:Set({
                Title = Name,
                Content = ThemeDescriptions[Name] or "Custom theme."
            })
        end

        local Themes = {
            ["Default"] = DEFAULT_GRAY_THEME,
            ["🍌 Banana"] = {
                TextColor = Color3.fromRGB(255, 248, 214),
                Background = Color3.fromRGB(28, 24, 12),
                Topbar = Color3.fromRGB(42, 35, 14),
                Shadow = Color3.fromRGB(10, 8, 3),
                NotificationBackground = Color3.fromRGB(35, 29, 12),
                NotificationActionsBackground = Color3.fromRGB(255, 224, 72),
                TabBackground = Color3.fromRGB(55, 46, 17),
                TabStroke = Color3.fromRGB(104, 85, 20),
                TabBackgroundSelected = Color3.fromRGB(255, 218, 54),
                TabTextColor = Color3.fromRGB(255, 242, 181),
                SelectedTabTextColor = Color3.fromRGB(44, 34, 3),
                ElementBackground = Color3.fromRGB(45, 37, 14),
                ElementBackgroundHover = Color3.fromRGB(58, 48, 18),
                SecondaryElementBackground = Color3.fromRGB(37, 31, 12),
                ElementStroke = Color3.fromRGB(91, 73, 19),
                SecondaryElementStroke = Color3.fromRGB(71, 58, 17),
                SliderBackground = Color3.fromRGB(112, 89, 19),
                SliderProgress = Color3.fromRGB(255, 214, 43),
                SliderStroke = Color3.fromRGB(255, 231, 107),
                ToggleBackground = Color3.fromRGB(50, 41, 14),
                ToggleEnabled = Color3.fromRGB(255, 210, 34),
                ToggleDisabled = Color3.fromRGB(100, 89, 58),
                ToggleEnabledStroke = Color3.fromRGB(255, 231, 103),
                ToggleDisabledStroke = Color3.fromRGB(127, 113, 74),
                ToggleEnabledOuterStroke = Color3.fromRGB(177, 139, 22),
                ToggleDisabledOuterStroke = Color3.fromRGB(75, 65, 38),
                DropdownSelected = Color3.fromRGB(67, 55, 18),
                DropdownUnselected = Color3.fromRGB(45, 37, 14),
                InputBackground = Color3.fromRGB(41, 34, 13),
                InputStroke = Color3.fromRGB(100, 82, 20),
                PlaceholderColor = Color3.fromRGB(191, 169, 93)
            },

            ["🌙 Midnight"] = {
                TextColor = Color3.fromRGB(235, 240, 255),
                Background = Color3.fromRGB(15, 18, 28),
                Topbar = Color3.fromRGB(22, 27, 42),
                Shadow = Color3.fromRGB(5, 7, 12),
                NotificationBackground = Color3.fromRGB(19, 23, 36),
                NotificationActionsBackground = Color3.fromRGB(110, 130, 255),
                TabBackground = Color3.fromRGB(28, 34, 52),
                TabStroke = Color3.fromRGB(55, 67, 100),
                TabBackgroundSelected = Color3.fromRGB(92, 110, 210),
                TabTextColor = Color3.fromRGB(210, 220, 255),
                SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
                ElementBackground = Color3.fromRGB(24, 29, 44),
                ElementBackgroundHover = Color3.fromRGB(33, 40, 60),
                SecondaryElementBackground = Color3.fromRGB(20, 24, 37),
                ElementStroke = Color3.fromRGB(48, 58, 87),
                SecondaryElementStroke = Color3.fromRGB(39, 47, 71),
                SliderBackground = Color3.fromRGB(52, 66, 120),
                SliderProgress = Color3.fromRGB(102, 126, 255),
                SliderStroke = Color3.fromRGB(145, 163, 255),
                ToggleBackground = Color3.fromRGB(27, 33, 51),
                ToggleEnabled = Color3.fromRGB(95, 120, 255),
                ToggleDisabled = Color3.fromRGB(75, 82, 101),
                ToggleEnabledStroke = Color3.fromRGB(130, 150, 255),
                ToggleDisabledStroke = Color3.fromRGB(100, 108, 130),
                ToggleEnabledOuterStroke = Color3.fromRGB(70, 88, 190),
                ToggleDisabledOuterStroke = Color3.fromRGB(55, 62, 80),
                DropdownSelected = Color3.fromRGB(35, 43, 67),
                DropdownUnselected = Color3.fromRGB(24, 29, 44),
                InputBackground = Color3.fromRGB(22, 27, 42),
                InputStroke = Color3.fromRGB(57, 69, 103),
                PlaceholderColor = Color3.fromRGB(145, 155, 190)
            },

            ["🟣 Purple"] = "Amethyst",
            ["🌊 Ocean"] = "Ocean",

            ["🟢 Matrix"] = {
                TextColor = Color3.fromRGB(205, 255, 210),
                Background = Color3.fromRGB(7, 20, 10),
                Topbar = Color3.fromRGB(10, 30, 15),
                Shadow = Color3.fromRGB(1, 7, 2),
                NotificationBackground = Color3.fromRGB(8, 25, 12),
                NotificationActionsBackground = Color3.fromRGB(45, 255, 95),
                TabBackground = Color3.fromRGB(12, 38, 19),
                TabStroke = Color3.fromRGB(27, 92, 43),
                TabBackgroundSelected = Color3.fromRGB(44, 230, 88),
                TabTextColor = Color3.fromRGB(180, 255, 195),
                SelectedTabTextColor = Color3.fromRGB(3, 25, 8),
                ElementBackground = Color3.fromRGB(10, 31, 15),
                ElementBackgroundHover = Color3.fromRGB(14, 44, 21),
                SecondaryElementBackground = Color3.fromRGB(8, 25, 12),
                ElementStroke = Color3.fromRGB(23, 78, 36),
                SecondaryElementStroke = Color3.fromRGB(18, 61, 29),
                SliderBackground = Color3.fromRGB(23, 95, 42),
                SliderProgress = Color3.fromRGB(38, 235, 83),
                SliderStroke = Color3.fromRGB(97, 255, 130),
                ToggleBackground = Color3.fromRGB(12, 35, 18),
                ToggleEnabled = Color3.fromRGB(32, 230, 76),
                ToggleDisabled = Color3.fromRGB(65, 95, 71),
                ToggleEnabledStroke = Color3.fromRGB(82, 255, 117),
                ToggleDisabledStroke = Color3.fromRGB(90, 120, 95),
                ToggleEnabledOuterStroke = Color3.fromRGB(18, 135, 48),
                ToggleDisabledOuterStroke = Color3.fromRGB(45, 67, 50),
                DropdownSelected = Color3.fromRGB(15, 48, 23),
                DropdownUnselected = Color3.fromRGB(10, 31, 15),
                InputBackground = Color3.fromRGB(9, 27, 13),
                InputStroke = Color3.fromRGB(24, 85, 38),
                PlaceholderColor = Color3.fromRGB(115, 170, 125)
            },

            ["🔴 Crimson"] = {
                TextColor = Color3.fromRGB(255, 232, 232),
                Background = Color3.fromRGB(30, 9, 12),
                Topbar = Color3.fromRGB(44, 12, 16),
                Shadow = Color3.fromRGB(10, 2, 3),
                NotificationBackground = Color3.fromRGB(38, 10, 14),
                NotificationActionsBackground = Color3.fromRGB(255, 75, 90),
                TabBackground = Color3.fromRGB(55, 15, 21),
                TabStroke = Color3.fromRGB(110, 30, 41),
                TabBackgroundSelected = Color3.fromRGB(235, 55, 72),
                TabTextColor = Color3.fromRGB(255, 205, 210),
                SelectedTabTextColor = Color3.fromRGB(45, 3, 8),
                ElementBackground = Color3.fromRGB(46, 12, 17),
                ElementBackgroundHover = Color3.fromRGB(62, 17, 23),
                SecondaryElementBackground = Color3.fromRGB(37, 10, 14),
                ElementStroke = Color3.fromRGB(92, 25, 35),
                SecondaryElementStroke = Color3.fromRGB(73, 20, 28),
                SliderBackground = Color3.fromRGB(115, 28, 42),
                SliderProgress = Color3.fromRGB(242, 58, 78),
                SliderStroke = Color3.fromRGB(255, 110, 125),
                ToggleBackground = Color3.fromRGB(50, 13, 19),
                ToggleEnabled = Color3.fromRGB(235, 50, 72),
                ToggleDisabled = Color3.fromRGB(105, 72, 78),
                ToggleEnabledStroke = Color3.fromRGB(255, 95, 112),
                ToggleDisabledStroke = Color3.fromRGB(135, 95, 102),
                ToggleEnabledOuterStroke = Color3.fromRGB(170, 35, 52),
                ToggleDisabledOuterStroke = Color3.fromRGB(75, 53, 59),
                DropdownSelected = Color3.fromRGB(70, 19, 27),
                DropdownUnselected = Color3.fromRGB(46, 12, 17),
                InputBackground = Color3.fromRGB(41, 11, 15),
                InputStroke = Color3.fromRGB(102, 27, 38),
                PlaceholderColor = Color3.fromRGB(190, 125, 135)
            }
        }

        local Theme = Themes[Name]

        if Window.ModifyTheme and Theme then
            Window.ModifyTheme(Theme)
        end
    end
})

SettingsTab:CreateSection("🎨 Theme Editor")

SettingsTab:CreateInput({
    Name = "Theme Name",
    PlaceholderText = "Example: Banana",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        CustomThemeName = Text
    end
})

SettingsTab:CreateColorPicker({
    Name = "Background",
    Color = CustomTheme.Background,
    Callback = function(Color)
        CustomTheme.Background = Color
        ApplyCustomTheme()
    end
})

SettingsTab:CreateColorPicker({
    Name = "Topbar",
    Color = CustomTheme.Topbar,
    Callback = function(Color)
        CustomTheme.Topbar = Color
        ApplyCustomTheme()
    end
})

SettingsTab:CreateColorPicker({
    Name = "Accent",
    Color = CustomTheme.ToggleEnabled,
    Callback = function(Color)
        CustomTheme.ToggleEnabled = Color
        CustomTheme.ToggleEnabledStroke = Color
        CustomTheme.ToggleEnabledOuterStroke = Color
        CustomTheme.SliderProgress = Color
        CustomTheme.SliderStroke = Color
        CustomTheme.TabBackgroundSelected = Color
        ApplyCustomTheme()
    end
})

SettingsTab:CreateColorPicker({
    Name = "Buttons",
    Color = CustomTheme.ElementBackground,
    Callback = function(Color)
        CustomTheme.ElementBackground = Color
        CustomTheme.ElementBackgroundHover = Color:Lerp(
            Color3.new(1, 1, 1),
            0.08
        )
        CustomTheme.SecondaryElementBackground = Color:Lerp(
            Color3.new(0, 0, 0),
            0.12
        )
        ApplyCustomTheme()
    end
})

SettingsTab:CreateColorPicker({
    Name = "Text",
    Color = CustomTheme.TextColor,
    Callback = function(Color)
        CustomTheme.TextColor = Color
        CustomTheme.TabTextColor = Color
        ApplyCustomTheme()
    end
})

SettingsTab:CreateColorPicker({
    Name = "Strokes",
    Color = CustomTheme.ElementStroke,
    Callback = function(Color)
        CustomTheme.ElementStroke = Color
        CustomTheme.SecondaryElementStroke = Color
        CustomTheme.TabStroke = Color
        CustomTheme.InputStroke = Color
        ApplyCustomTheme()
    end
})

SettingsTab:CreateButton({
    Name = "Apply Custom Theme",
    Callback = ApplyCustomTheme
})

SettingsTab:CreateSection("📂 Theme Import / Export")

SettingsTab:CreateButton({
    Name = "Export Theme",
    Callback = ExportTheme
})

ThemeFileDropdown = SettingsTab:CreateDropdown({
    Name = "Saved Theme Files",
    Options = GetThemeFiles(),
    CurrentOption = {},
    SearchBarEnabled = true,
    Callback = function(Option)
        SelectedThemeFile =
            type(Option) == "table"
            and Option[1]
            or Option
    end
})

SettingsTab:CreateButton({
    Name = "Import Selected Theme",
    Callback = ImportTheme
})

SettingsTab:CreateSection("💾 Named Configs")
SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Example: Grinding",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        SelectedConfigName = Text
    end
})

ConfigDropdown = SettingsTab:CreateDropdown({
    Name = "Saved Configs",
    Options = GetNamedConfigs(),
    CurrentOption = {},
    SearchBarEnabled = true,
    Callback = function(Option)
        SelectedConfigToLoad =
            type(Option) == "table"
            and Option[1]
            or Option
    end
})

SettingsTab:CreateButton({
    Name = "💾 Save New Config",
    Callback = function()
        SaveNamedConfig(false)
    end
})
SettingsTab:CreateButton({
    Name = "📂 Load Selected Config",
    Callback = LoadNamedConfig
})
SettingsTab:CreateButton({
    Name = "♻️ Overwrite Selected Config",
    Callback = function()
        SaveNamedConfig(true)
    end
})

SettingsTab:CreateSection("⌨️ Controls")
SettingsTab:CreateKeybind({
    Name = "Open / Close UI",
    CurrentKeybind = "L",
    HoldToInteract = false,
    Flag = "Settings_UIKeybind",
    Callback = function(Key)
        if typeof(Key) == "EnumItem" then
            UIToggleKey = Key
        elseif type(Key) == "string" and Enum.KeyCode[Key] then
            UIToggleKey = Enum.KeyCode[Key]
        end
    end
})
SettingsTab:CreateParagraph({
    Title = "Controls",
    Content = "Use the keybind above to open or close 🍌 BANANIHUB 🍌."
})
SettingsTab:CreateButton({
    Name = "🔔 Test Notification",
    Callback = function()
        Notify("🍌 BANANIHUB 🍌", "Everything is working!")
    end
})

SettingsTab:CreateSection("🧹 Script Management")
SettingsTab:CreateButton({
    Name = "🗑️ Unload 🍌 BANANIHUB 🍌",
    Callback = UnloadBananiHub
})

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    if Input.KeyCode == UIToggleKey and Rayfield.ToggleUI then Rayfield:ToggleUI() end
end)

--==============================================================
-- CHARACTER RESPAWN
--==============================================================

Player.CharacterAdded:Connect(function()
    task.wait(1)
    UpdateMovement()
end)

RefreshPlayers()
RefreshWaypoints()
