--========================================================--
-- W2 — BASE SKELETON v1.5 FIXED
-- Judul "W2" | Logo + Banner + Notify pakai ID Bombax
--========================================================--

getgenv().W2 = getgenv().W2 or {}
local W = getgenv()

W2.NotifyEnabled = W2.NotifyEnabled ~= false

_G.W2_ACCENT    = Color3.fromRGB(255, 255, 255)
_G.W2_ACCENT_BG = Color3.fromRGB(0, 0, 0)
_G.W2_NEUTRAL   = Color3.fromRGB(90, 90, 90)
_G.W2_STROKE_OFF= Color3.fromRGB(25, 25, 25)
_G.W2_BG_OFF    = Color3.fromRGB(0, 0, 0)

local function __W2_Init__()
    local Players           = game:GetService("Players")
    local RunService        = game:GetService("RunService")
    local UserInputService  = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace         = game:GetService("Workspace")
    local CoreGui           = game:GetService("CoreGui")
    local CollectionService = game:GetService("CollectionService")
    local TweenService      = game:GetService("TweenService")
    local GuiService        = game:GetService("GuiService")
    local HttpService       = game:GetService("HttpService")
    local Lighting          = game:GetService("Lighting")
    local LP                = Players.LocalPlayer
    local isMobile          = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local VIM = nil
    pcall(function() VIM = game:GetService("VirtualInputManager") end)

    W.Players           = Players
    W.RunService        = RunService
    W.UserInputService  = UserInputService
    W.ReplicatedStorage = ReplicatedStorage
    W.Workspace         = Workspace
    W.CoreGui           = CoreGui
    W.CollectionService = CollectionService
    W.TweenService      = TweenService
    W.GuiService        = GuiService
    W.HttpService       = HttpService
    W.Lighting          = Lighting
    W.LP                = LP
    W.isMobile          = isMobile
    W.VIM               = VIM

    local UILib
    local ok, err = pcall(function()
        UILib = loadstring(game:HttpGet("https://glutofree.vercel.app/library"))()
    end)
    if not ok or not UILib then
        warn("[W2] UILib gagal load:", err)
        return
    end
    W.UILib = UILib

    do
        local function Fix(inst)
            if not inst then return end
            if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
                local t = inst.Text
                if t and (t:find("Gluto Windows", 1, true) or t:find("Gluto Window", 1, true)) then
                    pcall(function()
                        inst.Text = t:gsub("Gluto Windows", "Close"):gsub("Gluto Window", "Close")
                    end)
                end
            end
        end
        local function Scan(c)
            if not c then return end
            for _, d in ipairs(c:GetDescendants()) do Fix(d) end
            c.DescendantAdded:Connect(Fix)
        end
        Scan(CoreGui)
        if gethui then local ok2, hui = pcall(gethui); if ok2 and hui then Scan(hui) end end
        Scan(LP:FindFirstChild("PlayerGui"))
    end

    local NotifyColor = Color3.fromRGB(255, 255, 255)
    local function ShowNotify(title, msg, dur)
        if not W2.NotifyEnabled then return end
        if not UILib or not UILib.MakeNotify then return end
        pcall(function()
            UILib:MakeNotify({
                Title = title or "W2",
                Description = "Info",
                Content = msg or "",
                Color = NotifyColor,
                Time = 0.4,
                Delay = dur or 2,
                Icon = "138040631725974"
            })
        end)
    end
    W.Notify       = ShowNotify
    W.W2_Notify    = ShowNotify
    W.ForceNotify  = ShowNotify

    local function TeamIs(plr, role)
        if not plr or not plr.Team or not plr.Team.Name then return false end
        local tn = string.lower(plr.Team.Name)
        if role == "Killer"   then return tn:find("killer",   1, true) ~= nil end
        if role == "Survivor" then return tn:find("survivor", 1, true) ~= nil end
        return false
    end
    W.TeamIs = TeamIs

    local function GetRole()
        if TeamIs(LP, "Killer")   then return "Killer"   end
        if TeamIs(LP, "Survivor") then return "Survivor" end
        return nil
    end
    W.GetRole = GetRole

    W.GB_GetAllGenerators = function()
        local gens = {}
        local mf = Workspace:FindFirstChild("Map")
        if not mf then return gens end
        for _, obj in ipairs(mf:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == "Generator" then
                if obj:GetAttribute("RepairProgress")
                   or obj:GetAttribute("kickcount")
                   or obj:GetAttribute("ProgressRepair") then
                    table.insert(gens, obj)
                end
            end
        end
        return gens
    end
    W.GB_GetPoints = function(m)
        local pts = {}
        if not m then return pts end
        for _, o in ipairs(m:GetChildren()) do
            if o:IsA("BasePart") and o.Name:find("GeneratorPoint") then
                table.insert(pts, o)
            end
        end
        return pts
    end

    local uiOK, uiErr = pcall(function()
        -- ⭐ Title "W2", Logo + Banner pakai ID Bombax
        local Window = UILib:Window({
            Title          = "W2",
            LogoButtonSize = 52,
            Image          = "138040631725974",
            Footer         = "Free Script",
            Color          = NotifyColor,
            ShowInfo       = true,
            Search         = true,
        })
        W.Window = Window

        Window:InfoTab({
            Name         = "Information",
            Icon         = "lightbulb",
            SectionTitle = "Information",
            Banner       = "rbxassetid://138040631725974",
            Cards = {
                { Title = "⚠️ INFO", Description = "Script ini GRATIS!\n\n❌ JANGAN DIJUAL\n\nYang jual = SCAMMER!" }
            }
        })

        W.T_Surv  = Window:AddTab({ Name = "Survivor",  Icon = "user"         })
        W.T_Vis   = Window:AddTab({ Name = "Visuals",   Icon = "eye"          })
        W.T_Kill  = Window:AddTab({ Name = "Killer",    Icon = "crosshair"    })
        W.T_Misc  = Window:AddTab({ Name = "Misc",      Icon = "settings-2"   })
        W.T_Troll = Window:AddTab({ Name = "Troll",     Icon = "ghost"        })
        W.T_Cfg   = Window:AddTab({ Name = "Config",    Icon = "save"         })
    end)

    if not uiOK then warn("[W2] UI Error:", uiErr) end

    -- ⬇️ PART 2-16 DISISIPKAN DI SINI ⬇️--====================================================--
-- PART 2 FIXED: SURVIVOR — Self Heal, Swift Vault, Pallet Reflex, Fake Perks
-- Fake Perks pakai Cooldown 40s (kaya aslinya)
--====================================================--

function W.HealSelf(v)
    local c = LP.Character
    if not c then return end
    local ev = ReplicatedStorage.Remotes.Healing.HealEvent
    local hp = c:FindFirstChild("HumanoidRootPart")
    if not hp then return end
    pcall(function() ev:FireServer(hp, v) end)
end
function W.HealOther(p, v)
    if not p or not p.Character then return end
    local hp = p.Character:FindFirstChild("HumanoidRootPart")
    if not hp then return end
    local ev = ReplicatedStorage.Remotes.Healing.HealEvent
    pcall(function() ev:FireServer(hp, v) end)
end

W2.SelfHeal_Enabled = W2.SelfHeal_Enabled or false
W2.SelfHeal_AutoAll = W2.SelfHeal_AutoAll or false
W.SelfHeal_BlockedAnim = "95836365038528"

function W.setSelfHeal(v)
    W2.SelfHeal_Enabled = v
    if W._SelfHealConn then W._SelfHealConn:Disconnect(); W._SelfHealConn = nil end
    if v then
        W._SelfHealConn = RunService.Heartbeat:Connect(function()
            if not W2.SelfHeal_Enabled then return end
            local c = LP.Character
            if not c then return end
            local h = c:FindFirstChildOfClass("Humanoid")
            if not h then return end
            local a = h:FindFirstChildOfClass("Animator")
            if not a then return end
            local ok2, tracks = pcall(function() return a:GetPlayingAnimationTracks() end)
            if not ok2 then return end
            for _, t in ipairs(tracks) do
                local aid = t.Animation and t.Animation.AnimationId or ""
                if aid:match("%d+") == W.SelfHeal_BlockedAnim then
                    pcall(function() t:Stop(0) end)
                end
            end
        end)
        local ha = false
        if W._SelfHealLoop then W._SelfHealLoop:Disconnect() end
        W._SelfHealLoop = RunService.Heartbeat:Connect(function()
            if not W2.SelfHeal_Enabled then return end
            local c = LP.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if not h then return end
            if h.Health >= h.MaxHealth * 0.9 then
                if ha then ha = false; W.HealSelf(false) end
                return
            end
            if ha then
                local ci = c:FindFirstChild("CheckInterractable")
                if ci and not ci:GetAttribute("isHealing") then ha = false end
            end
            if not ha then ha = true; W.HealSelf(true) end
        end)
    else
        if W._SelfHealLoop then W._SelfHealLoop:Disconnect(); W._SelfHealLoop = nil end
        pcall(function() W.HealSelf(false) end)
    end
end

function W.setAutoHealAll(v)
    W2.SelfHeal_AutoAll = v
    if W._AutoHealLoop then W._AutoHealLoop:Disconnect(); W._AutoHealLoop = nil end
    if v then
        local ah = {}
        W._AutoHealLoop = RunService.Heartbeat:Connect(function()
            if not W2.SelfHeal_AutoAll then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local hu = p.Character:FindFirstChildOfClass("Humanoid")
                    if hu and hu.Health > 0 and hu.Health < hu.MaxHealth * 0.9 then
                        if not ah[p] then ah[p] = true; W.HealOther(p, true) end
                    else
                        if ah[p] then ah[p] = nil; W.HealOther(p, false) end
                    end
                end
            end
        end)
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if W2.SelfHeal_Enabled then W.setSelfHeal(true) end
    if W2.SelfHeal_AutoAll then W.setAutoHealAll(true) end
end)

-- === SWIFT VAULT ===
W2.SwiftVault_Enabled = W2.SwiftVault_Enabled or false
W2.SwiftVault_V2      = W2.SwiftVault_V2      or false
W2.SwiftVault_Speed   = W2.SwiftVault_Speed   or 13

do
    local _vaulted = {}
    local _lastScan = 0

    local function BuildGroups()
        local g = {}
        local map = Workspace:FindFirstChild("Map")
        if not map then return g end
        local seen = {}
        for _, o in ipairs(map:GetDescendants()) do
            if o:IsA("BasePart") and (o.Name == "VaultTrigger" or o.Name == "VaultPoint") then
                if not seen[o] then
                    seen[o] = true
                    local root = o.Parent
                    if o.Name == "VaultPoint" and o.Parent and o.Parent.Name == "VaultTrigger" then
                        root = o.Parent.Parent
                    elseif o.Name == "VaultTrigger" then
                        root = o.Parent
                    end
                    if root then
                        g[root] = g[root] or {}
                        table.insert(g[root], o)
                    end
                end
            end
        end
        return g
    end

    RunService.Heartbeat:Connect(function()
        if W2.SwiftVault_V2 then
            pcall(function()
                local c = LP.Character
                if c then c:SetAttribute("vaultspeed", (W2.SwiftVault_Speed or 13) / 10) end
            end)
        end
    end)

    RunService.Heartbeat:Connect(function()
        if not W2.SwiftVault_Enabled then return end
        if GetRole() ~= "Survivor" then return end
        if tick() - _lastScan < 0.15 then return end
        _lastScan = tick()
        pcall(function()
            local c = LP.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if not root or not h or h.Health <= 0 then return end
            if root.AssemblyLinearVelocity.Magnitude < 1 then return end
            for rw in pairs(BuildGroups()) do
                local allVT = {}
                for _, ch in ipairs(rw:GetChildren()) do
                    if ch.Name == "VaultTrigger" then table.insert(allVT, ch) end
                end
                if #allVT == 0 then continue end
                local near, nd = nil, math.huge
                for _, vt in ipairs(allVT) do
                    local pos = vt:IsA("BasePart") and vt.Position or (vt.PrimaryPart and vt.PrimaryPart.Position)
                    if pos then
                        local d = (root.Position - pos).Magnitude
                        if d < nd then nd = d; near = vt end
                    end
                end
                if not near or nd > 6 then continue end
                if tick() - (_vaulted[rw] or 0) < 3 then continue end
                local rf = ReplicatedStorage:FindFirstChild("Remotes")
                local wf = rf and rf:FindFirstChild("Window")
                if wf then
                    pcall(function() wf:FindFirstChild("VaultEvent"):FireServer(near, true) end)
                    pcall(function() wf:FindFirstChild("Vaultbindable"):Fire(near, true) end)
                    pcall(function() wf:FindFirstChild("fastvault"):FireServer(LP) end)
                    pcall(function() wf:FindFirstChild("VaultCompleteEventpart1"):FireServer() end)
                    pcall(function() wf:FindFirstChild("VaultCompleteEvent"):FireServer(near, false) end)
                end
                _vaulted[rw] = tick()
                break
            end
        end)
    end)

    LP.CharacterAdded:Connect(function() task.wait(0.5); _vaulted = {} end)

    function W.SwiftVault_Set(v) W2.SwiftVault_Enabled = v and true or false; _vaulted = {} end
    function W.SwiftVaultV2_Set(v)
        W2.SwiftVault_V2 = v and true or false
        if not v then
            local c = LP.Character
            if c then pcall(function() c:SetAttribute("vaultspeed", 1) end) end
        end
    end
    function W.SwiftVault_SetSpeed(v) W2.SwiftVault_Speed = tonumber(v) or 13 end
end

-- === PALLET REFLEX ===
W2.PalletReflex_Enabled = W2.PalletReflex_Enabled or false
W2.PalletReflex_Dist    = W2.PalletReflex_Dist    or 20

do
    local _lastDrop = 0
    local _used = {}

    local function GetKillerRoot()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and TeamIs(p, "Killer") and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then return hrp end
            end
        end
        return nil
    end

    local _lastScan = 0
    RunService.Heartbeat:Connect(function()
        if not W2.PalletReflex_Enabled then return end
        if GetRole() ~= "Survivor" then return end
        local now = tick()
        if now - _lastScan < 0.2 then return end
        _lastScan = now
        if now - _lastDrop < 2.5 then return end
        pcall(function()
            local c = LP.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if not root or not h or h.Health <= 0 then return end
            local kr = GetKillerRoot()
            if not kr then return end
            if (root.Position - kr.Position).Magnitude > (W2.PalletReflex_Dist or 20) then return end
            local rf = ReplicatedStorage:FindFirstChild("Remotes")
            local pf = rf and rf:FindFirstChild("Pallet")
            local drop = pf and pf:FindFirstChild("PalletDropEvent")
            if not drop then return end
            local map = Workspace:FindFirstChild("Map")
            if not map then return end
            local best, bd = nil, 8
            for _, obj in ipairs(map:GetDescendants()) do
                if obj.Name == "Palletwrong" and (obj:IsA("Model") or obj:IsA("Folder")) and not _used[obj] then
                    local ref = obj:FindFirstChild("PalletPointSlide") or obj:FindFirstChild("PalletPoint") or obj:FindFirstChildWhichIsA("BasePart", true)
                    if ref then
                        local d = (root.Position - ref.Position).Magnitude
                        if d < bd then bd = d; best = obj end
                    end
                end
            end
            if best then
                local tgt = best:FindFirstChild("PalletPointSlide") or best:FindFirstChild("PalletPoint")
                if tgt then
                    pcall(function() drop:FireServer(tgt) end)
                    _used[best] = true
                    _lastDrop = tick()
                end
            end
        end)
    end)

    LP.CharacterAdded:Connect(function() task.wait(0.5); _used = {} end)
    function W.PalletReflex_Set(v) W2.PalletReflex_Enabled = v and true or false; _used = {} end
    function W.PalletReflex_SetDist(v) W2.PalletReflex_Dist = tonumber(v) or 20 end
end

-- === FAKE PERKS (Cooldown 40s seperti aslinya) ===
W.FP = W.FP or { ActiveBuffs = {}, Conns = {}, LastBuffTime = {}, CooldownTime = 40 }
local FP = W.FP
if not FP.LastBuffTime then FP.LastBuffTime = {} end

local function FP_Char() return LP.Character end
local function FP_Hum() local c = FP_Char(); return c and c:FindFirstChildOfClass("Humanoid") end
local function FP_Total()
    local t = 0
    for _, b in pairs(FP.ActiveBuffs) do if tick() < b.endTime then t = t + b.amt end end
    return t
end
local function FP_Apply()
    local c = FP_Char(); local tb = FP_Total(); local h = FP_Hum()
    if c then c:SetAttribute("speedboost", tb > 0 and (1 + tb/14) or 1) end
    if h and tb > 0 then h.WalkSpeed = 16 + tb end
end
local function FP_HB()
    if FP.HB then return end
    FP.HB = RunService.Heartbeat:Connect(function()
        local exp = {}
        for n, b in pairs(FP.ActiveBuffs) do if tick() >= b.endTime then table.insert(exp, n) end end
        for _, n in ipairs(exp) do FP.ActiveBuffs[n] = nil end
        FP_Apply()
        if FP_Total() <= 0 and not next(FP.ActiveBuffs) then
            if FP.HB then FP.HB:Disconnect(); FP.HB = nil end
            local c = FP_Char(); if c then c:SetAttribute("speedboost", 1) end
            local h = FP_Hum(); if h then h.WalkSpeed = 16 end
        end
    end)
end

-- ⭐ Cooldown 40s per-buff
local function FP_Buff(name, amt, dur)
    if FP.ActiveBuffs[name] then return end
    FP.LastBuffTime = FP.LastBuffTime or {}
    local now = tick()
    local lastTime = FP.LastBuffTime[name] or 0
    local cdTime = tonumber(FP.CooldownTime) or 40
    if now - lastTime < cdTime then return end
    FP.LastBuffTime[name] = now
    FP.ActiveBuffs[name] = { amt = amt, endTime = now + (dur or 3), duration = dur or 3 }
    FP_Apply(); FP_HB()
    W.W2_Notify("Fake Perks", name .. " +" .. amt .. " (CD 40s)", 3)
end

local function FP_Clean(name)
    if FP.Conns[name] then for _, c in ipairs(FP.Conns[name]) do pcall(function() c:Disconnect() end) end FP.Conns[name] = nil end
end
local function FP_Reg(name, conn)
    FP.Conns[name] = FP.Conns[name] or {}
    table.insert(FP.Conns[name], conn)
end

-- FLOWSTATE (+5 speed, 3s, CD 40s)
function W.FP_Flowstate(v)
    FP.FlowstateOn = v
    local c = FP_Char()
    if c then c:SetAttribute("Flowstate", v) end
    if v then
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        local w = r and r:FindFirstChild("Window")
        local p = r and r:FindFirstChild("Pallet")
        local function on()
            if FP.FlowstateOn then
                task.delay(0.5, function()
                    if FP.FlowstateOn then FP_Buff("Flowstate", 5, 3) end
                end)
            end
        end
        if w then
            local vb = w:FindFirstChild("Vaultbindable")
            if vb and vb:IsA("BindableEvent") then FP_Reg("Flowstate", vb.Event:Connect(on)) end
        end
        if p then
            local sb = p:FindFirstChild("Slidebindable")
            if sb and sb:IsA("BindableEvent") then FP_Reg("Flowstate", sb.Event:Connect(on)) end
        end
    else
        FP_Clean("Flowstate"); FP.ActiveBuffs["Flowstate"] = nil
        local c2 = FP_Char(); if c2 then c2:SetAttribute("Flowstate", false) end
    end
end

-- QUICK RECOVERY (+6 speed, 3s, CD 40s)
function W.FP_QuickRec(v)
    FP.QuickRecOn = v
    if v then
        local function on()
            if FP.QuickRecOn then FP_Buff("QuickRecovery", 6, 3) end
        end
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        local hf = r and r:FindFirstChild("Healing")
        if hf then
            local hd = hf:FindFirstChild("Healdone")
            if hd and hd:IsA("BindableEvent") then
                FP_Reg("QuickRecovery", hd.Event:Connect(on))
            end
        end
    else
        FP_Clean("QuickRecovery"); FP.ActiveBuffs["QuickRecovery"] = nil
    end
end

-- PERFECT LANDING (+8 speed, 3s, CD 40s)
function W.FP_PerfLand(v)
    FP.PerfLandOn = v
    if v then
        local function hook(c)
            if not c then return end
            local h = c:FindFirstChildOfClass("Humanoid")
            if not h then return end
            local wf, fs = false, 0
            FP_Reg("PerfectLanding", h.StateChanged:Connect(function(_, n)
                if not FP.PerfLandOn then return end
                if n == Enum.HumanoidStateType.Freefall then wf = true; fs = tick() end
                if wf and (n == Enum.HumanoidStateType.Landed or n == Enum.HumanoidStateType.Running) then
                    local ft = tick() - fs; wf = false
                    if ft >= 0.25 then FP_Buff("PerfectLanding", 8, 3) end
                end
            end))
        end
        hook(LP.Character)
        FP_Reg("PerfectLanding", LP.CharacterAdded:Connect(hook))
    else
        FP_Clean("PerfectLanding"); FP.ActiveBuffs["PerfectLanding"] = nil
    end
end

-- ADRENALINE RUSH (+4 speed, 5s, CD 40s)
function W.FP_Adrenaline(v)
    FP.AdrenalineOn = v
    if v then
        local function hook(c)
            if not c then return end
            local h = c:FindFirstChildOfClass("Humanoid")
            if not h then return end
            local lh = h.Health
            FP_Reg("AdrenalineRush", h.HealthChanged:Connect(function(nh)
                if not FP.AdrenalineOn then return end
                if nh < lh and nh <= 50 and nh > 0 then FP_Buff("AdrenalineRush", 4, 5) end
                lh = nh
            end))
        end
        hook(LP.Character)
        FP_Reg("AdrenalineRush", LP.CharacterAdded:Connect(hook))
    else
        FP_Clean("AdrenalineRush"); FP.ActiveBuffs["AdrenalineRush"] = nil
    end
end

-- === UI SECTION: SURVIVOR PART 1 ===
do
    local s = W.T_Surv:AddSection("Self Heal")
    s:AddToggle({ Title = "Enable Self Heal", Default = false, Callback = function(v)
        W.setSelfHeal(v)
        W.W2_Notify("Self Heal", v and "Enabled" or "Disabled", 2)
    end })
    s:AddToggle({ Title = "Auto Heal All", Default = false, Callback = function(v)
        W.setAutoHealAll(v)
        W.W2_Notify("Auto Heal All", v and "Enabled" or "Disabled", 2)
    end })

    local s2 = W.T_Surv:AddSection("Swift Vault")
    s2:AddToggle({ Title = "Swift Vault", Default = false, Callback = function(v)
        W.SwiftVault_Set(v)
        W.W2_Notify("Swift Vault", v and "Enabled" or "Disabled", 2)
    end })
    s2:AddToggle({ Title = "Swift Vault V2", Default = false, Callback = function(v)
        W.SwiftVaultV2_Set(v)
        W.W2_Notify("Swift Vault V2", v and "Enabled" or "Disabled", 2)
    end })
    s2:AddSlider({ Title = "Vault Speed", Min = 10, Max = 20, Default = 13, Increment = 1,
        Callback = function(v) W.SwiftVault_SetSpeed(v) end })

    local s3 = W.T_Surv:AddSection("Pallet Reflex")
    s3:AddToggle({ Title = "Enable Pallet Reflex", Default = false, Callback = function(v)
        W.PalletReflex_Set(v)
        W.W2_Notify("Pallet Reflex", v and "Enabled" or "Disabled", 2)
    end })
    s3:AddSlider({ Title = "Distance", Min = 5, Max = 50, Default = 20, Increment = 1, Suffix = " studs",
        Callback = function(v) W.PalletReflex_SetDist(v) end })

    local s4 = W.T_Surv:AddSection("Fake Perks")
    s4:AddToggle({ Title = "Flowstate", Default = false, Callback = function(v)
        W.FP_Flowstate(v)
        if v then W.W2_Notify("Fake Perks", "Flowstate ON (CD 40s)", 2) end
    end })
    s4:AddToggle({ Title = "Quick Recovery", Default = false, Callback = function(v)
        W.FP_QuickRec(v)
        if v then W.W2_Notify("Fake Perks", "Quick Recovery ON (CD 40s)", 2) end
    end })
    s4:AddToggle({ Title = "Perfect Landing", Default = false, Callback = function(v)
        W.FP_PerfLand(v)
        if v then W.W2_Notify("Fake Perks", "Perfect Landing ON (CD 40s)", 2) end
    end })
    s4:AddToggle({ Title = "Adrenaline Rush", Default = false, Callback = function(v)
        W.FP_Adrenaline(v)
        if v then W.W2_Notify("Fake Perks", "Adrenaline ON (CD 40s)", 2) end
    end })
    s4:AddSlider({ Title = "Perk Cooldown", Min = 0, Max = 120, Default = 40, Increment = 5, Suffix = "s",
        Callback = function(v)
            FP.CooldownTime = tonumber(v) or 40
            W.W2_Notify("Fake Perks", "Cooldown: " .. tostring(v) .. "s", 2)
        end })
    end--====================================================--
-- PART 3: AUTO SKILL CHECK (FIXED) + GEN BYPASS + VAULT
--====================================================--

-- === AUTO SKILL CHECK (FIXED) ===
W.SC = W.SC or { Enabled = false, Mode = "Legit", Busy = false, Conn = nil }
local SC = W.SC

local function SC_FindPrompt()
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    if not pg then return nil end
    for _, name in ipairs({
        "SkillCheckPromptGui", "SkillCheck", "SkillcheckGui",
        "SkillCheckGui", "SkillcheckPrompt", "CheckPrompt"
    }) do
        local g = pg:FindFirstChild(name)
        if g then return g end
    end
    for _, g in ipairs(pg:GetChildren()) do
        local ln = g.Name:lower()
        if ln:find("skill") or ln:find("check") then return g end
    end
    return nil
end

local function SC_FindCheck(prompt)
    local c = prompt:FindFirstChild("Check")
    if c then return c end
    for _, d in ipairs(prompt:GetDescendants()) do
        if (d:IsA("Frame") or d:IsA("ImageLabel")) and d.Visible and d.AbsoluteSize.X > 30 then
            return d
        end
    end
    return nil
end

local function SC_FindPointerTarget(check)
    local pointer, target
    for _, d in ipairs(check:GetDescendants()) do
        if d:IsA("GuiObject") then
            local n = d.Name:lower()
            if n:find("pointer") or n:find("line") or n:find("spinner")
               or n:find("needle") or n:find("cursor") then
                pointer = d
            elseif n:find("target") or n:find("goal") or n:find("zone")
                or n:find("success") or n:find("hit") then
                target = d
            end
        end
    end
    return pointer, target
end

local function SC_Press()
    if VIM then
        local ok = pcall(function()
            VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.02)
            VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end)
        if ok then return true end
    end
    if keypress and keyrelease then
        local ok = pcall(function()
            keypress(Enum.KeyCode.Space)
            task.wait(0.02)
            keyrelease(Enum.KeyCode.Space)
        end)
        if ok then return true end
    end
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    local mob = pg and pg:FindFirstChild("Survivor-mob")
    local ctrl = mob and mob:FindFirstChild("Controls")
    if ctrl then
        for _, n in ipairs({"action", "Gui-mob", "Parry", "attack"}) do
            local btn = ctrl:FindFirstChild(n)
            if btn and btn:IsA("GuiButton") and firesignal then
                pcall(function() firesignal(btn.MouseButton1Click) end)
                return true
            end
        end
    end
    return false
end

function W.SC_Set(v)
    SC.Enabled = v
    W2.SkillCheck_Enabled = v
    if SC.Conn then SC.Conn:Disconnect(); SC.Conn = nil end
    if not v then return end
    SC.Conn = RunService.RenderStepped:Connect(function()
        if not SC.Enabled or SC.Busy then return end
        local prompt = SC_FindPrompt()
        if not prompt then return end
        local check = SC_FindCheck(prompt)
        if not check or not check.Visible then return end
        local pointer, target = SC_FindPointerTarget(check)

        if SC.Mode == "Instant" then
            SC.Busy = true
            task.spawn(function()
                SC_Press()
                task.wait(0.25)
                SC.Busy = false
            end)
            return
        end

        if pointer and target then
            local pr = pointer.Rotation % 360
            local tr = target.Rotation % 360
            local diff = math.abs((pr - tr + 180) % 360 - 180)
            if diff <= 12 then
                SC.Busy = true
                task.spawn(function()
                    SC_Press()
                    task.wait(0.05)
                    SC.Busy = false
                end)
            end
        elseif pointer then
            local r = pointer.Rotation % 360
            if r > 100 and r < 130 then
                SC.Busy = true
                task.spawn(function()
                    SC_Press()
                    task.wait(0.05)
                    SC.Busy = false
                end)
            end
        end
    end)
end

-- === BYPASS GENERATOR ===
W.GB = W.GB or { Enabled = false, Cache = {}, Timer = 0, Processed = {}, Hotkey = Enum.KeyCode.B, Range = 8 }
local GB = W.GB
W2.GenBypass_Enabled = W2.GenBypass_Enabled or false
W2.GenBypass_Range   = W2.GenBypass_Range   or 8

function W.GB_Cached()
    local now = tick()
    if now - GB.Timer < 5 then return GB.Cache end
    GB.Cache = {}; GB.Timer = now
    local map = Workspace:FindFirstChild("Map")
    if not map then return GB.Cache end
    pcall(function()
        for _, v in pairs(map:GetDescendants()) do
            if v:IsA("Model") and v.Name == "Generator" then
                if v:GetAttribute("RepairProgress") or v:GetAttribute("kickcount") or v:GetAttribute("ProgressRepair") then
                    table.insert(GB.Cache, v)
                end
            end
        end
    end)
    return GB.Cache
end

function W.GB_Nearest()
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local best, bd = nil, math.huge
    for _, g in pairs(W.GB_Cached()) do
        for _, p in pairs(W.GB_GetPoints(g)) do
            local d = (root.Position - p.Position).Magnitude
            if d < bd then bd = d; best = p end
        end
    end
    return best, bd
end

function W.GB_Repair(tp)
    local gm = tp.Parent
    if GB.Processed[gm] then return end
    GB.Processed[gm] = true
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if not root then GB.Processed[gm] = nil; return end
    local re = ReplicatedStorage.Remotes.Generator.RepairEvent
    local og = root.CFrame
    pcall(function()
        for _, p in pairs(W.GB_GetPoints(gm)) do
            if p ~= tp and p.Parent then
                root.Anchored = true
                root.CFrame = p.CFrame
                task.wait(0.15)
                pcall(function() re:FireServer(p, true) end)
                task.wait(0.3)
                pcall(function() re:FireServer(p, false) end)
                task.wait(0.1)
                pcall(function() re:FireServer(p, true) end)
                task.wait(0.3)
                root.Anchored = false
            end
        end
    end)
    pcall(function() if root and root.Parent then root.Anchored = false; root.CFrame = og end end)
    task.wait(0.1)
    pcall(function() re:FireServer(tp, false) end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp or isMobile then return end
    if input.KeyCode == GB.Hotkey and GB.Enabled then
        local bp, bd = W.GB_Nearest()
        if not bp or bd > GB.Range then return end
        if GB.Processed[bp.Parent] then return end
        W.GB_Repair(bp)
    end
end)

task.spawn(function()
    while true do
        task.wait(2)
        local c = LP.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        if root then
            for gm in pairs(GB.Processed) do
                if not gm or not gm.Parent then GB.Processed[gm] = nil; continue end
                local near = false
                for _, p in pairs(W.GB_GetPoints(gm)) do
                    if p.Parent and (root.Position - p.Position).Magnitude <= 10 then near = true; break end
                end
                if not near then GB.Processed[gm] = nil end
            end
        end
    end
end)

-- === UNLIMITED VAULT ===
local UVOn, UVConn = false, nil
function W.UV_Set(v)
    W2.UnlimitedVault = v
    if v then
        if UVOn then return end
        UVOn = true
        for _, inst in ipairs(CollectionService:GetTagged("Blocked")) do
            CollectionService:RemoveTag(inst, "Blocked")
        end
        UVConn = CollectionService:GetInstanceAddedSignal("Blocked"):Connect(function(i)
            CollectionService:RemoveTag(i, "Blocked")
        end)
    else
        UVOn = false
        if UVConn then UVConn:Disconnect(); UVConn = nil end
    end
end

-- === ANTI SLOW VAULT ===
local ASVOn, ASVConn = false, nil
function W.ASV_Set(v)
    W2.AntiSlowVault = v
    if v then
        if ASVOn then return end
        ASVOn = true
        for _, inst in ipairs(CollectionService:GetTagged("SlowVault")) do
            CollectionService:RemoveTag(inst, "SlowVault")
        end
        ASVConn = CollectionService:GetInstanceAddedSignal("SlowVault"):Connect(function(i)
            CollectionService:RemoveTag(i, "SlowVault")
        end)
    else
        ASVOn = false
        if ASVConn then ASVConn:Disconnect(); ASVConn = nil end
    end
end

-- === UI SECTION ===
do
    local s = W.T_Surv:AddSection("Auto Skill Check")
    s:AddToggle({ Title = "Enable Auto Skill Check", Default = false, Callback = function(v)
        W.SC_Set(v)
        W.W2_Notify("Auto Skill Check", v and "Enabled" or "Disabled", 2)
    end })
    s:AddDropdown({ Title = "Mode", Options = {"Legit", "Instant"}, Default = "Legit",
        Callback = function(v) SC.Mode = v end })

    local s2 = W.T_Surv:AddSection("Bypass Generator")
    s2:AddToggle({ Title = "Enable Bypass Generator", Content = "Hotkey B",
        Default = false, Callback = function(v)
            GB.Enabled = v; W2.GenBypass_Enabled = v
            if v then W.W2_Notify("Bypass Generator", "Enabled (Hotkey: B)", 3) end
        end })
    s2:AddSlider({ Title = "Trigger Range", Min = 3, Max = 20, Default = 8, Increment = 1, Suffix = " studs",
        Callback = function(v) GB.Range = v; W2.GenBypass_Range = v end })
    s2:AddButton({ Title = "Force Repair Nearest Generator", Callback = function()
        local bp, bd = W.GB_Nearest()
        if bp and bd <= GB.Range then W.GB_Repair(bp); W.ForceNotify("Bypass Generator", "Forcing repair...", 2)
        else W.ForceNotify("Bypass Generator", "Terlalu jauh", 2) end
    end })

    local s3 = W.T_Surv:AddSection("Unlimited Vault")
    s3:AddToggle({ Title = "Unlimited Vault", Content = "Remove 'Blocked' tag",
        Default = false, Callback = function(v)
            W.UV_Set(v)
            W.W2_Notify("Unlimited Vault", v and "Enabled" or "Disabled", 2)
        end })

    local s4 = W.T_Surv:AddSection("Anti Slow Vault")
    s4:AddToggle({ Title = "Anti Slow Vault", Content = "Remove 'SlowVault' tag",
        Default = false, Callback = function(v)
            W.ASV_Set(v)
            W.W2_Notify("Anti Slow Vault", v and "Enabled" or "Disabled", 2)
        end })
        end--====================================================--
-- PART 4: AUTO RUN + CROUCH + FLEE + NO FALL + TROLL TP + GOD
--====================================================--

W2.AutoRun_PC      = W2.AutoRun_PC      or false
W2.AutoRun_Mobile  = W2.AutoRun_Mobile  or false
W2.AutoCrouchDodge = W2.AutoCrouchDodge or false
W2.AutoFlee        = W2.AutoFlee        or false
W2.AutoFleeDist    = W2.AutoFleeDist    or 40
W2.AutoFleeCooldown= W2.AutoFleeCooldown or 1.5
W2.NoFallDamage    = W2.NoFallDamage    or false
W2.TrollTeleport   = W2.TrollTeleport   or false
W2.GodMode         = W2.GodMode         or false

-- === AUTO RUN ===
do
    local tPC, tMob = nil, nil

    local function startPC()
        if tPC then task.cancel(tPC) end
        tPC = task.spawn(function()
            while W2.AutoRun_PC do
                pcall(function() VIM:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, LP:GetMouse()) end)
                task.wait(0.1)
            end
            pcall(function() VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, LP:GetMouse()) end)
            tPC = nil
        end)
    end

    local function stopPC()
        W2.AutoRun_PC = false
        if tPC then task.cancel(tPC); tPC = nil end
        pcall(function() VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, LP:GetMouse()) end)
    end

    local function getSprint()
        local pg = LP:FindFirstChild("PlayerGui"); if not pg then return nil end
        local mob = pg:FindFirstChild("Survivor-mob"); if not mob then return nil end
        local ctrl = mob:FindFirstChild("Controls"); if not ctrl then return nil end
        return ctrl:FindFirstChild("sprint")
    end

    local function pressSprint()
        local b = getSprint()
        if not b then return end
        pcall(function()
            if firesignal then
                firesignal(b.MouseButton1Click)
                firesignal(b.MouseButton1Down)
                task.wait(0.04)
                firesignal(b.MouseButton1Up)
            end
        end)
    end

    local function startMob()
        if tMob then return end
        tMob = task.spawn(function()
            while W2.AutoRun_Mobile do
                local c = LP.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if h and h.MoveDirection.Magnitude > 0.12 then pressSprint() end
                task.wait(0.12)
            end
            tMob = nil
        end)
    end

    function W.AutoRunPC(v) W2.AutoRun_PC = v; if v then startPC() else stopPC() end end
    function W.AutoRunMobile(v) W2.AutoRun_Mobile = v; if v then startMob() else W2.AutoRun_Mobile = false end end
end

-- === AUTO CROUCH DODGE ===
W.IsDowned = function(char)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return true end
    local s = char:GetAttribute("State")
    return s == "Downed" or s == "Dead"
end

W.TriggerCrouch = function()
    local startT = tick()
    task.spawn(function()
        local c = LP.Character
        if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid")
        pcall(function() c:SetAttribute("Crouching", true) end)
        pcall(function() ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", true) end)
        pcall(function() ReplicatedStorage.Remotes.Chase.Runevent:FireServer(c, false) end)
        if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Landed) end) end
        pcall(function()
            local mob = LP:FindFirstChildOfClass("PlayerGui"):FindFirstChild("Survivor-mob")
            local ctrl = mob and mob:FindFirstChild("Controls")
            local btn = ctrl and ctrl:FindFirstChild("crouch")
            if btn and firesignal then firesignal(btn.MouseButton1Click) end
        end)
        while tick() - startT < 1.2 do
            pcall(function() ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", true) end)
            task.wait(0.1)
        end
        pcall(function() c:SetAttribute("Crouching", false) end)
        pcall(function() ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", false) end)
        if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Landed) end) end
        pcall(function()
            local mob = LP:FindFirstChildOfClass("PlayerGui"):FindFirstChild("Survivor-mob")
            local ctrl = mob and mob:FindFirstChild("Controls")
            local btn = ctrl and ctrl:FindFirstChild("crouch")
            if btn and firesignal then firesignal(btn.MouseButton1Click) end
        end)
    end)
end

local DodgeAttached = {}
local function attachCrouch(kChar)
    if not kChar or DodgeAttached[kChar] then return end
    DodgeAttached[kChar] = true
    local h = kChar:FindFirstChild("Humanoid") or kChar:WaitForChild("Humanoid", 5)
    if not h then return end
    local a = h:FindFirstChildOfClass("Animator") or h:WaitForChild("Animator", 5)
    if not a then return end
    kChar.AncestryChanged:Connect(function(_, p) if not p then DodgeAttached[kChar] = nil end end)
    a.AnimationPlayed:Connect(function(t)
        if not W2.AutoCrouchDodge then return end
        local aid = t.Animation and t.Animation.AnimationId or ""
        if aid:match("%d+") == "80411309607666" then
            local myChar = LP.Character
            if W.IsDowned(myChar) then return end
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local kRoot = kChar:FindFirstChild("HumanoidRootPart")
            if myRoot and kRoot then
                if (myRoot.Position - kRoot.Position).Magnitude <= 40 then W.TriggerCrouch() end
            end
        end
    end)
end

local function tryCrouchAttach(p)
    if p ~= LP and p.Team and p.Team.Name == "Killer" and p.Character then
        attachCrouch(p.Character)
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LP then
        p.CharacterAdded:Connect(function() tryCrouchAttach(p) end)
        p:GetPropertyChangedSignal("Team"):Connect(function() tryCrouchAttach(p) end)
        tryCrouchAttach(p)
    end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LP then
        p.CharacterAdded:Connect(function() tryCrouchAttach(p) end)
        p:GetPropertyChangedSignal("Team"):Connect(function() tryCrouchAttach(p) end)
    end
end)
task.spawn(function()
    while true do
        task.wait(5)
        for _, p in ipairs(Players:GetPlayers()) do tryCrouchAttach(p) end
    end
end)

-- === AUTO FLEE KILLER ===
local lastFlee = 0
task.spawn(function()
    while true do
        task.wait(0.1)
        if W2.AutoFlee and GetRole() == "Survivor" then
            local now = tick()
            if now - lastFlee >= (W2.AutoFleeCooldown or 1.5) then
                local c = LP.Character
                local root = c and c:FindFirstChild("HumanoidRootPart")
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if root and h and h.Health > 0 then
                    local kr, nd = nil, math.huge
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LP and TeamIs(p, "Killer") and p.Character then
                            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local d = (hrp.Position - root.Position).Magnitude
                                if d < nd then nd = d; kr = hrp end
                            end
                        end
                    end
                    if kr and nd <= (W2.AutoFleeDist or 40) then
                        lastFlee = now
                        local best, bd = nil, 0
                        local map = Workspace:FindFirstChild("Map")
                        if map then
                            for _, obj in ipairs(map:GetDescendants()) do
                                if obj:IsA("BasePart") and obj.Name:match("^GeneratorPoint%d+$") then
                                    local d = (obj.Position - kr.Position).Magnitude
                                    if d > bd then bd = d; best = obj end
                                end
                            end
                        end
                        if best then
                            pcall(function() root.CFrame = best.CFrame + Vector3.new(0, 5, 0) end)
                            W.W2_Notify("Auto Flee", "Teleported away!", 2)
                        end
                    end
                end
            end
        end
    end
end)

-- === NO FALL DAMAGE (flag only, hook digabung di PART 16) ===
-- Fungsi NoFallDamage di-handle oleh hook handler global di PART 16
-- Cuma perlu flag W2.NoFallDamage

-- === TROLL TELEPORT ===
W.TT = W.TT or {
    Enabled = false, Processing = false, Count = 0,
    BlockedAnim = { ["123812278891591"] = 1, ["74099023522626"] = 2 }
}
local TT = W.TT

local function TTHook(char)
    if not char then return end
    local h = char:FindFirstChildOfClass("Humanoid")
    if not h then return end
    local a = h:FindFirstChildOfClass("Animator") or h:WaitForChild("Animator", 3)
    if not a then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    a.AnimationPlayed:Connect(function(t)
        if not TT.Enabled or TT.Processing then return end
        local aid = t.Animation and t.Animation.AnimationId or ""
        local id = aid:match("%d+")
        local delay = id and TT.BlockedAnim[id]
        if not delay then return end
        TT.Processing = true
        TT.Count = TT.Count + 1
        local startCF = root.CFrame
        W.W2_Notify("Troll Teleport", "Trigger #" .. TT.Count, 2)
        task.spawn(function()
            if t.IsPlaying then pcall(function() t.Stopped:Wait() end) end
            task.wait(delay)
            local c = LP.Character
            local rp = c and c:FindFirstChild("HumanoidRootPart")
            if rp and rp.Parent then pcall(function() rp.CFrame = startCF end) end
            TT.Processing = false
        end)
    end)
end

function W.TT_Set(v)
    TT.Enabled = v
    W2.TrollTeleport = v
    if v then
        if TT.Hook then return end
        TT.Processing = false
        TTHook(LP.Character)
        TT.Hook = LP.CharacterAdded:Connect(function(c) task.wait(0.4); TTHook(c) end)
    else
        if TT.Hook then pcall(function() TT.Hook:Disconnect() end); TT.Hook = nil end
        TT.Processing = false
    end
end

-- === GOD MODE ===
local GodThread = nil
function W.God_Set(v)
    W2.GodMode = v
    if GodThread then task.cancel(GodThread); GodThread = nil end
    if v then
        GodThread = task.spawn(function()
            while W2.GodMode do
                local c = LP.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if h and h.Health > 0 and h.Health < h.MaxHealth then
                    pcall(function() h.Health = h.MaxHealth end)
                end
                task.wait(0.1)
            end
        end)
    end
end

-- === UI SECTION ===
do
    local s = W.T_Surv:AddSection("Auto Run")
    s:AddToggle({ Title = "Auto Run [PC]", Default = false, Callback = function(v)
        W.AutoRunPC(v); W.W2_Notify("Auto Run PC", v and "Enabled" or "Disabled", 2)
    end })
    s:AddToggle({ Title = "Auto Run [Mobile]", Default = false, Callback = function(v)
        W.AutoRunMobile(v); W.W2_Notify("Auto Run Mobile", v and "Enabled" or "Disabled", 2)
    end })

    local s2 = W.T_Surv:AddSection("Auto Crouch Dodge")
    s2:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
        W2.AutoCrouchDodge = v
        W.W2_Notify("Crouch Dodge", v and "Enabled" or "Disabled", 2)
    end })

    local s3 = W.T_Surv:AddSection("Auto Flee Killer")
    s3:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
        W2.AutoFlee = v
        W.W2_Notify("Auto Flee", v and "Enabled" or "Disabled", 2)
    end })
    s3:AddSlider({ Title = "Detect Distance", Min = 15, Max = 150, Default = 40, Increment = 5, Suffix = " studs",
        Callback = function(v) W2.AutoFleeDist = v end })
    s3:AddSlider({ Title = "Flee Cooldown", Min = 0.5, Max = 10, Default = 1.5, Increment = 0.5, Suffix = "s",
        Callback = function(v) W2.AutoFleeCooldown = v end })

    local s4 = W.T_Surv:AddSection("No Fall Damage")
    s4:AddToggle({ Title = "Enable No Fall Damage", Default = false, Callback = function(v)
        W2.NoFallDamage = v
        W.W2_Notify("No Fall Damage", v and "Enabled" or "Disabled", 2)
    end })

    local s5 = W.T_Surv:AddSection("Troll Teleport")
    s5:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
        W.TT_Set(v)
        W.W2_Notify("Troll Teleport", v and "Enabled" or "Disabled", 2)
    end })

    local s6 = W.T_Surv:AddSection("God Mode")
    s6:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
        W.God_Set(v)
        W.W2_Notify("God Mode", v and "Enabled" or "Disabled", 2)
    end })
            end--====================================================--
-- PART 5: MANUAL GENERATOR + AUTO GENERATOR
--====================================================--

W2.ManualGen        = W2.ManualGen        or false
W2.AutoGen          = W2.AutoGen          or false
W2.KillerEscapeDist = W2.KillerEscapeDist or 30

do
    local RepairEvent = nil
    pcall(function()
        RepairEvent = ReplicatedStorage.Remotes.Generator.RepairEvent
    end)

    local REPAIR_ANIM_ID = "rbxassetid://92960319113695"
    local ManualThread, AutoThread = nil, nil
    local ManualPoint, AutoPoint = nil, nil
    local LastFire = 0
    local RepairAnimTrack = nil

    local function IsKillerNearPos(pos, radius)
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LP and TeamIs(pl, "Killer") and pl.Character then
                local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - pos).Magnitude <= radius then
                    return true
                end
            end
        end
        return false
    end

    local function GetNearestKillerDist()
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil, math.huge end
        local best, dist = nil, math.huge
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LP and TeamIs(pl, "Killer") and pl.Character then
                local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local d = (hrp.Position - myRoot.Position).Magnitude
                    if d < dist then dist = d; best = hrp end
                end
            end
        end
        return best, dist
    end

    local function PlayRepairAnim()
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local animator = hum and hum:FindFirstChildOfClass("Animator")
        if not animator then return end
        if RepairAnimTrack and RepairAnimTrack.IsPlaying then return end
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = REPAIR_ANIM_ID
            RepairAnimTrack = animator:LoadAnimation(anim)
            RepairAnimTrack.Priority = Enum.AnimationPriority.Action
            RepairAnimTrack:Play()
        end)
    end

    local function StopRepairAnim()
        if RepairAnimTrack and RepairAnimTrack.IsPlaying then
            pcall(function() RepairAnimTrack:Stop() end)
        end
        RepairAnimTrack = nil
    end

    local function StopRepair(point)
        StopRepairAnim()
        if point and RepairEvent then
            pcall(function() RepairEvent:FireServer(point, false) end)
        end
    end

    local function IsGenDone(gen)
        local p = gen:GetAttribute("RepairProgress") or gen:GetAttribute("ProgressRepair") or 0
        return p >= 100
    end

    local function GetNearestGenPointInReach()
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        local bestPt, bestDist = nil, 5.5
        for _, gen in ipairs(W.GB_GetAllGenerators()) do
            for _, pt in ipairs(W.GB_GetPoints(gen)) do
                if pt and pt.Parent then
                    local d = (myRoot.Position - pt.Position).Magnitude
                    if d < bestDist then
                        bestDist = d
                        bestPt = pt
                    end
                end
            end
        end
        return bestPt
    end

    local function GetSafeNearestGenPoint()
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        local bestPt, bestDist = nil, math.huge
        for _, gen in ipairs(W.GB_GetAllGenerators()) do
            if IsGenDone(gen) then continue end
            local genPivot
            pcall(function() genPivot = gen:GetPivot().Position end)
            if genPivot and IsKillerNearPos(genPivot, W2.KillerEscapeDist) then
                continue
            end
            for _, pt in ipairs(W.GB_GetPoints(gen)) do
                if pt and pt.Parent then
                    local d = (pt.Position - myRoot.Position).Magnitude
                    if d < bestDist then
                        bestDist = d
                        bestPt = pt
                    end
                end
            end
        end
        return bestPt
    end

    local function StartManualThread()
        if ManualThread then pcall(function() task.cancel(ManualThread) end); ManualThread = nil end
        ManualThread = task.spawn(function()
            while W2.ManualGen do
                local myChar = LP.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")
                if not myRoot or not hum or hum.Health <= 0 then task.wait(0.2); continue end

                local _, kd = GetNearestKillerDist()
                if kd <= W2.KillerEscapeDist then
                    if ManualPoint then
                        StopRepair(ManualPoint)
                        ManualPoint = nil
                        W.W2_Notify("Manual Gen", "Killer near — release repair", 2)
                    end
                    task.wait(0.3)
                    continue
                end

                local pt = GetNearestGenPointInReach()
                if pt then
                    ManualPoint = pt
                    local now = tick()
                    if now - LastFire >= 0.5 then
                        pcall(function() if RepairEvent then RepairEvent:FireServer(pt, true) end end)
                        PlayRepairAnim()
                        LastFire = now
                    end
                else
                    if ManualPoint then StopRepair(ManualPoint); ManualPoint = nil end
                end
                task.wait(0.1)
            end
            if ManualPoint then StopRepair(ManualPoint) end
            ManualPoint = nil
        end)
    end

    local function StopManualThread()
        if ManualThread then pcall(function() task.cancel(ManualThread) end); ManualThread = nil end
        if ManualPoint then StopRepair(ManualPoint) end
        ManualPoint = nil
    end

    local function StartAutoThread()
        if AutoThread then pcall(function() task.cancel(AutoThread) end); AutoThread = nil end
        AutoThread = task.spawn(function()
            while W2.AutoGen do
                local myChar = LP.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")
                if not myRoot or not hum or hum.Health <= 0 then task.wait(0.3); continue end

                local _, kd = GetNearestKillerDist()
                if kd <= W2.KillerEscapeDist then
                    if AutoPoint then StopRepair(AutoPoint); AutoPoint = nil end
                    local safePt = GetSafeNearestGenPoint()
                    if safePt then
                        AutoPoint = safePt
                        pcall(function()
                            myRoot.CFrame = CFrame.new(safePt.Position + Vector3.new(0, 3, 0))
                        end)
                        task.wait(0.2)
                    end
                    task.wait(0.2)
                    continue
                end

                if AutoPoint and AutoPoint.Parent then
                    local now = tick()
                    if now - LastFire >= 0.5 then
                        pcall(function() if RepairEvent then RepairEvent:FireServer(AutoPoint, true) end end)
                        PlayRepairAnim()
                        LastFire = now
                    end
                else
                    local pt = GetNearestGenPointInReach()
                    if pt then
                        AutoPoint = pt
                    else
                        local safePt = GetSafeNearestGenPoint()
                        if safePt then
                            AutoPoint = safePt
                            pcall(function()
                                myRoot.CFrame = CFrame.new(safePt.Position + Vector3.new(0, 3, 0))
                            end)
                            task.wait(0.2)
                        end
                    end
                end
                task.wait(0.1)
            end
            if AutoPoint then StopRepair(AutoPoint) end
            AutoPoint = nil
        end)
    end

    local function StopAutoThread()
        if AutoThread then pcall(function() task.cancel(AutoThread) end); AutoThread = nil end
        if AutoPoint then StopRepair(AutoPoint) end
        AutoPoint = nil
    end

    function W.ManualGen_Set(v)
        W2.ManualGen = v and true or false
        if W2.ManualGen then StartManualThread() else StopManualThread() end
    end

    function W.AutoGen_Set(v)
        W2.AutoGen = v and true or false
        if W2.AutoGen then StartAutoThread() else StopAutoThread() end
    end

    function W.GenAuto_SetDistance(v)
        W2.KillerEscapeDist = tonumber(v) or 30
    end

    LP.CharacterAdded:Connect(function()
        task.wait(1)
        if W2.ManualGen then StartManualThread() end
        if W2.AutoGen then StartAutoThread() end
    end)
end

-- === UI SECTION ===
do
    local s = W.T_Surv:AddSection("Manual Generator")
    s:AddToggle({ Title = "Enable Manual Generator",
        Content = "Auto repair gen in reach. Release when killer near.",
        Default = false, Callback = function(v)
            W.ManualGen_Set(v)
            W.W2_Notify("Manual Gen", v and "Enabled" or "Disabled", 2)
        end })
    s:AddSlider({ Title = "Killer Escape Distance", Min = 10, Max = 80, Default = 30, Increment = 5, Suffix = " studs",
        Callback = function(v) W.GenAuto_SetDistance(v) end })

    local s2 = W.T_Surv:AddSection("Auto Generator")
    s2:AddToggle({ Title = "Enable Auto Generator",
        Content = "Auto TP to safe gen when killer approaches",
        Default = false, Callback = function(v)
            W.AutoGen_Set(v)
            W.W2_Notify("Auto Gen", v and "Enabled" or "Disabled", 2)
        end })
                end--====================================================--
-- PART 6: PARRY V1 + PARRY V2 + FAKE PARRY
--====================================================--

W2.ParryV1_Enabled    = W2.ParryV1_Enabled    or false
W2.ParryV1_Aggressive = W2.ParryV1_Aggressive or false
W2.ParryV1_Distance   = W2.ParryV1_Distance   or 10
W2.ParryV1_ShowRange  = W2.ParryV1_ShowRange  or false
W2.ParryV1_Silent     = W2.ParryV1_Silent     or false

W2.ParryV2_Enabled    = W2.ParryV2_Enabled    or false
W2.ParryV2_Aggressive = W2.ParryV2_Aggressive or false
W2.ParryV2_Safety     = W2.ParryV2_Safety     or false
W2.ParryV2_Distance   = W2.ParryV2_Distance   or 6
W2.ParryV2_Face       = W2.ParryV2_Face       or 0.7
W2.ParryV2_ShowCircle = W2.ParryV2_ShowCircle ~= false

W2.SURV_FakeParry         = W2.SURV_FakeParry         or false
W2.SURV_FakeParryAnim     = W2.SURV_FakeParryAnim     or "Enten"
W2.SURV_FakeParryCooldown = W2.SURV_FakeParryCooldown or 0.4
W2.SURV_FakeParryKey      = W2.SURV_FakeParryKey      or "V"
W2.SURV_FakeParryShowBtn  = W2.SURV_FakeParryShowBtn  or false
W2.SURV_FakeParryLocked   = W2.SURV_FakeParryLocked   or false

-- === SHARED: KillerAttackAnims ===
local KillerAttackAnims = {
    ["78432063483146"]="attack",["121216847022485"]="attack",["74968262036854"]="attack",
    ["132817836308238"]="attack",["82666958311998"]="attack",["111920872708571"]="attack",
    ["106871536134254"]="attack",["109402730355822"]="attack",["130593238885843"]="attack",
    ["138720291317243"]="attack",["139369275981139"]="attack",["133963973694098"]="attack",
    ["78935059863801"]="attack",
    ["118907603246885"]="lungehold",["135002183282873"]="lungehold",["113255068724446"]="lungehold",
    ["129784271201071"]="lungehold",["105374834496520"]="lungehold",["117070354890871"]="lungehold",
    ["115244153053858"]="lungehold",["110355011987939"]="lungehold",["117042998468241"]="lungehold",
    ["122812055447896"]="lungehold"
}
W.KillerAttackAnims = KillerAttackAnims

--====================================================--
-- PARRY V1
--====================================================--
do
    local ParryState = {
        LastParry = 0, ActiveAttackers = {},
        CircleFolder = nil, CircleDashes = {}, CircleRotCFs = {}, CircleOffsets = {},
        CircleRadius = 0, CircleLastX = math.huge, CircleLastY = math.huge, CircleLastZ = math.huge,
        CircleSpawnTime = 0, CircleSpawnDuration = 0.55,
    }
    local ParryCooldown = {
        OnCooldown = false, CooldownEnd = 0,
        WaitingForResult = false, WaitingStart = 0, WaitTimeout = 2.0,
        FallbackCooldown = 60, MaxCooldown = 90, LastFiredAt = 0,
        IsSilenced = false, JustFired = false, ManualDetect = false, ManualIgnoreWindow = 0.35
    }
    local parryResultRemote, parryFireRemote
    pcall(function()
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        local i = r and r:FindFirstChild("Items")
        local d = i and i:FindFirstChild("Parrying Dagger")
        if d then
            parryResultRemote = d:FindFirstChild("parryResult")
            parryFireRemote = d:FindFirstChild("parry")
        end
    end)

    local function ParryStartCD(d)
        d = math.clamp(tonumber(d) or 0, 0, ParryCooldown.MaxCooldown)
        if d <= 0 then d = ParryCooldown.FallbackCooldown end
        ParryCooldown.OnCooldown = true
        ParryCooldown.CooldownEnd = os.clock() + d
        ParryCooldown.WaitingForResult = false
        ParryCooldown.JustFired = false
        ParryCooldown.ManualDetect = false
    end
    local function ParryClearCD()
        ParryCooldown.OnCooldown = false
        ParryCooldown.CooldownEnd = 0
        ParryCooldown.WaitingForResult = false
        ParryCooldown.JustFired = false
        ParryCooldown.ManualDetect = false
    end
    local function ParryIsCD()
        if not ParryCooldown.OnCooldown then return false end
        if os.clock() >= ParryCooldown.CooldownEnd then ParryClearCD(); return false end
        return true
    end

    if parryResultRemote then
        parryResultRemote.OnClientEvent:Connect(function(success, cd)
            if not ParryCooldown.WaitingForResult and not ParryCooldown.JustFired then return end
            local c = tonumber(cd) or 0
            if success and c > 0 then ParryStartCD(math.min(c, ParryCooldown.MaxCooldown))
            else ParryStartCD(ParryCooldown.FallbackCooldown) end
        end)
    end

    local function ParryHookSilenced(char)
        if not char then return end
        ParryCooldown.IsSilenced = CollectionService:HasTag(char, "Silenced")
    end
    CollectionService:GetInstanceAddedSignal("Silenced"):Connect(function(i)
        if i == LP.Character then ParryCooldown.IsSilenced = true end
    end)
    CollectionService:GetInstanceRemovedSignal("Silenced"):Connect(function(i)
        if i == LP.Character then ParryCooldown.IsSilenced = false end
    end)
    LP.CharacterAdded:Connect(function(c) task.wait(0.5); ParryHookSilenced(c) end)
    if LP.Character then ParryHookSilenced(LP.Character) end

    local PCharCache = { Char=nil, Root=nil, Hum=nil, UpperTorso=nil, CheckInt=nil }
    local function ParryGetChar()
        local char = LP.Character
        if char ~= PCharCache.Char then
            PCharCache.Char = char
            PCharCache.Root = nil; PCharCache.Hum = nil
            PCharCache.UpperTorso = nil; PCharCache.CheckInt = nil
        end
        if not char then return PCharCache end
        if not PCharCache.Root then PCharCache.Root = char:FindFirstChild("HumanoidRootPart") end
        if not PCharCache.Hum then PCharCache.Hum = char:FindFirstChildOfClass("Humanoid") end
        if not PCharCache.UpperTorso then
            PCharCache.UpperTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        end
        if not PCharCache.CheckInt then PCharCache.CheckInt = char:FindFirstChild("CheckInterractable") end
        return PCharCache
    end

    local DaggerCache = { Value = false, LastCheck = 0, Interval = 0.15 }
    local function ParryIsDagger(inst)
        if not inst then return false end
        return inst:IsA("Model") or inst:IsA("Tool") or inst:IsA("Accessory")
    end
    local function ParryHasDagger()
        local now = os.clock()
        if now - DaggerCache.LastCheck < DaggerCache.Interval then return DaggerCache.Value end
        DaggerCache.LastCheck = now
        local has = false
        local c = LP.Character
        if c then
            local d = c:FindFirstChild("Parrying Dagger")
            if ParryIsDagger(d) then has = true end
        end
        if not has then
            local ws = Workspace:FindFirstChild(LP.Name)
            if ws then
                local d = ws:FindFirstChild("Parrying Dagger")
                if ParryIsDagger(d) then has = true end
            end
        end
        DaggerCache.Value = has
        return has
    end
    LP.CharacterAdded:Connect(function() DaggerCache.Value = false; DaggerCache.LastCheck = 0 end)

    local ParryAttrs = {"isVaulting","isSliding","isDroppingPallet","isRepairing","isHealing","isUnhooking","isExiting"}
    local function ParryBusy()
        local cc = ParryGetChar()
        if not cc.Char then return true end
        if LP:GetAttribute("IsDead") then return true end
        if cc.Char:GetAttribute("IsCarried") then return true end
        if cc.Char:GetAttribute("IsHooked") then return true end
        if cc.Root and CollectionService:HasTag(cc.Root, "doing action") then return true end
        if cc.CheckInt then
            for i = 1, #ParryAttrs do
                if cc.CheckInt:GetAttribute(ParryAttrs[i]) then return true end
            end
        end
        return false
    end
    local function ParryLowHP()
        local h = ParryGetChar().Hum
        if not h then return false end
        return h.Health < h.MaxHealth * 0.5
    end
    local function ParryCanFire()
        if not ParryHasDagger() then return false end
        if ParryCooldown.IsSilenced then return false end
        if ParryIsCD() then return false end
        if ParryCooldown.WaitingForResult then return false end
        if ParryBusy() then return false end
        if ParryLowHP() then return false end
        return true
    end

    local function ParryMobile()
        local didFire = false
        local pg = LP:FindFirstChildOfClass("PlayerGui")
        if pg and type(firesignal) == "function" then
            local mob = pg:FindFirstChild("Survivor-mob")
            local ctrl = mob and mob:FindFirstChild("Controls")
            if ctrl then
                for _, n in ipairs({"Gui-mob","action","Gui-mobile","Gui_mob","Parry","parry"}) do
                    local b = ctrl:FindFirstChild(n)
                    if b and b:IsA("GuiButton") then
                        pcall(function()
                            firesignal(b.MouseButton1Down)
                            task.delay(0.05, function()
                                if b and b.Parent then
                                    firesignal(b.MouseButton1Up)
                                    firesignal(b.MouseButton1Click)
                                end
                            end)
                        end)
                        didFire = true; break
                    end
                end
            end
        end
        if not didFire then
            local r = ReplicatedStorage:FindFirstChild("Remotes")
            local i = r and r:FindFirstChild("Items")
            local d = i and i:FindFirstChild("Parrying Dagger")
            local p = d and d:FindFirstChild("parry")
            if p then pcall(function() p:FireServer() end) end
        end
    end

    local function ParryPC()
        if not VIM then return end
        pcall(function()
            VIM:SendMouseMoveEvent(0, 0, game)
            task.wait(0.005)
            VIM:SendMouseButtonEvent(0, 0, 2, true, game, 0)
            task.wait(0.05)
            VIM:SendMouseButtonEvent(0, 0, 2, false, game, 0)
        end)
    end

    local function ParrySilent()
        if parryFireRemote then return pcall(function() parryFireRemote:FireServer() end) end
        return false
    end

    local function ParryFire()
        if not ParryCanFire() then return end
        ParryState.LastParry = os.clock()
        ParryCooldown.LastFiredAt = os.clock()
        ParryCooldown.WaitingForResult = true
        ParryCooldown.WaitingStart = os.clock()
        ParryCooldown.JustFired = true
        ParryCooldown.ManualDetect = false
        if W2.ParryV1_Silent then ParrySilent(); return end
        if isMobile then ParryMobile() else ParryPC() end
    end

    local function ParryMarkManual()
        if not ParryHasDagger() then return end
        if ParryCooldown.IsSilenced then return end
        if os.clock() - ParryCooldown.LastFiredAt < ParryCooldown.ManualIgnoreWindow then return end
        if ParryCooldown.OnCooldown or ParryCooldown.WaitingForResult then return end
        ParryCooldown.WaitingForResult = true
        ParryCooldown.WaitingStart = os.clock()
        ParryCooldown.JustFired = true
        ParryCooldown.ManualDetect = true
        ParryCooldown.LastFiredAt = os.clock()
    end
    UserInputService.InputBegan:Connect(function(input, gp)
        if input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
        if gp then return end
        ParryMarkManual()
    end)

    local function ParryHitbox(char)
        if not char then return nil end
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    end

    local function ParryCheck(kChar)
        if ParryIsCD() or ParryCooldown.WaitingForResult
            or ParryCooldown.IsSilenced or not ParryHasDagger() then return end
        local cc = ParryGetChar()
        local myRoot = cc.UpperTorso or cc.Root
        local kPart = ParryHitbox(kChar)
        if not myRoot or not kPart then return end
        local dist = (myRoot.Position - kPart.Position).Magnitude
        if W2.ParryV1_Aggressive then
            local ping = math.clamp(LP:GetNetworkPing(), 0, 0.3)
            local kRoot = kChar:FindFirstChild("HumanoidRootPart") or kPart
            local kVel = kRoot.AssemblyLinearVelocity
            local flatVel = Vector3.new(kVel.X, 0, kVel.Z)
            local pred = kPart.Position + flatVel * ping
            if (myRoot.Position - pred).Magnitude <= ((W2.ParryV1_Distance or 10) + 2.5) then
                if flatVel.Magnitude > 6 then
                    local dir = myRoot.Position - kPart.Position
                    if dir.Magnitude > 0 and flatVel.Unit:Dot(dir.Unit) > 0.4 then ParryFire(); return end
                end
            end
        end
        if dist <= (W2.ParryV1_Distance or 10) then ParryFire() end
    end

    local function ParryDestroyCircle()
        if ParryState.CircleFolder then
            pcall(function() if ParryState.CircleFolder.Parent then ParryState.CircleFolder:Destroy() end end)
        end
        ParryState.CircleFolder = nil
        ParryState.CircleDashes = {}
        ParryState.CircleRotCFs = {}
        ParryState.CircleOffsets = {}
        ParryState.CircleRadius = 0
        ParryState.CircleLastX = math.huge
        ParryState.CircleLastY = math.huge
        ParryState.CircleLastZ = math.huge
        ParryState.CircleSpawnTime = 0
    end
    getgenv()._W2_DestroyParryCircle = ParryDestroyCircle

    local function ParryBuildCircle(radius)
        ParryDestroyCircle()
        local folder = Instance.new("Folder")
        folder.Name = "W2ParryCircleDashes"
        local dashCount = math.clamp(math.floor(radius * 6), 24, 120)
        local slotLen = (2 * math.pi * radius) / dashCount
        local dashLen = slotLen * 0.55
        local thickness = 0.03
        local dashes, rotCFs, offsets = {}, {}, {}
        for i = 1, dashCount do
            local part = Instance.new("Part")
            part.Name = "Dash" .. i
            part.Anchored = true; part.CanCollide = false
            part.CanTouch = false; part.CanQuery = false; part.CastShadow = false
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(255, 255, 255)
            part.Transparency = 1
            part.Size = Vector3.new(thickness, thickness, dashLen)
            part.Parent = folder
            local angle = ((i - 1) / dashCount) * math.pi * 2
            local cosA, sinA = math.cos(angle), math.sin(angle)
            rotCFs[i] = CFrame.lookAt(Vector3.zero, Vector3.new(-sinA, 0, cosA))
            offsets[i] = Vector3.new(cosA * radius, 0, sinA * radius)
            dashes[i] = part
        end
        folder.Parent = Workspace
        ParryState.CircleFolder = folder
        ParryState.CircleDashes = dashes
        ParryState.CircleRotCFs = rotCFs
        ParryState.CircleOffsets = offsets
        ParryState.CircleRadius = radius
        ParryState.CircleSpawnTime = tick()
    end

    local function ParryUpdateCircle(myRoot)
        if not ParryState.CircleFolder or not ParryState.CircleFolder.Parent then return end
        local dashes = ParryState.CircleDashes
        local dc = #dashes
        if dc == 0 then return end
        local center = myRoot.Position - Vector3.new(0, (myRoot.Size.Y * 0.5) + 1.0, 0)
        local el = tick() - (ParryState.CircleSpawnTime or 0)
        local spawnT = math.clamp(el / (ParryState.CircleSpawnDuration or 0.55), 0, 1)
        local eased = 1 - (1 - spawnT)^3
        local scaleMult = eased
        if spawnT < 0.7 and spawnT > 0 then
            local bt = spawnT / 0.7
            scaleMult = eased + math.sin(bt * math.pi) * 0.1
        end
        local spinRot = (1 - eased) * math.pi * 2
        local spawnAlpha = 1 - eased
        local busy = ParryBusy()
        local onCD = ParryCooldown.OnCooldown
        local tc
        if busy then tc = Color3.fromRGB(255, 20, 20)
        elseif onCD then tc = Color3.fromRGB(255, 140, 0)
        else tc = Color3.fromRGB(255, 255, 255) end
        local targetT = 0
        if onCD then
            local period = 0.55
            local phase = (os.clock() % period) / period
            local pulse = (math.cos(phase * math.pi * 2) + 1) * 0.5
            targetT = (1 - pulse) * 0.85
        end
        local finalT = math.max(targetT, spawnAlpha)
        ParryState.CircleLastX = center.X
        ParryState.CircleLastY = center.Y
        ParryState.CircleLastZ = center.Z
        local rotCFs = ParryState.CircleRotCFs
        local offsets = ParryState.CircleOffsets
        local rotCF = CFrame.Angles(0, spinRot, 0)
        for i = 1, dc do
            local dash = dashes[i]
            if dash and dash.Parent then
                local scaled = offsets[i] * scaleMult
                local rotated = rotCF:VectorToWorldSpace(scaled)
                local wp = Vector3.new(center.X + rotated.X, center.Y, center.Z + rotated.Z)
                dash.CFrame = (rotCF * rotCFs[i]) + wp
                dash.Color = tc
                dash.Transparency = finalT
            end
        end
    end

    local function ParryAnimType(track)
        if not track or not track.Animation then return nil end
        local aid = track.Animation.AnimationId or ""
        local nid = aid:match("%d+") or ""
        local name = string.lower(track.Animation.Name or "")
        local v = KillerAttackAnims[aid]
        if v then return v end
        if nid ~= "" then v = KillerAttackAnims[nid]; if v then return v end end
        if name:find("lunge") or name:find("charge") then return "lungehold" end
        if name:find("attack") or name:find("slash") or name:find("swing")
            or name:find("stab") or name:find("melee") then return "attack" end
        return nil
    end

    local function ParryHookAnim(plr, char)
        if not char then return end
        local h = char:FindFirstChildOfClass("Humanoid")
        if not h then return end
        local a = h:FindFirstChildOfClass("Animator") or h:WaitForChild("Animator", 3)
        if not a then return end
        a.AnimationPlayed:Connect(function(t)
            if not W2.ParryV1_Enabled then return end
            if not ParryHasDagger() then return end
            local at = ParryAnimType(t)
            if at then
                ParryState.ActiveAttackers[plr] = { char = char, track = t, type = at, registeredAt = os.clock() }
            end
        end)
    end

    local function ParryHookKiller(plr)
        if plr == LP then return end
        if plr.Character then ParryHookAnim(plr, plr.Character) end
        plr.CharacterAdded:Connect(function(c) task.wait(0.5); ParryHookAnim(plr, c) end)
    end
    for _, p in ipairs(Players:GetPlayers()) do ParryHookKiller(p) end
    Players.PlayerAdded:Connect(ParryHookKiller)

    local parryLastPoll, parryLastCleanup = 0, 0
    local function ParryPollAttacks()
        if not W2.ParryV1_Enabled or not ParryHasDagger() then return end
        local now = os.clock()
        if now - parryLastPoll < 0.15 then return end
        parryLastPoll = now
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local c = plr.Character
                if c then
                    local h = c:FindFirstChildOfClass("Humanoid")
                    if h then
                        for _, t in ipairs(h:GetPlayingAnimationTracks()) do
                            local at = ParryAnimType(t)
                            if at then
                                local ex = ParryState.ActiveAttackers[plr]
                                if not ex or ex.track ~= t then
                                    ParryState.ActiveAttackers[plr] = { char = c, track = t, type = at, registeredAt = now }
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local function ParryCleanup()
        local now = os.clock()
        if now - parryLastCleanup < 1.0 then return end
        parryLastCleanup = now
        for plr, data in pairs(ParryState.ActiveAttackers) do
            if not plr or not plr.Parent or not data.track or not data.track.IsPlaying then
                ParryState.ActiveAttackers[plr] = nil
            end
        end
    end

    local function ParryUpdate()
        if not W2.ParryV1_Enabled then return end
        if not ParryHasDagger() then ParryState.ActiveAttackers = {}; return end
        if ParryCooldown.WaitingForResult then
            if os.clock() - ParryCooldown.WaitingStart > ParryCooldown.WaitTimeout then
                if ParryCooldown.ManualDetect then
                    ParryCooldown.WaitingForResult = false
                    ParryCooldown.JustFired = false
                    ParryCooldown.ManualDetect = false
                else
                    ParryStartCD(ParryCooldown.FallbackCooldown)
                end
            end
        end
        if ParryIsCD() or ParryCooldown.WaitingForResult then return end
        ParryPollAttacks()
        ParryCleanup()
        for plr, data in pairs(ParryState.ActiveAttackers) do
            if plr and plr.Parent and data.track and data.track.IsPlaying then
                local check = false
                if data.type == "attack" then
                    if data.track.TimePosition < 0.35 then check = true end
                elseif data.type == "lungehold" then
                    check = true
                end
                if check then
                    ParryCheck(data.char)
                    if ParryCooldown.WaitingForResult then break end
                end
            else
                ParryState.ActiveAttackers[plr] = nil
            end
        end
    end

    local function ParryCircleUpdate()
        local c = LP.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        if W2.ParryV1_ShowRange and W2.ParryV1_Enabled and ParryHasDagger() and root then
            if not ParryState.CircleFolder or ParryState.CircleRadius ~= (W2.ParryV1_Distance or 10) or not ParryState.CircleFolder.Parent then
                ParryBuildCircle(W2.ParryV1_Distance or 10)
            end
            ParryUpdateCircle(root)
        else
            if ParryState.CircleFolder then ParryDestroyCircle() end
        end
    end

    local lastLogic, lastCircle = 0, 0
    RunService.Heartbeat:Connect(function()
        local now = os.clock()
        if now - lastCircle >= 0.033 then lastCircle = now; pcall(ParryCircleUpdate) end
        if now - lastLogic >= 0.05 then lastLogic = now; pcall(ParryUpdate) end
    end)
end

--====================================================--
-- PARRY V2 (Wisnu style)
--====================================================--
do
    local ValidIDs = {
        ["122812055447896"]="Veil lunge",["133963973694098"]="Mayers Basic",
        ["117042998468241"]="Mayers lunge",["135002183282873"]="cure lunge",
        ["121216847022485"]="cure Basic",["132817836308238"]="Jeff Basic",
        ["129784271201071"]="Jeff lunge",["82666958311998"]="Jeff Frenzy",
        ["78432063483146"]="Abyssal Basic",["118907603246885"]="Abyssal lunge",
        ["139369275981139"]="Jason Basic",["110355011987939"]="Jason lunge",
        ["111920872708571"]="Masked Basic",["105374834496520"]="Masked lunge",
        ["138720291317243"]="Masked Tony",["106871536134254"]="Masked Alex",
        ["130593238885843"]="Masked Cobra",["115244153053858"]="Masked Cobra lunge",
        ["74968262036854"]="Hidden Basic",["113255068724446"]="Hidden lunge",
        ["98163597193511"]="Hidden S1",["80411309607666"]="Abyssal S1"
    }
    local State = { CD = false, CDThread = nil, Adornment = nil }
    local Attached = {}

    local function isKiller(p) return p and p.Team and p.Team.Name == "Killer" end
    local function isDowned(c) return c and (c:GetAttribute("Knocked") == true or c:GetAttribute("IsHooked") == true) end
    local function isSafe(c)
        if not W2.ParryV2_Safety then return true end
        if not c then return false end
        local ci = c:FindFirstChild("CheckInterractable")
        if ci then
            if ci:GetAttribute("isVaulting") then return false end
            if ci:GetAttribute("isRepairing") then return false end
            if ci:GetAttribute("isUnhooking") then return false end
            if ci:GetAttribute("isHealing") then return false end
            if ci:GetAttribute("isSliding") then return false end
        end
        return true
    end

    local function pressRC()
        if not VIM then return end
        pcall(function()
            VIM:SendMouseButtonEvent(0, 0, 1, true, game, 0)
            task.wait()
            VIM:SendMouseButtonEvent(0, 0, 1, false, game, 0)
        end)
    end

    local function tapMobile()
        local pg = LP:FindFirstChild("PlayerGui")
        if not pg then return end
        local mob = pg:FindFirstChild("Survivor-mob")
        local btn = mob and mob:FindFirstChild("Controls") and mob.Controls:FindFirstChild("Gui-mob")
        if btn and btn.Visible then
            if firesignal then pcall(function()
                firesignal(btn.MouseButton1Down)
                task.wait(0.01)
                firesignal(btn.MouseButton1Up)
            end) end
        else
            pressRC()
        end
    end

    local function execute()
        if State.CD then return end
        pcall(function()
            local p = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Items"):FindFirstChild("Parrying Dagger"):FindFirstChild("parry")
            if p then for i = 1, 10 do p:FireServer() end end
            task.spawn(tapMobile)
        end)
    end

    task.spawn(function()
        local r = ReplicatedStorage:WaitForChild("Remotes", 5)
        local d = r and r:WaitForChild("Items", 5):WaitForChild("Parrying Dagger", 5)
        local pr = d and d:WaitForChild("parryResult", 5)
        if pr then
            pr.OnClientEvent:Connect(function(a, b)
                local cdDur = tonumber(b) or ((a == true) and 90 or 60)
                State.CD = true
                if State.CDThread then task.cancel(State.CDThread) end
                State.CDThread = task.delay(cdDur, function() State.CD = false end)
            end)
        end
    end)

    local function attach(kChar)
        if not kChar or Attached[kChar] then return end
        Attached[kChar] = true
        local h = kChar:FindFirstChild("Humanoid") or kChar:WaitForChild("Humanoid", 5)
        if not h then return end
        local a = h:FindFirstChildOfClass("Animator") or h:WaitForChild("Animator", 5)
        if not a then return end
        kChar.AncestryChanged:Connect(function(_, p) if not p then Attached[kChar] = nil end end)
        a.AnimationPlayed:Connect(function(t)
            local aid = t.Animation and t.Animation.AnimationId or ""
            local id = aid:match("%d+")
            local nm = ValidIDs[id]
            if not nm then return end
            if not W2.ParryV2_Enabled then return end
            if State.CD then return end
            local myChar = LP.Character
            if isDowned(myChar) or not isSafe(myChar) then return end
            local myR = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local kR = kChar:FindFirstChild("HumanoidRootPart")
            if not myR or not kR then return end
            local dist = (myR.Position - kR.Position).Magnitude
            if W2.ParryV2_Aggressive then
                local agg = 12
                local det = W2.ParryV2_Distance + 5
                if dist > det then return end
                if dist <= agg then
                    execute()
                else
                    local tracker
                    local st = os.clock()
                    tracker = RunService.Heartbeat:Connect(function()
                        if os.clock() - st >= 1.5 or State.CD or not myR or not kR or isDowned(myChar) then
                            if tracker then tracker:Disconnect() end
                            return
                        end
                        if (myR.Position - kR.Position).Magnitude <= agg then
                            execute()
                            if tracker then tracker:Disconnect() end
                        end
                    end)
                end
            else
                if dist > W2.ParryV2_Distance then return end
                local mf = Vector3.new(myR.Position.X, 0, myR.Position.Z)
                local kf = Vector3.new(kR.Position.X, 0, kR.Position.Z)
                local fd = mf - kf
                if fd.Magnitude > 0 then
                    local fdu = fd.Unit
                    local kl = Vector3.new(kR.CFrame.LookVector.X, 0, kR.CFrame.LookVector.Z).Unit
                    if kl:Dot(fdu) < W2.ParryV2_Face then return end
                end
                execute()
            end
        end)
    end

    local function tryAttach(p)
        if p ~= LP and isKiller(p) and p.Character then attach(p.Character) end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            p.CharacterAdded:Connect(function() tryAttach(p) end)
            p:GetPropertyChangedSignal("Team"):Connect(function() tryAttach(p) end)
            tryAttach(p)
        end
    end
    Players.PlayerAdded:Connect(function(p)
        if p ~= LP then
            p.CharacterAdded:Connect(function() tryAttach(p) end)
            p:GetPropertyChangedSignal("Team"):Connect(function() tryAttach(p) end)
        end
    end)
    task.spawn(function()
        while true do
            task.wait(5)
            for _, p in ipairs(Players:GetPlayers()) do tryAttach(p) end
        end
    end)

    RunService.Heartbeat:Connect(function()
        local c = LP.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if W2.ParryV2_ShowCircle and W2.ParryV2_Enabled and hrp then
            if not State.Adornment or State.Adornment.Parent ~= hrp then
                if State.Adornment then State.Adornment:Destroy() end
                State.Adornment = Instance.new("CylinderHandleAdornment")
                State.Adornment.Name = "W2ParryV2Circle"
                State.Adornment.Height = 0.05
                State.Adornment.Transparency = 0.3
                State.Adornment.Adornee = hrp
                State.Adornment.Parent = hrp
                State.Adornment.ZIndex = 0
                State.Adornment.AlwaysOnTop = false
            end
            local r = W2.ParryV2_Distance
            State.Adornment.Radius = r
            State.Adornment.InnerRadius = math.max(0.1, r - 0.15)
            State.Adornment.CFrame = CFrame.new(0, -3, 0) * CFrame.Angles(math.rad(90), 0, 0)
            State.Adornment.Color3 = State.CD and Color3.fromRGB(128,128,128) or Color3.fromRGB(255,255,255)
        elseif State.Adornment then
            State.Adornment:Destroy()
            State.Adornment = nil
        end
    end)
end

--====================================================--
-- FAKE PARRY
--====================================================--
do
    local FakeParryTrack = nil
    local FakeParryLast  = 0
    local FakeParryButtonGui = nil

    local FakeParryAnims = {
        ["Enten"]       = "rbxassetid://127096285501517",
        ["Stopwatch"]   = "rbxassetid://81793464499285",
        ["Fih"]         = "rbxassetid://123307242865945",
        ["BloodShield"] = "rbxassetid://75939529748815",
    }

    local function FakeParry_Stop()
        if FakeParryTrack then
            pcall(function() FakeParryTrack:Stop(0.05) end)
            FakeParryTrack = nil
        end
    end

    local function FakeParry_Play()
        if not W2.SURV_FakeParry then return end
        if GetRole() ~= "Survivor" then return end
        local now = tick()
        if now - FakeParryLast < (tonumber(W2.SURV_FakeParryCooldown) or 0.4) then return end
        FakeParryLast = now

        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local animator = hum:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = hum
        end

        FakeParry_Stop()
        local animId = FakeParryAnims[W2.SURV_FakeParryAnim] or FakeParryAnims["Enten"]
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = animId
            local track = animator:LoadAnimation(anim)
            track.Priority = Enum.AnimationPriority.Action4
            track.Looped = false
            track:Play(0.1)
            FakeParryTrack = track
            task.delay(2, function()
                if FakeParryTrack == track then FakeParry_Stop() end
            end)
        end)
    end

    local function FakeParry_CreateButton()
        if FakeParryButtonGui then return end
        local pg = LP:FindFirstChild("PlayerGui")
        if not pg then return end

        local sg = Instance.new("ScreenGui")
        sg.Name = "W2FakeParryBtn"
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.DisplayOrder = 100
        sg.Parent = pg

        local btn = Instance.new("TextButton")
        btn.Name = "FakeParryBtn"
        btn.Size = UDim2.fromOffset(64, 64)
        btn.Position = UDim2.new(0.82, 0, 0.62, 0)
        btn.AnchorPoint = Vector2.new(0.5, 0.5)
        btn.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
        btn.BackgroundTransparency = 0.15
        btn.Text = "FAKE\nPARRY"
        btn.TextColor3 = Color3.fromRGB(220, 180, 255)
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamBold
        btn.ZIndex = 10
        btn.Parent = sg
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(200, 120, 255)
        stroke.Thickness = 2
        stroke.Transparency = 0.2

        local lockBtn = Instance.new("TextButton")
        lockBtn.Size = UDim2.new(0, 22, 0, 22)
        lockBtn.Position = UDim2.new(1, -5, 0, -5)
        lockBtn.AnchorPoint = Vector2.new(1, 0)
        lockBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        lockBtn.BackgroundTransparency = 0.3
        lockBtn.Text = W2.SURV_FakeParryLocked and "X" or "L"
        lockBtn.TextSize = 10
        lockBtn.Font = Enum.Font.GothamBold
        lockBtn.TextColor3 = Color3.new(1, 1, 1)
        lockBtn.ZIndex = 11
        lockBtn.Parent = btn
        Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(1, 0)

        lockBtn.MouseButton1Click:Connect(function()
            W2.SURV_FakeParryLocked = not W2.SURV_FakeParryLocked
            lockBtn.Text = W2.SURV_FakeParryLocked and "X" or "L"
            lockBtn.BackgroundColor3 = W2.SURV_FakeParryLocked and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(60, 60, 60)
        end)

        local dragging, dragStart, startPos = false, nil, nil
        local moved = false
        btn.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                if W2.SURV_FakeParryLocked then return end
                dragging = true; moved = false
                dragStart = inp.Position
                startPos = btn.Position
            end
        end)
        btn.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                if dragging and not moved then FakeParry_Play() end
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if not dragging or W2.SURV_FakeParryLocked then return end
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                local d = inp.Position - dragStart
                if math.abs(d.X) + math.abs(d.Y) > 6 then moved = true end
                btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)

        FakeParryButtonGui = sg
    end

    local function FakeParry_RemoveButton()
        if FakeParryButtonGui then
            pcall(function() FakeParryButtonGui:Destroy() end)
            FakeParryButtonGui = nil
        end
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local kc = Enum.KeyCode[W2.SURV_FakeParryKey or "V"]
        if kc and input.KeyCode == kc then FakeParry_Play() end
    end)

    task.spawn(function()
        local pg = LP:FindFirstChild("PlayerGui")
        if not pg then return end
        task.wait(2)
        pcall(function()
            local mob = pg:FindFirstChild("Survivor-mob")
            local controls = mob and mob:FindFirstChild("Controls")
            if not controls then return end
            for _, name in ipairs({"Parry", "parry", "action", "Gui-mob"}) do
                local btn = controls:FindFirstChild(name)
                if btn and btn:IsA("GuiButton") then
                    btn.MouseButton1Click:Connect(function() FakeParry_Play() end)
                end
            end
        end)
    end)

    LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        if W2.SURV_FakeParryShowBtn and W2.SURV_FakeParry then
            FakeParry_RemoveButton()
            FakeParry_CreateButton()
        end
    end)

    function W.FakeParry_SetEnabled(v)
        W2.SURV_FakeParry = v and true or false
        if not v then FakeParry_Stop() end
        if v and UserInputService.TouchEnabled and W2.SURV_FakeParryShowBtn then
            FakeParry_CreateButton()
        end
    end
    function W.FakeParry_SetAnim(name)
        if name and FakeParryAnims[name] then W2.SURV_FakeParryAnim = name
        else W2.SURV_FakeParryAnim = "Enten" end
    end
    function W.FakeParry_Trigger() FakeParry_Play() end
    function W.FakeParry_SetShowButton(v)
        W2.SURV_FakeParryShowBtn = v and true or false
        if v then FakeParry_CreateButton() else FakeParry_RemoveButton() end
    end
    function W.FakeParry_SetKeybind(name)
        local ok, kc = pcall(function() return Enum.KeyCode[tostring(name):upper()] end)
        if ok and kc then W2.SURV_FakeParryKey = kc.Name; return true end
        return false
    end
end

-- === UI SECTION ===
do
    local s = W.T_Surv:AddSection("Auto Parry V1")
    s:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
        W2.ParryV1_Enabled = v
        if not v and getgenv()._W2_DestroyParryCircle then pcall(getgenv()._W2_DestroyParryCircle) end
        W.W2_Notify("Parry V1", v and "Enabled" or "Disabled", 2)
    end })
    s:AddToggle({ Title = "Aggressive", Default = false, Callback = function(v) W2.ParryV1_Aggressive = v end })
    s:AddSlider({ Title = "Distance", Min = 4, Max = 30, Default = 10, Increment = 1, Suffix = " studs",
        Callback = function(v) W2.ParryV1_Distance = v end })
    s:AddToggle({ Title = "Show Range", Default = false, Callback = function(v)
        W2.ParryV1_ShowRange = v
        if not v and getgenv()._W2_DestroyParryCircle then pcall(getgenv()._W2_DestroyParryCircle) end
    end })
    s:AddToggle({ Title = "Silent Parry", Default = false, Callback = function(v) W2.ParryV1_Silent = v end })

    local s2 = W.T_Surv:AddSection("Auto Parry V2")
    s2:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
        W2.ParryV2_Enabled = v
        W.W2_Notify("Parry V2", v and "Enabled" or "Disabled", 2)
    end })
    s2:AddToggle({ Title = "Aggressive", Default = false, Callback = function(v) W2.ParryV2_Aggressive = v end })
    s2:AddToggle({ Title = "Safety", Default = false, Callback = function(v) W2.ParryV2_Safety = v end })
    s2:AddSlider({ Title = "Distance", Min = 4, Max = 25, Default = 6, Increment = 1, Suffix = " studs",
        Callback = function(v) W2.ParryV2_Distance = v end })
    s2:AddSlider({ Title = "Face Sensitivity", Min = -1, Max = 1, Default = 0.7, Increment = 0.05,
        Callback = function(v) W2.ParryV2_Face = v end })
    s2:AddToggle({ Title = "Show Circle", Default = true, Callback = function(v) W2.ParryV2_ShowCircle = v end })

    local s3 = W.T_Surv:AddSection("Fake Parry")
    s3:AddToggle({ Title = "Enable Fake Parry", Content = "Animasi parry palsu",
        Default = false, Callback = function(v)
            W.FakeParry_SetEnabled(v)
            W.W2_Notify("Fake Parry", v and ("Enabled — Key: " .. (W2.SURV_FakeParryKey or "V")) or "Disabled", 2)
        end })
    s3:AddDropdown({ Title = "Animation", Options = {"Enten","Stopwatch","Fih","BloodShield"},
        Default = "Enten", Multi = false, Callback = function(v)
            if type(v) == "table" then v = v[1] end
            W.FakeParry_SetAnim(v)
        end })
    s3:AddInput({ Title = "Keybind", Default = "V", Placeholder = "V / G / F / X / B",
        Callback = function(input)
            input = tostring(input or ""):gsub("%s+", "")
            if input == "" then return end
            W.FakeParry_SetKeybind(input)
        end })
    s3:AddSlider({ Title = "Cooldown", Min = 0, Max = 3, Default = 0.4, Increment = 0.1, Suffix = "s",
        Callback = function(v) W2.SURV_FakeParryCooldown = v end })
    s3:AddToggle({ Title = "Show Floating Button", Default = false,
        Callback = function(v) W.FakeParry_SetShowButton(v) end })
    s3:AddButton({ Title = "Test Fake Parry Now", Callback = function()
        W.FakeParry_Trigger()
        W.ForceNotify("Fake Parry", "Playing...", 2)
    end })
end--====================================================--
-- PART 7: MAP PREDICT + SELF UNHOOK + TOF + FLASHLIGHT + GUN + MOONWALK
--====================================================--

W2.MapPredict_Enabled = W2.MapPredict_Enabled or false
W2.SelfUnhook_Enabled = W2.SelfUnhook_Enabled or false
W2.SelfUnhook_Duration= W2.SelfUnhook_Duration or 30
W2.SelfUnhook_Distance= W2.SelfUnhook_Distance or 20
W2.TOF_Enabled        = W2.TOF_Enabled        or false
W2.TOF_Key            = W2.TOF_Key            or "Q"
W2.TOF_TargetMode     = W2.TOF_TargetMode     or "Killer"
W2.TOF_Laser          = W2.TOF_Laser          ~= false
W2.TOF_WallCheck      = W2.TOF_WallCheck      ~= false
W2.TOF_BlockKnocked   = W2.TOF_BlockKnocked   ~= false
W2.Flash_Enabled      = W2.Flash_Enabled      or false
W2.Flash_TargetPart   = W2.Flash_TargetPart   or "Head"
W2.Flash_Range        = W2.Flash_Range        or 120
W2.Flash_Smooth       = W2.Flash_Smooth       or 0.35
W2.GunAim_Enabled     = W2.GunAim_Enabled     or false
W2.Moonwalk_Enabled   = W2.Moonwalk_Enabled   or false

-- === NEXT MAP PREDICTION ===
do
    local MPS = { Gui = nil, Thread = nil, Enabled = false }
    local function detect(map)
        if not map then return nil end
        if map:FindFirstChild("random shakes") or map:FindFirstChild("SCP-173 Room") or map:FindFirstChild("SCP-205 Room") then
            return "Site 68"
        elseif map:FindFirstChild("HooksMeat") then return "BLOODBATH! Club"
        elseif map:FindFirstChild("Gate") and map.Gate:FindFirstChild("vfx") then return "Firelink Shrine"
        elseif map:FindFirstChild("Bldg_Addon_RooftopUnit_A") or map:FindFirstChild("Rooftop") then return "Mercy Hospital Rooftop"
        elseif map:FindFirstChild("White Armored Car") then return "Mount Massive Asylum"
        elseif map:FindFirstChild("Dumbster") then return "The Bay Harbor"
        elseif map:FindFirstChild("water pump") then return "Valdelobos Village"
        elseif map:FindFirstChild("LargeBoulder01") then return "Woodview Cabin" end
        return nil
    end
    local function build()
        if MPS.Gui then pcall(function() MPS.Gui:Destroy() end) end
        local pg = LP:FindFirstChild("PlayerGui")
        if gethui then local ok, hui = pcall(gethui); if ok and hui then pg = hui end end
        if not pg then return end
        local gui = Instance.new("ScreenGui")
        gui.Name = "W2MapPredict"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 50
        gui.Parent = pg
        local f = Instance.new("Frame")
        f.Name = "Main"
        f.Size = UDim2.new(0, 210, 0, 54)
        f.Position = UDim2.new(0.5, -105, 0, 110)
        f.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
        f.BackgroundTransparency = 0.15
        f.BorderSizePixel = 0
        f.Active = true
        f.Parent = gui
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local s = Instance.new("UIStroke", f)
        s.Color = Color3.fromRGB(255, 255, 255)
        s.Thickness = 1.5
        s.Transparency = 0.2
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        local t = Instance.new("TextLabel", f)
        t.Size = UDim2.new(1, 0, 0, 15)
        t.Position = UDim2.new(0, 0, 0, 5)
        t.BackgroundTransparency = 1
        t.Text = "NEXT MAP PREDICTION"
        t.TextColor3 = Color3.fromRGB(150, 180, 255)
        t.Font = Enum.Font.GothamBold
        t.TextSize = 10
        local mn = Instance.new("TextLabel", f)
        mn.Name = "MapName"
        mn.Size = UDim2.new(1, -12, 0, 18)
        mn.Position = UDim2.new(0, 6, 0, 21)
        mn.BackgroundTransparency = 1
        mn.Text = "Scanning..."
        mn.TextColor3 = Color3.fromRGB(255, 255, 255)
        mn.Font = Enum.Font.GothamBold
        mn.TextSize = 13
        mn.TextXAlignment = Enum.TextXAlignment.Center
        local st = Instance.new("TextLabel", f)
        st.Name = "StatusLabel"
        st.Size = UDim2.new(1, -12, 0, 12)
        st.Position = UDim2.new(0, 6, 0, 38)
        st.BackgroundTransparency = 1
        st.Text = "Status: Waiting"
        st.TextColor3 = Color3.fromRGB(150, 150, 150)
        st.Font = Enum.Font.GothamMedium
        st.TextSize = 9
        st.TextXAlignment = Enum.TextXAlignment.Center
        local dragging, dStart, sPos = false, nil, nil
        f.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dStart = inp.Position; sPos = f.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if not dragging then return end
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                local d = inp.Position - dStart
                f.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        MPS.Gui = gui
    end
    function W.MapPredict_Start()
        if MPS.Enabled then return end
        MPS.Enabled = true
        build()
        MPS.Thread = task.spawn(function()
            local lastDetected, lastExisted = nil, false
            while MPS.Enabled do
                local map = Workspace:FindFirstChild("Map")
                local exists = map ~= nil
                local det = exists and detect(map) or nil
                local gui = MPS.Gui
                local frame = gui and gui:FindFirstChild("Main")
                local nl = frame and frame:FindFirstChild("MapName")
                local sl = frame and frame:FindFirstChild("StatusLabel")
                if nl and sl then
                    if lastExisted and not exists then
                        nl.Text = lastDetected or "Unknown"
                        sl.Text = "Status: Loading next map..."
                        sl.TextColor3 = Color3.fromRGB(255, 200, 50)
                    elseif exists then
                        lastDetected = det or "Unknown"
                        nl.Text = det or "Unknown"
                        sl.Text = "Status: In-Game"
                        sl.TextColor3 = Color3.fromRGB(120, 255, 120)
                    else
                        nl.Text = "Waiting..."
                        sl.Text = "Status: Lobby"
                        sl.TextColor3 = Color3.fromRGB(150, 150, 160)
                    end
                end
                lastExisted = exists
                task.wait(0.5)
            end
        end)
    end
    function W.MapPredict_Stop()
        MPS.Enabled = false
        if MPS.Thread then pcall(function() task.cancel(MPS.Thread) end); MPS.Thread = nil end
        if MPS.Gui then pcall(function() MPS.Gui:Destroy() end); MPS.Gui = nil end
    end
end

-- === BYPASS SELF UNHOOK ===
W.SU = W.SU or {
    Enabled = false, Following = false, FollowDuration = 30, FollowDistance = 20,
    MonitorConn = nil, _lastTrigger = 0, _cooldown = 3,
    _hookPos = nil, _hookCFrame = nil, _activeThread = nil, _wasHooked = false
}
local SU = W.SU

function W.SU_IsHooked()
    local c = LP.Character
    if not c then return false end
    return c:GetAttribute("IsHooked") == true or c:GetAttribute("isHooked") == true
        or c:GetAttribute("Hooked") == true or c:GetAttribute("HookedState") == true
end
function W.SU_GetGenPoint()
    local gens = W.GB_GetAllGenerators()
    if not gens or #gens == 0 then return nil end
    local v = {}
    for _, g in ipairs(gens) do
        if g and g.Parent then
            for _, p in ipairs(W.GB_GetPoints(g)) do
                if p and p.Parent then table.insert(v, p) end
            end
        end
    end
    if #v == 0 then return nil end
    return v[math.random(1, #v)]
end
function W.SU_GetKillerHRP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and TeamIs(p, "Killer") and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then return hrp end
        end
    end
    return nil
end
function W.SU_Abort()
    SU.Following = false
    if SU._activeThread and coroutine.status(SU._activeThread) ~= "dead" then
        pcall(function() task.cancel(SU._activeThread) end)
    end
    SU._activeThread = nil
end
function W.SU_Trigger()
    if SU.Following then return end
    local now = tick()
    if now - SU._lastTrigger < SU._cooldown then return end
    if not W.SU_IsHooked() then return end
    SU._lastTrigger = now; SU.Following = true
    local c = LP.Character
    if c then
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then SU._hookPos = hrp.Position; SU._hookCFrame = hrp.CFrame end
    end
    SU._activeThread = task.spawn(function()
        local cc = LP.Character
        if not cc then SU.Following = false; SU._activeThread = nil; return end
        local hrp = cc:FindFirstChild("HumanoidRootPart")
        if not hrp then SU.Following = false; SU._activeThread = nil; return end
        local re = ReplicatedStorage:FindFirstChild("Remotes")
            and ReplicatedStorage.Remotes:FindFirstChild("Generator")
            and ReplicatedStorage.Remotes.Generator:FindFirstChild("RepairEvent")
        if not W.SU_IsHooked() then SU.Following = false; SU._activeThread = nil; return end
        local tp = W.SU_GetGenPoint()
        if tp then
            pcall(function() hrp.Velocity = Vector3.zero; hrp.CFrame = tp.CFrame + Vector3.new(0, 3, 0) end)
            task.wait(0.15)
            if re then
                pcall(function() re:FireServer(tp, true) end); task.wait(0.35)
                pcall(function() re:FireServer(tp, false) end); task.wait(0.15)
                pcall(function() re:FireServer(tp, true) end); task.wait(0.35)
                pcall(function() re:FireServer(tp, false) end)
            end
        end
        local fUntil = tick() + (SU.FollowDuration or 30)
        local bOff = SU.FollowDistance or 20
        while tick() < fUntil and SU.Enabled do
            if not W.SU_IsHooked() then
                SU.Following = false; SU._activeThread = nil
                W.W2_Notify("Self Unhook", "Released - STOP", 2)
                return
            end
            local c2 = LP.Character
            if not c2 then break end
            local r = c2:FindFirstChild("HumanoidRootPart")
            if not r then break end
            local khrp = W.SU_GetKillerHRP()
            if khrp then
                pcall(function()
                    r.Velocity = Vector3.zero
                    local tPos = Vector3.new(khrp.Position.X, khrp.Position.Y - bOff, khrp.Position.Z)
                    r.CFrame = CFrame.new(tPos, tPos + Vector3.new(0, 0, -1))
                end)
            end
            task.wait(0.03)
        end
        if W.SU_IsHooked() then
            local c3 = LP.Character
            if c3 then
                local r2 = c3:FindFirstChild("HumanoidRootPart")
                if r2 then
                    if SU._hookCFrame then pcall(function() r2.Velocity = Vector3.zero; r2.CFrame = SU._hookCFrame end)
                    elseif SU._hookPos then pcall(function() r2.Velocity = Vector3.zero; r2.CFrame = CFrame.new(SU._hookPos + Vector3.new(0, 3, 0)) end) end
                end
            end
        end
        SU.Following = false; SU._activeThread = nil
    end)
end
function W.SU_Start()
    if SU.MonitorConn then return end
    SU._wasHooked = false
    SU.MonitorConn = RunService.Heartbeat:Connect(function()
        if not SU.Enabled then return end
        local c = LP.Character
        if not c then return end
        local isH = W.SU_IsHooked()
        if not isH then SU._wasHooked = false; return end
        if not SU._wasHooked and not SU.Following then SU._wasHooked = true; W.SU_Trigger() end
    end)
end
function W.SU_Stop()
    if SU.MonitorConn then SU.MonitorConn:Disconnect(); SU.MonitorConn = nil end
    W.SU_Abort(); SU._wasHooked = false
end
function W.SU_Set(v)
    W2.SelfUnhook_Enabled = v
    SU.Enabled = v
    if v then W.SU_Start() else W.SU_Stop() end
end

-- === SILENT AIM TOF ===
local ToFState = {
    Conn = nil, Laser = nil, InputBegan = nil, InputEnded = nil,
    TouchInput = nil, IsAiming = false, SCPCache = {}, SCPCacheTimer = 0
}
local ToFKeys = { None=nil, Q=Enum.KeyCode.Q, E=Enum.KeyCode.E, R=Enum.KeyCode.R, T=Enum.KeyCode.T, F=Enum.KeyCode.F, G=Enum.KeyCode.G, H=Enum.KeyCode.H, J=Enum.KeyCode.J, K=Enum.KeyCode.K, L=Enum.KeyCode.L, X=Enum.KeyCode.X, Z=Enum.KeyCode.Z }

local function ToF_Downed(c)
    if not c then return true end
    local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return true end
    local h = c:FindFirstChildOfClass("Humanoid"); if h and h.Health <= 0 then return true end
    if c:GetAttribute("Knocked") == true then return true end
    if c:GetAttribute("IsHooked") == true then return true end
    if c:GetAttribute("IsCarried") == true then return true end
    return false
end
local function ToF_Blocked()
    if W2.TOF_BlockKnocked == false then return false end
    local c = LP.Character
    if not c then return true end
    return ToF_Downed(c)
end
local function ToF_GetEvent()
    local r = ReplicatedStorage:FindFirstChild("Remotes")
    local i = r and r:FindFirstChild("Items")
    local t = i and i:FindFirstChild("Twist of Fate")
    local f = t and t:FindFirstChild("Fire")
    if f and f:IsA("RemoteEvent") then return f end
    return nil
end
local function ToF_GetGun()
    local c = LP.Character
    if not c then return nil end
    local b = c:FindFirstChild("Twist of Fate", true)
    if not b then return nil end
    local ra = b:FindFirstChild("Right Arm")
    if ra then
        local g = ra:FindFirstChild("gun"); if g then return g end
        local e = ra:FindFirstChild("EmperorGun"); if e then return e end
    end
    return b
end
local function ToF_Visible(op, tp, tc)
    local d = tp - op
    local dist = d.Magnitude
    if dist < 0.1 then return true end
    local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude
    local ex = {}
    local lc = LP.Character
    if lc then table.insert(ex, lc) end
    if tc and tc ~= lc then table.insert(ex, tc) end
    if ToFState.Laser then table.insert(ex, ToFState.Laser) end
    rp.FilterDescendantsInstances = ex
    return workspace:Raycast(op, d.Unit * dist, rp) == nil
end
local function ToF_GetSCPs()
    if tick() - ToFState.SCPCacheTimer < 0.5 then return ToFState.SCPCache end
    local nt = {}
    local mf = workspace:FindFirstChild("Map")
    if mf then
        for _, c in pairs(mf:GetDescendants()) do
            if c:IsA("Model") then
                local a = c:GetAttributes()
                if c:GetAttribute("CorpseCreated0492") or next(a) ~= nil then
                    local r = c:FindFirstChild("HumanoidRootPart"); if r then table.insert(nt, r) end
                end
            end
        end
    end
    ToFState.SCPCache = nt; ToFState.SCPCacheTimer = tick()
    return nt
end
local function ToF_GetTarget()
    local g = ToF_GetGun(); local c = LP.Character
    if not (g and c) then return nil,nil,nil,nil end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil,nil,nil,nil end
    local mp = hrp.Position
    local op
    if c:GetAttribute("IsCarried") then
        op = hrp.Position + (hrp.CFrame.LookVector * 2)
    else
        pcall(function() op = g:IsA("BasePart") and g.Position or (g:FindFirstChildOfClass("BasePart") and g:FindFirstChildOfClass("BasePart").Position) end)
        op = op or Vector3.new(mp.X, mp.Y + 1.5, mp.Z)
    end
    local function predict(t, tc)
        local tp = t.Position
        if W2.TOF_WallCheck and not ToF_Visible(op, tp, tc) then return nil,nil,nil,nil end
        local tv = Vector3.new(0,0,0)
        local rp = tc and (tc:FindFirstChild("HumanoidRootPart") or t)
        if rp then tv = rp.Velocity end
        local dr = tp - op
        local d = dr.Magnitude
        if d < 0.1 then return nil,nil,nil,nil end
        if d < 5 then return dr.Unit, g, op, tp end
        local tt = d / 400
        local pp = tp + (tv * tt)
        for _ = 1, 2 do local nd = (pp - op).Magnitude; tt = nd/400; pp = tp + (tv*tt) end
        local fd = pp - op
        if fd.Magnitude < 0.1 then return nil,nil,nil,nil end
        return fd.Unit, g, op, pp
    end
    local mode = W2.TOF_TargetMode or "Killer"
    if mode == "Killer" then
        local bt, bc, bs = nil, nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and TeamIs(p, "Killer") and p.Character then
                local t = p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("HumanoidRootPart")
                if t then local d = (mp - t.Position).Magnitude; if d < bs then bs = d; bt = t; bc = p.Character end end
            end
        end
        if not bt then return nil,nil,nil,nil end
        return predict(bt, bc)
    elseif mode == "Survivors" then
        local bt, bc, bd = nil, nil, -math.huge
        local cam = workspace.CurrentCamera
        local cl = cam.CFrame.LookVector
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and TeamIs(p, "Survivor") and p.Character then
                local t = p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("HumanoidRootPart")
                if t then
                    local dt = t.Position - cam.CFrame.Position
                    if dt.Magnitude > 0.1 then
                        local dot = cl:Dot(dt.Unit)
                        if dot > 0.5 and dot > bd then bd = dot; bt = t; bc = p.Character end
                    end
                end
            end
        end
        if not bt then return nil,nil,nil,nil end
        return predict(bt, bc)
    elseif mode == "Zombie" then
        local bp, bd = nil, -math.huge
        local cam = workspace.CurrentCamera
        local cl = cam.CFrame.LookVector
        for _, r in ipairs(ToF_GetSCPs()) do
            if r and r.Parent then
                local dt = r.Position - cam.CFrame.Position
                if dt.Magnitude > 0.1 then
                    local dot = cl:Dot(dt.Unit)
                    if dot > 0.5 and dot > bd then bd = dot; bp = r end
                end
            end
        end
        if not bp then return nil,nil,nil,nil end
        return predict(bp, bp.Parent)
    end
    return nil,nil,nil,nil
end
local function ToF_UpdateLaser(op, tp)
    if not ToFState.Laser then
        local l = Instance.new("Part")
        l.Name = "W2ToFLaser"; l.Anchored = true; l.CanCollide = false
        l.CanTouch = false; l.CastShadow = false
        l.Material = Enum.Material.Neon
        l.Color = Color3.fromRGB(255, 255, 255)
        l.Parent = workspace
        ToFState.Laser = l
    end
    local d = (tp - op).Magnitude
    ToFState.Laser.Size = Vector3.new(0.05, 0.05, d)
    ToFState.Laser.CFrame = CFrame.new((op + tp) / 2, tp)
    ToFState.Laser.Transparency = 0
end
local function ToF_ClearLaser()
    if ToFState.Laser then pcall(function() ToFState.Laser:Destroy() end); ToFState.Laser = nil end
end
local function ToF_MobileBtn()
    local pg = LP:FindFirstChild("PlayerGui")
    local sm = pg and pg:FindFirstChild("Survivor-mob")
    local ct = sm and sm:FindFirstChild("Controls")
    local gm = ct and ct:FindFirstChild("Gui-mob")
    if not gm then return nil end
    for _, n in ipairs({"attack","Attack","shoot","Shoot","fire","Fire"}) do
        local b = gm:FindFirstChild(n, true)
        if b and b:IsA("GuiObject") then return b end
    end
    for _, o in ipairs(gm:GetDescendants()) do
        if o:IsA("GuiButton") and o.Visible then return o end
    end
    return gm:IsA("GuiObject") and gm or nil
end
local function ToF_IsTouchShoot(inp)
    local sb = ToF_MobileBtn()
    if not (sb and sb.Visible) then return false end
    local p = inp.Position
    local ap = sb.AbsolutePosition
    local az = sb.AbsoluteSize
    return p.X >= ap.X and p.X <= ap.X + az.X and p.Y >= ap.Y and p.Y <= ap.Y + az.Y
end
local function ToF_Shoot()
    if not W2.TOF_Enabled then return end
    if ToF_Blocked() then return end
    local td, g, op, tp = ToF_GetTarget()
    if not (td and g and tp and op) then return end
    local e = ToF_GetEvent()
    if not e then return end
    local fd = tp - op
    if fd.Magnitude < 0.1 then return end
    pcall(function() e:FireServer(g, fd.Unit) end)
end
local function ToF_SetMode(mode, notify)
    if mode ~= "Killer" and mode ~= "Survivors" and mode ~= "Zombie" then return end
    W2.TOF_TargetMode = mode
    if notify then W.W2_Notify("ToF Target", mode, 1) end
end
local function ToF_StartConn()
    if ToFState.Conn then return end
    ToFState.Conn = RunService.Heartbeat:Connect(function()
        if ToF_Blocked() then
            ToFState.IsAiming = false
            if ToFState.TouchInput then ToFState.TouchInput = nil end
            if ToFState.Laser then ToFState.Laser.Transparency = 1 end
            return
        end
        if not W2.TOF_Enabled or not ToFState.IsAiming then
            if ToFState.Laser then ToFState.Laser.Transparency = 1 end
            return
        end
        local _, _, op, tp = ToF_GetTarget()
        if op and tp then
            pcall(function()
                local c = LP.Character
                local hrp = c and c:FindFirstChild("HumanoidRootPart")
                if hrp and not c:GetAttribute("IsCarried") then
                    hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(tp.X, hrp.Position.Y, tp.Z))
                end
            end)
            if W2.TOF_Laser then ToF_UpdateLaser(op, tp)
            elseif ToFState.Laser then ToFState.Laser.Transparency = 1 end
        elseif ToFState.Laser then ToFState.Laser.Transparency = 1 end
    end)
end
local function ToF_StopConn()
    if ToFState.Conn then pcall(function() ToFState.Conn:Disconnect() end); ToFState.Conn = nil end
    ToFState.IsAiming = false
    ToF_ClearLaser()
end
local SetToFEnabled
local function ToF_EnsureInputs()
    if not ToFState.InputBegan then
        ToFState.InputBegan = UserInputService.InputBegan:Connect(function(inp, gp)
            if gp then return end
            local k = ToFKeys[W2.TOF_Key or "None"]
            if k and inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == k then
                SetToFEnabled(not W2.TOF_Enabled)
                return
            end
            if not W2.TOF_Enabled then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or (inp.UserInputType == Enum.UserInputType.Touch and ToF_IsTouchShoot(inp)) then
                if ToF_Blocked() then ToFState.IsAiming = false; return end
                ToFState.IsAiming = true
                if inp.UserInputType == Enum.UserInputType.Touch then ToFState.TouchInput = inp end
                return
            end
            if inp.UserInputType == Enum.UserInputType.Keyboard then
                if inp.KeyCode == Enum.KeyCode.K then ToF_SetMode("Killer", true)
                elseif inp.KeyCode == Enum.KeyCode.J then ToF_SetMode("Survivors", true)
                elseif inp.KeyCode == Enum.KeyCode.L then ToF_SetMode("Zombie", true) end
            end
        end)
    end
    if not ToFState.InputEnded then
        ToFState.InputEnded = UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or (inp.UserInputType == Enum.UserInputType.Touch and inp == ToFState.TouchInput) then
                local wa = ToFState.IsAiming
                ToFState.IsAiming = false
                if inp == ToFState.TouchInput then ToFState.TouchInput = nil end
                if ToFState.Laser then ToFState.Laser.Transparency = 1 end
                if wa then
                    if ToF_Blocked() then return end
                    ToF_Shoot()
                end
            end
        end)
    end
end
SetToFEnabled = function(en)
    W2.TOF_Enabled = en and true or false
    ToF_EnsureInputs()
    if W2.TOF_Enabled then ToF_StartConn()
    else ToF_StopConn() end
end
W.SetToFEnabled = SetToFEnabled
W.ToF_SetMode = ToF_SetMode
ToF_EnsureInputs()

-- === SILENT FLASHLIGHT ===
do
    local FS = { Active = false, Laser = nil, Part = nil, Conn = nil, Hooked = false }
    local function actRemote()
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        local i = r and r:FindFirstChild("Items")
        local f = i and i:FindFirstChild("Flashlight")
        local a = f and f:FindFirstChild("Activate")
        if a and a:IsA("RemoteEvent") then return a end
        return nil
    end
    local function targetPart(char)
        if not char then return nil end
        local p = char:FindFirstChild(W2.Flash_TargetPart or "Head")
        if p and p:IsA("BasePart") then return p end
        return char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    end
    local function alive(char)
        local h = char and char:FindFirstChildOfClass("Humanoid")
        if not h or h.Health <= 0 then return false end
        return char:GetAttribute("State") ~= "Dead"
    end
    local function getTarget()
        local c = LP.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local maxR = tonumber(W2.Flash_Range) or 120
        local best, bd = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and alive(p.Character) and TeamIs(p, "Killer") then
                local pt = targetPart(p.Character)
                if pt then
                    local d = (root.Position - pt.Position).Magnitude
                    if d <= maxR and d < bd then bd = d; best = pt end
                end
            end
        end
        return best
    end
    local function clearLaser()
        if FS.Laser then pcall(function() FS.Laser:Destroy() end); FS.Laser = nil end
    end
    local function getOrigin(cam)
        if FS.Part and FS.Part:IsA("BasePart") then return FS.Part.Position end
        local c = LP.Character
        local hand = c and (c:FindFirstChild("RightHand") or c:FindFirstChild("Right Arm") or c:FindFirstChild("HumanoidRootPart"))
        if hand and hand:IsA("BasePart") then return hand.Position end
        return cam and cam.CFrame.Position or nil
    end
    local function updateLaser(op, tp)
        if not FS.Laser then
            local l = Instance.new("Part")
            l.Name = "W2FlashLaser"; l.Anchored = true; l.CanCollide = false
            l.CanTouch = false; l.CanQuery = false; l.CastShadow = false
            l.Material = Enum.Material.Neon
            l.Color = Color3.fromRGB(255, 255, 255)
            l.Parent = Workspace
            FS.Laser = l
        end
        local d = (tp - op).Magnitude
        if d < 0.1 then return end
        FS.Laser.Size = Vector3.new(0.16, 0.16, d)
        FS.Laser.CFrame = CFrame.new((op + tp) / 2, tp)
        FS.Laser.Transparency = 0.35
    end
    local function step()
        if not (W2.Flash_Enabled and FS.Active) then
            if FS.Laser then FS.Laser.Transparency = 1 end
            return
        end
        local cam = Workspace.CurrentCamera
        local tp = getTarget()
        if not (cam and tp) then
            if FS.Laser then FS.Laser.Transparency = 1 end
            return
        end
        local smooth = math.clamp(tonumber(W2.Flash_Smooth) or 0.35, 0.05, 1)
        local op = getOrigin(cam)
        if op then pcall(updateLaser, op, tp.Position)
        elseif FS.Laser then FS.Laser.Transparency = 1 end
        pcall(function() cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, tp.Position), smooth) end)
        pcall(function()
            local c = LP.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(tp.Position.X, hrp.Position.Y, tp.Position.Z)) end
        end)
    end
    local function start()
        if FS.Conn then return end
        FS.Conn = RunService.RenderStepped:Connect(function() pcall(step) end)
    end
    local function stop()
        FS.Active = false; FS.Part = nil
        clearLaser()
        if FS.Conn then pcall(function() FS.Conn:Disconnect() end); FS.Conn = nil end
    end
    function W.Flash_Set(v)
        W2.Flash_Enabled = v and true or false
        if v then start() else stop() end
    end
    function W.Flash_SetActive(active, part)
        FS.Active = active and true or false
        if FS.Active and part then FS.Part = part
        elseif not FS.Active then FS.Part = nil end
        if not FS.Active and FS.Laser then FS.Laser.Transparency = 1 end
    end
    task.spawn(function()
        pcall(function()
            local r = actRemote()
            if not r then return end
            if typeof(hookmetamethod) ~= "function" or FS.Hooked then return end
            FS.Hooked = true
            -- PENTING: hook Flashlight Activate di-handle PART 16 (hook global)
            -- Cuma set flag di sini, hook digabung di PART 16
        end)
    end)
end

-- === AIM LOCK GUN ===
do
    local GA = {
        Enabled = false, Holding = false, TargetMode = "Killer",
        Strength = 0.5, Predict = true, PredictStrength = 0.12,
        FOV = 250, VisCheck = true,
        AimPart = "HumanoidRootPart", Target = nil,
    }
    local Conn = nil
    local CurrBtn = nil
    local function visible(part)
        local cam = Workspace.CurrentCamera
        if not cam then return true end
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = { LP.Character }
        local o = cam.CFrame.Position
        local d = part.Position - o
        local res = Workspace:Raycast(o, d, rp)
        if not res then return true end
        return res.Instance:IsDescendantOf(part.Parent)
    end
    local function getBtn()
        local cur = LP:FindFirstChild("PlayerGui")
        for s in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
            cur = cur and cur:FindFirstChild(s)
        end
        return cur
    end
    local function closest()
        local cam = Workspace.CurrentCamera
        if not cam then return nil end
        local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
        local best, bd = nil, GA.FOV
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Team then
                local valid = false
                if GA.TargetMode == "Killer" and string.find(string.lower(p.Team.Name), "killer", 1, true) then valid = true
                elseif GA.TargetMode == "Survivor" and string.find(string.lower(p.Team.Name), "survivor", 1, true) then valid = true end
                if valid then
                    local hrp = p.Character:FindFirstChild(GA.AimPart)
                    local h = p.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and h and h.Health > 0 then
                        local pos, on = cam:WorldToViewportPoint(hrp.Position)
                        if on then
                            local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                            if d < bd then
                                if GA.VisCheck and not visible(hrp) then continue end
                                bd = d; best = hrp
                            end
                        end
                    end
                end
            end
        end
        return best
    end
    local function start()
        if Conn then return end
        Conn = RunService.RenderStepped:Connect(function()
            if not GA.Enabled or not GA.Holding then GA.Target = nil; return end
            local t = closest()
            if not t then return end
            GA.Target = t
            local pos = t.Position
            if GA.Predict then pos = pos + (t.AssemblyLinearVelocity * GA.PredictStrength) end
            local cam = Workspace.CurrentCamera
            cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, pos), GA.Strength)
        end)
    end
    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton2 and GA.Enabled then
            GA.Holding = true
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton2 then GA.Holding = false end
    end)
    task.spawn(function()
        while true do
            task.wait(1)
            local b = getBtn()
            if b and b ~= CurrBtn then
                CurrBtn = b
                b.InputBegan:Connect(function(inp)
                    if (inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton2) and GA.Enabled then
                        GA.Holding = true
                    end
                end)
                b.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton2 then
                        GA.Holding = false
                    end
                end)
            end
        end
    end)
    W.GunAim_Start = start
    W.GunAim_Cfg = GA
end

-- === MOONWALK ===
do
    local sideSpd = 0.9
    local backSpd = 1.2
    local interval = 0.07
    local enabled = false
    local conn = nil
    local function stop()
        if conn then conn:Disconnect(); conn = nil end
    end
    local function start()
        stop()
        local c = LP.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        local h = c:FindFirstChildOfClass("Humanoid")
        if not hrp or not h then return end
        local lastSwitch = 0
        local dir = 1
        conn = RunService.RenderStepped:Connect(function()
            if not enabled then return end
            local cc = LP.Character
            if not cc then return end
            local chrp = cc:FindFirstChild("HumanoidRootPart")
            local chum = cc:FindFirstChildOfClass("Humanoid")
            if not chrp or not chum or chum.Health <= 0 then return end
            local now = tick()
            if now - lastSwitch >= interval then
                dir = dir * -1
                lastSwitch = now
            end
            local back = chrp.CFrame.LookVector * -backSpd
            local side = chrp.CFrame.RightVector * (dir * sideSpd)
            chum:Move(back + side, false)
        end)
    end
    function W.Moonwalk_Set(state)
        W2.Moonwalk_Enabled = state
        enabled = state
        if state then start() else stop() end
    end
    function W.Moonwalk_SetSide(v) sideSpd = v; W2.Moonwalk_SideSpeed = v end
    function W.Moonwalk_SetBack(v) backSpd = v; W2.Moonwalk_BackSpeed = v end
    function W.Moonwalk_SetInterval(v) interval = v; W2.Moonwalk_Interval = v end
    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.KeyCode == Enum.KeyCode.F8 then W.Moonwalk_Set(not enabled) end
    end)
    LP.CharacterAdded:Connect(function()
        task.wait(2)
        if enabled then start() end
    end)
end

-- === UI SECTION ===
do
    local s = W.T_Surv:AddSection("Next Map Prediction")
    s:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
        if v then W.MapPredict_Start() else W.MapPredict_Stop() end
        W.W2_Notify("Map Predict", v and "Enabled" or "Disabled", 2)
    end })

    local s2 = W.T_Surv:AddSection("Bypass Self Unhook")
    s2:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
        W.SU_Set(v)
        W.W2_Notify("Self Unhook", v and "Enabled" or "Disabled", 2)
    end })
    s2:AddSlider({ Title = "Follow Duration", Min = 5, Max = 120, Default = 30, Increment = 5, Suffix = "s",
        Callback = function(v) SU.FollowDuration = v end })
    s2:AddSlider({ Title = "Follow Distance", Min = 5, Max = 60, Default = 20, Increment = 1, Suffix = " studs",
        Callback = function(v) SU.FollowDistance = v end })

    local s3 = W.T_Surv:AddSection("Silent Aim TOF")
    s3:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
        W.SetToFEnabled(v)
        W.W2_Notify("Silent Aim TOF", v and "Enabled" or "Disabled", 2)
    end })
    s3:AddKeybind({ Title = "Toggle Key", Default = Enum.KeyCode.Q,
        Callback = function(kc) W2.TOF_Key = kc and kc.Name or "None" end })
    s3:AddDropdown({ Title = "Target Mode", Options = { "Killer", "Survivors", "Zombie" }, Default = "Killer",
        Callback = function(v) W.ToF_SetMode(v, true) end })
    s3:AddToggle({ Title = "Show Laser", Default = true, Callback = function(v) W2.TOF_Laser = v end })
    s3:AddToggle({ Title = "Wall Check", Default = true, Callback = function(v) W2.TOF_WallCheck = v end })
    s3:AddToggle({ Title = "Block When Knocked", Default = true, Callback = function(v) W2.TOF_BlockKnocked = v end })

    local s4 = W.T_Surv:AddSection("Silent Flashlight")
    s4:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
        W.Flash_Set(v)
        W.W2_Notify("Silent Flashlight", v and "Enabled" or "Disabled", 2)
    end })
    s4:AddDropdown({ Title = "Target Part", Options = {"Head","UpperTorso","Torso","HumanoidRootPart"}, Default = "Head",
        Callback = function(v) W2.Flash_TargetPart = type(v) == "table" and v[1] or v or "Head" end })
    s4:AddSlider({ Title = "Max Range", Min = 20, Max = 250, Default = 120, Increment = 5, Suffix = " studs",
        Callback = function(v) W2.Flash_Range = v end })
    s4:AddSlider({ Title = "Smoothness", Min = 0.05, Max = 1, Default = 0.35, Increment = 0.05,
        Callback = function(v) W2.Flash_Smooth = v end })

    local s5 = W.T_Surv:AddSection("Aim Lock Gun")
    s5:AddToggle({ Title = "Enable (Hold M2)", Default = false, Callback = function(v)
        if W.GunAim_Cfg then W.GunAim_Cfg.Enabled = v end
        if v and W.GunAim_Start then W.GunAim_Start() end
        W.W2_Notify("Aim Lock Gun", v and "Enabled" or "Disabled", 2)
    end })
    s5:AddDropdown({ Title = "Target Mode", Options = {"Killer","Survivor"}, Default = "Killer",
        Callback = function(v)
            local val = type(v) == "table" and v[1] or v
            if W.GunAim_Cfg then W.GunAim_Cfg.TargetMode = val end
        end })
    s5:AddSlider({ Title = "FOV Radius", Min = 50, Max = 1000, Default = 250, Increment = 10,
        Callback = function(v) if W.GunAim_Cfg then W.GunAim_Cfg.FOV = v end end })

    local s6 = W.T_Surv:AddSection("Moonwalk")
    s6:AddToggle({ Title = "Enable (F8)", Default = false, Callback = function(v)
        W.Moonwalk_Set(v)
        W.W2_Notify("Moonwalk", v and "Enabled" or "Disabled", 2)
    end })
    s6:AddSlider({ Title = "Side Speed", Min = 0.1, Max = 3, Default = 0.9, Increment = 0.1,
        Callback = function(v) W.Moonwalk_SetSide(v) end })
    s6:AddSlider({ Title = "Back Speed", Min = 0.1, Max = 3, Default = 1.2, Increment = 0.1,
        Callback = function(v) W.Moonwalk_SetBack(v) end })
    s6:AddSlider({ Title = "Switch Interval", Min = 0.02, Max = 0.5, Default = 0.07, Increment = 0.01,
        Callback = function(v) W.Moonwalk_SetInterval(v) end })
                        end--====================================================--
-- PART 8: VISUALS — FULL ESP + ESP STATUS
--====================================================--

W.FullESP = W.FullESP or {
    Survivor = false, Killer = false,
    Generator = false, Pallet = false, Window = false, SCP = false,
    Distance = 500,
}
W.FullESPStatus = W.FullESPStatus or {
    Enabled = false,
    ShowName = true, ShowDistance = true, ShowHealth = false,
    ShowAvatar = true, ShowAction = true, Radius = 500,
}
W.FullESPColors = W.FullESPColors or {
    Survivor = Color3.fromRGB(0, 190, 255), Killer = Color3.fromRGB(255, 0, 0),
    Generator = Color3.fromRGB(255, 255, 0), Window = Color3.fromRGB(255, 255, 255),
    Pallet = Color3.fromRGB(255, 165, 0), SCP = Color3.fromRGB(0, 255, 0),
}
local FESP = W.FullESP
local FESPS = W.FullESPStatus
local FESPC = W.FullESPColors

do
    local ESPObjects = {}
    local StatusESP = {}
    local CachedSCP, CachedGen, CachedPallet = {}, {}, {}
    local WindowObjects = {}

    local function cache(obj)
        if not obj then return end
        local ln = string.lower(obj.Name)
        if ln:find("scp", 1, true) then CachedSCP[obj] = true end
        if obj.Name == "Generator" then CachedGen[obj] = true
        elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then CachedPallet[obj] = true end
    end
    for _, o in ipairs(Workspace:GetDescendants()) do cache(o) end
    Workspace.DescendantAdded:Connect(cache)
    Workspace.DescendantRemoving:Connect(function(o)
        CachedSCP[o] = nil; CachedGen[o] = nil; CachedPallet[o] = nil
        if ESPObjects[o] then pcall(function() ESPObjects[o]:Destroy() end); ESPObjects[o] = nil end
        if StatusESP[o] then pcall(function() StatusESP[o]:Destroy() end); StatusESP[o] = nil end
    end)

    local function removeESP(obj)
        if not obj then return end
        if ESPObjects[obj] then pcall(function() ESPObjects[obj]:Destroy() end); ESPObjects[obj] = nil end
    end

    local function createESP(obj, color)
        if not obj or not obj.Parent then return end
        if ESPObjects[obj] then
            ESPObjects[obj].FillColor = color
            ESPObjects[obj].OutlineColor = color
            return
        end
        local h = Instance.new("Highlight")
        h.FillColor = color; h.OutlineColor = color
        h.FillTransparency = 0.9; h.OutlineTransparency = 0.3
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = obj
        ESPObjects[obj] = h
        obj.AncestryChanged:Connect(function(_, p) if not p then removeESP(obj) end end)
    end

    local function removeStatus(char)
        if StatusESP[char] then pcall(function() StatusESP[char]:Destroy() end); StatusESP[char] = nil end
    end

    local function getAction(char, hum)
        if not char or not hum then return "IDLE", Color3.fromRGB(150, 150, 150) end
        if hum.Health <= 0 then return "DEAD", Color3.fromRGB(200, 60, 60) end
        if char:GetAttribute("IsHooked") or char:GetAttribute("isHooked") or char:GetAttribute("Hooked") then
            return "HOOKED", Color3.fromRGB(255, 60, 60)
        end
        if char:GetAttribute("IsCarried") or char:GetAttribute("isCarried") or char:GetAttribute("Carried") then
            return "CARRIED", Color3.fromRGB(255, 100, 100)
        end
        local st = char:GetAttribute("State")
        if st == "Downed" or char:GetAttribute("Knocked") == true or char:GetAttribute("IsDown") == true or char:GetAttribute("Downed") == true then
            return "DOWNED", Color3.fromRGB(255, 130, 60)
        end
        local ci = char:FindFirstChild("CheckInterractable")
        if ci then
            if ci:GetAttribute("isRepairing") then return "REPAIR", Color3.fromRGB(255, 220, 60) end
            if ci:GetAttribute("isHealing") then return "HEAL", Color3.fromRGB(80, 220, 120) end
            if ci:GetAttribute("isVaulting") then return "VAULT", Color3.fromRGB(120, 200, 255) end
            if ci:GetAttribute("isSliding") then return "SLIDE", Color3.fromRGB(150, 180, 255) end
            if ci:GetAttribute("isDroppingPallet") then return "PALLET", Color3.fromRGB(255, 165, 60) end
            if ci:GetAttribute("isUnhooking") then return "UNHOOK", Color3.fromRGB(180, 120, 255) end
            if ci:GetAttribute("isExiting") then return "EXIT", Color3.fromRGB(80, 255, 180) end
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local v = root.AssemblyLinearVelocity
            local sp = Vector3.new(v.X, 0, v.Z).Magnitude
            if sp > 20 then return "SPRINT", Color3.fromRGB(120, 255, 200) end
            if sp > 2 then return "MOVE", Color3.fromRGB(200, 200, 220) end
        end
        return "IDLE", Color3.fromRGB(150, 150, 150)
    end

    local function createStatus(plr, char, root)
        if not FESPS.Enabled then removeStatus(char); return end
        if not root then return end
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not head or not hum then return end
        local isDown = hum.Health <= 0 or hum.Health < 2 or char:GetAttribute("Downed") == true
            or char:GetAttribute("IsDown") == true or char:GetAttribute("Knocked") == true
        local dist = (head.Position - root.Position).Magnitude
        if dist > FESPS.Radius then removeStatus(char); return end
        local accent = Color3.fromRGB(255, 255, 255)
        if TeamIs(plr, "Killer") then accent = FESPC.Killer
        elseif TeamIs(plr, "Survivor") then accent = FESPC.Survivor end
        if isDown then accent = Color3.fromRGB(255, 60, 60) end
        local hpPct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
        local hpCol
        if hpPct > 0.6 then hpCol = Color3.fromRGB(80, 220, 120)
        elseif hpPct > 0.3 then hpCol = Color3.fromRGB(255, 200, 60)
        else hpCol = Color3.fromRGB(255, 80, 80) end
        local act, actCol = getAction(char, hum)
        local bb = StatusESP[char]
        if not bb or not bb.Parent then
            bb = Instance.new("BillboardGui")
            bb.Name = "W2StatusESP"
            bb.AlwaysOnTop = true
            bb.LightInfluence = 0
            bb.Adornee = head
            bb.StudsOffset = Vector3.new(0, 2.5, 0)
            bb.Size = UDim2.fromOffset(260, 40)
            bb.Parent = char
            local scale = Instance.new("UIScale")
            scale.Name = "DistScale"; scale.Scale = 1; scale.Parent = bb
            local nLbl = Instance.new("TextLabel")
            nLbl.Name = "NameLbl"
            nLbl.BackgroundTransparency = 1
            nLbl.Size = UDim2.new(1, 0, 0, 16)
            nLbl.Position = UDim2.new(0, 0, 0, 0)
            nLbl.Font = Enum.Font.GothamBold
            nLbl.TextSize = 13
            nLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            nLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            nLbl.TextStrokeTransparency = 0.2
            nLbl.TextXAlignment = Enum.TextXAlignment.Center
            nLbl.TextYAlignment = Enum.TextYAlignment.Center
            nLbl.TextTruncate = Enum.TextTruncate.AtEnd
            nLbl.Parent = bb
            local pill = Instance.new("Frame")
            pill.Name = "Pill"
            pill.AnchorPoint = Vector2.new(0.5, 0)
            pill.Position = UDim2.new(0.5, 0, 0, 18)
            pill.Size = UDim2.fromOffset(120, 22)
            pill.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
            pill.BackgroundTransparency = 0.15
            pill.BorderSizePixel = 0
            pill.Parent = bb
            Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
            local ps = Instance.new("UIStroke", pill)
            ps.Name = "PillStroke"; ps.Color = accent; ps.Thickness = 1; ps.Transparency = 0.5
            ps.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local lay = Instance.new("UIListLayout", pill)
            lay.FillDirection = Enum.FillDirection.Horizontal
            lay.Padding = UDim.new(0, 5)
            lay.SortOrder = Enum.SortOrder.LayoutOrder
            lay.VerticalAlignment = Enum.VerticalAlignment.Center
            lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
            local pad = Instance.new("UIPadding", pill)
            pad.PaddingLeft = UDim.new(0, 6); pad.PaddingRight = UDim.new(0, 8)
            local avH = Instance.new("Frame")
            avH.Name = "AvatarHolder"
            avH.Size = UDim2.fromOffset(18, 18)
            avH.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
            avH.BorderSizePixel = 0
            avH.LayoutOrder = 1
            avH.ClipsDescendants = true
            avH.Parent = pill
            Instance.new("UICorner", avH).CornerRadius = UDim.new(1, 0)
            local avS = Instance.new("UIStroke", avH)
            avS.Name = "AvatarStroke"; avS.Color = accent; avS.Thickness = 1.2; avS.Transparency = 0.3
            avS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local avImg = Instance.new("ImageLabel")
            avImg.Name = "AvatarImg"
            avImg.Size = UDim2.fromScale(1, 1)
            avImg.BackgroundTransparency = 1
            avImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
            avImg.Parent = avH
            local dot = Instance.new("Frame")
            dot.Name = "Dot"
            dot.Size = UDim2.fromOffset(7, 7)
            dot.BackgroundColor3 = accent
            dot.BorderSizePixel = 0
            dot.LayoutOrder = 1
            dot.Visible = false
            dot.Parent = pill
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
            local distLbl = Instance.new("TextLabel")
            distLbl.Name = "DistLbl"
            distLbl.BackgroundTransparency = 1
            distLbl.Size = UDim2.fromOffset(32, 14)
            distLbl.Font = Enum.Font.GothamBold
            distLbl.TextSize = 11
            distLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
            distLbl.Text = "0m"
            distLbl.LayoutOrder = 2
            distLbl.Parent = pill
            local actLbl = Instance.new("TextLabel")
            actLbl.Name = "ActionLbl"
            actLbl.BackgroundTransparency = 1
            actLbl.Size = UDim2.fromOffset(50, 14)
            actLbl.Font = Enum.Font.GothamBold
            actLbl.TextSize = 10
            actLbl.TextColor3 = actCol
            actLbl.Text = "IDLE"
            actLbl.LayoutOrder = 3
            actLbl.Parent = pill
            local hpBg = Instance.new("Frame")
            hpBg.Name = "HPBarBg"
            hpBg.Size = UDim2.fromOffset(38, 4)
            hpBg.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            hpBg.BorderSizePixel = 0
            hpBg.LayoutOrder = 4
            hpBg.Parent = pill
            Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)
            local hpFill = Instance.new("Frame")
            hpFill.Name = "HPBarFill"
            hpFill.Size = UDim2.new(1, 0, 1, 0)
            hpFill.BackgroundColor3 = hpCol
            hpFill.BorderSizePixel = 0
            hpFill.Parent = hpBg
            Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)
            local downP = Instance.new("Frame")
            downP.Name = "DownPill"
            downP.Size = UDim2.fromOffset(36, 14)
            downP.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            downP.BackgroundTransparency = 0.1
            downP.BorderSizePixel = 0
            downP.Visible = false
            downP.LayoutOrder = 5
            downP.Parent = pill
            Instance.new("UICorner", downP).CornerRadius = UDim.new(1, 0)
            local downL = Instance.new("TextLabel")
            downL.Name = "DownLbl"
            downL.Size = UDim2.new(1, 0, 1, 0)
            downL.BackgroundTransparency = 1
            downL.Font = Enum.Font.GothamBold
            downL.TextSize = 9
            downL.TextColor3 = Color3.fromRGB(255, 255, 255)
            downL.Text = "DOWN"
            downL.Parent = downP
            StatusESP[char] = bb
        end
        local nLbl = bb:FindFirstChild("NameLbl")
        local pill = bb:FindFirstChild("Pill")
        if not pill then return end
        local ps = pill:FindFirstChild("PillStroke")
        local avH = pill:FindFirstChild("AvatarHolder")
        local avImg = avH and avH:FindFirstChild("AvatarImg")
        local avS = avH and avH:FindFirstChild("AvatarStroke")
        local dot = pill:FindFirstChild("Dot")
        local distLbl = pill:FindFirstChild("DistLbl")
        local actLbl = pill:FindFirstChild("ActionLbl")
        local hpBg = pill:FindFirstChild("HPBarBg")
        local hpFill = hpBg and hpBg:FindFirstChild("HPBarFill")
        local downP = pill:FindFirstChild("DownPill")
        local dScale = bb:FindFirstChild("DistScale")
        if ps then ps.Color = accent; ps.Transparency = isDown and 0.2 or 0.5 end
        if avH then
            avH.Visible = FESPS.ShowAvatar == true
            if avS then avS.Color = accent end
            if avImg and avImg.Image == "" then
                avImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
            end
        end
        if dot then dot.Visible = (FESPS.ShowAvatar ~= true); dot.BackgroundColor3 = accent end
        if nLbl then
            nLbl.Text = plr.Name
            nLbl.Visible = FESPS.ShowName
            nLbl.TextColor3 = isDown and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 255, 255)
        end
        if distLbl then distLbl.Text = string.format("%.0fm", dist); distLbl.Visible = FESPS.ShowDistance end
        if actLbl then
            actLbl.Text = act; actLbl.TextColor3 = actCol
            actLbl.Visible = FESPS.ShowAction == true
            if act == "IDLE" then actLbl.TextColor3 = Color3.fromRGB(150, 150, 150) end
        end
        if hpBg and hpFill then
            hpFill.Size = UDim2.new(hpPct, 0, 1, 0)
            hpFill.BackgroundColor3 = hpCol
            hpBg.Visible = FESPS.ShowHealth
        end
        if downP then downP.Visible = isDown end
        local totalW = 14
        local count = 0
        if FESPS.ShowAvatar then totalW = totalW + 18; count = count + 1
        else totalW = totalW + 7; count = count + 1 end
        if FESPS.ShowDistance then totalW = totalW + 32; count = count + 1 end
        if FESPS.ShowAction then totalW = totalW + 50; count = count + 1 end
        if FESPS.ShowHealth then totalW = totalW + 38; count = count + 1 end
        if isDown then totalW = totalW + 36; count = count + 1 end
        totalW = totalW + math.max(count - 1, 0) * 5
        if totalW < 50 then totalW = 50 end
        if totalW > 240 then totalW = 240 end
        pill.Size = UDim2.fromOffset(totalW, 22)
        local showPill = FESPS.ShowDistance or FESPS.ShowHealth or isDown or FESPS.ShowAction or FESPS.ShowAvatar
        pill.Visible = showPill
        bb.Size = UDim2.fromOffset(260, 16 + (showPill and 24 or 0))
        if dScale then
            local sv = 1 - (dist - 50) / 500
            dScale.Scale = math.clamp(sv, 0.5, 1.05)
        end
    end

    local function getGVal(obj, name)
        if not obj then return nil end
        local attr = obj:GetAttribute(name)
        if attr ~= nil then return attr end
        local child = obj:FindFirstChild(name)
        if child then
            local ok, v = pcall(function() return child.Value end)
            if ok then return v end
        end
        return nil
    end

    local function updateGen(gen)
        if not gen or not gen.Parent then return end
        if not FESP.Generator then
            local o = gen:FindFirstChild("GenESP"); if o then o:Destroy() end
            local h = gen:FindFirstChild("GenHighlight"); if h then h:Destroy() end
            return
        end
        local pct = getGVal(gen, "RepairProgress") or getGVal(gen, "Progress") or getGVal(gen, "ProgressRepair") or 0
        local bb = gen:FindFirstChild("GenESP")
        if pct >= 100 then if bb then bb:Destroy() end; return end
        local cp = math.clamp(pct, 0, 100)
        local color = FESPC.Generator:Lerp(Color3.fromRGB(0, 255, 120), cp / 100)
        local text = string.format("[%.0f%%]", pct)
        if not bb then
            bb = Instance.new("BillboardGui")
            bb.Name = "GenESP"; bb.Size = UDim2.new(0, 100, 0, 30); bb.AlwaysOnTop = true
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1
            lbl.Text = text; lbl.TextColor3 = color; lbl.TextStrokeTransparency = 0
            lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
            lbl.Parent = bb
            bb.Adornee = gen; bb.Parent = gen
        else
            local lbl = bb:FindFirstChildOfClass("TextLabel")
            if lbl then lbl.Text = text; lbl.TextColor3 = color end
        end
        local h = gen:FindFirstChild("GenHighlight") or Instance.new("Highlight")
        h.Name = "GenHighlight"; h.Adornee = gen
        h.FillColor = color; h.OutlineColor = color
        h.FillTransparency = 0.9; h.OutlineTransparency = 0.3
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = gen
    end

    local function updateMapESP(obj, root)
        if not obj or not root or not obj.Parent then return end
        local pos
        if obj:IsA("Model") then
            if obj.PrimaryPart then pos = obj.PrimaryPart.Position
            else
                local ok, pivot = pcall(function() return obj:GetPivot().Position end)
                pos = ok and pivot or nil
                if not pos then
                    local bp = obj:FindFirstChildWhichIsA("BasePart", true)
                    if bp then pos = bp.Position end
                end
            end
        elseif obj:IsA("BasePart") then pos = obj.Position end
        if not pos then return end
        local dist = (pos - root.Position).Magnitude
        if obj.Name == "Pallet" or obj.Name == "Palletwrong" then
            if FESP.Pallet and dist <= FESP.Distance then createESP(obj, FESPC.Pallet)
            else removeESP(obj) end
        end
    end

    local function updateSCP(root)
        if not FESP.SCP then
            for obj in pairs(CachedSCP) do removeESP(obj) end
            return
        end
        for obj in pairs(CachedSCP) do
            if obj and obj.Parent then
                local pos
                if obj:IsA("Model") then
                    local ok, pivot = pcall(function() return obj:GetPivot().Position end)
                    pos = ok and pivot or nil
                elseif obj:IsA("BasePart") then pos = obj.Position end
                if pos then
                    local dist = (pos - root.Position).Magnitude
                    if dist <= FESP.Distance then createESP(obj, FESPC.SCP)
                    else removeESP(obj) end
                end
            end
        end
    end

    local function removeWindowESP(model)
        if not model then return end
        local wData = WindowObjects[model]
        if wData then
            if wData.highlight then pcall(function() wData.highlight:Destroy() end) end
            if wData.box then pcall(function() wData.box:Destroy() end) end
            if wData.bottomPart and wData.bottomPart.Parent then
                pcall(function()
                    local o = wData.bottomPart:GetAttribute("ESP_OrigTrans")
                    if o ~= nil then
                        wData.bottomPart.Transparency = o
                        wData.bottomPart:SetAttribute("ESP_OrigTrans", nil)
                    end
                end)
            end
            WindowObjects[model] = nil
        end
    end

    local function handleWindow(child)
        if not FESP.Window then return end
        if not child or child.Name ~= "VaultTrigger" then return end
        local winModel = child.Parent
        if not winModel or not winModel:IsA("Model") then return end
        if WindowObjects[winModel] then return end
        local bottomPart = winModel:FindFirstChild("Bottom")
        if not bottomPart or not bottomPart:IsA("BasePart") then
            local bestSize = 0
            for _, p in ipairs(winModel:GetChildren()) do
                if p:IsA("BasePart") and p.Name ~= "VaultTrigger" and p.Name ~= "inviswall" and p.Size.Magnitude > bestSize then
                    bestSize = p.Size.Magnitude; bottomPart = p
                end
            end
        end
        if not bottomPart then return end
        if bottomPart:GetAttribute("ESP_OrigTrans") == nil then
            bottomPart:SetAttribute("ESP_OrigTrans", bottomPart.Transparency)
        end
        if bottomPart.Transparency > 0.5 then bottomPart.Transparency = 0.5 end
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "W2WindowBox"; box.Adornee = bottomPart; box.Size = bottomPart.Size
        box.Color3 = FESPC.Window; box.Transparency = 0.3; box.AlwaysOnTop = true; box.ZIndex = 5
        box.Parent = bottomPart
        local hl = Instance.new("Highlight")
        hl.Name = "W2WindowHighlight"; hl.Adornee = winModel
        hl.FillColor = FESPC.Window; hl.FillTransparency = 0.9
        hl.OutlineColor = FESPC.Window; hl.OutlineTransparency = 0.1
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = winModel
        WindowObjects[winModel] = { highlight = hl, box = box, bottomPart = bottomPart }
    end

    local function scanWindows()
        if not FESP.Window then return end
        local map = Workspace:FindFirstChild("Map")
        if not map then return end
        for _, o in ipairs(map:GetDescendants()) do
            if o.Name == "VaultTrigger" then handleWindow(o) end
        end
    end

    Workspace.DescendantAdded:Connect(function(o)
        if o.Name == "VaultTrigger" and FESP.Window then
            task.defer(function() handleWindow(o) end)
        end
    end)

    local lastUpdate = 0
    RunService.RenderStepped:Connect(function()
        local now = tick()
        if now - lastUpdate < 0.05 then return end
        lastUpdate = now
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local char = p.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local dist = (hrp.Position - root.Position).Magnitude
                        if dist <= FESP.Distance then
                            if FESP.Survivor and TeamIs(p, "Survivor") then createESP(char, FESPC.Survivor)
                            elseif FESP.Killer and TeamIs(p, "Killer") then createESP(char, FESPC.Killer)
                            else removeESP(char) end
                        else removeESP(char) end
                    end
                    createStatus(p, char, root)
                else
                    removeESP(char); removeStatus(char)
                end
            end
        end
        if FESP.Generator then
            for gen in pairs(CachedGen) do updateGen(gen) end
        end
        for obj in pairs(CachedPallet) do updateMapESP(obj, root) end
        updateSCP(root)
        if FESP.Window then
            if not _G.W2WindowScanned then
                _G.W2WindowScanned = true
                pcall(scanWindows)
            end
        else
            _G.W2WindowScanned = false
            for model in pairs(WindowObjects) do removeWindowESP(model) end
        end
    end)
end

-- === UI SECTION ===
do
    local s = W.T_Vis:AddSection("Full ESP System")
    s:AddToggle({ Title = "ESP Survivor", Default = false, Callback = function(v) FESP.Survivor = v end })
    s:AddColorPicker({ Title = "Survivor Color", Default = FESPC.Survivor, Save = false, Callback = function(c) FESPC.Survivor = c end })
    s:AddToggle({ Title = "ESP Killer", Default = false, Callback = function(v) FESP.Killer = v end })
    s:AddColorPicker({ Title = "Killer Color", Default = FESPC.Killer, Save = false, Callback = function(c) FESPC.Killer = c end })
    s:AddToggle({ Title = "ESP Generator", Default = false, Callback = function(v) FESP.Generator = v end })
    s:AddColorPicker({ Title = "Generator Color", Default = FESPC.Generator, Save = false, Callback = function(c) FESPC.Generator = c end })
    s:AddToggle({ Title = "ESP Pallet", Default = false, Callback = function(v) FESP.Pallet = v end })
    s:AddColorPicker({ Title = "Pallet Color", Default = FESPC.Pallet, Save = false, Callback = function(c) FESPC.Pallet = c end })
    s:AddToggle({ Title = "ESP Window", Default = false, Callback = function(v)
        FESP.Window = v; _G.W2WindowScanned = false
    end })
    s:AddColorPicker({ Title = "Window Color", Default = FESPC.Window, Save = false, Callback = function(c) FESPC.Window = c end })
    s:AddToggle({ Title = "ESP SCP", Default = false, Callback = function(v) FESP.SCP = v end })
    s:AddColorPicker({ Title = "SCP Color", Default = FESPC.SCP, Save = false, Callback = function(c) FESPC.SCP = c end })
    s:AddSlider({ Title = "ESP Radius", Min = 10, Max = 1000, Default = 500, Increment = 10,
        Callback = function(v) FESP.Distance = v end })

    local s2 = W.T_Vis:AddSection("ESP Status")
    s2:AddToggle({ Title = "Enable Status ESP", Default = false, Callback = function(v) FESPS.Enabled = v end })
    s2:AddToggle({ Title = "Show Name", Default = true, Callback = function(v) FESPS.ShowName = v end })
    s2:AddToggle({ Title = "Show Distance", Default = true, Callback = function(v) FESPS.ShowDistance = v end })
    s2:AddToggle({ Title = "Show Avatar", Default = true, Callback = function(v) FESPS.ShowAvatar = v end })
    s2:AddToggle({ Title = "Show Action", Default = true, Callback = function(v) FESPS.ShowAction = v end })
    s2:AddToggle({ Title = "Show Health", Default = false, Callback = function(v) FESPS.ShowHealth = v end })
    s2:AddSlider({ Title = "Status Radius", Min = 20, Max = 1000, Default = 500, Increment = 10,
        Callback = function(v) FESPS.Radius = v end })
                            end--====================================================--
-- PART 9: VISUALS — HITBOX + GRAPHICS
--====================================================--

W2.Hitbox_Enabled      = W2.Hitbox_Enabled      or false
W2.Hitbox_Color        = W2.Hitbox_Color        or Color3.fromRGB(255, 0, 0)
W2.Hitbox_Transparency = W2.Hitbox_Transparency or 0.6
W2.Hitbox_Expand       = W2.Hitbox_Expand       or false
W2.Hitbox_SizeMult     = W2.Hitbox_SizeMult     or 2
W2.Hitbox_TargetMode   = W2.Hitbox_TargetMode   or "Both"
W2.Hitbox_ESPBox       = W2.Hitbox_ESPBox       or false
W2.Hitbox_HideESP      = W2.Hitbox_HideESP      or false
W2.Hitbox_ESPColor     = W2.Hitbox_ESPColor     or Color3.fromRGB(255, 0, 0)

-- === HITBOX VISUAL + EXPAND + ESP BOX ===
do
    local HitboxObjects = {}
    local ESPBoxObjects = {}
    local function clearHitbox(char)
        if HitboxObjects[char] then
            pcall(function() HitboxObjects[char]:Destroy() end)
            HitboxObjects[char] = nil
        end
    end
    local function clearESPBox(char)
        if ESPBoxObjects[char] then
            pcall(function() ESPBoxObjects[char]:Destroy() end)
            ESPBoxObjects[char] = nil
        end
    end
    local function isTarget(plr)
        if plr == LP then return false end
        if W2.Hitbox_TargetMode == "Killer"   then return TeamIs(plr, "Killer")   end
        if W2.Hitbox_TargetMode == "Survivor" then return TeamIs(plr, "Survivor") end
        return TeamIs(plr, "Killer") or TeamIs(plr, "Survivor")
    end
    local function createHitbox(char, part)
        if not char or not part or not part.Parent then return end
        if HitboxObjects[char] then
            local b = HitboxObjects[char]
            b.Size = part.Size * (W2.Hitbox_Expand and (W2.Hitbox_SizeMult or 2) or 1)
            b.Color3 = W2.Hitbox_Color
            b.Transparency = W2.Hitbox_Transparency
            return
        end
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "W2Hitbox"
        box.Adornee = part
        box.Size = part.Size * (W2.Hitbox_Expand and (W2.Hitbox_SizeMult or 2) or 1)
        box.Color3 = W2.Hitbox_Color
        box.Transparency = W2.Hitbox_Transparency
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Parent = part
        HitboxObjects[char] = box
    end
    local function createESPBox(char, root)
        if not char or not root or not root.Parent then return end
        if ESPBoxObjects[char] then
            local b = ESPBoxObjects[char]
            b.Size = root.Size * 1.5
            b.Color3 = W2.Hitbox_ESPColor
            b.Transparency = 0.3
            b.Visible = not W2.Hitbox_HideESP
            return
        end
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "W2ESPBox"
        box.Adornee = root
        box.Size = root.Size * 1.5
        box.Color3 = W2.Hitbox_ESPColor
        box.Transparency = 0.3
        box.AlwaysOnTop = true
        box.ZIndex = 6
        box.Parent = root
        ESPBoxObjects[char] = box
    end

    RunService.RenderStepped:Connect(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local char = p.Character
                if W2.Hitbox_Enabled and isTarget(p) then
                    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
                    if torso then createHitbox(char, torso) end
                else
                    clearHitbox(char)
                end
                if W2.Hitbox_ESPBox and isTarget(p) then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then createESPBox(char, root) end
                else
                    clearESPBox(char)
                end
            else
                if p.Character then clearHitbox(p.Character); clearESPBox(p.Character) end
            end
        end
    end)
end

-- === GRAPHICS SYSTEM ===
W.Graphics = W.Graphics or {
    Fullbright = false, NoShadow = false, LowGraphics = false,
    NoScreenEffects = false, CleanSky = false,
    ClockTimeEnabled = false, ClockTime = 14, Brightness = 2,
    UnlimitedZoom = false, MaxZoomDistance = 1000,
    FOVEnabled = false, FOV = 70, PotatoEnabled = false,
    LockPOV = false, LockedFOV = 80,
    FOVLock = false, FOVLockValue = 70,
    HDRingan = false, HDKincolong = false,
}
local G = W.Graphics
local orig = {
    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows,
    FOV = Workspace.CurrentCamera and Workspace.CurrentCamera.FieldOfView or 70,
}
local lastState = { FB = nil, NS = nil, Amb = nil, Bright = nil, Clock = nil }
local lastOpt = { LG = nil, CS = nil }
local disabledEffects = {}
local effectTypes = { "ColorCorrectionEffect", "DepthOfFieldEffect", "BlurEffect", "SunRaysEffect", "BloomEffect" }

local function applyGraphics(force)
    if force or lastState.FB ~= G.Fullbright then
        lastState.FB = G.Fullbright
        if G.Fullbright then
            Lighting.Brightness = 2; Lighting.ClockTime = 14
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            Lighting.Brightness = orig.Brightness
            Lighting.ClockTime = orig.ClockTime
            Lighting.Ambient = orig.Ambient
            Lighting.OutdoorAmbient = orig.OutdoorAmbient
        end
    end
    if force or lastState.NS ~= G.NoShadow then
        lastState.NS = G.NoShadow
        Lighting.GlobalShadows = not G.NoShadow
    end
    local ambChanged = lastState.Amb ~= G.ClockTimeEnabled or lastState.Bright ~= G.Brightness or lastState.Clock ~= G.ClockTime
    if force or ambChanged then
        lastState.Amb = G.ClockTimeEnabled
        lastState.Bright = G.Brightness
        lastState.Clock = G.ClockTime
        if G.ClockTimeEnabled then
            Lighting.ClockTime = G.ClockTime
            Lighting.Brightness = G.Brightness
        elseif not G.Fullbright then
            Lighting.Brightness = orig.Brightness
            Lighting.ClockTime = orig.ClockTime
        end
    end
end

local function applyOpt(force)
    if force or lastOpt.LG ~= G.LowGraphics then
        lastOpt.LG = G.LowGraphics
        pcall(function()
            if G.LowGraphics then
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            else
                settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            end
        end)
    end
    if force or lastOpt.CS ~= G.CleanSky then
        lastOpt.CS = G.CleanSky
        if G.CleanSky then
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("Sky") then v:Destroy() end
            end
        end
    end
end

local function applyNoFx()
    if G.NoScreenEffects then
        for _, v in pairs(Lighting:GetChildren()) do
            for _, t in ipairs(effectTypes) do
                if v:IsA(t) then
                    if disabledEffects[v] == nil then disabledEffects[v] = v.Enabled end
                    v.Enabled = false
                end
            end
        end
    else
        for obj, state in pairs(disabledEffects) do
            if obj and obj.Parent then obj.Enabled = state end
        end
        disabledEffects = {}
    end
end

Lighting.ChildAdded:Connect(function(v)
    if not G.NoScreenEffects then return end
    task.wait()
    for _, t in ipairs(effectTypes) do
        if v:IsA(t) then
            if disabledEffects[v] == nil then disabledEffects[v] = v.Enabled end
            v.Enabled = false
        end
    end
end)

local function applyZoom()
    if G.UnlimitedZoom then
        LP.CameraMaxZoomDistance = G.MaxZoomDistance
        LP.CameraMinZoomDistance = 0
    else
        LP.CameraMaxZoomDistance = 128
        LP.CameraMinZoomDistance = 0.5
    end
end

local function applyFOV()
    local cam = Workspace.CurrentCamera
    if not cam then return end
    if G.FOVEnabled then cam.FieldOfView = G.FOV
    else cam.FieldOfView = orig.FOV end
end

-- === POTATO MODE ===
local potatoOn = false
local potatoBusy = false
local potatoChanged = {}
local potatoConns = {}
local POTATO_BATCH = 40

local function potatoSave(obj, prop)
    if not potatoChanged[obj] then potatoChanged[obj] = {} end
    if potatoChanged[obj][prop] == nil then
        local ok, val = pcall(function() return obj[prop] end)
        if ok then potatoChanged[obj][prop] = val end
    end
end
local function potatoSet(obj, prop, value)
    if not obj or not obj.Parent then return end
    potatoSave(obj, prop)
    pcall(function() obj[prop] = value end)
end
local function potatoOpt(obj)
    if not potatoOn or not obj then return end
    if obj:IsA("BasePart") then
        potatoSet(obj, "CastShadow", false)
        potatoSet(obj, "Reflectance", 0)
        pcall(function() potatoSet(obj, "Material", Enum.Material.Plastic) end)
    end
    if obj:IsA("MeshPart") then
        pcall(function() potatoSet(obj, "RenderFidelity", Enum.RenderFidelity.Performance) end)
    end
    if obj:IsA("Texture") or obj:IsA("Decal") then potatoSet(obj, "Transparency", 1) end
    if obj:IsA("SurfaceAppearance") then
        pcall(function()
            potatoSet(obj, "ColorMap", "")
            potatoSet(obj, "MetalnessMap", "")
            potatoSet(obj, "NormalMap", "")
            potatoSet(obj, "RoughnessMap", "")
        end)
    end
    if obj:IsA("ParticleEmitter") then potatoSet(obj, "Enabled", false) end
    if obj:IsA("Trail") then potatoSet(obj, "Enabled", false) end
    if obj:IsA("Beam") then potatoSet(obj, "Enabled", false) end
    if obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then potatoSet(obj, "Enabled", false) end
    if obj:IsA("Clouds") then
        potatoSet(obj, "Cover", 0); potatoSet(obj, "Density", 0)
    end
end

local function potatoEnable()
    if potatoOn then return end
    potatoOn = true
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    potatoSet(Lighting, "GlobalShadows", false)
    potatoSet(Lighting, "Brightness", 1)
    pcall(function()
        potatoSet(Lighting, "EnvironmentDiffuseScale", 0)
        potatoSet(Lighting, "EnvironmentSpecularScale", 0)
    end)
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        potatoSet(terrain, "Decoration", false)
        potatoSet(terrain, "WaterWaveSize", 0)
        potatoSet(terrain, "WaterWaveSpeed", 0)
        potatoSet(terrain, "WaterReflectance", 0)
    end
    if not potatoConns.new then
        potatoConns.new = Workspace.DescendantAdded:Connect(function(obj)
            if not potatoOn then return end
            task.defer(function() if potatoOn then potatoOpt(obj) end end)
        end)
    end
    task.spawn(function()
        if potatoBusy then return end
        potatoBusy = true
        local objs = Workspace:GetDescendants()
        local total = #objs
        local idx = 1
        while potatoOn and idx <= total do
            local fin = math.min(idx + POTATO_BATCH - 1, total)
            for i = idx, fin do
                if not potatoOn then break end
                potatoOpt(objs[i])
            end
            RunService.Heartbeat:Wait()
            idx = fin + 1
        end
        potatoBusy = false
    end)
end

local function potatoDisable()
    if not potatoOn then return end
    potatoOn = false
    for _, c in pairs(potatoConns) do pcall(function() c:Disconnect() end) end
    potatoConns = {}
    task.spawn(function()
        local cnt = 0
        for obj, props in pairs(potatoChanged) do
            if obj and obj.Parent then
                for prop, val in pairs(props) do
                    pcall(function() obj[prop] = val end)
                    cnt = cnt + 1
                    if cnt >= POTATO_BATCH then task.wait(); cnt = 0 end
                end
            end
        end
        potatoChanged = {}
    end)
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic end)
end

local function applyHDRingan()
    if G.HDRingan then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level06
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 100000
            Lighting.EnvironmentDiffuseScale = 0.5
            Lighting.EnvironmentSpecularScale = 0.5
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("BloomEffect") then v.Enabled = true; v.Intensity = 0.6; v.Size = 20 end
                if v:IsA("SunRaysEffect") then v.Enabled = true; v.Intensity = 0.05 end
            end
        end)
    end
end

local function applyHDKincolong()
    if G.HDKincolong then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000000
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("BloomEffect") then v.Enabled = true; v.Intensity = 1; v.Size = 32; v.Threshold = 0.8 end
                if v:IsA("SunRaysEffect") then v.Enabled = true; v.Intensity = 0.15; v.Spread = 1 end
                if v:IsA("ColorCorrectionEffect") then
                    v.Enabled = true
                    v.Brightness = 0.1; v.Contrast = 0.2; v.Saturation = 0.3
                end
            end
        end)
    end
end

RunService.RenderStepped:Connect(function()
    if G.FOVEnabled then
        local cam = Workspace.CurrentCamera
        if cam and cam.FieldOfView ~= G.FOV then cam.FieldOfView = G.FOV end
    end
    if G.LockPOV then
        local cam = Workspace.CurrentCamera
        if cam and math.abs(cam.FieldOfView - G.LockedFOV) > 0.1 then cam.FieldOfView = G.LockedFOV end
    end
    if G.FOVLock then
        local cam = Workspace.CurrentCamera
        if cam and math.abs(cam.FieldOfView - G.FOVLockValue) > 0.1 then cam.FieldOfView = G.FOVLockValue end
    end
end)

RunService.RenderStepped:Connect(function()
    if not G.UnlimitedZoom then return end
    if LP.CameraMaxZoomDistance ~= G.MaxZoomDistance then
        LP.CameraMaxZoomDistance = G.MaxZoomDistance
    end
    if LP.CameraMinZoomDistance ~= 0 then LP.CameraMinZoomDistance = 0 end
end)

W.Graphics_Apply           = applyGraphics
W.Graphics_ApplyOpt        = applyOpt
W.Graphics_ApplyNoFx       = applyNoFx
W.Graphics_ApplyZoom       = applyZoom
W.Graphics_ApplyFOV        = applyFOV
W.Graphics_ApplyHDRingan   = applyHDRingan
W.Graphics_ApplyHDKincolong= applyHDKincolong
W.Potato_Set = function(v)
    G.PotatoEnabled = v and true or false
    if G.PotatoEnabled then potatoEnable() else potatoDisable() end
end

LP.CharacterAdded:Connect(function()
    task.wait(1)
    applyGraphics(true); applyOpt(true)
    applyNoFx(); applyZoom(); applyFOV()
end)

-- === UI SECTION ===
do
    local s = W.T_Vis:AddSection("Hitbox")
    s:AddToggle({ Title = "Enable Hitbox", Default = false, Callback = function(v) W2.Hitbox_Enabled = v end })
    s:AddColorPicker({ Title = "Hitbox Color", Default = Color3.fromRGB(255, 0, 0), Save = false, Callback = function(c) W2.Hitbox_Color = c end })
    s:AddSlider({ Title = "Transparency", Min = 0, Max = 1, Default = 0.6, Increment = 0.05, Callback = function(v) W2.Hitbox_Transparency = v end })
    s:AddToggle({ Title = "Expand Hitbox", Default = false, Callback = function(v) W2.Hitbox_Expand = v end })
    s:AddSlider({ Title = "Size Multiplier", Min = 1, Max = 5, Default = 2, Increment = 0.5, Callback = function(v) W2.Hitbox_SizeMult = v end })
    s:AddDropdown({ Title = "Target Mode", Options = {"Killer","Survivor","Both"}, Default = "Both", Callback = function(v) W2.Hitbox_TargetMode = v end })
    s:AddToggle({ Title = "Show ESP Box", Default = false, Callback = function(v) W2.Hitbox_ESPBox = v end })
    s:AddToggle({ Title = "Hide ESP Box", Default = false, Callback = function(v) W2.Hitbox_HideESP = v end })
    s:AddColorPicker({ Title = "ESP Box Color", Default = Color3.fromRGB(255, 0, 0), Save = false, Callback = function(c) W2.Hitbox_ESPColor = c end })

    local s2 = W.T_Vis:AddSection("Graphics")
    s2:AddToggle({ Title = "Fullbright", Default = false, Callback = function(v) G.Fullbright = v; applyGraphics() end })
    s2:AddToggle({ Title = "No Shadow", Default = false, Callback = function(v) G.NoShadow = v; applyGraphics() end })
    s2:AddToggle({ Title = "Low Graphics", Default = false, Callback = function(v) G.LowGraphics = v; applyOpt() end })
    s2:AddToggle({ Title = "No Screen Effects", Default = false, Callback = function(v) G.NoScreenEffects = v; applyNoFx() end })
    s2:AddToggle({ Title = "Clean Sky", Default = false, Callback = function(v) G.CleanSky = v; applyOpt() end })
    s2:AddToggle({ Title = "Potato Mode", Default = false, Callback = function(v)
        W.Potato_Set(v)
        if v then W.W2_Notify("Potato Mode", "Enabled", 3) end
    end })
    s2:AddToggle({ Title = "Grafik HD Ringan", Default = false, Callback = function(v) G.HDRingan = v; applyHDRingan() end })
    s2:AddToggle({ Title = "Grafik HD Kincolong", Default = false, Callback = function(v) G.HDKincolong = v; applyHDKincolong() end })
                                end--====================================================--
-- PART 10: VISUALS — CLOCK + ZOOM + POV + CAMERA DBD
--====================================================--

W2.CamDBD_Enabled     = W2.CamDBD_Enabled     or false
W2.CamDBD_Smooth      = W2.CamDBD_Smooth      or 4
W2.CamDBD_Sensitivity = W2.CamDBD_Sensitivity or 1.0
W2.CamDBD_POVLock     = W2.CamDBD_POVLock     or false
W2.CamDBD_POVValue    = W2.CamDBD_POVValue    or 85
W2.CamDBD_POVSmooth   = W2.CamDBD_POVSmooth   or 9
W2.CamDBD_ScreenSmooth= W2.CamDBD_ScreenSmooth or false
W2.CamDBD_ScreenLevel = W2.CamDBD_ScreenLevel or 5
W2.CamDBD_RotSpeed    = W2.CamDBD_RotSpeed    or 1.0
W2.CamDBD_Deadzone    = W2.CamDBD_Deadzone    or 10

-- === CAMERA DBD FIXED + SENSITIVITY ===
do
    local bindName = "W2_CamDBD_Fix"
    local prevPos, prevRot = nil, nil
    local smoothRot = nil
    pcall(function() RunService:UnbindFromRenderStep(bindName) end)

    RunService:BindToRenderStep(bindName, Enum.RenderPriority.Camera.Value + 1, function(dt)
        local cam = Workspace.CurrentCamera
        if not cam then return end
        if cam.CameraType ~= Enum.CameraType.Custom and cam.CameraType ~= Enum.CameraType.Follow then
            prevPos = nil; prevRot = nil; smoothRot = nil
            return
        end
        if W2.CamDBD_Enabled then
            local curCF = cam.CFrame
            local curPos = curCF.Position
            local curRot = curCF.Rotation
            local sens = tonumber(W2.CamDBD_Sensitivity) or 1.0
            if not prevPos or not prevRot then
                prevPos = curPos
                prevRot = curRot
            else
                local spd = tonumber(W2.CamDBD_Smooth) or 4
                local posA = 1 - math.exp(-spd * dt)
                prevPos = prevPos:Lerp(curPos, math.clamp(posA * sens, 0, 1))
                local rotA = 1 - math.exp(-(spd * 2.0 * sens) * dt)
                prevRot = prevRot:Lerp(curRot, math.clamp(rotA, 0, 1))
                cam.CFrame = CFrame.new(prevPos) * prevRot
            end
        else
            prevPos = nil; prevRot = nil
        end
        if W2.CamDBD_ScreenSmooth then
            local level = tonumber(W2.CamDBD_ScreenLevel) or 5
            local rSpd = tonumber(W2.CamDBD_RotSpeed) or 1.0
            local dz = tonumber(W2.CamDBD_Deadzone) or 10
            local sens = tonumber(W2.CamDBD_Sensitivity) or 1.0
            local factor = math.clamp(level / 10, 0.05, 0.6)
            local rotTarget = cam.CFrame.Rotation
            if not smoothRot then
                smoothRot = rotTarget
            else
                local delta = rotTarget * smoothRot:Inverse()
                local angle = math.acos(math.clamp((delta.X + delta.Y + delta.Z + delta.W) * 0.5, -1, 1)) * 2
                local deg = math.deg(angle)
                if deg > (dz / 10) then
                    local alpha = 1 - math.exp(-(1 - factor) * rSpd * sens * dt * 8)
                    smoothRot = smoothRot:Lerp(rotTarget, math.clamp(alpha, 0, 1))
                    cam.CFrame = CFrame.new(cam.CFrame.Position) * smoothRot
                end
            end
        else
            smoothRot = nil
        end
        if W2.CamDBD_POVLock then
            local povSpd = tonumber(W2.CamDBD_POVSmooth) or 9
            local alpha = 1 - math.exp(-povSpd * dt)
            local target = tonumber(W2.CamDBD_POVValue) or 85
            cam.FieldOfView = cam.FieldOfView + (target - cam.FieldOfView) * alpha
        end
    end)

    function W.CamDBD_Reset()
        prevPos = nil; prevRot = nil; smoothRot = nil
        W2.CamDBD_Smooth = 4
        W2.CamDBD_Sensitivity = 1.0
        W2.CamDBD_ScreenLevel = 5
        W2.CamDBD_RotSpeed = 1.0
        W2.CamDBD_Deadzone = 10
        W.W2_Notify("Camera DBD", "Reset to default", 2)
    end

    LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        prevPos = nil; prevRot = nil; smoothRot = nil
    end)
end

-- === UI SECTION ===
do
    local s = W.T_Vis:AddSection("Clock & Ambient")
    s:AddToggle({ Title = "Enable Clock Override", Default = false, Callback = function(v)
        G.ClockTimeEnabled = v; W.Graphics_Apply()
    end })
    s:AddSlider({ Title = "Clock Time", Min = 0, Max = 24, Default = 14, Increment = 1, Callback = function(v)
        G.ClockTime = v; G.ClockTimeEnabled = true; W.Graphics_Apply()
    end })
    s:AddSlider({ Title = "Brightness", Min = 0, Max = 5, Default = 2, Increment = 0.1, Callback = function(v)
        G.Brightness = v; G.ClockTimeEnabled = true; W.Graphics_Apply()
    end })

    local s2 = W.T_Vis:AddSection("Zoom & FOV")
    s2:AddToggle({ Title = "Unlimited Zoom", Default = false, Callback = function(v)
        G.UnlimitedZoom = v; W.Graphics_ApplyZoom()
    end })
    s2:AddSlider({ Title = "Max Zoom Distance", Min = 100, Max = 5000, Default = 1000, Increment = 50,
        Callback = function(v) G.MaxZoomDistance = v end })
    s2:AddToggle({ Title = "Custom FOV", Default = false, Callback = function(v)
        G.FOVEnabled = v; W.Graphics_ApplyFOV()
    end })
    s2:AddSlider({ Title = "Camera FOV", Min = 40, Max = 120, Default = 70, Increment = 5,
        Callback = function(v) G.FOV = v end })

    local s3 = W.T_Vis:AddSection("Lock POV & FOV Lock")
    s3:AddToggle({ Title = "Lock POV", Default = false, Callback = function(v) G.LockPOV = v end })
    s3:AddSlider({ Title = "Locked FOV", Min = 40, Max = 120, Default = 80, Increment = 5,
        Callback = function(v) G.LockedFOV = v end })
    s3:AddToggle({ Title = "FOV Lock", Default = false, Callback = function(v) G.FOVLock = v end })
    s3:AddSlider({ Title = "FOV Lock Value", Min = 40, Max = 120, Default = 70, Increment = 5,
        Callback = function(v) G.FOVLockValue = v end })

    local s4 = W.T_Vis:AddSection("Camera DBD")
    s4:AddToggle({ Title = "Enable Camera DBD", Default = false, Callback = function(v)
        W2.CamDBD_Enabled = v
        W.W2_Notify("Camera DBD", v and "Smooth ON" or "Smooth OFF", 2)
    end })
    s4:AddSlider({ Title = "Smoothness", Min = 1, Max = 30, Default = 4, Increment = 1,
        Callback = function(v) W2.CamDBD_Smooth = v end })
    s4:AddSlider({ Title = "Rotation Sensitivity", Min = 0.3, Max = 3, Default = 1.0, Increment = 0.1,
        Callback = function(v) W2.CamDBD_Sensitivity = v end })
    s4:AddToggle({ Title = "POV Lock", Default = false, Callback = function(v)
        W2.CamDBD_POVLock = v
        W.W2_Notify("Camera DBD", v and "POV Lock ON" or "POV Lock OFF", 2)
    end })
    s4:AddSlider({ Title = "POV Value", Min = 60, Max = 120, Default = 85, Increment = 1, Suffix = "°",
        Callback = function(v) W2.CamDBD_POVValue = v end })
    s4:AddToggle({ Title = "Screen Smooth (Anti Berat)", Default = false, Callback = function(v)
        W2.CamDBD_ScreenSmooth = v
    end })
    s4:AddSlider({ Title = "Screen Level", Min = 1, Max = 10, Default = 5, Increment = 1,
        Callback = function(v) W2.CamDBD_ScreenLevel = v end })
    s4:AddSlider({ Title = "Rotation Speed", Min = 0.1, Max = 2, Default = 1.0, Increment = 0.1,
        Callback = function(v) W2.CamDBD_RotSpeed = v end })
    s4:AddSlider({ Title = "Deadzone", Min = 0, Max = 50, Default = 10, Increment = 1,
        Callback = function(v) W2.CamDBD_Deadzone = v end })
    s4:AddButton({ Title = "Reset to Default", Callback = function() W.CamDBD_Reset() end })
end

--====================================================--
-- PART 11 prep: KILLER FLAGS (biar bisa diakses part selanjutnya)
--====================================================--
W2.InfLunge_Enabled     = W2.InfLunge_Enabled     or false
W2.CounterParry_Enabled = W2.CounterParry_Enabled or false
W2.AutoAttack_Enabled   = W2.AutoAttack_Enabled   or false
W2.AutoAttack_Range     = W2.AutoAttack_Range     or 12
W2.AutoAttack_Cooldown  = W2.AutoAttack_Cooldown  or 0.15--====================================================--
-- PART 11: KILLER — AUTO ATTACK + INF LUNGE + COUNTER PARRY
--====================================================--

-- === INFINITE LUNGE ===
local OrigLungeBoost = nil
function W.UpdateInfLunge()
    local c = LP.Character
    if not c then return end
    if W2.InfLunge_Enabled then
        if c:GetAttribute("lungeboost") ~= 999999 then
            OrigLungeBoost = c:GetAttribute("lungeboost") or 1
            c:SetAttribute("lungeboost", 999999)
        end
    else
        if OrigLungeBoost then
            c:SetAttribute("lungeboost", OrigLungeBoost)
            OrigLungeBoost = nil
        end
    end
end
LP.CharacterRemoving:Connect(function() OrigLungeBoost = nil end)

-- === COUNTER AUTO PARRY ===
do
    local animList = {}
    for id, _ in pairs(KillerAttackAnims) do table.insert(animList, id) end

    task.spawn(function()
        while true do
            task.wait(0.5)
            if not W2.CounterParry_Enabled then continue end
            local c = LP.Character
            if not c then continue end
            local r = c:FindFirstChild("HumanoidRootPart")
            if not r then continue end
            local near = false
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Team and string.find(string.lower(p.Team.Name), "survivor", 1, true) then
                    local rr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if rr and (r.Position - rr.Position).Magnitude <= 15 then near = true; break end
                end
            end
            if near then
                local rid = animList[math.random(1, #animList)]
                local a = Instance.new("Animation")
                a.AnimationId = "rbxassetid://" .. rid
                local h = c:FindFirstChildOfClass("Humanoid")
                local anim = h and h:FindFirstChildOfClass("Animator")
                if anim then
                    local t = anim:LoadAnimation(a)
                    t:Play()
                    t:AdjustWeight(0)
                    task.wait(0.05)
                    t:Stop()
                    a:Destroy()
                end
            end
        end
    end)
end

-- === AUTO ATTACK ===
local lastAA = 0
task.spawn(function()
    while true do
        task.wait(0.1)
        if W2.AutoAttack_Enabled and GetRole() == "Killer" then
            local now = tick()
            if now - lastAA >= (W2.AutoAttack_Cooldown or 0.15) then
                local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if r then
                    local closest, shortest = nil, W2.AutoAttack_Range or 12
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LP and TeamIs(plr, "Survivor") and plr.Character then
                            local h = plr.Character:FindFirstChildOfClass("Humanoid")
                            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                            if h and hrp and h.Health > 35 then
                                local d = (hrp.Position - r.Position).Magnitude
                                if d <= shortest then shortest = d; closest = plr end
                            end
                        end
                    end
                    if closest then
                        lastAA = now
                        pcall(function()
                            local a = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Attacks")
                            local b = a and a:FindFirstChild("BasicAttack")
                            if b then b:FireServer(false) end
                        end)
                    end
                end
            end
        end
    end
end)

-- === UI SECTION ===
do
    local s = W.T_Kill:AddSection("Auto Attack")
    s:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
        W2.AutoAttack_Enabled = v
        W.W2_Notify("Auto Attack", v and "Enabled" or "Disabled", 2)
    end })
    s:AddSlider({ Title = "Range", Min = 5, Max = 30, Default = 12, Increment = 1, Suffix = " studs",
        Callback = function(v) W2.AutoAttack_Range = v end })
    s:AddSlider({ Title = "Cooldown", Min = 0.05, Max = 1, Default = 0.15, Increment = 0.05, Suffix = "s",
        Callback = function(v) W2.AutoAttack_Cooldown = v end })

    local s2 = W.T_Kill:AddSection("Infinite Lunge")
    s2:AddToggle({ Title = "Enable (Basic Attack)", Default = false, Callback = function(v)
        W2.InfLunge_Enabled = v
        W.W2_Notify("Infinite Lunge", v and "Enabled" or "Disabled", 2)
    end })

    local s3 = W.T_Kill:AddSection("Counter Auto Parry")
    s3:AddToggle({ Title = "Enable", Content = "Spam animasi parry biar survivor auto parry sendiri",
        Default = false, Callback = function(v)
            W2.CounterParry_Enabled = v
            W.W2_Notify("Counter Parry", v and "Enabled" or "Disabled", 2)
        end })
                                    end--====================================================--
-- PART 12: KILLER — AIM LOCK HIDDEN + AIM LOCK ATTACK + AIMBOT ZOMBIE
--====================================================--

W2.AimbotZombie_Enabled = W2.AimbotZombie_Enabled or false
W2.AimHidden_Enabled    = W2.AimHidden_Enabled    or false
W2.AimHidden_Key        = W2.AimHidden_Key        or "E"
W2.AimAttack_Enabled    = W2.AimAttack_Enabled    or false

-- === AIM LOCK HIDDEN (Aim semua musuh) ===
do
    local thread = nil
    local aiming = false
    local holdKey = Enum.KeyCode.E

    local function closest()
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local myTeam = LP.Team and LP.Team.Name or ""
        local myK = string.find(string.lower(myTeam), "killer", 1, true) ~= nil
        local best, bd = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local thrp = p.Character:FindFirstChild("HumanoidRootPart")
                local h = p.Character:FindFirstChildOfClass("Humanoid")
                local pTeam = p.Team and p.Team.Name or ""
                local theirK = string.find(string.lower(pTeam), "killer", 1, true) ~= nil
                if thrp and h and h.Health > 0 then
                    local enemy = (myK and not theirK) or ((not myK) and theirK)
                    if enemy then
                        local d = (thrp.Position - hrp.Position).Magnitude
                        if d < bd then bd = d; best = thrp end
                    end
                end
            end
        end
        return best
    end

    local function start()
        if thread then task.cancel(thread) end
        thread = task.spawn(function()
            while W2.AimHidden_Enabled do
                if aiming then
                    local t = closest()
                    if t then
                        pcall(function()
                            Workspace.CurrentCamera.CFrame = CFrame.new(
                                Workspace.CurrentCamera.CFrame.Position,
                                t.Position + Vector3.new(0, 2.5, 0)
                            )
                        end)
                    end
                end
                task.wait()
            end
        end)
    end

    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp or not W2.AimHidden_Enabled then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton2 then aiming = true end
        if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == holdKey then aiming = true end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if not W2.AimHidden_Enabled then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton2 then aiming = false end
        if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == holdKey then aiming = false end
    end)

    function W.AimHidden_Set(v)
        W2.AimHidden_Enabled = v
        if v then start()
        else
            aiming = false
            if thread then task.cancel(thread); thread = nil end
        end
    end
    function W.AimHidden_SetKey(name)
        local ok, kc = pcall(function() return Enum.KeyCode[tostring(name):upper()] end)
        if ok and kc then holdKey = kc; W2.AimHidden_Key = kc.Name end
    end
end

-- === AIM LOCK ATTACK ===
do
    local AA = { Enabled = false, Holding = false, Strength = 1, Predict = true, PredictStrength = 0.12, FOV = 250, VisCheck = true, AimPart = "HumanoidRootPart" }
    local conn = nil
    local currBtn = nil
    local paths = { "Slasher-mob.Controls.attack", "Masked-mob.Controls.attack", "Killer-mob.Controls.attack" }
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude

    local function visible(part)
        local cam = Workspace.CurrentCamera
        if not cam then return true end
        rp.FilterDescendantsInstances = { LP.Character }
        local o = cam.CFrame.Position
        local d = part.Position - o
        local res = Workspace:Raycast(o, d, rp)
        if not res then return true end
        return res.Instance:IsDescendantOf(part.Parent)
    end

    local function getBtn()
        for _, path in ipairs(paths) do
            local cur = LP:FindFirstChild("PlayerGui")
            for s in string.gmatch(path, "[^%.]+") do
                cur = cur and cur:FindFirstChild(s)
            end
            if cur and cur:IsA("GuiObject") then return cur end
        end
        return nil
    end

    local function closest()
        local cam = Workspace.CurrentCamera
        if not cam then return nil end
        local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
        local best, bd = nil, AA.FOV
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Team and string.find(string.lower(p.Team.Name), "survivor", 1, true) and p.Character then
                local hrp = p.Character:FindFirstChild(AA.AimPart)
                local h = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and h and h.Health > 0 then
                    local pos, on = cam:WorldToViewportPoint(hrp.Position)
                    if on then
                        local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if d < bd then
                            if AA.VisCheck and not visible(hrp) then continue end
                            bd = d; best = hrp
                        end
                    end
                end
            end
        end
        return best
    end

    local function start()
        if conn then return end
        conn = RunService.RenderStepped:Connect(function()
            if not AA.Enabled or not AA.Holding then return end
            local t = closest()
            if not t then return end
            local cam = Workspace.CurrentCamera
            local pos = t.Position
            if AA.Predict then pos = pos + (t.AssemblyLinearVelocity * AA.PredictStrength) end
            cam.CFrame = CFrame.new(cam.CFrame.Position, pos)
        end)
    end

    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton2 and AA.Enabled then AA.Holding = true end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton2 then AA.Holding = false end
    end)

    task.spawn(function()
        while true do
            task.wait(1)
            local b = getBtn()
            if b and b ~= currBtn then
                currBtn = b
                b.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.Touch and AA.Enabled then AA.Holding = true end
                end)
                b.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.Touch then AA.Holding = false end
                end)
            end
        end
    end)

    W.AttackAim_Start = start
    W.AttackAim_Cfg = AA
end

-- === AIMBOT ZOMBIE ===
do
    local Z = { Enabled = false, Holding = false, Strength = 1, Predict = true, PredictStrength = 0.12, FOV = 250, VisCheck = true, AimPart = "HumanoidRootPart", Target = nil }
    local conn = nil

    local function visible(part)
        local cam = Workspace.CurrentCamera
        if not cam then return true end
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = { LP.Character }
        local o = cam.CFrame.Position
        local d = part.Position - o
        local res = Workspace:Raycast(o, d, rp)
        if not res then return true end
        return res.Instance:IsDescendantOf(part.Parent)
    end

    local function zombies()
        local l = {}
        local map = Workspace:FindFirstChild("Map")
        if not map then return l end
        for _, c in ipairs(map:GetDescendants()) do
            if c:IsA("Model") then
                local a = c:GetAttributes()
                local isZ = c:GetAttribute("CorpseCreated0492") ~= nil or c:GetAttribute("IsZombie") == true or next(a) ~= nil
                local hrp = c:FindFirstChild("HumanoidRootPart")
                local hum = c:FindFirstChildOfClass("Humanoid")
                if isZ and hrp and hum and hum.Health > 0 then table.insert(l, hrp) end
            end
        end
        return l
    end

    local function closest()
        local cam = Workspace.CurrentCamera
        if not cam then return nil end
        local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        local best, bd = nil, Z.FOV
        for _, hrp in ipairs(zombies()) do
            if hrp and hrp.Parent then
                local pos, on = cam:WorldToViewportPoint(hrp.Position)
                if on then
                    local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if d < bd then
                        if Z.VisCheck and not visible(hrp) then continue end
                        bd = d; best = hrp
                    end
                end
            end
        end
        return best
    end

    local function start()
        if conn then return end
        conn = RunService.RenderStepped:Connect(function()
            if not W2.AimbotZombie_Enabled or not Z.Holding then return end
            local t = closest()
            if not t then return end
            Z.Target = t
            local pos = t.Position
            if Z.Predict then pos = pos + (t.AssemblyLinearVelocity * Z.PredictStrength) end
            local cam = Workspace.CurrentCamera
            cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, pos), Z.Strength)
        end)
    end

    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton2 and W2.AimbotZombie_Enabled then Z.Holding = true end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton2 then Z.Holding = false end
    end)

    function W.ZombieAim_Start() start() end
    W.ZombieAim_Cfg = Z
end

-- === UI SECTION ===
do
    local s = W.T_Kill:AddSection("Aim Lock Hidden")
    s:AddToggle({ Title = "Enable (Hold M2/E)", Default = false, Callback = function(v)
        W.AimHidden_Set(v)
        W.W2_Notify("Aim Lock Hidden", v and "Enabled" or "Disabled", 2)
    end })
    s:AddInput({ Title = "Hold Keybind", Default = "E", Placeholder = "E / Q / F",
        Callback = function(inp)
            inp = tostring(inp or ""):gsub("%s+", "")
            if inp == "" then return end
            W.AimHidden_SetKey(inp)
            W.W2_Notify("Aim Lock Hidden", "Key: " .. inp:upper(), 2)
        end })

    local s2 = W.T_Kill:AddSection("Aim Lock Attack")
    s2:AddToggle({ Title = "Enable (Hold M2)", Default = false, Callback = function(v)
        if W.AttackAim_Cfg then W.AttackAim_Cfg.Enabled = v end
        if v and W.AttackAim_Start then W.AttackAim_Start() end
        W.W2_Notify("Aim Lock Attack", v and "Enabled" or "Disabled", 2)
    end })
    s2:AddSlider({ Title = "FOV Radius", Min = 50, Max = 1000, Default = 250, Increment = 10,
        Callback = function(v)
            if W.AttackAim_Cfg then W.AttackAim_Cfg.FOV = v end
        end })

    local s3 = W.T_Kill:AddSection("Aimbot Zombie")
    s3:AddToggle({ Title = "Enable (Hold M2)", Default = false, Callback = function(v)
        W2.AimbotZombie_Enabled = v
        if v and W.ZombieAim_Start then W.ZombieAim_Start() end
        W.W2_Notify("Aimbot Zombie", v and "Enabled" or "Disabled", 2)
    end })
    s3:AddSlider({ Title = "FOV Radius", Min = 50, Max = 1000, Default = 250, Increment = 10,
        Callback = function(v)
            if W.ZombieAim_Cfg then W.ZombieAim_Cfg.FOV = v end
        end })
                                        end--====================================================--
-- PART 13: KILLER — ANTI BLIND + DESTROY PALLET + MASKED + VEIL V1/V2
--====================================================--

W2.AntiBlind_Enabled = W2.AntiBlind_Enabled or false
W2.DestroyPallet     = W2.DestroyPallet     or false
W2.Masked_Power      = W2.Masked_Power      or "Cobra"

W2.VeilV1_Enabled     = W2.VeilV1_Enabled     or false
W2.VeilV1_ShowFOV     = W2.VeilV1_ShowFOV     ~= false
W2.VeilV1_ShowTracker = W2.VeilV1_ShowTracker or false
W2.VeilV1_AutoPredict = W2.VeilV1_AutoPredict ~= false
W2.VeilV1_FOV         = W2.VeilV1_FOV         or 150
W2.VeilV1_MaxDist     = W2.VeilV1_MaxDist     or 280
W2.VeilV1_SpearSpeed  = W2.VeilV1_SpearSpeed  or 165
W2.VeilV1_Gravity     = W2.VeilV1_Gravity     or 103
W2.VeilV1_Lead        = W2.VeilV1_Lead        or 1.4

-- === ANTI BLIND (flag only, hook digabung di PART 16) ===
-- Cuma set flag, hook __namecall global ada di PART 16

-- === DESTROY PALLET ===
getgenv().W2_BreakingPallet = false
function W.DestroyPallets()
    if not W2.DestroyPallet then return end
    if GetRole() ~= "Killer" then return end
    if getgenv().W2_BreakingPallet then return end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if not c or not root then return end
    local st = c:GetAttribute("IsStunned") or c:GetAttribute("isStunned")
    local im = c:GetAttribute("Immobile") or c:GetAttribute("immobile")
    local cr = c:GetAttribute("IsCarrying") or c:GetAttribute("isCarrying")
    local ci = c:FindFirstChild("CheckInterractable")
    local act = ci and (ci:GetAttribute("action") or ci:GetAttribute("Action"))
    if st or im or cr or act then return end
    local pts = CollectionService:GetTagged("PalletPointSlide")
    local near, nd = nil, 6
    for _, p in ipairs(pts) do
        if p:IsA("BasePart") and not CollectionService:HasTag(p, "doing action") then
            local d = (p.Position - root.Position).Magnitude
            if d < nd then nd = d; near = p end
        end
    end
    if not near then return end
    getgenv().W2_BreakingPallet = true
    task.spawn(function()
        pcall(function()
            local r = ReplicatedStorage:FindFirstChild("Remotes")
            local pf = r and r:FindFirstChild("Pallet")
            local j = pf and pf:FindFirstChild("Jason")
            if j then
                local dg = j:FindFirstChild("Destroy-Global")
                local com = j:FindFirstChild("PalletBreakCommit")
                if dg and dg:IsA("RemoteEvent") then dg:FireServer(near) end
                if com and com:IsA("RemoteEvent") then com:FireServer(near) end
            end
        end)
        task.wait(0.2)
        local s = os.clock()
        while c and c.Parent and (c:GetAttribute("Immobile") or c:GetAttribute("immobile")) do
            if os.clock() - s > 3 then break end
            task.wait(0.1)
        end
        getgenv().W2_BreakingPallet = false
    end)
end

-- === SELECT MASKED POWER ===
W.Masked = W.Masked or { CurrentPower = "Cobra", Powers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex", "Tony"} }
local Masked = W.Masked

function W.Masked_Activate()
    local ev = ReplicatedStorage:FindFirstChild("Remotes", true)
        and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
        and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
        and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Activatepower")
    if ev then
        pcall(function() ev:FireServer(Masked.CurrentPower) end)
        W.W2_Notify("Select Masked", "Activated: " .. Masked.CurrentPower, 2)
    else W.ForceNotify("Select Masked", "Remote not found", 2) end
end
function W.Masked_Deactivate()
    local ev = ReplicatedStorage:FindFirstChild("Remotes", true)
        and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
        and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
        and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Deactivatepower")
    if ev then
        pcall(function() ev:FireServer() end)
        W.W2_Notify("Select Masked", "Deactivated", 2)
    else W.ForceNotify("Select Masked", "Remote not found", 2) end
end

-- === SILENT SPEAR VEIL V1 ===
do
    local VeilState = { target = nil, lookVector = nil, velHistory = {} }

    local function Veil_IsSurvivor(p)
        if not p or not p.Team or not p.Team.Name then return false end
        return string.find(string.lower(p.Team.Name), "survivor", 1, true) ~= nil
    end

    local function Veil_solvePitch(p, d, dy)
        d = math.max(d, 0.1)
        local s2 = p.v0 * p.v0
        local root = s2 * s2 - p.g * (p.g * d * d + 2 * dy * s2)
        if root < 0 then root = 0 end
        local tanTheta = (s2 - math.sqrt(root)) / (p.g * d)
        local theta = math.atan(tanTheta)
        local t = d / (p.v0 * math.cos(theta))
        return theta, t
    end

    local function Veil_GetVel(char)
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
        if not root or not root:IsA("BasePart") then return Vector3.zero end
        local now = os.clock()
        local last = VeilState.velHistory[char]
        local measured = Vector3.zero
        if last and now - last.t > 0.02 then
            measured = (root.Position - last.pos) / (now - last.t)
            if measured.Magnitude > 150 then measured = last.smooth or Vector3.zero end
        end
        local smooth = last and last.smooth or measured
        smooth = smooth:Lerp(measured, 0.65)
        VeilState.velHistory[char] = { pos = root.Position, t = now, smooth = smooth }
        if smooth.Magnitude < 1 then return Vector3.zero end
        return Vector3.new(smooth.X, 0, smooth.Z)
    end

    Players.PlayerRemoving:Connect(function(p)
        if p.Character then VeilState.velHistory[p.Character] = nil end
    end)

    local function Veil_Update()
        if GetRole() ~= "Killer" then VeilState.target = nil; VeilState.lookVector = nil; return end
        local cam = Workspace.CurrentCamera
        if not cam then return end
        if not W2.VeilV1_Enabled then VeilState.target = nil; VeilState.lookVector = nil; return end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        local near, nearPart = nil, nil
        local bestD = W2.VeilV1_FOV or 150
        local bestS = W2.VeilV1_MaxDist or 280
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and Veil_IsSurvivor(p) and p.Character then
                local pc = p.Character
                local isDown = pc:GetAttribute("Knocked") == true or pc:GetAttribute("HookProgressDepleting") == true
                if not isDown then
                    local hum = pc:FindFirstChildOfClass("Humanoid")
                    local tPart = pc:FindFirstChild("UpperTorso") or pc:FindFirstChild("Torso") or pc:FindFirstChild("HumanoidRootPart")
                    if hum and hum.Health > 0 and tPart then
                        local sp, on = cam:WorldToViewportPoint(tPart.Position)
                        if on and sp.Z > 0 then
                            local sd = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                            if sd < bestD then
                                local stud = (tPart.Position - hrp.Position).Magnitude
                                if stud <= bestS then bestD = sd; near = p; nearPart = tPart end
                            end
                        end
                    end
                end
            end
        end
        if near and near.Character and nearPart then
            local tp = nearPart.Position
            local hand = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
            local origin = (hand and hand:IsA("BasePart")) and hand.Position or hrp.Position
            local dir = tp - origin
            local dist = dir.Magnitude
            if dist > 0.1 and dist <= (W2.VeilV1_MaxDist or 280) then
                local isAura = char:GetAttribute("special") == true
                local prof
                if isAura then
                    prof = { v0 = 165, g = 96.5, windup = 0.10, latency = 0.04, maxlead = 25, scale = W2.VeilV1_Lead or 1.4 }
                else
                    prof = { v0 = W2.VeilV1_SpearSpeed or 165, g = W2.VeilV1_Gravity or 103, windup = 0.10, latency = 0.04, maxlead = 45, scale = W2.VeilV1_Lead or 1.4 }
                end
                local aimPoint = tp
                if W2.VeilV1_AutoPredict then
                    local vel = Veil_GetVel(near.Character)
                    if vel.Magnitude > 0.5 then
                        local h0 = Vector3.new(dir.X, 0, dir.Z)
                        local _, tFlight = Veil_solvePitch(prof, h0.Magnitude, dir.Y)
                        local ping = 0.08
                        pcall(function() ping = math.clamp(LP:GetNetworkPing(), 0, 0.35) end)
                        local delay = tFlight + prof.windup + ping + prof.latency
                        for _ = 1, 2 do
                            local lead = vel * delay * prof.scale
                            local maxLead = math.clamp(dist * 0.6, 3, prof.maxlead)
                            if lead.Magnitude > maxLead then lead = lead.Unit * maxLead end
                            aimPoint = tp + lead
                            local ad = aimPoint - origin
                            local ah = Vector3.new(ad.X, 0, ad.Z)
                            local _, t2 = Veil_solvePitch(prof, math.max(ah.Magnitude, 0.1), ad.Y)
                            delay = t2 + prof.windup + ping + prof.latency
                        end
                    end
                end
                local adir = aimPoint - origin
                local ah = Vector3.new(adir.X, 0, adir.Z)
                local ahDist = ah.Magnitude
                local pitch = Veil_solvePitch(prof, ahDist, adir.Y)
                if ahDist > 0.001 then
                    VeilState.lookVector = ah.Unit * math.cos(pitch) + Vector3.new(0, math.sin(pitch), 0)
                else
                    VeilState.lookVector = adir.Unit
                end
                VeilState.target = near
            end
        else
            VeilState.target = nil; VeilState.lookVector = nil
        end
    end

    -- Simpan referensi lookVector ke W biar bisa diakses hook global di PART 16
    W._VeilV1_State = VeilState
    RunService.RenderStepped:Connect(function() pcall(Veil_Update) end)
end

-- === SILENT SPEAR VEIL V2 (W424 style) ===
do
    local Config = {}
    local Camera = Workspace.CurrentCamera
    local AimConfig = AimConfig or {}
    AimConfig.Aim_SilentVeil = false
    AimConfig.Aim_SilentVeilV2 = false
    AimConfig.Veil_ShowFOV = true
    AimConfig.SpearSmart_enable = false
    AimConfig.Veil_FOV = 150
    AimConfig.SPEAR_Speed = 165
    AimConfig.SPEAR_Gravity = workspace.Gravity * 0.5
    AimConfig.SPEAR_MaxDist = 200
    AimConfig.Veil_LeadMultiplier = 1.4
    AimConfig.AIM_Auto = false
    AimConfig.AIM_TargetPart = "Torso"

    local isChargingSpear = false
    local isAttackCD = false
    local isFiringSpear = false
    local currentTouch = nil

    local function IsSilentOn() return AimConfig.Aim_SilentVeil or AimConfig.Aim_SilentVeilV2 end

    local function getTargetPartObject(char)
        if AimConfig.AIM_TargetPart == "Head" then return char:FindFirstChild("Head")
        elseif AimConfig.AIM_TargetPart == "Root" or AimConfig.AIM_TargetPart == "HumanoidRootPart" then return char:FindFirstChild("HumanoidRootPart")
        else return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart") end
    end

    local function getClosestSurvivor()
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        local closestFov = AimConfig.Veil_FOV
        local closest = nil
        local cam = workspace.CurrentCamera
        local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Team and p.Team.Name == "Survivors" and p.Character then
                local char = p.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                local tPart = getTargetPartObject(char)
                if hum and hum.Health > 0 and tPart then
                    local d3 = (tPart.Position - myRoot.Position).Magnitude
                    if d3 <= AimConfig.SPEAR_MaxDist then
                        local sp, on = cam:WorldToViewportPoint(tPart.Position)
                        if on then
                            local d2 = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                            if d2 <= closestFov then closestFov = d2; closest = tPart end
                        end
                    end
                end
            end
        end
        return closest
    end

    local vHighlight = Instance.new("Highlight")
    vHighlight.Name = "W2_VeilTarget"
    vHighlight.FillColor = Color3.fromRGB(150, 150, 150)
    vHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    vHighlight.FillTransparency = 0.5
    vHighlight.OutlineTransparency = 0

    local trackerOn = false
    local trackerLine = nil
    local curBillboard = nil

    local function setupTracker()
        if CoreGui:FindFirstChild("W2VeilTrackerGui") then return end
        local sg = Instance.new("ScreenGui")
        sg.Name = "W2VeilTrackerGui"
        sg.IgnoreGuiInset = true
        sg.ResetOnSpawn = false
        sg.Parent = CoreGui
        trackerLine = Instance.new("Frame")
        trackerLine.AnchorPoint = Vector2.new(0.5, 0.5)
        trackerLine.BackgroundColor3 = Color3.fromRGB(138, 138, 138)
        trackerLine.BackgroundTransparency = 0.2
        trackerLine.BorderSizePixel = 0
        trackerLine.Visible = false
        trackerLine.Parent = sg
    end
    setupTracker()

    local fovFrame = nil
    if not CoreGui:FindFirstChild("W2FOVCircleGui") then
        local fg = Instance.new("ScreenGui")
        fg.Name = "W2FOVCircleGui"
        fg.Parent = CoreGui
        fg.ResetOnSpawn = false
        fg.IgnoreGuiInset = true
        fovFrame = Instance.new("Frame")
        fovFrame.BackgroundTransparency = 1
        fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        fovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        fovFrame.Visible = false
        fovFrame.Parent = fg
        Instance.new("UICorner", fovFrame).CornerRadius = UDim.new(1, 0)
        local stk = Instance.new("UIStroke", fovFrame)
        stk.Color = Color3.fromRGB(222, 222, 222)
        stk.Thickness = 1.5
    end

    -- Setup input handler dulu (bukan hook)
    UserInputService.InputBegan:Connect(function(inp, gp)
        local isTouch = (inp.UserInputType == Enum.UserInputType.Touch)
        if gp and not isTouch then return end
        local c = LP.Character
        local isSpear = c and c:GetAttribute("spearmode") == true
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            if IsSilentOn() and isSpear then isChargingSpear = true end
        end
        if isTouch then
            if IsSilentOn() and isSpear then
                local pg = LP:FindFirstChild("PlayerGui")
                if pg then
                    local sm = pg:FindFirstChild("Slasher-mob")
                    local ctrl = sm and sm:FindFirstChild("Controls")
                    local atk = ctrl and ctrl:FindFirstChild("attack")
                    if atk and atk.Visible then
                        local pos = inp.Position
                        local ap = atk.AbsolutePosition
                        local az = atk.AbsoluteSize
                        if pos.X >= ap.X and pos.X <= ap.X + az.X and pos.Y >= ap.Y and pos.Y <= ap.Y + az.Y then
                            isChargingSpear = true
                            currentTouch = inp
                        end
                    end
                end
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(inp, gp)
        if isChargingSpear and (inp == currentTouch or inp.UserInputType == Enum.UserInputType.MouseButton1) then
            isChargingSpear = false
            if isAttackCD then return end
            isAttackCD = true
            task.delay(2, function() isAttackCD = false end)
            local myChar = LP.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local startPart = myChar and (myChar:FindFirstChild("Head") or myHRP)
            if startPart and myHRP then
                local isSpecial = myChar:GetAttribute("special") == true
                local startPos = Config.SpearSmart_enable and myHRP.Position or startPart.Position
                local curSpeed = Config.SpearSmart_enable and (isSpecial and 165 or 142.5) or AimConfig.SPEAR_Speed
                local targetPart = getClosestSurvivor()
                local aimDir
                if targetPart then
                    local targetHRP = targetPart:IsA("Model") and targetPart:FindFirstChild("HumanoidRootPart") or targetPart
                    local targetPos = targetHRP.Position
                    local targetVel = Vector3.new(0,0,0)
                    local targetHum = targetPart.Parent and targetPart.Parent:FindFirstChildOfClass("Humanoid")
                    if targetHum and targetHum.MoveDirection.Magnitude > 0 then
                        targetVel = targetHum.MoveDirection * targetHum.WalkSpeed
                    elseif targetHRP:IsA("BasePart") then
                        targetVel = targetHRP.AssemblyLinearVelocity
                    end
                    targetVel = Vector3.new(targetVel.X, 0, targetVel.Z)
                    local distance = (targetPos - startPos).Magnitude
                    local timeToHit = distance / curSpeed
                    if Config.SpearSmart_enable then
                        local leadMult = AimConfig.Veil_LeadMultiplier or 1.4
                        local predicted = targetPos + (targetVel * (timeToHit * leadMult))
                        local spearG = workspace.Gravity * 0.5
                        local dropComp = 0.5 * spearG * (timeToHit ^ 2)
                        local finalPos = predicted + Vector3.new(0, dropComp - 1.5, 0)
                        aimDir = (finalPos - startPos).Unit
                    else
                        local dynPred = math.clamp(distance / 50, 0.1, 4.0)
                        local predicted = targetPos + (targetVel * (timeToHit * dynPred))
                        local distMult = math.clamp(distance / 100, 1, 2.5)
                        local autoG = math.max(0, distance - 8)
                        local g = AimConfig.AIM_Auto and autoG or AimConfig.SPEAR_Gravity
                        local dropComp = 0.5 * g * (timeToHit ^ 2) * distMult
                        local finalPos = predicted + Vector3.new(0, dropComp, 0)
                        aimDir = (finalPos - startPos).Unit
                    end
                else
                    aimDir = Camera.CFrame.LookVector
                end
                if AimConfig.Aim_SilentVeil then
                    pcall(function()
                        ReplicatedStorage.Remotes.Killers.Veil.Spearthrow:FireServer(aimDir, curSpeed, startPos)
                    end)
                end
            end
        end
    end)

    RunService.RenderStepped:Connect(function()
        local c = LP.Character
        local isSpear = c and c:GetAttribute("spearmode") == true
        local cam = workspace.CurrentCamera
        if fovFrame then
            if IsSilentOn() and AimConfig.Veil_ShowFOV and isSpear then
                fovFrame.Visible = true
                fovFrame.Size = UDim2.new(0, AimConfig.Veil_FOV * 2, 0, AimConfig.Veil_FOV * 2)
            else fovFrame.Visible = false end
        end
        if IsSilentOn() and isSpear and cam then
            local targetPart = getClosestSurvivor()
            if targetPart and targetPart.Parent then
                vHighlight.Parent = targetPart.Parent
                if trackerOn then
                    if not curBillboard or curBillboard.Parent ~= targetPart then
                        if curBillboard then curBillboard:Destroy() end
                        local bb = Instance.new("BillboardGui")
                        bb.Name = "VeilTrackerBillboard"
                        bb.Size = UDim2.fromOffset(14, 14)
                        bb.AlwaysOnTop = true
                        bb.LightInfluence = 0
                        bb.MaxDistance = 500
                        local ring = Instance.new("Frame")
                        ring.AnchorPoint = Vector2.new(0.5, 0.5)
                        ring.Position = UDim2.fromScale(0.5, 0.5)
                        ring.Size = UDim2.fromScale(1, 1)
                        ring.BackgroundTransparency = 1
                        ring.Parent = bb
                        Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
                        local s = Instance.new("UIStroke")
                        s.Color = Color3.fromRGB(255, 255, 255)
                        s.Thickness = 1
                        s.Transparency = 0.1
                        s.Parent = ring
                        bb.Adornee = targetPart
                        bb.Parent = targetPart
                        curBillboard = bb
                    end
                    local sp, on = cam:WorldToViewportPoint(targetPart.Position)
                    if on and sp.Z > 0 and trackerLine then
                        local vp = cam.ViewportSize
                        local fx = vp.X * 0.5
                        local fy = vp.Y
                        local tx, ty = sp.X, sp.Y
                        local dx, dy = tx - fx, ty - fy
                        local len = math.sqrt(dx * dx + dy * dy)
                        trackerLine.Size = UDim2.fromOffset(math.max(len, 1), 1)
                        trackerLine.Position = UDim2.fromOffset((fx + tx) * 0.5, (fy + ty) * 0.5)
                        trackerLine.Rotation = math.deg(math.atan2(dy, dx))
                        trackerLine.Visible = true
                    elseif trackerLine then trackerLine.Visible = false end
                else
                    if curBillboard then curBillboard:Destroy(); curBillboard = nil end
                    if trackerLine then trackerLine.Visible = false end
                end
            else
                vHighlight.Parent = nil
                if curBillboard then curBillboard:Destroy(); curBillboard = nil end
                if trackerLine then trackerLine.Visible = false end
            end
        else
            vHighlight.Parent = nil
            if curBillboard then curBillboard:Destroy(); curBillboard = nil end
            if trackerLine then trackerLine.Visible = false end
        end
    end)

    W.W424Veil_API = {
        AimConfig = AimConfig,
        Config = Config,
        getClosestSurvivor = getClosestSurvivor,
        IsVeilSilentOn = IsSilentOn,
        setTracker = function(v) trackerOn = v end,
    }
end

-- === UI SECTION ===
do
    local s = W.T_Kill:AddSection("Anti Blind")
    s:AddToggle({ Title = "Enable", Content = "Block efek pusing dari flashlight survivor",
        Default = false, Callback = function(v)
            W2.AntiBlind_Enabled = v
            W.W2_Notify("Anti Blind", v and "Enabled" or "Disabled", 2)
        end })

    local s2 = W.T_Kill:AddSection("Destroy Pallet")
    s2:AddToggle({ Title = "Enable Auto Destroy", Default = false, Callback = function(v)
        W2.DestroyPallet = v
        W.W2_Notify("Destroy Pallet", v and "Enabled" or "Disabled", 2)
    end })

    local s3 = W.T_Kill:AddSection("Select Masked Power")
    s3:AddDropdown({ Title = "Power", Options = Masked.Powers, Default = Masked.CurrentPower,
        Callback = function(v)
            local val = type(v) == "table" and v[1] or v
            Masked.CurrentPower = val; W2.Masked_Power = val
        end })
    s3:AddButton({ Title = "Activate", Callback = function() W.Masked_Activate() end })
    s3:AddButton({ Title = "Deactivate", Callback = function() W.Masked_Deactivate() end })

    local s4 = W.T_Kill:AddSection("Silent Spear Veil V1")
    s4:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
        W2.VeilV1_Enabled = v
        W.W2_Notify("Veil V1", v and "Enabled" or "Disabled", 2)
    end })
    s4:AddToggle({ Title = "Show FOV", Default = true, Callback = function(v) W2.VeilV1_ShowFOV = v end })
    s4:AddToggle({ Title = "Show Tracker", Default = false, Callback = function(v) W2.VeilV1_ShowTracker = v end })
    s4:AddToggle({ Title = "Auto Predict", Default = true, Callback = function(v) W2.VeilV1_AutoPredict = v end })
    s4:AddSlider({ Title = "FOV Size", Min = 50, Max = 500, Default = 150, Increment = 10,
        Callback = function(v) W2.VeilV1_FOV = v end })
    s4:AddSlider({ Title = "Max Distance", Min = 50, Max = 280, Default = 280, Increment = 10,
        Callback = function(v) W2.VeilV1_MaxDist = v end })

    local s5 = W.T_Kill:AddSection("Silent Spear Veil V2")
    s5:AddToggle({ Title = "V1", Default = false, Callback = function(v)
        W.W424Veil_API.AimConfig.Aim_SilentVeil = v
    end })
    s5:AddToggle({ Title = "V2", Default = false, Callback = function(v)
        W.W424Veil_API.AimConfig.Aim_SilentVeilV2 = v
        W.W2_Notify("Veil V2", v and "ON" or "OFF", 2)
    end })
    s5:AddToggle({ Title = "Auto Predict", Default = false, Callback = function(v)
        W.W424Veil_API.Config.SpearSmart_enable = v
    end })
    s5:AddSlider({ Title = "Lead Multiplier", Min = 0.5, Max = 5, Default = 1.4,
        Callback = function(v) W.W424Veil_API.AimConfig.Veil_LeadMultiplier = v end })
    s5:AddSlider({ Title = "Spear Speed", Min = 50, Max = 200, Default = 165,
        Callback = function(v) W.W424Veil_API.AimConfig.SPEAR_Speed = v end })
    s5:AddSlider({ Title = "Spear Gravity", Min = 0, Max = 200, Default = 103,
        Callback = function(v) W.W424Veil_API.AimConfig.SPEAR_Gravity = v end })
    s5:AddToggle({ Title = "ESP Tracker", Default = false, Callback = function(v)
        W.W424Veil_API.setTracker(v)
    end })
                                            end--====================================================--
-- PART 14 FIXED v2: BYPASS + UNLOCK CARRY + SPEAR AIMBOT + KILLER ABILITIES
-- FIX: Killer Abilities gabungan (toggle + instant button dalam 1 section)
--====================================================--

W2.Bypass_HiddenLeap = W2.Bypass_HiddenLeap or false
W2.Bypass_MyersGrab  = W2.Bypass_MyersGrab  or false
W2.Bypass_LakeMist   = W2.Bypass_LakeMist   or false
W2.Bypass_Pursuit    = W2.Bypass_Pursuit    or false
W2.Bypass_AbyssCD    = W2.Bypass_AbyssCD    or false
W2.Bypass_JeffFrenzy = W2.Bypass_JeffFrenzy or false
W2.UnlockCarry_Enabled = W2.UnlockCarry_Enabled or false
W2.SpearAimbot_Enabled = W2.SpearAimbot_Enabled or false
W2.SpearAimbot_Gravity = W2.SpearAimbot_Gravity or 50
W2.SpearAimbot_Speed   = W2.SpearAimbot_Speed   or 100
W2.AutoStalk           = W2.AutoStalk           or false
W2.AutoStalk_Range     = W2.AutoStalk_Range     or 150
W2.AutoKillAll         = W2.AutoKillAll         or false
W2.DropAllPallet       = W2.DropAllPallet       or false
W2.BlockAllVault       = W2.BlockAllVault       or false
W2.AutoHook            = W2.AutoHook            or false

-- === BYPASS: HIDDEN LEAP ===
getgenv().W2_HiddenLeapThread = nil
function W.StartHiddenBypass()
    if getgenv().W2_HiddenLeapThread then return end
    getgenv().W2_HiddenLeapThread = task.spawn(function()
        local leapFn, m2Fn
        local function scan()
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "function" and islclosure(v) then
                        local info
                        pcall(function() info = debug.getinfo(v) end)
                        if info then
                            if info.name == "tryActivate" then leapFn = v
                            elseif info.name == "playM2Animation" then m2Fn = v end
                        end
                    end
                    if leapFn and m2Fn then break end
                end
            end)
        end
        scan()
        local lastScan = os.clock()
        while task.wait(0.1) do
            if not W2.Bypass_HiddenLeap then break end
            if not (leapFn and m2Fn) then
                if os.clock() - lastScan >= 2 then lastScan = os.clock(); scan() end
            end
            if leapFn then
                pcall(function()
                    for i, v in pairs(debug.getupvalues(leapFn)) do
                        if type(v) == "boolean" and v == true then debug.setupvalue(leapFn, i, false) end
                    end
                end)
            end
            if m2Fn then
                pcall(function()
                    for i, v in pairs(debug.getupvalues(m2Fn)) do
                        if type(v) == "boolean" and v == true then debug.setupvalue(m2Fn, i, false) end
                    end
                end)
            end
        end
        getgenv().W2_HiddenLeapThread = nil
    end)
end
function W.SetHiddenLeap(v)
    W2.Bypass_HiddenLeap = v and true or false
    if W2.Bypass_HiddenLeap then W.StartHiddenBypass() end
end

-- === BYPASS: MYERS INFINITE GRAB ===
W.MyersData = W.MyersData or { Enabled = false, Hotkey = Enum.KeyCode.H }
local Myers = W.MyersData

function W.Myers_GetTarget()
    local c = LP.Character
    if not c then return nil end
    local myHRP = c:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and h and h.Health > 0 then
                table.insert(list, { player = p, dist = (hrp.Position - myHRP.Position).Magnitude })
            end
        end
    end
    table.sort(list, function(a, b) return a.dist < b.dist end)
    for _, v in ipairs(list) do return v.player end
    return nil
end

function W.Myers_DoGrab()
    if not Myers.Enabled then return end
    local t = W.Myers_GetTarget()
    if not t or not t.Character then return end
    pcall(function() ReplicatedStorage.Remotes.Killers.Stalker.grab:FireServer(t.Character) end)
end

function W.Myers_Set(v)
    Myers.Enabled = v and true or false
    W2.Bypass_MyersGrab = Myers.Enabled
end

UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Myers.Hotkey and Myers.Enabled then W.Myers_DoGrab() end
end)

-- === BYPASS: SLASHER (LakeMist + Pursuit) ===
getgenv().W2_SlasherThread = nil
function W.StartSlasherBypass()
    if getgenv().W2_SlasherThread then return end
    pcall(function()
        local b = true
        local mt = debug.getmetatable(b)
        if not mt then mt = {}; debug.setmetatable(b, mt) end
        if setreadonly then setreadonly(mt, false) end
        mt.__div = function() return 0 end
        mt.__mul = function() return 0 end
        mt.__add = function() return 0 end
        mt.__sub = function() return 0 end
        if setreadonly then setreadonly(mt, true) end
    end)
    getgenv().W2_SlasherThread = task.spawn(function()
        local toggleFn, pursuitFn
        local function scan()
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "function" and islclosure(v) then
                        local cs = debug.getconstants(v)
                        local ho, hl, ha, ht = false, false, false, false
                        local hp, hw = false, false
                        for _, c in pairs(cs) do
                            if c == "Offset" then ho = true end
                            if c == "Linear" then hl = true end
                            if c == "action" then ha = true end
                            if c == "TweenInfo" then ht = true end
                            if c == "Pursuit" then hp = true end
                            if c == "WalkSpeed" then hw = true end
                        end
                        if ho and hl and ha and ht and not hp then toggleFn = v end
                        if hp and ht and ha and hw then pursuitFn = v end
                    end
                    if toggleFn and pursuitFn then break end
                end
            end)
        end
        scan()
        local lastScan = os.clock()
        while task.wait(0.1) do
            if not W2.Bypass_LakeMist and not W2.Bypass_Pursuit then break end
            if not (toggleFn and pursuitFn) then
                if os.clock() - lastScan >= 2 then scan(); lastScan = os.clock() end
            end
            if toggleFn and W2.Bypass_LakeMist then
                pcall(function()
                    debug.setupvalue(toggleFn, 6, false)
                    debug.setupvalue(toggleFn, 10, false)
                end)
            end
            if pursuitFn and W2.Bypass_Pursuit then
                pcall(function()
                    debug.setupvalue(pursuitFn, 5, false)
                    debug.setupvalue(pursuitFn, 6, false)
                end)
            end
        end
        getgenv().W2_SlasherThread = nil
    end)
end
function W.SetLakeMist(v)
    W2.Bypass_LakeMist = v and true or false
    if W2.Bypass_LakeMist or W2.Bypass_Pursuit then W.StartSlasherBypass() end
end
function W.SetPursuit(v)
    W2.Bypass_Pursuit = v and true or false
    if W2.Bypass_LakeMist or W2.Bypass_Pursuit then W.StartSlasherBypass() end
end

-- === BYPASS: ABYSS ===
getgenv().W2_AbyssConn = nil
getgenv().W2_CorruptFn = nil
function W.StartAbyssBypass()
    if not getgenv().W2_CorruptFn then
        pcall(function()
            for _, v in pairs(getgc(true)) do
                if type(v) == "function" and islclosure(v) then
                    local cs = debug.getconstants(v)
                    if table.find(cs, "corrupt") and table.find(cs, "Immobile") then
                        getgenv().W2_CorruptFn = v
                        break
                    end
                end
            end
        end)
    end
    if not getgenv().W2_CorruptFn then return end
    if getgenv().W2_AbyssConn then getgenv().W2_AbyssConn:Disconnect() end
    getgenv().W2_AbyssConn = RunService.Heartbeat:Connect(function()
        if not W2.Bypass_AbyssCD then return end
        if getgenv().W2_CorruptFn then
            local ups = debug.getupvalues(getgenv().W2_CorruptFn)
            for i, v in pairs(ups) do
                if type(v) == "boolean" and v == false then
                    debug.setupvalue(getgenv().W2_CorruptFn, i, true)
                end
            end
        end
    end)
end
function W.SetAbyssBypass(v)
    W2.Bypass_AbyssCD = v and true or false
    if W2.Bypass_AbyssCD then W.StartAbyssBypass()
    elseif getgenv().W2_AbyssConn then getgenv().W2_AbyssConn:Disconnect(); getgenv().W2_AbyssConn = nil end
end

-- === BYPASS: JEFF INFINITE FRENZY ===
getgenv().W2_JeffThread = nil
function W.StartJeffBypass()
    if getgenv().W2_JeffThread then return end
    getgenv().W2_JeffThread = task.spawn(function()
        while task.wait() do
            if not W2.Bypass_JeffFrenzy then break end
            pcall(function()
                local c = LP.Character
                if c and c:GetAttribute("Frenzy") ~= true then c:SetAttribute("Frenzy", true) end
            end)
        end
        getgenv().W2_JeffThread = nil
    end)
end
function W.StopJeffBypass()
    pcall(function()
        local c = LP.Character
        if c and c:GetAttribute("Frenzy") == true then
            c:SetAttribute("Frenzy", false)
            local k = ReplicatedStorage:FindFirstChild("Remotes")
                and ReplicatedStorage.Remotes:FindFirstChild("Killers")
                and ReplicatedStorage.Remotes.Killers:FindFirstChild("Killer")
            if k then
                local d = k:FindFirstChild("Deactivatefromclient")
                if d then d:FireServer() end
            end
        end
    end)
end
function W.SetJeffFrenzy(v)
    W2.Bypass_JeffFrenzy = v and true or false
    if W2.Bypass_JeffFrenzy then W.StartJeffBypass() else W.StopJeffBypass() end
end

-- === UNLOCK SKILL WHILE CARRYING ===
W.CarryCfg = W.CarryCfg or { Enabled = false }
function W.SetUnlockCarry(v)
    W2.UnlockCarry_Enabled = v and true or false
    W.CarryCfg.Enabled = W2.UnlockCarry_Enabled
end

-- === SPEAR AIMBOT ===
do
    local SD = { UI = nil, Button = nil, Active = true, DragLocked = false, Dragging = false, DragStart = nil, DragStartPos = nil, ManualTarget = nil, TargetIndex = 0, TargetLabel = nil }

    local function calc(targetPos)
        if not W2.SpearAimbot_Enabled or GetRole() ~= "Killer" then return nil end
        local c = LP.Character
        if not c then return nil end
        local root = c:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local startPos = root.Position + Vector3.new(0, 2, 0)
        local dist = (targetPos - startPos).Magnitude
        local g = W2.SpearAimbot_Gravity or 50
        local sp = W2.SpearAimbot_Speed or 100
        local t = dist / sp
        local drop = 0.5 * g * t * t
        return targetPos + Vector3.new(0, drop, 0)
    end

    local function targetList()
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local l = {}
        if not root then return l end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and TeamIs(p, "Survivor") and p.Character then
                local tr = p.Character:FindFirstChild("HumanoidRootPart")
                local th = p.Character:FindFirstChildOfClass("Humanoid")
                if tr and th and th.MaxHealth > 0 and (th.Health / th.MaxHealth) > 0.25 then
                    table.insert(l, { P = p, D = (tr.Position - root.Position).Magnitude })
                end
            end
        end
        table.sort(l, function(a, b) return a.D < b.D end)
        local out = {}
        for _, v in ipairs(l) do table.insert(out, v.P) end
        return out
    end

    local function updateLabel()
        if not SD.TargetLabel then return end
        if SD.ManualTarget and SD.ManualTarget.Parent then
            SD.TargetLabel.Text = SD.ManualTarget.Name
        else SD.TargetLabel.Text = "AUTO" end
        SD.TargetLabel.Visible = true
    end

    local function cycle(dir)
        local l = targetList()
        if #l == 0 then
            SD.ManualTarget = nil; SD.TargetIndex = 0
            W.W2_Notify("Spear Aimbot", "No target", 2)
            return
        end
        local cur = nil
        if SD.ManualTarget then
            for i, p in ipairs(l) do
                if p == SD.ManualTarget then cur = i; break end
            end
        end
        local next
        if cur then
            next = cur + dir
            if next > #l then next = 1 end
            if next < 1 then next = #l end
        else next = 1 end
        SD.TargetIndex = next
        SD.ManualTarget = l[next]
        W.W2_Notify("Spear Aimbot", "Target: " .. SD.ManualTarget.Name, 2)
        updateLabel()
    end

    local function updateAim()
        if not W2.SpearAimbot_Enabled then return end
        if SD and not SD.Active then return end
        if GetRole() ~= "Killer" then return end
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local target = nil
        if SD.ManualTarget then
            local p = SD.ManualTarget
            local valid = p.Parent and TeamIs(p, "Survivor") and p.Character
            if valid then
                local tr = p.Character:FindFirstChild("HumanoidRootPart")
                local th = p.Character:FindFirstChildOfClass("Humanoid")
                valid = tr and th and th.MaxHealth > 0 and (th.Health / th.MaxHealth) > 0.25
            end
            if valid then target = p
            else SD.ManualTarget = nil; updateLabel() end
        end
        if not target then
            local closest, cd = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and TeamIs(p, "Survivor") and p.Character then
                    local tr = p.Character:FindFirstChild("HumanoidRootPart")
                    local th = p.Character:FindFirstChildOfClass("Humanoid")
                    if tr and th and th.MaxHealth > 0 and (th.Health / th.MaxHealth) > 0.25 then
                        local d = (tr.Position - root.Position).Magnitude
                        if d < cd then cd = d; closest = p end
                    end
                end
            end
            target = closest
        end
        if target and target.Character then
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local aimPos = calc(tr.Position)
                if aimPos then
                    local cam = Workspace.CurrentCamera
                    if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, aimPos) end
                end
            end
        end
    end

    local function buildButton()
        if SD.UI then pcall(function() SD.UI:Destroy() end) end
        local pg = LP:FindFirstChild("PlayerGui")
        if not pg then return end
        SD.UI = Instance.new("ScreenGui")
        SD.UI.Name = "W2SpearAimbotUI"
        SD.UI.ResetOnSpawn = false
        SD.UI.IgnoreGuiInset = true
        SD.UI.Parent = pg
        SD.Button = Instance.new("TextButton")
        SD.Button.Name = "SpearAimbotButton"
        SD.Button.Size = UDim2.new(0, 65, 0, 65)
        SD.Button.Position = UDim2.new(0.15, 0, 0.75, 0)
        SD.Button.AnchorPoint = Vector2.new(0.5, 0.5)
        SD.Button.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
        SD.Button.BackgroundTransparency = 0.15
        SD.Button.AutoButtonColor = true
        SD.Button.Text = "SPEAR\nAIM"
        SD.Button.TextColor3 = Color3.fromRGB(255, 100, 100)
        SD.Button.TextSize = 11
        SD.Button.Font = Enum.Font.GothamBold
        SD.Button.Visible = false
        SD.Button.ZIndex = 10
        SD.Button.Parent = SD.UI
        Instance.new("UICorner", SD.Button).CornerRadius = UDim.new(1, 0)
        local stk = Instance.new("UIStroke", SD.Button)
        stk.Color = Color3.fromRGB(255, 80, 80)
        stk.Thickness = 2
        stk.Transparency = 0.2
        local lock = Instance.new("TextButton")
        lock.Size = UDim2.new(0, 22, 0, 22)
        lock.Position = UDim2.new(1, -5, 0, -5)
        lock.AnchorPoint = Vector2.new(1, 0)
        lock.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        lock.BackgroundTransparency = 0.3
        lock.Text = "L"
        lock.TextSize = 10
        lock.Font = Enum.Font.GothamBold
        lock.TextColor3 = Color3.new(1, 1, 1)
        lock.ZIndex = 11
        lock.Parent = SD.Button
        Instance.new("UICorner", lock).CornerRadius = UDim.new(1, 0)
        lock.MouseButton1Click:Connect(function()
            SD.DragLocked = not SD.DragLocked
            lock.Text = SD.DragLocked and "X" or "L"
            lock.BackgroundColor3 = SD.DragLocked and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(60, 60, 60)
        end)
        local lbl = Instance.new("TextLabel")
        lbl.Name = "TargetLabel"
        lbl.Size = UDim2.new(0, 90, 0, 18)
        lbl.Position = UDim2.new(0.5, 0, 0, -22)
        lbl.AnchorPoint = Vector2.new(0.5, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "AUTO"
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextSize = 12
        lbl.Font = Enum.Font.GothamBold
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.ZIndex = 11
        lbl.Visible = false
        lbl.Parent = SD.Button
        SD.TargetLabel = lbl
        local left = Instance.new("TextButton")
        left.Size = UDim2.new(0, 28, 0, 28)
        left.Position = UDim2.new(0, -34, 0.5, 0)
        left.AnchorPoint = Vector2.new(0.5, 0.5)
        left.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
        left.BackgroundTransparency = 0.15
        left.Text = "<"
        left.TextColor3 = Color3.fromRGB(158, 158, 158)
        left.TextSize = 16
        left.Font = Enum.Font.GothamBold
        left.ZIndex = 10
        left.Parent = SD.Button
        Instance.new("UICorner", left).CornerRadius = UDim.new(1, 0)
        local ls = Instance.new("UIStroke", left)
        ls.Color = Color3.fromRGB(255, 80, 80)
        ls.Thickness = 1.5
        ls.Transparency = 0.3
        left.MouseButton1Click:Connect(function() cycle(-1) end)
        local right = Instance.new("TextButton")
        right.Size = UDim2.new(0, 28, 0, 28)
        right.Position = UDim2.new(1, 34, 0.5, 0)
        right.AnchorPoint = Vector2.new(0.5, 0.5)
        right.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
        right.BackgroundTransparency = 0.15
        right.Text = ">"
        right.TextColor3 = Color3.fromRGB(255, 150, 150)
        right.TextSize = 16
        right.Font = Enum.Font.GothamBold
        right.ZIndex = 10
        right.Parent = SD.Button
        Instance.new("UICorner", right).CornerRadius = UDim.new(1, 0)
        local rs = Instance.new("UIStroke", right)
        rs.Color = Color3.fromRGB(255, 80, 80)
        rs.Thickness = 1.5
        rs.Transparency = 0.3
        right.MouseButton1Click:Connect(function() cycle(1) end)
        SD.Button.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                if SD.DragLocked then return end
                SD.Dragging = true
                SD.DragStart = inp.Position
                SD.DragStartPos = SD.Button.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if SD.Dragging and not SD.DragLocked and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                local d = inp.Position - SD.DragStart
                SD.Button.Position = UDim2.new(SD.DragStartPos.X.Scale, SD.DragStartPos.X.Offset + d.X, SD.DragStartPos.Y.Scale, SD.DragStartPos.Y.Offset + d.Y)
            end
        end)
        SD.Button.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                SD.Dragging = false
            end
        end)
        SD.Button.MouseButton1Click:Connect(function()
            SD.Active = not SD.Active
            if SD.Active then
                SD.Button.BackgroundColor3 = Color3.fromRGB(10, 40, 10)
                SD.Button.TextColor3 = Color3.fromRGB(80, 255, 120)
                stk.Color = Color3.fromRGB(80, 255, 120)
                W.W2_Notify("Spear Aimbot", "AKTIF", 2)
            else
                SD.Button.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
                SD.Button.TextColor3 = Color3.fromRGB(255, 100, 100)
                stk.Color = Color3.fromRGB(255, 80, 80)
                W.W2_Notify("Spear Aimbot", "NONAKTIF", 2)
            end
        end)
    end

    RunService.RenderStepped:Connect(function() pcall(updateAim) end)
    RunService.Heartbeat:Connect(function()
        if SD and SD.Button then
            local show = W2.SpearAimbot_Enabled and GetRole() == "Killer"
            SD.Button.Visible = show
            if show then pcall(updateLabel) end
        end
    end)
    LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        if W2.SpearAimbot_Enabled then pcall(buildButton) end
    end)
    function W.SpearAimbot_Set(v)
        W2.SpearAimbot_Enabled = v and true or false
        if v then SD.Active = true; buildButton()
        else
            if SD.UI then pcall(function() SD.UI:Destroy() end); SD.UI = nil end
            SD.Button = nil
        end
    end
    function W.SpearAimbot_SetG(v) W2.SpearAimbot_Gravity = tonumber(v) or 50 end
    function W.SpearAimbot_SetS(v) W2.SpearAimbot_Speed = tonumber(v) or 100 end
end

-- === KILLER ABILITIES — DENGAN TIMER EXPOSE ===
W.KA = W.KA or {
    AutoStalk = W2.AutoStalk, AutoStalkRange = W2.AutoStalk_Range,
    AutoKillAll = W2.AutoKillAll, DropAllPallet = W2.DropAllPallet,
    BlockAllVault = W2.BlockAllVault,
}
local KA = W.KA

W._KATimer = W._KATimer or { lastDrop = 0, lastBlock = 0 }
local _KAtimer = W._KATimer

function W.KA_Closest(range, minHP)
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, shortest = nil, (range or math.huge)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and TeamIs(p, "Survivor") then
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if h and hrp and h.Health > (minHP or 30) then
                local d = (hrp.Position - root.Position).Magnitude
                if d <= shortest then shortest = d; closest = p end
            end
        end
    end
    return closest
end

local AutoStalkConn = nil
function W.KA_StartAutoStalk()
    if AutoStalkConn then return end
    AutoStalkConn = RunService.Heartbeat:Connect(function()
        if not KA.AutoStalk then return end
        if GetRole() ~= "Killer" then return end
        local t = W.KA_Closest(KA.AutoStalkRange, 30)
        if not t or not t.Character then return end
        local ev = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
            and ReplicatedStorage.Remotes.Killers:FindFirstChild("Stalker", true)
            and ReplicatedStorage.Remotes.Killers.Stalker:FindFirstChild("StartStalking")
        if ev then pcall(function() ev:FireServer(t) end) end
    end)
end
function W.KA_StopAutoStalk()
    if AutoStalkConn then pcall(function() AutoStalkConn:Disconnect() end); AutoStalkConn = nil end
end
function W.KA_SetAutoStalk(v)
    KA.AutoStalk = v and true or false
    W2.AutoStalk = KA.AutoStalk
    if KA.AutoStalk then W.KA_StartAutoStalk() else W.KA_StopAutoStalk() end
end

local KillAllTarget = nil
function W.KA_UpdateKillAll()
    if not KA.AutoKillAll then KillAllTarget = nil; return end
    if GetRole() ~= "Killer" then KillAllTarget = nil; return end
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local tChar = KillAllTarget and KillAllTarget.Character
    if not KillAllTarget or not tChar or not tChar.Parent or not tChar:FindFirstChild("Humanoid") or tChar.Humanoid.Health <= 35 then
        KillAllTarget = W.KA_Closest(math.huge, 30)
        tChar = KillAllTarget and KillAllTarget.Character
    end
    if KillAllTarget and tChar then
        local tr = tChar:FindFirstChild("HumanoidRootPart")
        if tr then
            local v = tr.AssemblyLinearVelocity
            local pr = v * 0.15
            local tp = tr.Position + pr
            local behind = tr.CFrame.LookVector * -3
            root.CFrame = CFrame.new(tp + behind, tp)
        end
        pcall(function()
            local a = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Attacks")
            local b = a and a:FindFirstChild("BasicAttack")
            if b then b:FireServer(false) end
        end)
    end
end
function W.KA_SetAutoKillAll(v)
    KA.AutoKillAll = v and true or false
    W2.AutoKillAll = KA.AutoKillAll
    if not KA.AutoKillAll then KillAllTarget = nil end
end

function W.KA_DropAllPallets()
    if not KA.DropAllPallet then return end
    if GetRole() ~= "Killer" then return end
    local now = tick()
    if now - _KAtimer.lastDrop < 2 then return end
    _KAtimer.lastDrop = now
    pcall(function()
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        local pf = r and r:FindFirstChild("Pallet")
        local drop = pf and pf:FindFirstChild("PalletDropEvent")
        if not drop then return end
        local map = workspace:FindFirstChild("Map")
        if not map then return end
        for _, obj in ipairs(map:GetDescendants()) do
            if obj.Name == "Palletwrong" and (obj:IsA("Model") or obj:IsA("Folder")) then
                local t = obj:FindFirstChild("PalletPointSlide") or obj:FindFirstChild("PalletPoint")
                if t then pcall(function() drop:FireServer(t) end) end
            end
        end
    end)
end
function W.KA_SetDropAllPallet(v)
    KA.DropAllPallet = v and true or false
    W2.DropAllPallet = KA.DropAllPallet
end

function W.KA_DropAllPallets_Force()
    if GetRole() ~= "Killer" then return end
    _KAtimer.lastDrop = 0
    local saved = KA.DropAllPallet
    KA.DropAllPallet = true
    pcall(W.KA_DropAllPallets)
    task.delay(0.1, function() KA.DropAllPallet = saved end)
end

function W.KA_BlockAllVaults()
    if not KA.BlockAllVault then return end
    local ev = ReplicatedStorage:FindFirstChild("Remotes")
        and ReplicatedStorage.Remotes:FindFirstChild("Window")
        and ReplicatedStorage.Remotes.Window:FindFirstChild("VaultEvent")
    if not ev then return end
    local map = workspace:FindFirstChild("Map")
    if not map then return end
    for _, t in ipairs(map:GetDescendants()) do
        if t.Name == "VaultTrigger" then
            pcall(function() ev:FireServer(t, true) end)
        end
    end
end
function W.KA_SetBlockAllVault(v)
    KA.BlockAllVault = v and true or false
    W2.BlockAllVault = KA.BlockAllVault
end

function W.KA_BlockAllVaults_Force()
    _KAtimer.lastBlock = 0
    pcall(W.KA_BlockAllVaults)
end

task.spawn(function()
    while true do
        task.wait(0.12)
        if KA.AutoKillAll then pcall(W.KA_UpdateKillAll) end
        if KA.DropAllPallet then pcall(W.KA_DropAllPallets) end
        if KA.BlockAllVault then pcall(W.KA_BlockAllVaults) end
        if W2.DestroyPallet then pcall(W.DestroyPallets) end
        pcall(W.UpdateInfLunge)
    end
end)
LP.CharacterAdded:Connect(function()
    task.wait(1)
    if KA.AutoStalk then pcall(W.KA_StartAutoStalk) end
end)

-- === AUTO HOOK ===
do
    local isHooking = false
    local function getHooks()
        local l = {}
        local map = Workspace:FindFirstChild("Map")
        if not map then return l end
        for _, obj in ipairs(map:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == "Hook" then
                local hp = obj:FindFirstChild("HookPoint") or obj:FindFirstChild("HookHitbox") or obj:FindFirstChildWhichIsA("BasePart", true)
                if hp then table.insert(l, { model = obj, part = hp }) end
            end
        end
        return l
    end
    local function onHook(char, hooks)
        local tr = char:FindFirstChild("HumanoidRootPart")
        if not tr then return false end
        for _, h in ipairs(hooks) do
            if (h.part.Position - tr.Position).Magnitude < 6 then return true end
        end
        return false
    end
    local function findDowned(hooks)
        local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil, nil end
        local cl, cd, cc = nil, math.huge, nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LP or not p.Character then continue end
            if not TeamIs(p, "Survivor") then continue end
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if not tr or not h then continue end
            local pct = h.MaxHealth > 0 and (h.Health / h.MaxHealth) or 0
            if pct > 0.25 or pct <= 0 then continue end
            if onHook(p.Character, hooks) then continue end
            if p.Character:GetAttribute("IsCarried") == true then continue end
            local d = (tr.Position - myRoot.Position).Magnitude
            if d < cd then cd = d; cl = tr; cc = p.Character end
        end
        return cl, cc
    end
    local function nearestHook(pos, hooks)
        local cl, cd = nil, math.huge
        for _, h in ipairs(hooks) do
            local d = (h.part.Position - pos).Magnitude
            if d < cd then cd = d; cl = h end
        end
        return cl
    end
    local function doHook()
        if not W2.AutoHook then return end
        if isHooking then return end
        if GetRole() ~= "Killer" then return end
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hooks = getHooks()
        if #hooks == 0 then return end
        local tRoot, tChar = findDowned(hooks)
        if not tRoot then return end
        local near = nearestHook(tRoot.Position, hooks)
        if not near then return end
        isHooking = true
        task.spawn(function()
            local carryEv, hookEv, hookCom
            pcall(function()
                local cf = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Carry")
                carryEv = cf:FindFirstChild("CarrySurvivorEvent")
                hookEv = cf:FindFirstChild("HookEvent")
                hookCom = cf:FindFirstChild("HookCommit")
            end)
            pcall(function() root.CFrame = CFrame.new(tRoot.Position + Vector3.new(0, 3, 0), tRoot.Position) end)
            task.wait(0.2)
            pcall(function() if carryEv then carryEv:FireServer(tChar) end end)
            task.wait(0.5)
            local r2 = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not r2 then isHooking = false; return end
            pcall(function() r2.CFrame = CFrame.new(near.part.Position + Vector3.new(0, 3, 0)) end)
            task.wait(0.3)
            pcall(function()
                local hp = near.model:FindFirstChild("HookPoint") or near.model:FindFirstChild("HookHitbox") or near.part
                if hookEv then hookEv:FireServer(hp) end
                if hookCom then hookCom:FireServer(hp) end
            end)
            task.wait(1)
            isHooking = false
        end)
    end
    function W.KA_StartAutoHook()
        if W._AutoHookThread then return end
        W._AutoHookThread = task.spawn(function()
            while W2.AutoHook do
                if GetRole() == "Killer" then pcall(doHook) end
                task.wait(1)
            end
            W._AutoHookThread = nil
        end)
    end
    function W.KA_StopAutoHook()
        if W._AutoHookThread then pcall(function() task.cancel(W._AutoHookThread) end); W._AutoHookThread = nil end
    end
    function W.KA_SetAutoHook(v)
        W2.AutoHook = v and true or false
        if W2.AutoHook then W.KA_StartAutoHook() else W.KA_StopAutoHook() end
    end
end

-- === UI SECTION: KILLER ABILITIES GABUNGAN ===
do
    local s = W.T_Kill:AddSection("Bypass No Cooldown")
    s:AddToggle({ Title = "Hidden Leap", Default = false, Callback = function(v) W.SetHiddenLeap(v) end })
    s:AddToggle({ Title = "Myers Grab (H)", Default = false, Callback = function(v) W.Myers_Set(v) end })
    s:AddToggle({ Title = "Slasher LakeMist", Default = false, Callback = function(v) W.SetLakeMist(v) end })
    s:AddToggle({ Title = "Slasher Pursuit", Default = false, Callback = function(v) W.SetPursuit(v) end })
    s:AddToggle({ Title = "Abyss Bypass", Default = false, Callback = function(v) W.SetAbyssBypass(v) end })
    s:AddToggle({ Title = "Jeff Infinite Frenzy", Default = false, Callback = function(v) W.SetJeffFrenzy(v) end })

    local s2 = W.T_Kill:AddSection("Unlock Skill While Carrying")
    s2:AddToggle({ Title = "Enable", Default = false, Callback = function(v) W.SetUnlockCarry(v) end })

    local s3 = W.T_Kill:AddSection("Spear Aimbot")
    s3:AddToggle({ Title = "Enable", Default = false, Callback = function(v) W.SpearAimbot_Set(v) end })
    s3:AddSlider({ Title = "Gravity", Min = 10, Max = 200, Default = 50, Increment = 1, Callback = function(v) W.SpearAimbot_SetG(v) end })
    s3:AddSlider({ Title = "Speed", Min = 50, Max = 300, Default = 100, Increment = 5, Callback = function(v) W.SpearAimbot_SetS(v) end })

    -- ⭐ FIX: Killer Abilities gabungan — toggle + instant button dalam 1 section
    local s4 = W.T_Kill:AddSection("Killer Abilities")

    s4:AddToggle({ Title = "Auto Stalk", Default = false, Callback = function(v) W.KA_SetAutoStalk(v) end })
    s4:AddSlider({ Title = "Stalk Range", Min = 20, Max = 500, Default = 150, Increment = 10, Suffix = " studs",
        Callback = function(v) KA.AutoStalkRange = v; W2.AutoStalk_Range = v end })
    s4:AddToggle({ Title = "Auto Kill All", Default = false, Callback = function(v) W.KA_SetAutoKillAll(v) end })
    s4:AddToggle({ Title = "Drop All Pallet", Default = false, Callback = function(v) W.KA_SetDropAllPallet(v) end })
    s4:AddToggle({ Title = "Block All Vault", Default = false, Callback = function(v) W.KA_SetBlockAllVault(v) end })
    s4:AddToggle({ Title = "Auto Hook", Default = false, Callback = function(v) W.KA_SetAutoHook(v) end })

    s4:AddButton({ Title = "Instant Auto Kill (1x)", Callback = function()
        if not W.KA then W.W2_Notify("Auto Kill", "KA not ready", 2); return end
        local saved = W.KA.AutoKillAll
        W.KA.AutoKillAll = true
        task.spawn(function()
            task.wait(0.3)
            W.KA.AutoKillAll = saved
        end)
        W.W2_Notify("Auto Kill", "Triggered once", 2)
    end })
    s4:AddButton({ Title = "Instant Drop All Pallet (1x)", Callback = function()
        if W.KA_DropAllPallets_Force then
            W.KA_DropAllPallets_Force()
        else
            pcall(W.KA_DropAllPallets)
        end
        W.W2_Notify("Drop Pallet", "Triggered (bypass cooldown)", 2)
    end })
    s4:AddButton({ Title = "Instant Block All Vault (1x)", Callback = function()
        if W.KA_BlockAllVaults_Force then
            W.KA_BlockAllVaults_Force()
        else
            pcall(W.KA_BlockAllVaults)
        end
        W.W2_Notify("Block Vault", "Triggered (bypass cooldown)", 2)
    end })
    s4:AddButton({ Title = "Unblock All Vault (1x)", Callback = function()
        local VaultCompleteEvent = ReplicatedStorage:FindFirstChild("Remotes")
            and ReplicatedStorage.Remotes:FindFirstChild("Window")
            and ReplicatedStorage.Remotes.Window:FindFirstChild("VaultCompleteEvent")
        if not VaultCompleteEvent then return end
        local count = 0
        local map = workspace:FindFirstChild("Map"); if not map then return end
        for _, trigger in ipairs(map:GetDescendants()) do
            if trigger.Name == "VaultPointInUse" then
                local vaultParent = trigger.Parent
                if vaultParent then
                    pcall(function()
                        VaultCompleteEvent:FireServer(vaultParent, false)
                        count = count + 1
                    end)
                end
            end
        end
        W.ForceNotify("Block Vault", "Unblock " .. count .. " vaults!", 3)
    end })
                                                end--====================================================--
-- PART 15: KILLER — FLASK + DASH LOCK + INSTANT BUTTONS
--====================================================--

W2.Flask_Enabled    = W2.Flask_Enabled    or false
W2.Flask_ShowBeam   = W2.Flask_ShowBeam   ~= false
W2.Flask_ShowLanding= W2.Flask_ShowLanding~= false
W2.Flask_Predict    = W2.Flask_Predict    ~= false
W2.Flask_Speed      = W2.Flask_Speed      or 90
W2.Flask_Gravity    = W2.Flask_Gravity    or 196
W2.Flask_Lead       = W2.Flask_Lead       or 1.0
W2.Flask_Range      = W2.Flask_Range      or 200
W2.DashLock_Enabled = W2.DashLock_Enabled or false
W2.DashLock_Duration= W2.DashLock_Duration or 1.5
W2.DashLock_Smooth  = W2.DashLock_Smooth  or 0.3
W2.DashLock_Freeze  = W2.DashLock_Freeze  or false

-- === SILENT FLASK (THE CURE) ===
do
    local FS = { Target = nil, PredictedPos = nil, BeamPart = nil, AccentPart = nil, LandingRing = nil }

    local function getTarget()
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        local maxR = tonumber(W2.Flask_Range) or 200
        local best, bd = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and TeamIs(p, "Survivor") and p.Character then
                local h = p.Character:FindFirstChildOfClass("Humanoid")
                local r = p.Character:FindFirstChild("HumanoidRootPart")
                if h and h.Health > 0 and r then
                    local d = (r.Position - myRoot.Position).Magnitude
                    if d <= maxR and d < bd then bd = d; best = { Player = p, Root = r, Char = p.Character } end
                end
            end
        end
        return best
    end

    local function getHand()
        local c = LP.Character
        if not c then return nil end
        return c:FindFirstChild("LeftHand") or c:FindFirstChild("Left Arm") or c:FindFirstChild("RightHand") or c:FindFirstChild("Right Arm") or c:FindFirstChild("HumanoidRootPart")
    end

    local function predict(origin, targetRoot)
        local targetPos = targetRoot.Position
        local speed = tonumber(W2.Flask_Speed) or 90
        local gravity = tonumber(W2.Flask_Gravity) or 196
        local lead = tonumber(W2.Flask_Lead) or 1.0
        if not W2.Flask_Predict then return targetPos end
        local tv = targetRoot.AssemblyLinearVelocity or Vector3.zero
        local hv = Vector3.new(tv.X, 0, tv.Z)
        local dist = (targetPos - origin).Magnitude
        local time = dist / speed
        local pred = targetPos
        for _ = 1, 3 do
            pred = targetPos + hv * time * lead
            local nd = (pred - origin).Magnitude
            time = nd / speed
        end
        local drop = 0.5 * gravity * (time * time)
        return pred + Vector3.new(0, drop, 0)
    end

    local function clear()
        if FS.BeamPart then pcall(function() FS.BeamPart:Destroy() end); FS.BeamPart = nil end
        if FS.AccentPart then pcall(function() FS.AccentPart:Destroy() end); FS.AccentPart = nil end
        if FS.LandingRing then pcall(function() FS.LandingRing:Destroy() end); FS.LandingRing = nil end
    end

    local function hide()
        if FS.BeamPart then FS.BeamPart.Transparency = 1 end
        if FS.AccentPart then FS.AccentPart.Transparency = 1 end
        if FS.LandingRing then FS.LandingRing.Transparency = 1 end
    end

    local function ensureBeam()
        if not FS.BeamPart or not FS.BeamPart.Parent then
            local b = Instance.new("Part")
            b.Name = "W2FlaskBeam"; b.Anchored = true; b.CanCollide = false
            b.CanTouch = false; b.CanQuery = false; b.CastShadow = false
            b.Material = Enum.Material.Neon
            b.Color = Color3.fromRGB(255, 255, 255)
            b.Transparency = 0.2
            b.Parent = Workspace
            FS.BeamPart = b
        end
        if not FS.AccentPart or not FS.AccentPart.Parent then
            local a = Instance.new("Part")
            a.Name = "W2FlaskBeamAccent"; a.Anchored = true; a.CanCollide = false
            a.CanTouch = false; a.CanQuery = false; a.CastShadow = false
            a.Material = Enum.Material.SmoothPlastic
            a.Color = Color3.fromRGB(25, 25, 25)
            a.Transparency = 0.35
            a.Parent = Workspace
            FS.AccentPart = a
        end
    end

    local function updateBeam(origin, landing)
        ensureBeam()
        local dir = landing - origin
        local dist = dir.Magnitude
        if dist < 0.1 then return end
        local mid = (origin + landing) / 2
        local cf = CFrame.lookAt(mid, landing)
        FS.BeamPart.Size = Vector3.new(0.12, 0.12, dist)
        FS.BeamPart.CFrame = cf
        FS.BeamPart.Transparency = 0.2
        FS.AccentPart.Size = Vector3.new(0.22, 0.22, dist)
        FS.AccentPart.CFrame = cf
        FS.AccentPart.Transparency = 0.35
    end

    local function updateLanding(pos)
        if not W2.Flask_ShowLanding then
            if FS.LandingRing then FS.LandingRing.Transparency = 1 end
            return
        end
        if not FS.LandingRing or not FS.LandingRing.Parent then
            local ring = Instance.new("Part")
            ring.Name = "W2FlaskLanding"
            ring.Shape = Enum.PartType.Cylinder
            ring.Anchored = true; ring.CanCollide = false
            ring.CanTouch = false; ring.CanQuery = false; ring.CastShadow = false
            ring.Material = Enum.Material.Neon
            ring.Color = Color3.fromRGB(255, 255, 255)
            ring.Size = Vector3.new(0.2, 5, 5)
            ring.Parent = Workspace
            FS.LandingRing = ring
        end
        FS.LandingRing.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
        FS.LandingRing.Transparency = 0.35
    end

    -- Simpan referensi ke W biar bisa diakses hook global di PART 16
    W._Flask_FS = FS

    RunService.RenderStepped:Connect(function()
        if not W2.Flask_Enabled then
            hide(); FS.Target = nil; FS.PredictedPos = nil
            return
        end
        if GetRole() ~= "Killer" then hide(); return end
        local t = getTarget()
        if not t or not t.Root then
            hide(); FS.Target = nil; FS.PredictedPos = nil; return
        end
        local hand = getHand()
        if not hand then return end
        local landing = predict(hand.Position, t.Root)
        FS.Target = t
        FS.PredictedPos = landing
        if W2.Flask_ShowBeam then pcall(updateBeam, hand.Position, landing)
        else
            if FS.BeamPart then FS.BeamPart.Transparency = 1 end
            if FS.AccentPart then FS.AccentPart.Transparency = 1 end
        end
        pcall(updateLanding, landing)
    end)

    function W.Flask_Set(v) W2.Flask_Enabled = v and true or false; if not v then clear() end end
    function W.Flask_SetSpeed(v) W2.Flask_Speed = tonumber(v) or 90 end
    function W.Flask_SetGravity(v) W2.Flask_Gravity = tonumber(v) or 196 end
    function W.Flask_SetLead(v) W2.Flask_Lead = tonumber(v) or 1.0 end
    function W.Flask_SetRange(v) W2.Flask_Range = tonumber(v) or 200 end
end

-- === DASH LOCK ===
do
    W2.DashLock_Active = false
    W2.DashLock_Target = nil
    W2.DashLock_Conn = nil
    local DASH_ANIM = "rbxassetid://98163597193511"

    local function update()
        if not W2.DashLock_Enabled or not W2.DashLock_Active then return end
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then W2.DashLock_Target = nil; return end
        local t, td = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and TeamIs(p, "Survivor") then
                local c = p.Character
                if c then
                    local r = c:FindFirstChild("HumanoidRootPart")
                    local h = c:FindFirstChildOfClass("Humanoid")
                    if r and h and h.Health > 0 then
                        local d = (myRoot.Position - r.Position).Magnitude
                        if d < td then td = d; t = r end
                    end
                end
            end
        end
        if not t then W2.DashLock_Target = nil; return end
        W2.DashLock_Target = t
        local cam = Workspace.CurrentCamera
        if cam then
            local s = W2.DashLock_Smooth or 0.3
            cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, t.Position), s)
        end
        if W2.DashLock_Freeze then
            local h = myChar:FindFirstChildOfClass("Humanoid")
            if h and h.WalkSpeed ~= 0 then h.WalkSpeed = 0 end
        end
    end

    local function setActive(a)
        a = a and true or false
        if a == W2.DashLock_Active then return end
        W2.DashLock_Active = a
        if a then
            if not W2.DashLock_Conn then
                W2.DashLock_Conn = RunService.RenderStepped:Connect(function() pcall(update) end)
            end
        else
            if W2.DashLock_Conn then pcall(function() W2.DashLock_Conn:Disconnect() end); W2.DashLock_Conn = nil end
            W2.DashLock_Target = nil
            if W2.DashLock_Freeze then
                local c = LP.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if h and h.WalkSpeed == 0 then h.WalkSpeed = 16 end
            end
        end
    end

    local function hook(char)
        if not char then return end
        local h = char:FindFirstChildOfClass("Humanoid")
        if not h then return end
        local a = h:FindFirstChildOfClass("Animator") or h:WaitForChild("Animator", 5)
        if not a then return end
        a.AnimationPlayed:Connect(function(t)
            if not W2.DashLock_Enabled then return end
            local aid = t.Animation and t.Animation.AnimationId or ""
            if aid == DASH_ANIM then
                setActive(true)
                task.delay(W2.DashLock_Duration or 1.5, function() setActive(false) end)
            end
        end)
    end

    if LP.Character then hook(LP.Character) end
    LP.CharacterAdded:Connect(function(c) task.wait(0.5); hook(c) end)

    function W.DashLock_Set(v)
        W2.DashLock_Enabled = v and true or false
        if not v then setActive(false) end
    end
end

-- === UI SECTION ===
do
    local s = W.T_Kill:AddSection("Silent Flask (The Cure)")
    s:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
        W.Flask_Set(v)
        W.W2_Notify("Silent Flask", v and "Enabled" or "Disabled", 2)
    end })
    s:AddToggle({ Title = "Show Beam", Default = true, Callback = function(v) W2.Flask_ShowBeam = v end })
    s:AddToggle({ Title = "Show Landing", Default = true, Callback = function(v) W2.Flask_ShowLanding = v end })
    s:AddToggle({ Title = "Enable Prediction", Default = true, Callback = function(v) W2.Flask_Predict = v end })
    s:AddSlider({ Title = "Speed", Min = 30, Max = 200, Default = 90, Increment = 5, Callback = function(v) W.Flask_SetSpeed(v) end })
    s:AddSlider({ Title = "Gravity", Min = 50, Max = 400, Default = 196, Increment = 5, Callback = function(v) W.Flask_SetGravity(v) end })
    s:AddSlider({ Title = "Lead Multiplier", Min = 0, Max = 3, Default = 1.0, Increment = 0.1, Callback = function(v) W.Flask_SetLead(v) end })
    s:AddSlider({ Title = "Max Range", Min = 50, Max = 500, Default = 200, Increment = 10, Suffix = " studs", Callback = function(v) W.Flask_SetRange(v) end })

    local s2 = W.T_Kill:AddSection("Dash Lock")
    s2:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
        W.DashLock_Set(v)
        W.W2_Notify("Dash Lock", v and "Enabled" or "Disabled", 2)
    end })
    s2:AddSlider({ Title = "Duration", Min = 0.5, Max = 5, Default = 1.5, Increment = 0.1, Suffix = "s",
        Callback = function(v) W2.DashLock_Duration = v end })
    s2:AddSlider({ Title = "Smoothness", Min = 0.05, Max = 1, Default = 0.3, Increment = 0.05,
        Callback = function(v) W2.DashLock_Smooth = v end })
    s2:AddToggle({ Title = "Freeze Character", Default = false, Callback = function(v)
        W2.DashLock_Freeze = v
        if not v then
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed == 0 then hum.WalkSpeed = 16 end
        end
    end })

    local s3 = W.T_Kill:AddSection("Killer Abilities — Instant")
    s3:AddButton({ Title = "Instant Auto Kill (1x)", Callback = function()
        local saved = KA.AutoKillAll
        KA.AutoKillAll = true
        task.spawn(function()
            task.wait(0.3)
            KA.AutoKillAll = saved
        end)
        W.W2_Notify("Auto Kill", "Triggered once", 2)
    end })
    s3:AddButton({ Title = "Instant Drop All Pallet (1x)", Callback = function()
        lastDrop = 0
        pcall(W.KA_DropAllPallets)
        W.W2_Notify("Drop Pallet", "Triggered", 2)
    end })
    s3:AddButton({ Title = "Instant Block All Vault (1x)", Callback = function()
        lastBlock = 0
        pcall(W.KA_BlockAllVaults)
        W.W2_Notify("Block Vault", "Triggered", 2)
    end })
    s3:AddButton({ Title = "Unblock All Vault (1x)", Callback = function()
        local VaultCompleteEvent = ReplicatedStorage:FindFirstChild("Remotes")
            and ReplicatedStorage.Remotes:FindFirstChild("Window")
            and ReplicatedStorage.Remotes.Window:FindFirstChild("VaultCompleteEvent")
        if not VaultCompleteEvent then return end
        local count = 0
        local map = workspace:FindFirstChild("Map"); if not map then return end
        for _, trigger in ipairs(map:GetDescendants()) do
            if trigger.Name == "VaultPointInUse" then
                local vaultParent = trigger.Parent
                if vaultParent then
                    pcall(function()
                        VaultCompleteEvent:FireServer(vaultParent, false)
                        count = count + 1
                    end)
                end
            end
        end
        W.ForceNotify("Block Vault", "Unblock " .. count .. " vaults!", 3)
    end })
                                                    end--====================================================--
-- PART 16A: MISC (Stun, Invis, Utility, SpeedBoost, Cursor, Spectator)
--====================================================--

W2.Stun_Enabled    = W2.Stun_Enabled    or false
W2.Stun_Sound      = W2.Stun_Sound      or "Default"
W2.Stun_SoundAlert = W2.Stun_SoundAlert ~= false
W2.Stun_Range      = W2.Stun_Range      or 500
W2.Stun_Volume     = W2.Stun_Volume     or 1.5
W2.Invis_Enabled   = W2.Invis_Enabled   or false
W2.Invis_Hotkey    = W2.Invis_Hotkey    or "G"
W2.PU_SpeedEnabled = W2.PU_SpeedEnabled or false
W2.PU_SpeedValue   = W2.PU_SpeedValue   or 16
W2.PU_ShiftLock    = W2.PU_ShiftLock    or false
W2.PU_UnlimitedZoom= W2.PU_UnlimitedZoom or false
W2.PU_Noclip       = W2.PU_Noclip       or false
W2.SpeedBoost_Enabled = W2.SpeedBoost_Enabled or false
W2.SpeedBoost_Value   = W2.SpeedBoost_Value   or 30
W2.Cursor_Enabled  = W2.Cursor_Enabled  or false
W2.Spectator_Enabled = W2.Spectator_Enabled or false

-- === STUN INDICATOR ===
W.StunSounds = W.StunSounds or {
    ["Default"]="18843924331",["Clash Royale"]="114072050006157",["Blash"]="89068385567682",
    ["Coin"]="75510526696824",["Kururin Kuru"]="119896940405402",["Spongebob"]="6835794541",
    ["Fahhhh"]="123562480982353",["Cave"]="3173566193",["Aughhh"]="9095205664",
    ["Samsung"]="6879335951",["iPhone"]="4203251375",["Siren"]="130677853589923",
}
W.StunInd = W.StunInd or {
    Enabled = false, Cache = {}, Conn = nil, Range = 500,
    SoundEnabled = true, SoundId = "18843924331",
    Volume = 1.5, SoundRange = 500, SelectedSound = "Default",
}
local SI = W.StunInd
SI.SelectedSound = SI.SelectedSound or "Default"

local function SI_SoundId()
    return W.StunSounds[SI.SelectedSound] or SI.SoundId
end
local function SI_Stunned(char)
    if not char then return false end
    if char:GetAttribute("IsStunned") or char:GetAttribute("isStunned") or char:GetAttribute("Stunned")
        or char:GetAttribute("stunned") or char:GetAttribute("IsStun") or char:GetAttribute("Stun") then return true end
    local ci = char:FindFirstChild("CheckInterractable")
    if ci and (ci:GetAttribute("isStunned") or ci:GetAttribute("Stunned")) then return true end
    local h = char:FindFirstChildOfClass("Humanoid")
    if h then
        local sv = h:FindFirstChild("StunValue")
        if sv and sv.Value > 0 then return true end
    end
    return false
end
local function SI_Remove(char)
    local d = SI.Cache[char]
    if d then
        pcall(function() if d.Gui then d.Gui:Destroy() end end)
        SI.Cache[char] = nil
    end
end
local function SI_Play(char)
    if not SI.SoundEnabled then return end
    pcall(function()
        local head = char and char:FindFirstChild("Head")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local att = head or hrp
        if not att then return end
        local s = Instance.new("Sound")
        s.Name = "W2StunSound"
        s.SoundId = "rbxassetid://" .. tostring(SI_SoundId())
        s.Volume = SI.Volume or 1.5
        s.RollOffMaxDistance = SI.SoundRange or 500
        s.RollOffMinDistance = 10
        s.RollOffMode = Enum.RollOffMode.InverseTapered
        s.Parent = att
        s:Play()
        s.Ended:Connect(function() pcall(function() s:Destroy() end) end)
        task.delay(5, function() pcall(function() if s and s.Parent then s:Destroy() end end) end)
    end)
end
local function SI_Create(char)
    if SI.Cache[char] then return SI.Cache[char] end
    local head = char:FindFirstChild("Head")
    if not head then return nil end
    local bbg = Instance.new("BillboardGui")
    bbg.Name = "W2StunIndicator"
    bbg.Size = UDim2.fromOffset(140, 42)
    bbg.StudsOffset = Vector3.new(0, 3, 0)
    bbg.AlwaysOnTop = true
    bbg.LightInfluence = 0
    bbg.MaxDistance = 500
    bbg.Adornee = head
    bbg.Parent = char
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 140, 0, 34)
    main.Position = UDim2.new(0, 0, 0, 4)
    main.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 0
    main.Parent = bbg
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 9)
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -42, 0, 12)
    t.Position = UDim2.new(0, 34, 0, 4)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.GothamBlack
    t.Text = "STUNNED"
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.TextSize = 11
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    t.TextStrokeTransparency = 0.5
    t.Parent = main
    SI.Cache[char] = { Gui = bbg, Main = main }
    return SI.Cache[char]
end

function W.SInd_Set(v)
    SI.Enabled = v and true or false
    W2.Stun_Enabled = SI.Enabled
    if SI.Enabled then
        if SI.Conn then return end
        SI.Conn = RunService.Heartbeat:Connect(function()
            if not SI.Enabled then return end
            local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and TeamIs(p, "Killer") and p.Character then
                    local char = p.Character
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local d = (hrp.Position - myRoot.Position).Magnitude
                        local stun = SI_Stunned(char)
                        local data = SI.Cache[char]
                        local wasStun = data ~= nil
                        if stun and d <= SI.Range then
                            if not wasStun then SI_Play(char); SI_Create(char) end
                        else
                            if wasStun then SI_Remove(char) end
                        end
                    end
                end
            end
        end)
    else
        if SI.Conn then SI.Conn:Disconnect(); SI.Conn = nil end
        for _, d in pairs(SI.Cache) do
            pcall(function() if d.Gui then d.Gui:Destroy() end end)
        end
        SI.Cache = {}
    end
end
W.SInd_GetSoundId = SI_SoundId

-- === INVISIBILITY ===
do
    local MV = getgenv().W2Invis
    if not MV then
        MV = { Enabled = false, Loading = false, Ready = false, API = nil, _lastToggle = 0, _retries = 0, _retryMax = 3, _retryDelay = 2, _queueState = nil }
        getgenv().W2Invis = MV
    end
    local URL = "https://leekguy.vercel.app/roblox/menghub/crack_obf_invisible_93978595733734.lua"
    local function validate(api)
        if type(api) ~= "table" then return false end
        if type(api.enable) ~= "function" then return false end
        if type(api.disable) ~= "function" then return false end
        return true
    end
    local function cleanup()
        pcall(function()
            local ch = Workspace:FindFirstChild("invischair")
            if ch then ch:Destroy() end
            local c = LP.Character
            if c then
                for _, p in ipairs(c:GetDescendants()) do
                    if p:IsA("BasePart") or p:IsA("Decal") then
                        if p.Name ~= "Hurtbox" and p.Name ~= "HumanoidRootPart" and p.Name ~= "HRP_Clone" then
                            p.Transparency = 0
                            if p:IsA("BasePart") then p.LocalTransparencyModifier = 0 end
                        end
                    end
                end
            end
        end)
    end
    local function loadAPI()
        if _G.MengHub and _G.MengHub.Invisible and validate(_G.MengHub.Invisible) then
            MV.API = _G.MengHub.Invisible; MV.Ready = true
            return true
        end
        MV.Loading = true; MV.Ready = false
        for i = 1, MV._retryMax do
            MV._retries = i
            local ok = pcall(function() loadstring(game:HttpGet(URL))() end)
            task.wait(0.5)
            if ok and _G.MengHub and _G.MengHub.Invisible and validate(_G.MengHub.Invisible) then
                MV.API = _G.MengHub.Invisible; MV.Ready = true; MV.Loading = false
                if MV._queueState ~= nil then
                    local q = MV._queueState; MV._queueState = nil
                    task.defer(function() W.Invisible_SetState(q, false) end)
                end
                return true
            elseif i < MV._retryMax then task.wait(MV._retryDelay) end
        end
        MV.Loading = false; MV.Ready = false
        return false
    end
    task.spawn(function() loadAPI() end)

    function W.Invisible_SetState(state, fromBtn)
        state = state and true or false
        local now = tick()
        if now - MV._lastToggle < 0.25 then return end
        if not MV.API then
            if MV.Loading then
                W.W2_Notify("Invisible", "Loading API...", 2)
                MV._queueState = state
            else
                W.W2_Notify("Invisible", "Retry...", 2)
                MV._queueState = state
                task.spawn(function()
                    if loadAPI() then
                        local q = MV._queueState; MV._queueState = nil
                        if q ~= nil then task.defer(function() W.Invisible_SetState(q, fromBtn) end) end
                    end
                end)
            end
            return
        end
        if MV.Enabled == state then
            if not state then cleanup() end
            return
        end
        MV._lastToggle = now
        MV.Enabled = state
        W2.Invis_Enabled = state
        if state then pcall(function() MV.API.enable() end)
        else pcall(function() MV.API.disable() end); cleanup() end
    end

    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local hk = Enum.KeyCode[W2.Invis_Hotkey or "G"]
        if hk and inp.KeyCode == hk then W.Invisible_SetState(not MV.Enabled, false) end
    end)
    LP.CharacterAdded:Connect(function()
        task.wait(1.2)
        if MV.Enabled and MV.API then pcall(function() MV.API.enable() end) end
    end)
    W.Invisible_IsOn = function() return MV.Enabled end
end

-- === PLAYER UTILITY ===
do
    local PU = { _Conns = {}, _OrigCanCollide = {}, _ShiftWasActive = false }
    W.PU = PU

    table.insert(PU._Conns, RunService.Heartbeat:Connect(function()
        if not W2.PU_SpeedEnabled then return end
        local c = LP.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        if h and h.WalkSpeed ~= W2.PU_SpeedValue then h.WalkSpeed = W2.PU_SpeedValue end
    end))

    table.insert(PU._Conns, RunService.RenderStepped:Connect(function()
        local c = LP.Character
        if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid")
        local root = c:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not (h and root and cam) then return end
        if W2.PU_ShiftLock then
            h.AutoRotate = false
            PU._ShiftWasActive = true
            local lv = cam.CFrame.LookVector
            local flat = Vector3.new(lv.X, 0, lv.Z)
            if flat.Magnitude > 0.001 then root.CFrame = CFrame.new(root.Position, root.Position + flat.Unit) end
        elseif PU._ShiftWasActive then
            h.AutoRotate = true
            PU._ShiftWasActive = false
        end
    end))

    table.insert(PU._Conns, RunService.RenderStepped:Connect(function()
        if not W2.PU_UnlimitedZoom then return end
        if LP.CameraMaxZoomDistance ~= math.huge then LP.CameraMaxZoomDistance = math.huge end
        if LP.CameraMinZoomDistance ~= 0 then LP.CameraMinZoomDistance = 0 end
    end))

    table.insert(PU._Conns, RunService.Stepped:Connect(function()
        if not W2.PU_Noclip then return end
        local c = LP.Character
        if not c then return end
        for _, d in ipairs(c:GetDescendants()) do
            if d:IsA("BasePart") then
                if PU._OrigCanCollide[d] == nil then PU._OrigCanCollide[d] = d.CanCollide end
                d.CanCollide = false
            end
        end
    end))

    LP.CharacterRemoving:Connect(function(c)
        if c == LP.Character then PU._OrigCanCollide = {} end
    end)
end

-- === SPEED BOOST ===
do
    local conn = nil
    local function shouldDisable()
        local c = LP.Character
        if not c then return true end
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then
            if h.Health <= 0 or h.Health < 2
                or c:GetAttribute("Downed") == true
                or c:GetAttribute("IsDown") == true
                or c:GetAttribute("Knocked") == true then
                return true
            end
        end
        return false
    end
    function W.SpeedBoost_Set(v)
        W2.SpeedBoost_Enabled = v and true or false
        if conn then conn:Disconnect(); conn = nil end
        if not W2.SpeedBoost_Enabled then
            local c = LP.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h then pcall(function() h.WalkSpeed = 16 end) end
            return
        end
        conn = RunService.Heartbeat:Connect(function()
            if not W2.SpeedBoost_Enabled then return end
            if shouldDisable() then return end
            local c = LP.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h and h.WalkSpeed ~= W2.SpeedBoost_Value then pcall(function() h.WalkSpeed = W2.SpeedBoost_Value end) end
        end)
    end
    LP.CharacterAdded:Connect(function()
        task.wait(0.8)
        if W2.SpeedBoost_Enabled then W.SpeedBoost_Set(true) end
    end)
end

-- === CURSOR FEATURE ===
do
    local thread = nil
    local saved = { MouseIconEnabled = nil, MouseBehavior = nil, AutoRotate = nil }
    function W.Cursor_Set(v)
        W2.Cursor_Enabled = v and true or false
        if v then
            saved.MouseIconEnabled = UserInputService.MouseIconEnabled
            saved.MouseBehavior = UserInputService.MouseBehavior
            local c = LP.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            saved.AutoRotate = h and h.AutoRotate or true
            pcall(function()
                UserInputService.MouseIconEnabled = true
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end)
            if h then pcall(function() h.AutoRotate = false end) end
            if thread then pcall(function() task.cancel(thread) end) end
            thread = task.spawn(function()
                while W2.Cursor_Enabled do
                    pcall(function()
                        UserInputService.MouseIconEnabled = true
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                    end)
                    local c2 = LP.Character
                    local h2 = c2 and c2:FindFirstChildOfClass("Humanoid")
                    if h2 and h2.AutoRotate then h2.AutoRotate = false end
                    task.wait(0.1)
                end
            end)
        else
            if thread then pcall(function() task.cancel(thread) end); thread = nil end
            pcall(function()
                UserInputService.MouseIconEnabled = saved.MouseIconEnabled or false
                UserInputService.MouseBehavior = saved.MouseBehavior or Enum.MouseBehavior.LockCenter
            end)
            local c = LP.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h then pcall(function() h.AutoRotate = saved.AutoRotate or true end) end
        end
    end
    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.KeyCode == Enum.KeyCode.LeftAlt or inp.KeyCode == Enum.KeyCode.RightAlt then
            W.Cursor_Set(not W2.Cursor_Enabled)
        end
    end)
    LP.CharacterAdded:Connect(function()
        task.wait(1)
        if W2.Cursor_Enabled then W.Cursor_Set(true) end
    end)
end

-- === SPECTATOR COUNTER ===
do
    local Gui, Label, Thread = nil, nil, nil
    local function build()
        if Gui then Gui:Destroy(); Gui = nil end
        Gui = Instance.new("ScreenGui")
        Gui.Name = "W2SpectatorCounter"
        Gui.ResetOnSpawn = false
        Gui.IgnoreGuiInset = true
        Gui.Parent = CoreGui
        local f = Instance.new("Frame", Gui)
        f.Name = "MainBox"
        f.AnchorPoint = Vector2.new(0.5, 0)
        f.Position = UDim2.new(0.5, 0, 0.42, 0)
        f.Size = UDim2.new(0, 145, 0, 52)
        f.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        f.BackgroundTransparency = 0.1
        f.BorderSizePixel = 0
        f.Active = true
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
        local h = Instance.new("Frame", f)
        h.Size = UDim2.new(1, 0, 0, 18)
        h.Position = UDim2.new(0, 0, 0, 4)
        h.BackgroundTransparency = 1
        h.Active = true
        local t = Instance.new("TextLabel", h)
        t.Size = UDim2.new(1, -20, 1, 0)
        t.BackgroundTransparency = 1
        t.Font = Enum.Font.GothamBold
        t.Text = "Spectators"
        t.TextColor3 = Color3.fromRGB(255, 255, 255)
        t.TextSize = 10
        local body = Instance.new("Frame", f)
        body.Size = UDim2.new(1, 0, 1, -25)
        body.Position = UDim2.new(0, 0, 0, 25)
        body.BackgroundTransparency = 1
        Label = Instance.new("TextLabel", body)
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamMedium
        Label.Text = "No spectators"
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.TextSize = 10
        local drag, dStart, sPos = false, nil, nil
        f.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                drag = true; dStart = inp.Position; sPos = f.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if not drag then return end
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                local d = inp.Position - dStart
                f.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then drag = false end
        end)
    end
    local function update()
        if not Label then return end
        local cnt = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Team and p.Team.Name == "Spectator" then cnt = cnt + 1 end
        end
        if cnt == 0 then
            Label.Text = "No spectators"; Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        else
            Label.Text = cnt .. " spectators"; Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
    function W.Spectator_Set(state)
        W2.Spectator_Enabled = state
        if Thread then task.cancel(Thread); Thread = nil end
        if state then
            build(); update()
            Thread = task.spawn(function()
                while W2.Spectator_Enabled do update(); task.wait(1.2) end
            end)
        else
            if Gui then Gui:Destroy(); Gui = nil; Label = nil end
        end
    end
end

-- === JERK OFF TOOL ===
W.JerkTool = W.JerkTool or { Enabled = false, ToolName = "Jerk Off" }
local JerkTool = W.JerkTool
local currentJerkTool = nil
local jerkRunning = false

function W.JerkOff_Destroy()
    if currentJerkTool then pcall(function() currentJerkTool:Destroy() end); currentJerkTool = nil end
end

function W.JerkOff_Create()
    W.JerkOff_Destroy()
    local character = LP.Character
    if not character then return end
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    local backpack = LP:FindFirstChildWhichIsA("Backpack")
    if not humanoid or not backpack then return end

    local tool = Instance.new("Tool")
    tool.Name = JerkTool.ToolName
    tool.ToolTip = 'jorking it'
    tool.RequiresHandle = false
    tool.Parent = backpack
    currentJerkTool = tool

    local jorkin = false
    local track = nil

    local function stopTomfoolery()
        jorkin = false
        if track then pcall(function() track:Stop() end); track = nil end
    end

    tool.Equipped:Connect(function() jorkin = true end)
    tool.Unequipped:Connect(stopTomfoolery)
    if humanoid.Died then humanoid.Died:Connect(stopTomfoolery) end

    task.spawn(function()
        while jerkRunning do
            task.wait()
            if not JerkTool.Enabled or not jorkin then
                if track then pcall(function() track:Stop() end) end
                continue
            end
            local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
            if not track then
                local anim = Instance.new("Animation")
                anim.AnimationId = not isR15 and "rbxassetid://72042024" or "rbxassetid://698251653"
                track = humanoid:LoadAnimation(anim)
            end
            track:Play()
            track:AdjustSpeed(isR15 and 0.7 or 0.65)
            track.TimePosition = 0.6
            task.wait(0.1)
            while track and track.TimePosition < (not isR15 and 0.65 or 0.7) do
                task.wait(0.1)
            end
            if track then pcall(function() track:Stop() end) end
        end
    end)
end

function W.JerkOff_SetEnabled(v)
    JerkTool.Enabled = v and true or false
    jerkRunning = JerkTool.Enabled
    if v then W.JerkOff_Create() else W.JerkOff_Destroy() end
end

LP.CharacterAdded:Connect(function()
    task.wait(1)
    if JerkTool.Enabled then jerkRunning = true; W.JerkOff_Create() end
end)

-- === SKIP END SCREEN ===
W.SkipEnd = W.SkipEnd or { Enabled = false }
local function ShowInstantResults()
    if not W.SkipEnd.Enabled then return end
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam then cam.CameraType = Enum.CameraType.Custom; cam.FieldOfView = 70 end
        UserInputService.MouseIconEnabled = true
        LP:SetAttribute("isspectating", true)
        local pg = LP:FindFirstChild("PlayerGui")
        if pg then
            for _, n in ipairs({"Results", "EndScreen", "Darkness"}) do
                local g = pg:FindFirstChild(n)
                if g then
                    g.Enabled = true
                    local f = g:FindFirstChild("blackout") or g:FindFirstChild("Frame2")
                    if f then f.BackgroundTransparency = 1 end
                end
            end
        end
    end)
end
task.spawn(function()
    local gf = ReplicatedStorage:WaitForChild("Remotes", 10)
    gf = gf and gf:WaitForChild("Game", 10)
    if not gf then return end
    for _, n in ipairs({"endscreencutscene", "cutsceneEnd", "cutsceneEnd2", "cutsceneEndwithownchar"}) do
        local ev = gf:FindFirstChild(n)
        if ev and ev:IsA("RemoteEvent") then
            ev.OnClientEvent:Connect(ShowInstantResults)
        end
    end
end)
function W.SkipEnd_Set(v) W.SkipEnd.Enabled = v and true or false end

-- === HIDE NAME ===
W.HideName = W.HideName or { Enabled = false, Conn = nil }
local function ProcessHideName(obj)
    if not obj then return end
    local ok, isText = pcall(function()
        return obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")
    end)
    if not ok or not isText then return end
    local txt = ""
    pcall(function() txt = tostring(obj.Text or "") end)
    if txt == "" then return end
    if txt == LP.Name or txt == LP.DisplayName
        or txt:find(LP.Name, 1, true) ~= nil then
        pcall(function() obj.Visible = not W.HideName.Enabled end)
    end
end
function W.HideName_Set(enabled)
    W.HideName.Enabled = enabled and true or false
    if W.HideName.Conn then
        pcall(function() W.HideName.Conn:Disconnect() end)
        W.HideName.Conn = nil
    end
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    if not pg then return end
    for _, d in ipairs(pg:GetDescendants()) do ProcessHideName(d) end
    if W.HideName.Enabled then
        W.HideName.Conn = pg.DescendantAdded:Connect(function(obj)
            task.defer(ProcessHideName, obj)
        end)
    end
end

-- === HIDE SURVIVOR ICON ===
W.HideIcon = W.HideIcon or { Enabled = false, OrigIcons = {} }
function W.HideIcon_Apply()
    local pg = LP:FindFirstChild("PlayerGui")
    if not pg then return end
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name:match("%-mob$") then
            local frame = gui:FindFirstChild("Frame")
            if frame then
                for i = 1, 5 do
                    local sf = frame:FindFirstChild("Survivor" .. i)
                    if sf then
                        local il = sf:FindFirstChild("ImageLabel")
                        local tl = sf:FindFirstChild("TextLabel")
                        if il and il:IsA("ImageLabel") then
                            if not W.HideIcon.OrigIcons[il] then
                                W.HideIcon.OrigIcons[il] = { Image = il.Image, ImageTransparency = il.ImageTransparency }
                            end
                            il.Image = "rbxassetid://92826170205694"
                            il.ImageTransparency = 0
                        end
                        if tl and tl:IsA("TextLabel") then
                            if not W.HideIcon.OrigIcons[tl] then
                                W.HideIcon.OrigIcons[tl] = { Text = tl.Text, TextTransparency = tl.TextTransparency }
                            end
                            tl.Text = "W2"
                            tl.TextTransparency = 0
                        end
                    end
                end
            end
        end
    end
end
function W.HideIcon_Restore()
    for obj, data in pairs(W.HideIcon.OrigIcons) do
        if obj and obj.Parent then
            pcall(function()
                if data.Image ~= nil and obj:IsA("ImageLabel") then
                    obj.Image = data.Image
                    obj.ImageTransparency = data.ImageTransparency
                end
                if data.Text ~= nil and obj:IsA("TextLabel") then
                    obj.Text = data.Text
                    obj.TextTransparency = data.TextTransparency
                end
            end)
        end
    end
    W.HideIcon.OrigIcons = {}
end
RunService.Heartbeat:Connect(function()
    if W.HideIcon.Enabled then W.HideIcon_Apply() end
end)
function W.HideIcon_Set(v)
    W.HideIcon.Enabled = v and true or false
    if v then W.HideIcon_Apply() else W.HideIcon_Restore() end
                                                        end--====================================================--
-- PART 16B: HOOK + FLOATING BUTTONS + BOMBAX V4 (RAYFIELD) + FPS + TROLL
--====================================================--

-- === PART 16B-1: HOOK GLOBAL ===
do
    local installed = false
    if installed then return end
    installed = true
    task.spawn(function()
        pcall(function()
            if typeof(hookmetamethod) ~= "function" then return end
            local oldNC
            oldNC = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if checkcaller() then return oldNC(self, ...) end

                -- 1. No Fall Damage
                if method == "FireServer" and W2.NoFallDamage then
                    local ok, n = pcall(function() return self.Name end)
                    if ok and n == "Fall" then
                        local par = self.Parent
                        if par and par.Name == "Mechanics" then return nil end
                    end
                end

                -- 2. Anti Blind
                if method == "FireServer" and W2.AntiBlind_Enabled then
                    local ok, n = pcall(function() return self.Name end)
                    if ok and n == "GotBlinded" then
                        local par = self.Parent
                        if par and par.Name == "Flashlight" then
                            if GetRole() == "Killer" then return nil end
                        end
                    end
                end

                -- 3. Silent Flashlight
                if method == "FireServer" then
                    local ok, n = pcall(function() return self.Name end)
                    if ok and n == "Activate" then
                        local par = self.Parent
                        if par and par.Name == "Flashlight" then
                            local args = {...}
                            pcall(function()
                                if W.Flash_SetActive then
                                    W.Flash_SetActive(args[2] == true, args[1])
                                end
                            end)
                        end
                    end
                end

                -- 4. Veil (Spearthrow)
                if method == "FireServer" then
                    local ok, n = pcall(function() return self.Name end)
                    if ok and n == "Spearthrow" then
                        local args = {...}
                        local api = W.W424Veil_API
                        local VeilState = W._VeilV1_State

                        local modeV1ALF = W2.VeilV1_Enabled and VeilState and typeof(VeilState.lookVector) == "Vector3"
                        local modeV2Block = false
                        local modeV2Predict = false
                        if api then
                            local ac = api.AimConfig
                            if ac then
                                if ac.Aim_SilentVeil and not ac.Aim_SilentVeilV2 then modeV2Block = true end
                                if ac.Aim_SilentVeilV2 then modeV2Predict = true end
                            end
                        end

                        if modeV2Block then return nil end

                        if modeV2Predict and api then
                            local ac = api.AimConfig
                            local cfg = api.Config
                            local lookVec, speed, originPos = args[1], args[2], args[3]
                            speed = speed or ac.SPEAR_Speed or 165
                            local myChar = LP.Character
                            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                            local startPart = myChar and (myChar:FindFirstChild("Head") or myHRP)
                            local isSpecial = myChar and myChar:GetAttribute("special") == true
                            if cfg and cfg.SpearSmart_enable then
                                speed = isSpecial and 165 or 142.5
                            else
                                speed = ac.SPEAR_Speed or 165
                            end
                            originPos = originPos or (myHRP and myHRP.Position) or (startPart and startPart.Position)
                            local bestDir = lookVec
                            local targetPart = api.getClosestSurvivor and api.getClosestSurvivor()
                            if targetPart and originPos then
                                local targetHRP = targetPart:IsA("Model") and targetPart:FindFirstChild("HumanoidRootPart") or targetPart
                                local targetPos = targetHRP.Position
                                local targetVel = Vector3.new(0, 0, 0)
                                local targetHum = targetPart.Parent and targetPart.Parent:FindFirstChildOfClass("Humanoid")
                                if targetHum and targetHum.MoveDirection.Magnitude > 0 then
                                    targetVel = targetHum.MoveDirection * targetHum.WalkSpeed
                                elseif targetHRP:IsA("BasePart") then
                                    targetVel = targetHRP.AssemblyLinearVelocity
                                end
                                targetVel = Vector3.new(targetVel.X, 0, targetVel.Z)
                                local distance = (targetPos - originPos).Magnitude
                                local timeToHit = distance / math.max(speed, 1)
                                local leadMult = ac.Veil_LeadMultiplier or 1.4
                                local predicted = targetPos + (targetVel * (timeToHit * leadMult))
                                local spearG = workspace.Gravity * 0.5
                                local drop = 0.5 * spearG * (timeToHit * timeToHit)
                                local finalPos = predicted + Vector3.new(0, drop - 1.5, 0)
                                bestDir = (finalPos - originPos).Unit
                            end
                            args[1] = bestDir
                            args[2] = speed
                            args[3] = originPos
                            return oldNC(self, unpack(args))
                        end

                        if modeV1ALF then
                            if typeof(args[1]) == "Vector3" then
                                args[1] = VeilState.lookVector
                                return oldNC(self, unpack(args))
                            end
                        end
                    end
                end

                -- 5. Silent Flask
                if method == "FireServer" and W2.Flask_Enabled then
                    local ok, n = pcall(function() return self.Name end)
                    if ok and n == "ThrowFlask" then
                        local FS = W._Flask_FS
                        if FS and FS.PredictedPos and GetRole() == "Killer" then
                            local args = {...}
                            if typeof(args[2]) == "Vector3" then
                                local o = args[2]
                                local dir = (FS.PredictedPos - o)
                                if dir.Magnitude > 0.1 then
                                    args[1] = dir.Unit
                                    return oldNC(self, unpack(args))
                                end
                            elseif typeof(args[1]) == "Vector3" then
                                local c = LP.Character
                                local hand = c and (c:FindFirstChild("LeftHand") or c:FindFirstChild("Left Arm") or c:FindFirstChild("RightHand") or c:FindFirstChild("Right Arm") or c:FindFirstChild("HumanoidRootPart"))
                                if hand then
                                    local dir = (FS.PredictedPos - hand.Position)
                                    if dir.Magnitude > 0.1 then
                                        args[1] = dir.Unit
                                        return oldNC(self, unpack(args))
                                    end
                                end
                            end
                        end
                    end
                end

                -- 6. Unlock Skill While Carrying
                if method == "GetAttribute" and W.CarryCfg and W.CarryCfg.Enabled then
                    local args = {...}
                    if args[1] == "IsCarrying" then return false end
                end

                return oldNC(self, ...)
            end)
        end)
    end)
end

--====================================================--
-- PART 16B-2: FLOATING BUTTONS (10)
--====================================================--
local function CreateFloat(cfg)
    local st = cfg.state
    st.Conns = st.Conns or {}
    local function clear()
        for _, c in ipairs(st.Conns) do pcall(function() c:Disconnect() end) end
        st.Conns = {}
    end
    local function destroy()
        clear()
        if st.Gui then pcall(function() st.Gui:Destroy() end); st.Gui = nil end
    end
    local function refresh()
        if not st.Gui then return end
        local main = st.Gui:FindFirstChild("MainBtn", true)
        if not main then return end
        local on = cfg.isOn()
        local sp = main:FindFirstChild("StatusPill")
        local sT = sp and sp:FindFirstChild("StatusText")
        local sD = sp and sp:FindFirstChild("StatusDot")
        local sStr = main:FindFirstChild("MainStroke")
        local ic = main:FindFirstChild("IconCircle")
        local iDot = ic and ic:FindFirstChild("IconDot")
        if on then
            TweenService:Create(main, TweenInfo.new(0.25), { BackgroundColor3 = _G.W2_BG_OFF }):Play()
            if ic then TweenService:Create(ic, TweenInfo.new(0.25), { BackgroundColor3 = _G.W2_ACCENT, BackgroundTransparency = 0.15 }):Play() end
            if iDot then TweenService:Create(iDot, TweenInfo.new(0.25), { ImageColor3 = _G.W2_ACCENT }):Play() end
            if sp then TweenService:Create(sp, TweenInfo.new(0.25), { BackgroundColor3 = _G.W2_BG_OFF }):Play() end
            if sT then sT.Text = "ON"; TweenService:Create(sT, TweenInfo.new(0.25), { TextColor3 = _G.W2_ACCENT }):Play() end
            if sD then TweenService:Create(sD, TweenInfo.new(0.25), { BackgroundColor3 = _G.W2_ACCENT }):Play() end
            if sStr then TweenService:Create(sStr, TweenInfo.new(0.25), { Color = Color3.fromRGB(255, 255, 255) }):Play() end
        else
            TweenService:Create(main, TweenInfo.new(0.25), { BackgroundColor3 = _G.W2_BG_OFF }):Play()
            if ic then TweenService:Create(ic, TweenInfo.new(0.25), { BackgroundColor3 = _G.W2_NEUTRAL, BackgroundTransparency = 0.4 }):Play() end
            if iDot then TweenService:Create(iDot, TweenInfo.new(0.25), { ImageColor3 = _G.W2_NEUTRAL }):Play() end
            if sp then TweenService:Create(sp, TweenInfo.new(0.25), { BackgroundColor3 = _G.W2_BG_OFF }):Play() end
            if sT then sT.Text = "OFF"; TweenService:Create(sT, TweenInfo.new(0.25), { TextColor3 = Color3.fromRGB(120, 120, 120) }):Play() end
            if sD then TweenService:Create(sD, TweenInfo.new(0.25), { BackgroundColor3 = _G.W2_NEUTRAL }):Play() end
            if sStr then TweenService:Create(sStr, TweenInfo.new(0.25), { Color = _G.W2_STROKE_OFF }):Play() end
        end
    end
    local function toggle()
        local s = not cfg.isOn()
        cfg.onToggle(s)
        refresh()
    end
    local function create()
        destroy()
        local parent = LP:FindFirstChild("PlayerGui")
        if gethui then local ok, hui = pcall(gethui); if ok and hui then parent = hui end end
        if not parent then return end
        local gui = Instance.new("ScreenGui")
        gui.Name = "W2" .. cfg.id .. "Btn"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = parent
        st.Gui = gui
        local cont = Instance.new("Frame")
        cont.Name = "Container"
        cont.Size = UDim2.fromOffset(180, 40)
        cont.Position = st.SavedPos
        cont.BackgroundTransparency = 1
        cont.Parent = gui
        local main = Instance.new("Frame")
        main.Name = "MainBtn"
        main.Size = UDim2.fromOffset(132, 40)
        main.BackgroundColor3 = _G.W2_BG_OFF
        main.BorderSizePixel = 0
        main.Parent = cont
        Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
        local ms = Instance.new("UIStroke", main)
        ms.Name = "MainStroke"
        ms.Color = _G.W2_STROKE_OFF
        ms.Thickness = 1.2
        ms.Transparency = 0.2
        local ic = Instance.new("Frame", main)
        ic.Name = "IconCircle"
        ic.Size = UDim2.fromOffset(24, 24)
        ic.Position = UDim2.new(0, 8, 0.5, -12)
        ic.BackgroundColor3 = _G.W2_NEUTRAL
        ic.BackgroundTransparency = 0.4
        ic.BorderSizePixel = 0
        Instance.new("UICorner", ic).CornerRadius = UDim.new(1, 0)
        local iDot = Instance.new("ImageLabel", ic)
        iDot.Name = "IconDot"
        iDot.Size = UDim2.fromOffset(16, 16)
        iDot.Position = UDim2.new(0.5, -8, 0.5, -8)
        iDot.BackgroundTransparency = 1
        iDot.Image = "rbxassetid://138040631725974"
        iDot.ImageColor3 = Color3.fromRGB(255, 255, 255)
        iDot.Rotation = cfg.iconRotation or 0
        iDot.ZIndex = 3
        local ml = Instance.new("TextLabel", main)
        ml.Size = UDim2.new(1, -70, 1, 0)
        ml.Position = UDim2.new(0, 38, 0, 0)
        ml.BackgroundTransparency = 1
        ml.Font = Enum.Font.GothamBold
        ml.Text = cfg.title
        ml.TextColor3 = Color3.fromRGB(240, 240, 245)
        ml.TextSize = 13
        ml.TextXAlignment = Enum.TextXAlignment.Left
        local sp = Instance.new("Frame", main)
        sp.Name = "StatusPill"
        sp.AnchorPoint = Vector2.new(1, 0.5)
        sp.Size = UDim2.fromOffset(42, 20)
        sp.Position = UDim2.new(1, -8, 0.5, 0)
        sp.BackgroundColor3 = _G.W2_BG_OFF
        sp.BorderSizePixel = 0
        Instance.new("UICorner", sp).CornerRadius = UDim.new(1, 0)
        local sD = Instance.new("Frame", sp)
        sD.Name = "StatusDot"
        sD.Size = UDim2.fromOffset(6, 6)
        sD.Position = UDim2.new(0, 7, 0.5, -3)
        sD.BackgroundColor3 = _G.W2_NEUTRAL
        sD.BorderSizePixel = 0
        Instance.new("UICorner", sD).CornerRadius = UDim.new(1, 0)
        local sT = Instance.new("TextLabel", sp)
        sT.Name = "StatusText"
        sT.Size = UDim2.new(1, -18, 1, 0)
        sT.Position = UDim2.new(0, 16, 0, 0)
        sT.BackgroundTransparency = 1
        sT.Font = Enum.Font.GothamBold
        sT.Text = "OFF"
        sT.TextColor3 = Color3.fromRGB(140, 140, 152)
        sT.TextSize = 10
        sT.TextXAlignment = Enum.TextXAlignment.Center
        local lock = Instance.new("TextButton", cont)
        lock.Name = "LockBtn"
        lock.Size = UDim2.fromOffset(40, 40)
        lock.Position = UDim2.new(1, -44, 0, 0)
        lock.BackgroundColor3 = _G.W2_BG_OFF
        lock.BorderSizePixel = 0
        lock.Text = ""
        lock.AutoButtonColor = false
        Instance.new("UICorner", lock).CornerRadius = UDim.new(0, 12)
        local ls = Instance.new("UIStroke", lock)
        ls.Color = _G.W2_STROKE_OFF
        ls.Thickness = 1.2
        ls.Transparency = 0.2
        ls.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        local li = Instance.new("TextLabel", lock)
        li.Size = UDim2.fromScale(1, 1)
        li.BackgroundTransparency = 1
        li.Font = Enum.Font.GothamBold
        li.Text = "🔓"
        li.TextColor3 = Color3.fromRGB(180, 180, 190)
        li.TextSize = 16
        local function updLock()
            if st.DragLocked then
                li.Text = "🔒"
                TweenService:Create(ls, TweenInfo.new(0.2), { Color = _G.W2_ACCENT, Transparency = 0, Thickness = 1.5 }):Play()
                TweenService:Create(lock, TweenInfo.new(0.2), { BackgroundColor3 = _G.W2_ACCENT_BG }):Play()
                TweenService:Create(li, TweenInfo.new(0.2), { TextColor3 = _G.W2_ACCENT }):Play()
            else
                li.Text = "🔓"
                TweenService:Create(ls, TweenInfo.new(0.2), { Color = _G.W2_STROKE_OFF, Transparency = 0.2, Thickness = 1.2 }):Play()
                TweenService:Create(lock, TweenInfo.new(0.2), { BackgroundColor3 = _G.W2_BG_OFF }):Play()
                TweenService:Create(li, TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(180, 180, 190) }):Play()
            end
        end
        local cd = Instance.new("TextButton", main)
        cd.Name = "ClickDetect"
        cd.Size = UDim2.fromScale(1, 1)
        cd.BackgroundTransparency = 1
        cd.Text = ""
        cd.AutoButtonColor = false
        cd.ZIndex = 5
        local drag, dStart, sPos = false, nil, nil
        local dDist = 0
        table.insert(st.Conns, cd.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dStart = inp.Position; sPos = cont.Position; dDist = 0
                if not st.DragLocked then drag = true end
            end
        end))
        table.insert(st.Conns, cd.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                if drag then drag = false; st.SavedPos = cont.Position end
                if dDist < 8 then toggle() end
            end
        end))
        table.insert(st.Conns, UserInputService.InputChanged:Connect(function(inp)
            if not drag then return end
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                local d = inp.Position - dStart
                dDist = math.abs(d.X) + math.abs(d.Y)
                cont.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
            end
        end))
        table.insert(st.Conns, lock.MouseButton1Click:Connect(function()
            st.DragLocked = not st.DragLocked
            if st.DragLocked then drag = false end
            updLock()
        end))
        refresh()
        updLock()
    end
    st.SetEnabled = function(en)
        st.Enabled = en and true or false
        if st.Enabled then create() else destroy() end
    end
    st.Refresh = refresh
    return st
end
W.CreateFloat = CreateFloat

-- 10 Floating Buttons
local SH_St = { Enabled = false, DragLocked = false, Gui = nil, SavedPos = UDim2.new(0.03, 0, 0.25, 0), Conns = {} }
local SH_Btn = CreateFloat({ id = "SelfHeal", title = "Heal", state = SH_St,
    isOn = function() return W2.SelfHeal_Enabled end,
    onToggle = function(v) W.setSelfHeal(v) end, iconRotation = 0 })
getgenv().W2_SHB_SetEnabled = function(en) SH_Btn.SetEnabled(en) end
getgenv().W2_SHB_UpdateVisual = function() SH_Btn.Refresh() end

local SU_St = { Enabled = false, DragLocked = false, Gui = nil, SavedPos = UDim2.new(0.03, 0, 0.31, 0), Conns = {} }
local SU_Btn = CreateFloat({ id = "SelfUnhook", title = "Hook", state = SU_St,
    isOn = function() return W2.SelfUnhook_Enabled end,
    onToggle = function(v) W.SU_Set(v) end, iconRotation = 135 })
getgenv().W2_SUB_SetEnabled = function(en) SU_Btn.SetEnabled(en) end
getgenv().W2_SUB_UpdateVisual = function() SU_Btn.Refresh() end

local ESC_St = { Enabled = false, DragLocked = false, Gui = nil, SavedPos = UDim2.new(0.03, 0, 0.37, 0), Conns = {} }
local ESC_Btn = CreateFloat({ id = "Escape", title = "Escape", state = ESC_St,
    isOn = function() return W2.Escape_Enabled end,
    onToggle = function(v) W2.Escape_Enabled = v; if v then W.Escape_TP() end end, iconRotation = 45 })
getgenv().W2_Escape_SetEnabled = function(en) ESC_Btn.SetEnabled(en) end
getgenv().W2_Escape_UpdateVisual = function() ESC_Btn.Refresh() end

local INV_St = { Enabled = false, DragLocked = false, Gui = nil, SavedPos = UDim2.new(0.03, 0, 0.43, 0), Conns = {} }
local INV_Btn = CreateFloat({ id = "Invisible", title = "Invis", state = INV_St,
    isOn = function()
        local MV = getgenv().W2Invis
        return MV and MV.Enabled or false
    end,
    onToggle = function(v) W.Invisible_SetState(v, true) end, iconRotation = 180 })
getgenv().W2_InvisBtn_SetEnabled = function(en) INV_Btn.SetEnabled(en) end
getgenv().W2_InvisBtn_UpdateVisual = function() INV_Btn.Refresh() end

local MW_St = { Enabled = false, DragLocked = false, Gui = nil, SavedPos = UDim2.new(0.03, 0, 0.49, 0), Conns = {} }
local MW_Btn = CreateFloat({ id = "Moonwalk", title = "Moon", state = MW_St,
    isOn = function() return W2.Moonwalk_Enabled end,
    onToggle = function(v) W.Moonwalk_Set(v) end, iconRotation = 0 })
getgenv().W2_MoonwalkBtn_SetEnabled = function(en) MW_Btn.SetEnabled(en) end
getgenv().W2_MoonwalkBtn_UpdateVisual = function() MW_Btn.Refresh() end

local SP_St = { Enabled = false, DragLocked = false, Gui = nil, SavedPos = UDim2.new(0.03, 0, 0.55, 0), Conns = {} }
local SP_Btn = CreateFloat({ id = "SpearAimbot", title = "Spear", state = SP_St,
    isOn = function() return W2.SpearAimbot_Enabled end,
    onToggle = function(v) W.SpearAimbot_Set(v) end, iconRotation = 90 })
getgenv().W2_SpearBtn_SetEnabled = function(en) SP_Btn.SetEnabled(en) end
getgenv().W2_SpearBtn_UpdateVisual = function() SP_Btn.Refresh() end

local TT_St = { Enabled = false, DragLocked = false, Gui = nil, SavedPos = UDim2.new(0.03, 0, 0.61, 0), Conns = {} }
local TT_Btn = CreateFloat({ id = "TrollTP", title = "T_TP", state = TT_St,
    isOn = function() return W.TT.Enabled end,
    onToggle = function(v) W.TT_Set(v) end, iconRotation = 225 })
getgenv().W2_TTB_SetEnabled = function(en) TT_Btn.SetEnabled(en) end
getgenv().W2_TTB_UpdateVisual = function() TT_Btn.Refresh() end

local P1_St = { Enabled = false, DragLocked = false, Gui = nil, SavedPos = UDim2.new(0.03, 0, 0.67, 0), Conns = {} }
local P1_Btn = CreateFloat({ id = "Parry", title = "Parry", state = P1_St,
    isOn = function() return W2.ParryV1_Enabled end,
    onToggle = function(v) W2.ParryV1_Enabled = v end, iconRotation = 45 })
getgenv().W2_ParryBtn_SetEnabled = function(en) P1_Btn.SetEnabled(en) end
getgenv().W2_ParryBtn_UpdateVisual = function() P1_Btn.Refresh() end

local MG_St = { Enabled = false, DragLocked = false, Gui = nil, SavedPos = UDim2.new(0.03, 0, 0.73, 0), Conns = {} }
local MG_Btn = CreateFloat({ id = "MyersGrab", title = "Grab", state = MG_St,
    isOn = function() return W.MyersData.Enabled end,
    onToggle = function(v) W.Myers_Set(v) end, iconRotation = 90 })
getgenv().W2_MGrabBtn_SetEnabled = function(en) MG_Btn.SetEnabled(en) end
getgenv().W2_MGrabBtn_UpdateVisual = function() MG_Btn.Refresh() end

local PT_St = { Enabled = false, DragLocked = false, Gui = nil, SavedPos = UDim2.new(0.03, 0, 0.79, 0), Conns = {} }
local PT_Btn = CreateFloat({ id = "PistolTOF", title = "Pistol", state = PT_St,
    isOn = function() return W2.TOF_Enabled end,
    onToggle = function(v) W.SetToFEnabled(v) end, iconRotation = 0 })
getgenv().W2_PistolBtn_SetEnabled = function(en) PT_Btn.SetEnabled(en) end
getgenv().W2_PistolBtn_UpdateVisual = function() PT_Btn.Refresh() end

-- 2 FLOATING BUTTON BARU: EMOTE + SILENT AIM PISTOL (3 MODE)
local EM_St = { Enabled = false, DragLocked = false, Gui = nil, SavedPos = UDim2.new(0.03, 0, 0.85, 0), Conns = {} }
local EM_Btn = CreateFloat({ id = "Emote", title = "Emote", state = EM_St,
    isOn = function() return W.Emote and W.Emote.Enabled end,
    onToggle = function(v) W.Emote_Set(v) end, iconRotation = 0 })
getgenv().W2_EmoteBtn_SetEnabled = function(en) EM_Btn.SetEnabled(en) end
getgenv().W2_EmoteBtn_UpdateVisual = function() EM_Btn.Refresh() end

local SA_St = { Enabled = false, DragLocked = false, Gui = nil, SavedPos = UDim2.new(0.03, 0, 0.91, 0), Conns = {} }
local SA_Btn = CreateFloat({ id = "SilentPistol", title = "Pistol", state = SA_St,
    isOn = function() return W2.TOF_Enabled end,
    onToggle = function(v)
        W.SetToFEnabled(v)
        if v then
            -- Cycle mode: Killer → Survivors → Zombie
            local modes = {"Killer", "Survivors", "Zombie"}
            local cur = W2.TOF_TargetMode or "Killer"
            local idx = 1
            for i, m in ipairs(modes) do if m == cur then idx = i; break end end
            local nxt = modes[(idx % #modes) + 1]
            W.ToF_SetMode(nxt, true)
        end
    end, iconRotation = 90 })
getgenv().W2_SilentPistolBtn_SetEnabled = function(en) SA_Btn.SetEnabled(en) end
getgenv().W2_SilentPistolBtn_UpdateVisual = function() SA_Btn.Refresh() end

--====================================================--
-- PART 16B-3: BOMBAX UI V4 RAYFIELD-STYLE
--====================================================--
do
    local IMG = "rbxassetid://138040631725974"
    local BS = {
        Gui = nil, ButtonBox = nil, Window = nil,
        Open = false, Conns = {},
        ProgressFill = nil, TimeLabel = nil, NowLabel = nil,
        PlayBtn = nil, LoopBtn = nil, PickerBtn = nil,
        _ButtonBox = nil,
    }

    local function clean()
        for _, c in ipairs(BS.Conns) do pcall(function() c:Disconnect() end) end
        BS.Conns = {}
    end

    local function updateProgress()
        if not BS.ProgressFill or not BS.TimeLabel then return end
        local BX = W.Bombax
        if not BX or not BX.Current then
            BS.ProgressFill.Size = UDim2.new(0, 0, 1, 0)
            BS.TimeLabel.Text = "0:00 / 0:00"
            return
        end
        local ok, length = pcall(function() return BX.Current.TimeLength end)
        local ok2, pos = pcall(function() return BX.Current.TimePosition end)
        if not ok or not ok2 or not length or length <= 0 then
            BS.ProgressFill.Size = UDim2.new(0, 0, 1, 0)
            BS.TimeLabel.Text = "0:00 / 0:00"
            return
        end
        local pct = math.clamp(pos / length, 0, 1)
        BS.ProgressFill.Size = UDim2.new(pct, 0, 1, 0)
        local function fmt(t)
            t = math.max(0, math.floor(t))
            local m = math.floor(t / 60)
            local s = t - m * 60
            return string.format("%d:%02d", m, s)
        end
        BS.TimeLabel.Text = fmt(pos) .. " / " .. fmt(length)
    end

    local function updateNowLabel()
        if not BS.NowLabel then return end
        local BX = W.Bombax
        if BX then BS.NowLabel.Text = "▶ " .. tostring(BX.Selected) end
        if BS.PickerBtn and BX then
            BS.PickerBtn.Text = "🎵 SONG: " .. tostring(BX.Selected)
        end
    end

    local function updatePlayBtn()
        if not BS.PlayBtn then return end
        local BX = W.Bombax
        if BX and BX.Playing then
            BS.PlayBtn.Text = "⏸"
            BS.PlayBtn.BackgroundColor3 = Color3.fromRGB(70, 30, 30)
        else
            BS.PlayBtn.Text = "▶"
            BS.PlayBtn.BackgroundColor3 = Color3.fromRGB(30, 70, 40)
        end
    end

    local function updateLoopBtn()
        if not BS.LoopBtn then return end
        local BX = W.Bombax
        if not BX then return end
        BS.LoopBtn.BackgroundColor3 = BX.Looped and Color3.fromRGB(30, 70, 40) or Color3.fromRGB(45, 45, 58)
        BS.LoopBtn.Text = "LOOP: " .. (BX.Looped and "ON" or "OFF")
    end

    local function toggleWindow()
        if not BS.Window then return end
        BS.Open = not BS.Open
        if BS.Open then
            BS.Window.Visible = true
            BS.Window.Size = UDim2.fromOffset(0, 0)
            BS.Window.BackgroundTransparency = 1
            TweenService:Create(BS.Window, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(260, 260),
                BackgroundTransparency = 0.05,
            }):Play()
        else
            local tw = TweenService:Create(BS.Window, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.fromOffset(0, 0),
                BackgroundTransparency = 1,
            })
            tw:Play()
            tw.Completed:Connect(function()
                if BS.Window then BS.Window.Visible = false end
            end)
        end
        if getgenv().W2_BombaxRefresh then
            pcall(getgenv().W2_BombaxRefresh)
        end
    end

    -- BUILD BUTTON (RAYFIELD STYLE)
    local function buildButton()
        if BS.ButtonBox then pcall(function() BS.ButtonBox:Destroy() end); BS.ButtonBox = nil end

        local box = Instance.new("Frame")
        box.Name = "W2MenuToggleBtn"
        box.Size = UDim2.fromOffset(54, 54)
        box.Position = UDim2.new(0, 20, 0, 20)
        box.BackgroundTransparency = 1
        box.Parent = BS.Gui
        BS.ButtonBox = box
        BS._ButtonBox = box

        local glow = Instance.new("Frame")
        glow.Name = "Glow"
        glow.Size = UDim2.fromScale(1.35, 1.35)
        glow.Position = UDim2.fromScale(0.5, 0.5)
        glow.AnchorPoint = Vector2.new(0.5, 0.5)
        glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        glow.BackgroundTransparency = 1
        glow.BorderSizePixel = 0
        glow.ZIndex = 1
        glow.Parent = box
        Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)
        local glowStroke = Instance.new("UIStroke", glow)
        glowStroke.Color = Color3.fromRGB(255, 255, 255)
        glowStroke.Thickness = 1
        glowStroke.Transparency = 1
        glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local btn = Instance.new("TextButton")
        btn.Name = "Btn"
        btn.Size = UDim2.fromScale(1, 1)
        btn.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        btn.BackgroundTransparency = 0.08
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 2
        btn.Parent = box
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Name = "S"
        btnStroke.Color = Color3.fromRGB(255, 255, 255)
        btnStroke.Thickness = 1.5
        btnStroke.Transparency = 0.35
        btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local icon = Instance.new("ImageLabel", btn)
        icon.Name = "I"
        icon.Size = UDim2.fromScale(0.62, 0.62)
        icon.Position = UDim2.fromScale(0.19, 0.19)
        icon.BackgroundTransparency = 1
        icon.Image = IMG
        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        icon.ZIndex = 3

        local hint = Instance.new("TextLabel", box)
        hint.Name = "Hint"
        hint.AnchorPoint = Vector2.new(0.5, 0)
        hint.Position = UDim2.new(0.5, 0, 1, 4)
        hint.Size = UDim2.fromOffset(60, 12)
        hint.BackgroundTransparency = 1
        hint.Font = Enum.Font.GothamBold
        hint.Text = "MENU"
        hint.TextColor3 = Color3.fromRGB(180, 180, 200)
        hint.TextSize = 9
        hint.TextStrokeTransparency = 0.5
        hint.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        hint.ZIndex = 2

        task.spawn(function()
            while box.Parent do
                if not BS.Open then
                    TweenService:Create(glowStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {
                        Transparency = 0.2,
                        Thickness = 2.5,
                    }):Play()
                    TweenService:Create(glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {
                        Size = UDim2.fromScale(1.45, 1.45),
                    }):Play()
                    task.wait(1.2)
                    TweenService:Create(glowStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {
                        Transparency = 1,
                        Thickness = 1,
                    }):Play()
                    TweenService:Create(glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {
                        Size = UDim2.fromScale(1.15, 1.15),
                    }):Play()
                    task.wait(1.2)
                else
                    task.wait(0.3)
                end
            end
        end)

        local function refresh()
            local isOpen = BS.Open
            local isPlaying = W.Bombax and W.Bombax.Playing

            local strokeColor = Color3.fromRGB(255, 255, 255)
            local strokeTrans = 0.35
            local iconColor = Color3.fromRGB(255, 255, 255)
            local bgColor = Color3.fromRGB(12, 12, 16)

            if isOpen then
                strokeColor = Color3.fromRGB(120, 200, 255)
                strokeTrans = 0
                iconColor = Color3.fromRGB(120, 200, 255)
                bgColor = Color3.fromRGB(20, 25, 40)
            elseif isPlaying then
                strokeColor = Color3.fromRGB(120, 255, 160)
                strokeTrans = 0
                iconColor = Color3.fromRGB(120, 255, 160)
                bgColor = Color3.fromRGB(15, 30, 20)
            end

            TweenService:Create(btnStroke, TweenInfo.new(0.3), {
                Color = strokeColor,
                Transparency = strokeTrans,
                Thickness = isOpen and 2 or 1.5,
            }):Play()
            TweenService:Create(icon, TweenInfo.new(0.3), {
                ImageColor3 = iconColor,
            }):Play()
            TweenService:Create(btn, TweenInfo.new(0.3), {
                BackgroundColor3 = bgColor,
            }):Play()
            TweenService:Create(hint, TweenInfo.new(0.3), {
                TextColor3 = isOpen and Color3.fromRGB(120, 200, 255) or Color3.fromRGB(180, 180, 200),
            }):Play()
        end
        getgenv().W2_BombaxRefresh = refresh
        refresh()

        local dragging, dragStart, startPos = false, nil, nil
        local dDist = 0
        local holdStart = 0

        btn.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = inp.Position
                startPos = box.Position
                dDist = 0
                holdStart = tick()
            end
        end)

        btn.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                if dDist < 8 and (tick() - holdStart) < 0.6 then
                    toggleWindow()
                    refresh()
                end
            end
        end)

        table.insert(BS.Conns, UserInputService.InputChanged:Connect(function(inp)
            if not dragging then return end
            if inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch then
                local d = inp.Position - dragStart
                dDist = math.abs(d.X) + math.abs(d.Y)
                box.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y
                )
            end
        end))

        btn.MouseEnter:Connect(function()
            if not BS.Open then
                TweenService:Create(btn, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0,
                }):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if not BS.Open then
                TweenService:Create(btn, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.08,
                }):Play()
            end
        end)
    end

    -- BUILD WINDOW
    local function buildWindow()
        if BS.Window then pcall(function() BS.Window:Destroy() end); BS.Window = nil end

        local win = Instance.new("Frame")
        win.Name = "BombaxWindow"
        win.Size = UDim2.fromOffset(260, 260)
        win.Position = UDim2.new(0, 20, 0, 84)
        win.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        win.BackgroundTransparency = 0.05
        win.BorderSizePixel = 0
        win.Visible = false
        win.ZIndex = 50
        win.Active = true
        win.Parent = BS.Gui
        BS.Window = win
        Instance.new("UICorner", win).CornerRadius = UDim.new(0, 14)
        local winStroke = Instance.new("UIStroke", win)
        winStroke.Color = Color3.fromRGB(255, 255, 255)
        winStroke.Thickness = 1.2
        winStroke.Transparency = 0.25
        winStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local header = Instance.new("Frame", win)
        header.Name = "Header"
        header.Size = UDim2.new(1, 0, 0, 40)
        header.BackgroundTransparency = 1
        header.Active = true

        local iconBox = Instance.new("ImageLabel", header)
        iconBox.Name = "Icon"
        iconBox.Size = UDim2.fromOffset(28, 28)
        iconBox.Position = UDim2.new(0, 10, 0.5, -14)
        iconBox.BackgroundTransparency = 1
        iconBox.Image = IMG
        iconBox.ImageColor3 = Color3.fromRGB(255, 255, 255)

        local title = Instance.new("TextLabel", header)
        title.Size = UDim2.new(1, -80, 0, 16)
        title.Position = UDim2.new(0, 46, 0, 6)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.Text = "BOMBAX PLAYER"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 12
        title.TextXAlignment = Enum.TextXAlignment.Left

        local subtitle = Instance.new("TextLabel", header)
        subtitle.Size = UDim2.new(1, -80, 0, 12)
        subtitle.Position = UDim2.new(0, 46, 0, 22)
        subtitle.BackgroundTransparency = 1
        subtitle.Font = Enum.Font.Gotham
        subtitle.Text = "Music Player"
        subtitle.TextColor3 = Color3.fromRGB(140, 140, 160)
        subtitle.TextSize = 9
        subtitle.TextXAlignment = Enum.TextXAlignment.Left

        local closeBtn = Instance.new("TextButton", header)
        closeBtn.Name = "CloseBtn"
        closeBtn.AnchorPoint = Vector2.new(1, 0.5)
        closeBtn.Size = UDim2.fromOffset(24, 24)
        closeBtn.Position = UDim2.new(1, -8, 0.5, 0)
        closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        closeBtn.BorderSizePixel = 0
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 12
        closeBtn.AutoButtonColor = false
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
        closeBtn.MouseButton1Click:Connect(function()
            if BS.Open then toggleWindow() end
        end)

        local nowCard = Instance.new("Frame", win)
        nowCard.Name = "NowCard"
        nowCard.Size = UDim2.new(1, -20, 0, 46)
        nowCard.Position = UDim2.fromOffset(10, 48)
        nowCard.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        nowCard.BorderSizePixel = 0
        Instance.new("UICorner", nowCard).CornerRadius = UDim.new(0, 8)
        local nowStroke = Instance.new("UIStroke", nowCard)
        nowStroke.Color = Color3.fromRGB(60, 60, 80)
        nowStroke.Thickness = 1
        nowStroke.Transparency = 0.4

        local nowLabel = Instance.new("TextLabel", nowCard)
        nowLabel.Name = "NowLabel"
        nowLabel.Size = UDim2.new(1, -16, 0, 18)
        nowLabel.Position = UDim2.fromOffset(8, 4)
        nowLabel.BackgroundTransparency = 1
        nowLabel.Font = Enum.Font.GothamBold
        nowLabel.Text = "▶ " .. tostring((W.Bombax and W.Bombax.Selected) or "One")
        nowLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
        nowLabel.TextSize = 11
        nowLabel.TextXAlignment = Enum.TextXAlignment.Left
        nowLabel.TextTruncate = Enum.TextTruncate.AtEnd
        BS.NowLabel = nowLabel

        local progBg = Instance.new("Frame", nowCard)
        progBg.Name = "ProgBg"
        progBg.Size = UDim2.new(1, -110, 0, 6)
        progBg.Position = UDim2.new(0, 8, 0, 30)
        progBg.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
        progBg.BorderSizePixel = 0
        Instance.new("UICorner", progBg).CornerRadius = UDim.new(1, 0)

        local progFill = Instance.new("Frame", progBg)
        progFill.Name = "Fill"
        progFill.Size = UDim2.new(0, 0, 1, 0)
        progFill.BackgroundColor3 = Color3.fromRGB(120, 255, 160)
        progFill.BorderSizePixel = 0
        Instance.new("UICorner", progFill).CornerRadius = UDim.new(1, 0)
        BS.ProgressFill = progFill

        local timeLabel = Instance.new("TextLabel", nowCard)
        timeLabel.Name = "TimeLabel"
        timeLabel.AnchorPoint = Vector2.new(1, 0)
        timeLabel.Size = UDim2.fromOffset(96, 12)
        timeLabel.Position = UDim2.new(1, -8, 0, 26)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Font = Enum.Font.GothamBold
        timeLabel.Text = "0:00 / 0:00"
        timeLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        timeLabel.TextSize = 9
        timeLabel.TextXAlignment = Enum.TextXAlignment.Right
        BS.TimeLabel = timeLabel

        local pick = Instance.new("TextButton", win)
        pick.Name = "Picker"
        pick.Size = UDim2.new(1, -20, 0, 32)
        pick.Position = UDim2.fromOffset(10, 102)
        pick.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
        pick.BorderSizePixel = 0
        pick.Text = "🎵 SONG: " .. tostring((W.Bombax and W.Bombax.Selected) or "One")
        pick.TextColor3 = Color3.fromRGB(230, 230, 245)
        pick.Font = Enum.Font.GothamBold
        pick.TextSize = 11
        pick.TextTruncate = Enum.TextTruncate.AtEnd
        Instance.new("UICorner", pick).CornerRadius = UDim.new(0, 8)
        local pickStroke = Instance.new("UIStroke", pick)
        pickStroke.Color = Color3.fromRGB(80, 80, 100)
        pickStroke.Thickness = 1
        pickStroke.Transparency = 0.4
        BS.PickerBtn = pick
        pick.MouseButton1Click:Connect(function()
            W.Bombax_Next()
            updateNowLabel(); updatePlayBtn()
            local BX = W.Bombax
            if BX and BX.Enabled then W.Bombax_Play(BX.Selected) end
        end)

        local ctrl = Instance.new("Frame", win)
        ctrl.Name = "Controls"
        ctrl.Size = UDim2.new(1, -20, 0, 44)
        ctrl.Position = UDim2.fromOffset(10, 142)
        ctrl.BackgroundTransparency = 1

        local function mkCtrl(name, txt, x, bg)
            local b = Instance.new("TextButton", ctrl)
            b.Name = name
            b.Size = UDim2.fromOffset(74, 44)
            b.Position = UDim2.fromOffset(x, 0)
            b.BackgroundColor3 = bg
            b.BorderSizePixel = 0
            b.Text = txt
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 18
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
            local s = Instance.new("UIStroke", b)
            s.Color = Color3.fromRGB(255, 255, 255)
            s.Thickness = 1
            s.Transparency = 0.6
            return b
        end

        local prevB = mkCtrl("Prev", "⏮", 0, Color3.fromRGB(45, 45, 58))
        local playB = mkCtrl("Play", "▶", 78, Color3.fromRGB(30, 70, 40))
        local nextB = mkCtrl("Next", "⏭", 156, Color3.fromRGB(45, 45, 58))
        BS.PlayBtn = playB

        prevB.MouseButton1Click:Connect(function()
            W.Bombax_Prev(); updateNowLabel(); updatePlayBtn()
        end)
        playB.MouseButton1Click:Connect(function()
            local BX = W.Bombax
            if not BX then return end
            if BX.Playing then W.Bombax_Stop()
            else W.Bombax_Play(BX.Selected) end
            updatePlayBtn()
        end)
        nextB.MouseButton1Click:Connect(function()
            W.Bombax_Next(); updateNowLabel(); updatePlayBtn()
        end)

        local vrow = Instance.new("Frame", win)
        vrow.Name = "VolumeRow"
        vrow.Size = UDim2.new(1, -20, 0, 22)
        vrow.Position = UDim2.fromOffset(10, 194)
        vrow.BackgroundTransparency = 1

        local vIcon = Instance.new("TextLabel", vrow)
        vIcon.Size = UDim2.fromOffset(24, 22)
        vIcon.BackgroundTransparency = 1
        vIcon.Font = Enum.Font.GothamBold
        vIcon.Text = "🔊"
        vIcon.TextColor3 = Color3.fromRGB(200, 200, 220)
        vIcon.TextSize = 13
        vIcon.TextXAlignment = Enum.TextXAlignment.Left

        local vbar = Instance.new("Frame", vrow)
        vbar.Name = "Bar"
        vbar.Size = UDim2.new(1, -80, 0, 8)
        vbar.Position = UDim2.new(0, 28, 0.5, -4)
        vbar.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
        vbar.BorderSizePixel = 0
        Instance.new("UICorner", vbar).CornerRadius = UDim.new(1, 0)
        local vfill = Instance.new("Frame", vbar)
        vfill.Name = "Fill"
        vfill.Size = UDim2.new(((W.Bombax and W.Bombax.Volume) or 2) / 10, 0, 1, 0)
        vfill.BackgroundColor3 = Color3.fromRGB(120, 255, 160)
        vfill.BorderSizePixel = 0
        Instance.new("UICorner", vfill).CornerRadius = UDim.new(1, 0)

        local vval = Instance.new("TextLabel", vrow)
        vval.Name = "Val"
        vval.AnchorPoint = Vector2.new(1, 0.5)
        vval.Size = UDim2.fromOffset(42, 22)
        vval.Position = UDim2.new(1, 0, 0.5, 0)
        vval.BackgroundTransparency = 1
        vval.Font = Enum.Font.GothamBold
        vval.Text = string.format("%.1f", (W.Bombax and W.Bombax.Volume) or 2)
        vval.TextColor3 = Color3.fromRGB(255, 255, 255)
        vval.TextSize = 11
        vval.TextXAlignment = Enum.TextXAlignment.Right

        local vhit = Instance.new("TextButton", vbar)
        vhit.Size = UDim2.fromScale(1, 1)
        vhit.BackgroundTransparency = 1
        vhit.Text = ""

        local vDrag = false
        local function applyV(x)
            local ax = vbar.AbsolutePosition.X
            local aw = vbar.AbsoluteSize.X
            local pct = math.clamp((x - ax) / math.max(aw, 1), 0, 1)
            local nv = math.floor(pct * 20 + 0.5) / 2
            W.Bombax_SetVol(nv)
            vval.Text = string.format("%.1f", nv)
            vfill.Size = UDim2.new(nv / 10, 0, 1, 0)
        end
        vhit.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                vDrag = true
                applyV(inp.Position.X)
            end
        end)
        table.insert(BS.Conns, UserInputService.InputChanged:Connect(function(inp)
            if not vDrag then return end
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                applyV(inp.Position.X)
            end
        end))
        table.insert(BS.Conns, UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                vDrag = false
            end
        end))

        local loop = Instance.new("TextButton", win)
        loop.Name = "Loop"
        loop.Size = UDim2.new(1, -20, 0, 26)
        loop.Position = UDim2.fromOffset(10, 222)
        loop.BackgroundColor3 = ((W.Bombax and W.Bombax.Looped) and Color3.fromRGB(30, 70, 40)) or Color3.fromRGB(45, 45, 58)
        loop.BorderSizePixel = 0
        loop.Text = "LOOP: " .. (((W.Bombax and W.Bombax.Looped) and "ON") or "OFF")
        loop.TextColor3 = Color3.fromRGB(255, 255, 255)
        loop.Font = Enum.Font.GothamBold
        loop.TextSize = 11
        Instance.new("UICorner", loop).CornerRadius = UDim.new(0, 8)
        BS.LoopBtn = loop
        loop.MouseButton1Click:Connect(function()
            local BX = W.Bombax
            if not BX then return end
            W.Bombax_SetLoop(not BX.Looped)
            updateLoopBtn()
        end)

        local dragging, dragStart, startPos = false, nil, nil
        header.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = inp.Position
                startPos = win.Position
            end
        end)
        header.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        table.insert(BS.Conns, UserInputService.InputChanged:Connect(function(inp)
            if not dragging then return end
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                local d = inp.Position - dragStart
                win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end))
    end

    function W.BombaxUI_BuildAll()
        clean()
        if BS.Gui then pcall(function() BS.Gui:Destroy() end); BS.Gui = nil end
        BS.ButtonBox = nil
        BS.Window = nil
        BS._ButtonBox = nil
        BS.Open = false

        local parent = LP:FindFirstChild("PlayerGui")
        if gethui then local ok, hui = pcall(gethui); if ok and hui then parent = hui end end
        if not parent then return end

        local gui = Instance.new("ScreenGui")
        gui.Name = "W2BombaxUI"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.DisplayOrder = 999
        gui.Parent = parent
        BS.Gui = gui

        buildButton()
        buildWindow()
    end

    function W.BombaxUI_Start()
        if not BS.Gui then W.BombaxUI_BuildAll() end
    end
    function W.BombaxUI_Stop()
        clean()
        if BS.ButtonBox then pcall(function() BS.ButtonBox:Destroy() end); BS.ButtonBox = nil end
        if BS.Window then pcall(function() BS.Window:Destroy() end); BS.Window = nil end
        if BS.Gui then pcall(function() BS.Gui:Destroy() end); BS.Gui = nil end
        BS.Open = false
    end
    function W.BombaxUI_Set(v)
        W2.Bombax_ButtonEnabled = v and true or false
        if v then W.BombaxUI_Start() else W.BombaxUI_Stop() end
    end
    function W.BombaxUI_Toggle()
        toggleWindow()
    end

    task.spawn(function()
        while true do
            task.wait(0.1)
            if BS.Window and BS.Open then pcall(updateProgress) end
        end
    end)
    task.spawn(function()
        while true do
            task.wait(0.5)
            if BS.Window and BS.Open then
                pcall(updateNowLabel); pcall(updatePlayBtn); pcall(updateLoopBtn)
            end
            if getgenv().W2_BombaxRefresh then pcall(getgenv().W2_BombaxRefresh) end
        end
    end)
    task.spawn(function()
        task.wait(2)
        if W2.Bombax_ButtonEnabled then W.BombaxUI_Start() end
    end)
    LP.CharacterAdded:Connect(function()
        task.wait(1.5)
        if W2.Bombax_ButtonEnabled then W.BombaxUI_Start() end
    end)
end

--====================================================--
-- PART 16B-4: FPS/PING COUNTER (AUTO-ON)
--====================================================--
do
    local FpsPingGui = nil
    local FpsLabel = nil
    local PingLabel = nil
    local FrameCount = 0
    local LastTime = tick()
    local FpsValue = 0

    local function GetPing()
        local ok, v = pcall(function()
            return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        return ok and v or 0
    end

    local function BuildUI()
        if FpsPingGui then pcall(function() FpsPingGui:Destroy() end) end
        local parent = LP:FindFirstChild("PlayerGui")
        if gethui then
            local ok, hui = pcall(gethui)
            if ok and hui then parent = hui end
        end
        if not parent then return end
        local gui = Instance.new("ScreenGui")
        gui.Name = "W2FpsPing"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 9999
        gui.Parent = parent
        FpsPingGui = gui
        local frame = Instance.new("Frame")
        frame.Name = "Box"
        frame.AnchorPoint = Vector2.new(0.5, 1)
        frame.Position = UDim2.new(0.5, 0, 1, -10)
        frame.Size = UDim2.fromOffset(200, 30)
        frame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        frame.BackgroundTransparency = 0.15
        frame.BorderSizePixel = 0
        frame.Parent = gui
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 1
        stroke.Transparency = 0.5
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        local layout = Instance.new("UIListLayout", frame)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        FpsLabel = Instance.new("TextLabel")
        FpsLabel.Name = "FPS"
        FpsLabel.Size = UDim2.fromOffset(70, 20)
        FpsLabel.BackgroundTransparency = 1
        FpsLabel.Font = Enum.Font.GothamBold
        FpsLabel.Text = "FPS: --"
        FpsLabel.TextColor3 = Color3.fromRGB(120, 255, 160)
        FpsLabel.TextSize = 12
        FpsLabel.LayoutOrder = 1
        FpsLabel.Parent = frame
        local sep = Instance.new("Frame")
        sep.Size = UDim2.fromOffset(1, 14)
        sep.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
        sep.BorderSizePixel = 0
        sep.LayoutOrder = 2
        sep.Parent = frame
        PingLabel = Instance.new("TextLabel")
        PingLabel.Name = "PING"
        PingLabel.Size = UDim2.fromOffset(70, 20)
        PingLabel.BackgroundTransparency = 1
        PingLabel.Font = Enum.Font.GothamBold
        PingLabel.Text = "PING: --"
        PingLabel.TextColor3 = Color3.fromRGB(120, 200, 255)
        PingLabel.TextSize = 12
        PingLabel.LayoutOrder = 3
        PingLabel.Parent = frame
    end
    BuildUI()
    RunService.RenderStepped:Connect(function()
        FrameCount = FrameCount + 1
        local now = tick()
        if now - LastTime >= 0.5 then
            FpsValue = math.floor(FrameCount / (now - LastTime) + 0.5)
            FrameCount = 0
            LastTime = now
            if FpsLabel and FpsLabel.Parent then
                FpsLabel.Text = "FPS: " .. tostring(FpsValue)
                if FpsValue >= 50 then FpsLabel.TextColor3 = Color3.fromRGB(120, 255, 160)
                elseif FpsValue >= 30 then FpsLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
                else FpsLabel.TextColor3 = Color3.fromRGB(255, 100, 100) end
            end
            if PingLabel and PingLabel.Parent then
                local ping = GetPing()
                PingLabel.Text = "PING: " .. tostring(ping)
                if ping < 100 then PingLabel.TextColor3 = Color3.fromRGB(120, 200, 255)
                elseif ping < 200 then PingLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
                else PingLabel.TextColor3 = Color3.fromRGB(255, 100, 100) end
            end
        end
    end)
    LP.CharacterAdded:Connect(function()
        task.wait(1)
        if not FpsPingGui or not FpsPingGui.Parent then BuildUI() end
    end)
end

--====================================================--
-- PART 16B-5: TROLL (EMOTE + BOMBAX + AVATAR + KORLESS + HEADER + ESCAPE)
--====================================================--
W2.Emote_Enabled = W2.Emote_Enabled or false
W2.Emote_Selected = W2.Emote_Selected or "Friday Night"
W2.FakeAvatar_Enabled = W2.FakeAvatar_Enabled or false
W2.FakeAvatar_ID = W2.FakeAvatar_ID or 0
W2.Korless_Enabled = W2.Korless_Enabled or false
W2.Header_Enabled = W2.Header_Enabled or false
W2.Header_Text = W2.Header_Text or "W2"
W2.Header_Color = W2.Header_Color or Color3.fromRGB(255,255,255)
W2.Bombax_Enabled = W2.Bombax_Enabled or false
W2.Bombax_Selected = W2.Bombax_Selected or "One"
W2.Bombax_Volume = W2.Bombax_Volume or 2
W2.Bombax_Looped = W2.Bombax_Looped ~= false
W2.Bombax_ButtonEnabled = W2.Bombax_ButtonEnabled or false
W2.Escape_Enabled = W2.Escape_Enabled or false

-- EMOTE
W.Emote = W.Emote or {
    Enabled = false, Track = nil, Sound = nil, Selected = "Friday Night",
    Options = { "Friday Night","WarCry","24 Hour Cinderella","Applause","Arm Swing","Backflip","California Girls","Christmas Spirit","Floating Rest","Ghoul","Griddy","Kyoufuu","OnePlays","Vulnerable" },
    Data = {
        ["Friday Night"] = { Anim = "rbxassetid://83229063951016", Sound = "rbxassetid://85355610204255" },
        ["WarCry"] = { Anim = "rbxassetid://82600868380136", Sound = "rbxassetid://120101930689931" },
        ["24 Hour Cinderella"] = { Anim = "rbxassetid://137195203725366", Sound = "rbxassetid://121099446613414" },
        ["Applause"] = { Anim = "rbxassetid://96328361165090", Sound = "rbxassetid://115490787020749" },
        ["Arm Swing"] = { Anim = "rbxassetid://80552139463944", Sound = "rbxassetid://74216458932348" },
        ["Backflip"] = { Anim = "rbxassetid://74705617908505" },
        ["California Girls"] = { Anim = "rbxassetid://123552803041504", Sound = "rbxassetid://87899327891544" },
        ["Christmas Spirit"] = { Anim = "rbxassetid://137859761110514" },
        ["Floating Rest"] = { Anim = "rbxassetid://114593021219597" },
        ["Ghoul"] = { Anim = "rbxassetid://130415594909401", Sound = "rbxassetid://123004139176580" },
        ["Griddy"] = { Anim = "rbxassetid://75586690784894" },
        ["Kyoufuu"] = { Anim = "rbxassetid://137322894494527", Sound = "rbxassetid://129064643026442" },
        ["OnePlays"] = { Anim = "rbxassetid://140625405103474", Sound = "rbxassetid://94749073728335" },
        ["Vulnerable"] = { Anim = "rbxassetid://121773684313913", Sound = "rbxassetid://135265751184744" },
    },
}
local Emote = W.Emote
function W.Emote_Stop()
    if Emote.Track then pcall(function() Emote.Track:Stop() end); Emote.Track = nil end
    if Emote.Sound then pcall(function() Emote.Sound:Destroy() end); Emote.Sound = nil end
end
function W.Emote_Play()
    W.Emote_Stop()
    local c = LP.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    local r = c:FindFirstChild("HumanoidRootPart")
    if not h or not r then return end
    local d = Emote.Data[Emote.Selected]
    if not d then return end
    if d.Anim then
        local a = Instance.new("Animation")
        a.AnimationId = d.Anim
        local t = h:LoadAnimation(a)
        t.Looped = true
        t.Priority = Enum.AnimationPriority.Action
        t:Play()
        Emote.Track = t
    end
    if d.Sound then
        local s = Instance.new("Sound")
        s.SoundId = d.Sound
        s.Looped = true
        s.Volume = 2
        s.Parent = r
        s:Play()
        Emote.Sound = s
    end
end
function W.Emote_Set(v)
    Emote.Enabled = v and true or false
    W2.Emote_Enabled = Emote.Enabled
    if Emote.Enabled then W.Emote_Play() else W.Emote_Stop() end
end
function W.Emote_Select(name)
    if Emote.Data[name] then
        Emote.Selected = name
        W2.Emote_Selected = name
        if Emote.Enabled then W.Emote_Play() end
    end
end
LP.CharacterRemoving:Connect(function() W.Emote_Stop() end)
LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Emote.Enabled then W.Emote_Play() end
end)

-- BOMBAX
W.Bombax = W.Bombax or {
    Enabled = false, Current = nil, Selected = "One", Volume = 2, Looped = true, Playing = false,
    Songs = {
        {id = "101985596918228", judul = "One"},
        {id = "78520199502339",  judul = "Two"},
        {id = "78253224480952",  judul = "Three"},
        {id = "136949217768985", judul = "Four"},
        {id = "92143860315842",  judul = "Five"},
        {id = "96568301359656",  judul = "Six"},
        {id = "96053601899287",  judul = "Seven"},
        {id = "116537762304510", judul = "Eight"},
        {id = "111775377151665", judul = "Nine"},
        {id = "131317416582166", judul = "Ten"},
        {id = "107569604895628", judul = "Eleven"},
        {id = "80210594606101",  judul = "Danza Kuduro"},
        {id = "135887188304832", judul = "Ada Yang Tumbang Jos Jis"},
        {id = "105372329671874", judul = "Million Stars Asoy"},
        {id = "79296696808534",  judul = "My Lope Lope (Speed Up)"},
        {id = "70578919220987",  judul = "My Lope Lope (Andri Poter)"},
        {id = "89338419772018",  judul = "Habibi Ishqi"},
        {id = "93652038633690",  judul = "Santai Dulu"},
        {id = "124582101215124", judul = "DJ Akimilaku Im Back"},
        {id = "121304834713825", judul = "Dangdut Week Sebelas"},
        {id = "102944382854479", judul = "Lagu Misterius"},
        {id = "126810420971446", judul = "Anak Kota"},
        {id = "94299109467073",  judul = "Cinderella Jedag Jedug"},
        {id = "83463789936127",  judul = "Lagu Jawa (Kowe Siji)"},
        {id = "771523191444498", judul = "Cintaku Ini Istimewa - AIS x Celawze"},
        {id = "86422417888834",  judul = "Kini Tinggal Kenangan - Celawze"},
        {id = "70868757792328",  judul = "Mashup Dora Dora (Funky RMX)"},
        {id = "128071048140468", judul = "Always Loving You - Natraa"},
        {id = "136239433509180", judul = "Mysterious Girl (Funky RMX)"},
        {id = "101280279977761", judul = "Kini Kita Pe Kisah - DJ Pelik Pungki"},
        {id = "117080961502380", judul = "DJ Music Dubstep x Bangun Tidur Selfie"},
        {id = "110337096446518", judul = "DJ Onia"},
    },
}
local BX = W.Bombax
function W.Bombax_GetList()
    local l = {}
    for _, s in ipairs(BX.Songs) do table.insert(l, s.judul) end
    return l
end
function W.Bombax_Find(t)
    for _, s in ipairs(BX.Songs) do
        if s.judul == t then return s end
    end
    return nil
end
function W.Bombax_Stop()
    if BX.Current then
        pcall(function() BX.Current:Stop() end)
        pcall(function() BX.Current:Destroy() end)
        BX.Current = nil
    end
    BX.Playing = false
    if getgenv().W2_BombaxRefresh then pcall(getgenv().W2_BombaxRefresh) end
end
function W.Bombax_Play(t)
    W.Bombax_Stop()
    t = t or BX.Selected
    local s = W.Bombax_Find(t)
    if not s then W.ForceNotify("Bombax", "Lagu gak ada", 2); return end
    local c = LP.Character
    if not c then W.ForceNotify("Bombax", "Character kosong", 2); return end
    local r = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Head")
    if not r then return end
    local snd = Instance.new("Sound")
    snd.Name = "W2BombaxSound"
    snd.SoundId = "rbxassetid://" .. s.id
    snd.Volume = BX.Volume
    snd.Looped = BX.Looped
    snd.Parent = r
    snd:Play()
    BX.Current = snd
    BX.Playing = true
    BX.Selected = t
    W2.Bombax_Selected = t
    W.W2_Notify("Bombax", "▶ " .. t, 3)
end
function W.Bombax_Set(v)
    BX.Enabled = v
    W2.Bombax_Enabled = v
    if v then W.Bombax_Play(BX.Selected) else W.Bombax_Stop() end
end
function W.Bombax_SetVol(v)
    BX.Volume = tonumber(v) or 2
    W2.Bombax_Volume = BX.Volume
    if BX.Current then pcall(function() BX.Current.Volume = BX.Volume end) end
end
function W.Bombax_SetLoop(v)
    BX.Looped = v and true or false
    W2.Bombax_Looped = BX.Looped
    if BX.Current then pcall(function() BX.Current.Looped = BX.Looped end) end
end
function W.Bombax_Next()
    local l = BX.Songs
    local idx = 1
    for i, s in ipairs(l) do if s.judul == BX.Selected then idx = i; break end end
    local n = idx + 1
    if n > #l then n = 1 end
    W.Bombax_Play(l[n].judul)
end
function W.Bombax_Prev()
    local l = BX.Songs
    local idx = 1
    for i, s in ipairs(l) do if s.judul == BX.Selected then idx = i; break end end
    local p = idx - 1
    if p < 1 then p = #l end
    W.Bombax_Play(l[p].judul)
end

-- FAKE AVATAR
W2.FakeAvatar_Enabled = W2.FakeAvatar_Enabled or false
W2.FakeAvatar_ID = W2.FakeAvatar_ID or 0

do
    local FakeAvatarEnabled = W2.FakeAvatar_Enabled
    local SelectedFakeAva = LP.UserId

    local function LoadAppearanceIntoChar(appearance, character, head)
        local items = appearance:GetChildren()
        local function applyMesh(obj)
            if obj:IsA("CharacterMesh") or obj:IsA("BodyColors") or obj:IsA("Shirt") or obj:IsA("Pants") then
                local existing = character:FindFirstChild(obj.Name)
                if existing and existing.ClassName == obj.ClassName then existing:Destroy() end
                obj:Clone().Parent = character
            end
        end
        for _, item in pairs(items) do
            if item:IsA("Folder") or item:IsA("Model") then
                for _, subItem in pairs(item:GetChildren()) do applyMesh(subItem) end
            else applyMesh(item) end
        end
        for _, item in pairs(items) do
            if item:IsA("SpecialMesh") and head then
                local targetMesh = head:FindFirstChildOfClass("SpecialMesh") or Instance.new("SpecialMesh", head)
                targetMesh.MeshType = Enum.MeshType.FileMesh
                targetMesh.MeshId = item.MeshId
                targetMesh.TextureId = item.TextureId
            elseif item:IsA("Decal") and item.Name == "face" and head then
                if head:FindFirstChild("face") then head.face:Destroy() end
                item:Clone().Parent = head
            end
        end
        for _, item in pairs(items) do
            if item:IsA("Accessory") then
                local clone = item:Clone()
                local handle = clone:FindFirstChild("Handle")
                if handle then
                    local att = handle:FindFirstChildOfClass("Attachment")
                    if att then
                        local targetAtt = character:FindFirstChild(att.Name, true)
                        if targetAtt then
                            local weld = Instance.new("Weld")
                            weld.Part0 = handle; weld.Part1 = targetAtt.Parent
                            weld.C0 = att.CFrame; weld.C1 = targetAtt.CFrame
                            weld.Parent = handle
                        end
                    end
                    handle.CanCollide = false; handle.Massless = true; clone.Parent = character
                end
            end
        end
    end

    local function ApplyFakeAvatar()
        local character = LP.Character
        if not character or not SelectedFakeAva then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        task.spawn(function()
            local success, appearance = pcall(function()
                return game:GetService("Players"):GetCharacterAppearanceAsync(SelectedFakeAva)
            end)
            if not success or not appearance then warn("[FakeAvatar] Gagal load data avatar!"); return end
            for _, obj in pairs(character:GetChildren()) do
                if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants")
                or obj:IsA("BodyColors") or obj:IsA("CharacterMesh") or obj:IsA("ShirtGraphic") then
                    obj:Destroy()
                end
            end
            local head = character:FindFirstChild("Head")
            if head then
                for _, hObj in pairs(head:GetChildren()) do
                    if hObj:IsA("SpecialMesh") or hObj:IsA("Decal") then hObj:Destroy() end
                end
                local m = Instance.new("SpecialMesh", head)
                m.MeshType = Enum.MeshType.Head; m.Scale = Vector3.new(1, 1, 1)
            end
            local scaleDefaults = { BodyDepthScale = 1, BodyHeightScale = 1, BodyWidthScale = 1, HeadScale = 1, BodyTypeScale = 0, BodyProportionScale = 0 }
            for scaleName, val in pairs(scaleDefaults) do
                local s = humanoid:FindFirstChild(scaleName); if s then s.Value = val end
            end
            task.wait(0.1)
            LoadAppearanceIntoChar(appearance, character, head)
            pcall(function()
                local info = game:GetService("Players"):GetCharacterAppearanceInfoAsync(SelectedFakeAva)
                if head and info.assets then
                    for _, asset in pairs(info.assets) do
                        if asset.assetType.name == "Face" then
                            if head:FindFirstChild("face") then head.face:Destroy() end
                            local f = Instance.new("Decal", head)
                            f.Name = "face"; f.Texture = "rbxassetid://" .. asset.id
                            break
                        end
                    end
                end
            end)
        end)
    end

    function W.FakeAvatar_Set(state)
        FakeAvatarEnabled = state
        W2.FakeAvatar_Enabled = state
        if state then ApplyFakeAvatar() end
    end

    function W.FakeAvatar_SetId(id)
        SelectedFakeAva = id
        W2.FakeAvatar_ID = id
        if FakeAvatarEnabled then ApplyFakeAvatar() end
    end

    function W.FakeAvatar_FromUsername(input)
        input = (input or ""):gsub("^@", "")
        if input == "" then W.ForceNotify("Fake Avatar", "Masukkan username dulu!", 2); return false end
        local ok, userId = pcall(function()
            return game:GetService("Players"):GetUserIdFromNameAsync(input)
        end)
        if not ok or not userId then
            W.ForceNotify("Fake Avatar", "Username tidak ditemukan: " .. input, 2)
            return false
        end
        SelectedFakeAva = userId
        W2.FakeAvatar_ID = userId
        ApplyFakeAvatar()
        W.ForceNotify("Fake Avatar", "Applied: @" .. input, 2)
        return true
    end

    LP.CharacterAdded:Connect(function()
        if FakeAvatarEnabled then task.wait(1); ApplyFakeAvatar() end
    end)
end

-- KORLESS
do
    local Conn = nil
    local function morph()
        local plr = LP
        task.spawn(function()
            repeat task.wait() until plr.Character
                and plr.Character:FindFirstChild("HumanoidRootPart")
                and plr.Character:FindFirstChild("Right Leg")
            task.wait(0.1)
            local c = plr.Character
            pcall(function()
                c.Head.Transparency = 1
                local f = c.Head:FindFirstChild("face")
                if f then f:Destroy() end
                c["Right Leg"].Transparency = 1
                local old = c:FindFirstChild("KorlessHead")
                if old then old:Destroy() end
                local mesh = Instance.new("MeshPart")
                mesh.Name = "KorlessHead"
                mesh.Size = Vector3.new(1.5, 1.5, 1.5)
                mesh.CanCollide = false
                mesh.MeshId = "rbxassetid://902942096"
                mesh.TextureID = "rbxassetid://902843398"
                mesh.CFrame = c["Right Leg"].CFrame * CFrame.new(0, 0.5, 0)
                mesh.Parent = c
                local w = Instance.new("WeldConstraint")
                w.Part0 = c["Right Leg"]
                w.Part1 = mesh
                w.Parent = mesh
            end)
        end)
    end
    local function remove()
        local c = LP.Character
        if c then
            local m = c:FindFirstChild("KorlessHead")
            if m then m:Destroy() end
            if c:FindFirstChild("Head") then c.Head.Transparency = 0 end
            if c:FindFirstChild("Right Leg") then c["Right Leg"].Transparency = 0 end
        end
        if Conn then Conn:Disconnect(); Conn = nil end
    end
    function W.Korless_Set(v)
        W2.Korless_Enabled = v and true or false
        if v then
            morph()
            if Conn then Conn:Disconnect() end
            Conn = LP.CharacterAdded:Connect(function() task.wait(1); morph() end)
        else remove() end
    end
end

-- HEADER
do
    local HS = { Billboard = nil, Txt = nil }
    local BW = isMobile and 90 or 140
    local BH = isMobile and 20 or 32
    local function create()
        if HS.Billboard then HS.Billboard:Destroy() end
        local c = LP.Character or LP.CharacterAdded:Wait()
        if not c:FindFirstChild("Head") then return end
        local bb = Instance.new("BillboardGui")
        bb.Name = "W2HeaderBillboard"
        bb.Adornee = c.Head
        bb.Size = UDim2.new(0, BW, 0, BH)
        bb.StudsOffset = Vector3.new(0, 1.5, 0)
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0
        bb.Parent = c
        HS.Billboard = bb
        local t = Instance.new("TextLabel", bb)
        t.Name = "BaseText"
        t.Size = UDim2.new(1, 0, 1, 0)
        t.BackgroundTransparency = 1
        t.TextScaled = true
        t.Font = Enum.Font.GothamBold
        t.TextStrokeTransparency = 0.5
        t.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        t.TextColor3 = W2.Header_Color
        t.Text = W2.Header_Text
        HS.Txt = t
    end
    local function updateText(txt)
        W2.Header_Text = txt or "W2"
        if HS.Txt then HS.Txt.Text = W2.Header_Text end
    end
    local function toggle(v)
        if v then create()
        else
            if HS.Billboard then HS.Billboard:Destroy() end
            HS.Billboard = nil; HS.Txt = nil
        end
    end
    function W.Header_Set(v) W2.Header_Enabled = v; toggle(v) end
    function W.Header_SetText(t) updateText(t) end
    function W.Header_SetColor(c)
        W2.Header_Color = c
        if HS.Txt then HS.Txt.TextColor3 = c end
    end
    LP.CharacterAdded:Connect(function()
        task.wait(1)
        if W2.Header_Enabled then toggle(true) end
    end)
end

-- INSTANT ESCAPE
W.Escape = W.Escape or { Enabled = false, Name = "fininshline", Count = 0 }
function W.Escape_TP()
    local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not r then W.ForceNotify("Escape", "Character not found", 2); return false end
    local found = nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if string.lower(obj.Name) == string.lower(W.Escape.Name) and obj:IsA("BasePart") then
            found = obj; break
        end
    end
    if not found then W.ForceNotify("Escape", "Finish line not found", 2); return false end
    pcall(function() r.CFrame = found.CFrame + Vector3.new(0, 5, 0) end)
    W.Escape.Count = W.Escape.Count + 1
    W.W2_Notify("Instant Escape", "Teleported! (#" .. W.Escape.Count .. ")", 2)
    return true
end

--====================================================--
-- END OF PART 16B
--====================================================--    --====================================================--
    -- PART 16C FINAL: UI SECTIONS + CONFIG + CLOSING
    --====================================================--

    -- === UI SECTION: MISC ===
    do
        local s = W.T_Misc:AddSection("Stun Indicator")
        s:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
            W.SInd_Set(v)
            W.W2_Notify("Stun Indicator", v and "Enabled" or "Disabled", 2)
        end })
        s:AddDropdown({ Title = "Stun Sound",
            Options = { "Default","Clash Royale","Blash","Coin","Kururin Kuru","Spongebob","Fahhhh","Cave","Aughhh","Samsung","iPhone","Siren" },
            Default = "Default", Callback = function(v)
                local val = type(v) == "table" and v[1] or v
                if W.StunInd then W.StunInd.SelectedSound = val end
            end })
        s:AddToggle({ Title = "Sound Alert", Default = true, Callback = function(v)
            if W.StunInd then W.StunInd.SoundEnabled = v end
        end })
        s:AddButton({ Title = "Preview Sound", Callback = function()
            pcall(function()
                local sid = "18843924331"
                if W.SInd_GetSoundId then sid = W.SInd_GetSoundId() end
                local snd = Instance.new("Sound")
                snd.SoundId = "rbxassetid://" .. tostring(sid)
                snd.Volume = (W.StunInd and W.StunInd.Volume) or 1.5
                snd.Parent = LP:FindFirstChildOfClass("PlayerGui") or Workspace
                snd:Play()
                snd.Ended:Connect(function() pcall(function() snd:Destroy() end) end)
            end)
        end })
        s:AddSlider({ Title = "Detect Range", Min = 50, Max = 2000, Default = 500, Increment = 25, Suffix = " studs",
            Callback = function(v) if W.StunInd then W.StunInd.Range = v end end })
        s:AddSlider({ Title = "Volume", Min = 0, Max = 5, Default = 1.5, Increment = 0.1,
            Callback = function(v) if W.StunInd then W.StunInd.Volume = v end end })

        local s2 = W.T_Misc:AddSection("Invisibility")
        s2:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
            W.Invisible_SetState(v, false)
        end })
        s2:AddKeybind({ Title = "Hotkey", Default = Enum.KeyCode.G, Callback = function(kc)
            if kc then W2.Invis_Hotkey = kc.Name end
        end })

        local s3 = W.T_Misc:AddSection("Player Utility")
        s3:AddToggle({ Title = "Speed Hack", Default = false, Callback = function(v)
            W2.PU_SpeedEnabled = v
            if not v then
                local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if h then h.WalkSpeed = 16 end
            end
        end })
        s3:AddSlider({ Title = "Speed Value", Min = 16, Max = 200, Default = 16, Increment = 1,
            Callback = function(v) W2.PU_SpeedValue = v end })
        s3:AddToggle({ Title = "Shift Lock", Default = false, Callback = function(v) W2.PU_ShiftLock = v end })
        s3:AddToggle({ Title = "Unlimited Zoom", Default = false, Callback = function(v) W2.PU_UnlimitedZoom = v end })
        s3:AddToggle({ Title = "Noclip", Default = false, Callback = function(v) W2.PU_Noclip = v end })

        local s4 = W.T_Misc:AddSection("Speed Boost")
        s4:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
            W.SpeedBoost_Set(v)
            W.W2_Notify("Speed Boost", v and "Enabled" or "Disabled", 2)
        end })
        s4:AddSlider({ Title = "Speed Value", Min = 16, Max = 100, Default = 30, Increment = 1,
            Callback = function(v) W2.SpeedBoost_Value = v end })

        local s5 = W.T_Misc:AddSection("Cursor Feature")
        s5:AddToggle({ Title = "Enable Cursor Unlock", Default = false, Callback = function(v)
            W.Cursor_Set(v)
        end })
        s5:AddButton({ Title = "Toggle Now", Callback = function()
            W.Cursor_Set(not W2.Cursor_Enabled)
        end })

        local s6 = W.T_Misc:AddSection("Spectator Counter")
        s6:AddToggle({ Title = "Enable", Default = false, Callback = function(v) W.Spectator_Set(v) end })

        local s7 = W.T_Misc:AddSection("Jerk Off")
        s7:AddToggle({ Title = "Enable Jerk Off Tool", Default = false, Callback = function(v)
            W.JerkOff_SetEnabled(v)
        end })

        local s8 = W.T_Misc:AddSection("Player Utility — Extra")
        s8:AddToggle({ Title = "Skip End Screen", Default = false, Callback = function(v)
            W.SkipEnd_Set(v)
        end })
        s8:AddToggle({ Title = "Hide Name", Default = false, Callback = function(v)
            W.HideName_Set(v)
        end })
        s8:AddToggle({ Title = "Hide Survivor Icon", Default = false, Callback = function(v)
            W.HideIcon_Set(v)
        end })

        local s9 = W.T_Misc:AddSection("Floating Buttons")
        s9:AddToggle({ Title = "Self Heal Button", Default = false, Callback = function(v)
            if getgenv().W2_SHB_SetEnabled then getgenv().W2_SHB_SetEnabled(v) end
        end })
        s9:AddToggle({ Title = "Self Unhook Button", Default = false, Callback = function(v)
            if getgenv().W2_SUB_SetEnabled then getgenv().W2_SUB_SetEnabled(v) end
        end })
        s9:AddToggle({ Title = "Escape Button", Default = false, Callback = function(v)
            if getgenv().W2_Escape_SetEnabled then getgenv().W2_Escape_SetEnabled(v) end
        end })
        s9:AddToggle({ Title = "Invisible Button", Default = false, Callback = function(v)
            if getgenv().W2_InvisBtn_SetEnabled then getgenv().W2_InvisBtn_SetEnabled(v) end
        end })
        s9:AddToggle({ Title = "Moonwalk Button", Default = false, Callback = function(v)
            if getgenv().W2_MoonwalkBtn_SetEnabled then getgenv().W2_MoonwalkBtn_SetEnabled(v) end
        end })
        s9:AddToggle({ Title = "Spear Aimbot Button", Default = false, Callback = function(v)
            if getgenv().W2_SpearBtn_SetEnabled then getgenv().W2_SpearBtn_SetEnabled(v) end
        end })
        s9:AddToggle({ Title = "Troll TP Button", Default = false, Callback = function(v)
            if getgenv().W2_TTB_SetEnabled then getgenv().W2_TTB_SetEnabled(v) end
        end })
        s9:AddToggle({ Title = "Parry Button", Default = false, Callback = function(v)
            if getgenv().W2_ParryBtn_SetEnabled then getgenv().W2_ParryBtn_SetEnabled(v) end
        end })
        s9:AddToggle({ Title = "Myers Grab Button", Default = false, Callback = function(v)
            if getgenv().W2_MGrabBtn_SetEnabled then getgenv().W2_MGrabBtn_SetEnabled(v) end
        end })
        s9:AddToggle({ Title = "Pistol TOF Button", Default = false, Callback = function(v)
            if getgenv().W2_PistolBtn_SetEnabled then getgenv().W2_PistolBtn_SetEnabled(v) end
        end })
        s9:AddButton({ Title = "Show All Buttons", Callback = function()
            for _, fn in ipairs({
                "W2_SHB_SetEnabled", "W2_SUB_SetEnabled", "W2_Escape_SetEnabled",
                "W2_InvisBtn_SetEnabled", "W2_MoonwalkBtn_SetEnabled", "W2_SpearBtn_SetEnabled",
                "W2_TTB_SetEnabled", "W2_ParryBtn_SetEnabled", "W2_MGrabBtn_SetEnabled",
                "W2_PistolBtn_SetEnabled"
            }) do
                if getgenv()[fn] then pcall(getgenv()[fn], true) end
            end
            W.W2_Notify("Buttons", "All 10 buttons ON", 3)
        end })
        s9:AddButton({ Title = "Hide All Buttons", Callback = function()
            for _, fn in ipairs({
                "W2_SHB_SetEnabled", "W2_SUB_SetEnabled", "W2_Escape_SetEnabled",
                "W2_InvisBtn_SetEnabled", "W2_MoonwalkBtn_SetEnabled", "W2_SpearBtn_SetEnabled",
                "W2_TTB_SetEnabled", "W2_ParryBtn_SetEnabled", "W2_MGrabBtn_SetEnabled",
                "W2_PistolBtn_SetEnabled"
            }) do
                if getgenv()[fn] then pcall(getgenv()[fn], false) end
            end
            W.W2_Notify("Buttons", "All buttons OFF", 3)
        end })
    end

    -- === UI SECTION: TROLL ===
    do
        local t1 = W.T_Troll:AddSection("Emote")
        t1:AddToggle({ Title = "Enable", Default = false, Callback = function(v) W.Emote_Set(v) end })
        t1:AddDropdown({ Title = "Select Emote",
            Options = (W.Emote and W.Emote.Options) or {},
            Default = "Friday Night", Multi = false,
            Callback = function(v)
                local val = type(v) == "table" and v[1] or v
                W.Emote_Select(val or "Friday Night")
            end })
        t1:AddButton({ Title = "Stop Emote", Callback = function()
            W.Emote_Stop()
            if W.Emote then W.Emote.Enabled = false end
        end })

        local t2 = W.T_Troll:AddSection("Bombax")
        t2:AddToggle({ Title = "Enable Bombax", Default = false, Callback = function(v) W.Bombax_Set(v) end })
        t2:AddDropdown({ Title = "Select Song",
            Options = W.Bombax_GetList and W.Bombax_GetList() or {},
            Default = "One", Multi = false,
            Callback = function(v)
                local val = type(v) == "table" and v[1] or v
                if W.Bombax then W.Bombax.Selected = val end
                W2.Bombax_Selected = val
                if W.Bombax and W.Bombax.Enabled then W.Bombax_Play(val) end
            end })
        t2:AddSlider({ Title = "Volume", Min = 0, Max = 10, Default = 2, Increment = 0.5,
            Callback = function(v) W.Bombax_SetVol(v) end })
        t2:AddToggle({ Title = "Looped", Default = true, Callback = function(v) W.Bombax_SetLoop(v) end })
        t2:AddButton({ Title = "▶ Play", Callback = function()
            W.Bombax_Play(W.Bombax and W.Bombax.Selected or "One")
        end })
        t2:AddButton({ Title = "⏸ Stop", Callback = function() W.Bombax_Stop() end })
        t2:AddButton({ Title = "⏭ Next", Callback = function() W.Bombax_Next() end })
        t2:AddButton({ Title = "⏮ Prev", Callback = function() W.Bombax_Prev() end })
        t2:AddToggle({ Title = "Show Bombax Button", Content = "Tombol kecil + window toggle",
            Default = false, Callback = function(v)
                if W.BombaxUI_Set then W.BombaxUI_Set(v) end
            end })
        t2:AddButton({ Title = "Toggle Bombax Window", Content = "Buka/tutup window",
            Callback = function()
                if W.BombaxUI_Toggle then W.BombaxUI_Toggle() end
            end })

        local t3 = W.T_Troll:AddSection("Fake Avatar")
        t3:AddDropdown({ Title = "Preset",
            Options = { "Self Avatar","Random 1","Random 2","Random 3","Random 4","Random 5","Random 6","Random 7",
                "WoozyNate","Nicholas","yvlyf","traevp","J0LLY","LucashDev","CEOofIsaac","Stealthy","Wildes","Talon",
                "Relukt","Sammy","Diesel","S4ans03","Aura","iJava","White Guy","Purple King","Kachaaaa Gay","Mpruyyy" },
            Default = "Self Avatar", Callback = function(opt)
                local ids = {
                    ["Self Avatar"] = LP.UserId, ["Random 1"] = 2888298851, ["Random 2"] = 10074747755,
                    ["Random 3"] = 5209567453, ["Random 4"] = 8991982843, ["Random 5"] = 5796319029,
                    ["Random 6"] = 9744452117, ["Random 7"] = 8476755006, ["WoozyNate"] = 146089324,
                    ["Nicholas"] = 909635, ["yvlyf"] = 181751703, ["traevp"] = 471607078, ["J0LLY"] = 1073847038,
                    ["LucashDev"] = 2525651744, ["CEOofIsaac"] = 63238912, ["Stealthy"] = 56602747,
                    ["Wildes"] = 40397833, ["Talon"] = 75974130, ["Relukt"] = 65042011, ["Sammy"] = 2678001507,
                    ["Diesel"] = 9123921576, ["S4ans03"] = 35439794, ["Aura"] = 2275806428, ["iJava"] = 276557820,
                    ["White Guy"] = 8843268357, ["Purple King"] = 9070758608,
                    ["Kachaaaa Gay"] = 8956318334, ["Mpruyyy"] = 8340163775
                }
                W.FakeAvatar_SetId(ids[opt] or LP.UserId)
            end })
        t3:AddToggle({ Title = "Enable Fake Avatar", Default = false, Callback = function(v) W.FakeAvatar_Set(v) end })
        local UN = ""
        t3:AddInput({ Title = "Fake Avatar Username", Placeholder = "username",
            Callback = function(inp) UN = (inp or ""):gsub("^@", "") end })
        t3:AddButton({ Title = "Apply From Username", Callback = function()
            if UN == "" then W.ForceNotify("Fake Avatar", "Masukkan username dulu!", 2); return end
            W.FakeAvatar_FromUsername(UN)
        end })

        local t4 = W.T_Troll:AddSection("Fake Korless")
        t4:AddToggle({ Title = "Korless Morph", Default = false, Callback = function(v) W.Korless_Set(v) end })

        local t5 = W.T_Troll:AddSection("Header Title")
        t5:AddInput({ Title = "Header Text", Default = "W2", Placeholder = "Nama header...",
            Callback = function(inp) W.Header_SetText(inp) end })
        t5:AddToggle({ Title = "Enable Header", Default = false, Callback = function(v) W.Header_Set(v) end })
        t5:AddColorPicker({ Title = "Header Color", Default = Color3.fromRGB(255, 255, 255), Save = false,
            Callback = function(c) W.Header_SetColor(c) end })

        local t6 = W.T_Troll:AddSection("Escape")
        t6:AddToggle({ Title = "Enable", Default = false, Callback = function(v)
            W2.Escape_Enabled = v
        end })
        t6:AddButton({ Title = "Teleport Now", Callback = function() W.Escape_TP() end })
    end

    -- === UI SECTION: CONFIG ===
    do
        local cfgName = ""
        local selCfg = nil
        local cfgList = nil
        local function folderPath() return "W2/Config" end
        local function ensureFolder()
            if isfolder and makefolder then
                if not isfolder("W2") then makefolder("W2") end
                if not isfolder(folderPath()) then makefolder(folderPath()) end
            end
        end
        ensureFolder()

        local function refreshList()
            local l = {}
            if listfiles then
                ensureFolder()
                local ok, files = pcall(listfiles, folderPath())
                if ok and files then
                    for _, f in ipairs(files) do
                        local n = string.match(f, "([^/\\]+)%.json$")
                        if n then table.insert(l, n) end
                    end
                end
            end
            if cfgList and cfgList.SetValues then cfgList:SetValues(l, selCfg, true) end
        end

        local function GetSnapshot()
            local snap = {}
            for k, v in pairs(W2) do
                local t = type(v)
                if t ~= "function" and t ~= "userdata" and t ~= "thread" then
                    if t == "table" then
                        local ok = pcall(function() return HttpService:JSONEncode(v) end)
                        if ok then snap[k] = v end
                    else
                        snap[k] = v
                    end
                end
            end
            return snap
        end

        local s = W.T_Cfg:AddSection("Config Manager")
        s:AddInput({ Title = "Config Name", Placeholder = "MyConfig", Save = false,
            Callback = function(t) cfgName = t end })
        cfgList = s:AddDropdown({ Title = "Saved Configs", Multi = false, Options = {}, Save = false,
            Callback = function(v) selCfg = v end })
        refreshList()

        s:AddButton({ Title = "Save", SubTitle = "Load",
            Callback = function()
                if cfgName == nil or cfgName == "" then
                    W.ForceNotify("Config", "Isi nama config dulu!", 2); return
                end
                if not writefile or not HttpService then
                    W.ForceNotify("Config", "Executor gak support", 2); return
                end
                ensureFolder()
                local snapshot = GetSnapshot()
                local okEnc, encoded = pcall(function() return HttpService:JSONEncode(snapshot) end)
                if not okEnc or not encoded then
                    W.ForceNotify("Config", "Gagal encode", 2); return
                end
                local okW = pcall(writefile, folderPath() .. "/" .. cfgName .. ".json", encoded)
                if not okW then
                    W.ForceNotify("Config", "Gagal save", 2); return
                end
                W.ForceNotify("Config", "Saved: " .. cfgName, 2)
                refreshList()
            end,
            SubCallback = function()
                if not selCfg or selCfg == "" then
                    W.ForceNotify("Config", "Pilih config dulu!", 2); return
                end
                if not readfile or not isfile then
                    W.ForceNotify("Config", "Executor gak support", 2); return
                end
                local path = folderPath() .. "/" .. selCfg .. ".json"
                if not isfile(path) then
                    W.ForceNotify("Config", "File gak ketemu", 2); return
                end
                local okR, raw = pcall(readfile, path)
                if not okR or not raw then
                    W.ForceNotify("Config", "Gagal baca file", 2); return
                end
                local okD, dec = pcall(function() return HttpService:JSONDecode(raw) end)
                if not okD or type(dec) ~= "table" then
                    W.ForceNotify("Config", "File corrupt", 2); return
                end
                for k, v in pairs(dec) do
                    if k ~= "_version" then W2[k] = v end
                end
                W.ForceNotify("Config", "Loaded: " .. selCfg, 2)
            end
        })

        s:AddButton({ Title = "Delete", SubTitle = "Refresh List",
            Callback = function()
                if not selCfg or selCfg == "" then
                    W.ForceNotify("Config", "Pilih config dulu!", 2); return
                end
                local path = folderPath() .. "/" .. selCfg .. ".json"
                if isfile and delfile and isfile(path) then
                    pcall(delfile, path)
                    W.ForceNotify("Config", "Deleted: " .. selCfg, 2)
                    selCfg = nil; refreshList()
                end
            end,
            SubCallback = function()
                refreshList()
                W.ForceNotify("Config", "List refreshed", 2)
            end
        })

        s:AddToggle({ Title = "Auto Save", Default = false, Save = false,
            Callback = function(v) W2.Config_AutoSave = v end })
        s:AddToggle({ Title = "Auto Load", Default = false, Save = false,
            Callback = function(v) W2.Config_AutoLoad = v end })

        local s2 = W.T_Cfg:AddSection("Config Info")
        s2:AddParagraph({ Title = "Cara Pakai Config",
            Content = "• Save: tulis nama config, klik Save\n• Load: pilih dropdown, klik Load\n• Auto Save: simpan otomatis\n• Auto Load: load config saat start" })
    end

    -- === CLOSING ===
    print("[W2] Loaded OK")
    print("  Tab: Survivor / Visuals / Killer / Misc / Troll / Config")
    print("  Buttons: 10 floating buttons + Bombax Toggle + FPS Counter")
    print("  Free Script - Jangan Dijual!")

    W.W2_Notify("W2", "Script Loaded!", 6)

end  -- PENUTUP __W2_Init__()

-- === EXECUTE (1 X SAJA) ===
__W2_Init__()
