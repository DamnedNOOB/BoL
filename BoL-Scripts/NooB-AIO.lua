local version = 0.008
local scriptName = "NooB-AIO"
local autoUpdate   = true
local silentUpdate = false

HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION")))
id = 221-- DO NOT CHANGE. This is set to your proper ID.

-- Changelog:

-- v.0.003: (Vi) added Q-Flash-Q 
-- v.0.004: (Vi) wont waste Flash anymore if target gets in range
--          ímproved AAreset with E
--          fixed menu

-- v.0.005  (Riven) added Basic Script
-- v.0.006  (Vi) fixed AAreset (Error spamming)
-- v.0.008  (Riven) Combo-, Gapclose-, farming- improvements...
--[[ 

 ____  _____   ___      ___   ______             _       _____   ___    
|_   \|_   _|.'   `.  .'   `.|_   _ \           / \     |_   _|.'   `.  
  |   \ | | /  .-.  \/  .-.  \ | |_) | ______  / _ \      | | /  .-.  \ 
  | |\ \| | | |   | || |   | | |  __'.|______|/ ___ \     | | | |   | | 
 _| |_\   |_\  `-'  /\  `-'  /_| |__) |     _/ /   \ \_  _| |_\  `-'  / 
|_____|\____|`.___.'  `.___.'|_______/     |____| |____||_____|`.___.'  
                                                                        
                                                                           (soon(TM)-AIO) by DamnedNOOB

]]--                                                              

 
local champions = {
    ["Vi"]           = true,
    ["Riven"]        = true,
}

if not champions[player.charName] then autoUpdate = nil silentUpdate = nil version = nil scriptName = nil champions = nil collectgarbage() return end

--[[ Updater and library downloader ]]

local sourceLibFound = true
if FileExist(LIB_PATH .. "SourceLib.lua") then
    require "SourceLib"
else
    sourceLibFound = false
    DownloadFile("https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua", LIB_PATH .. "SourceLib.lua", function() print("<font color=\"#6699ff\"><b>" .. scriptName .. ":</b></font> <font color=\"#FFFFFF\">SourceLib downloaded! Please reload!</font>") end)
end

if not sourceLibFound then return end

if autoUpdate then
    SourceUpdater(scriptName, version, "raw.github.com", "/DamnedNOOB/BoL/master/BoL-Scripts/" .. scriptName .. ".lua", SCRIPT_PATH .. GetCurrentEnv().FILE_NAME, "/DamnedNOOB/BoL/master/version/" .. scriptName .. ".version"):SetSilent(silentUpdate):CheckUpdate()
end

local libDownloader = Require(scriptName)
libDownloader:Add("Prodiction",  "https://bitbucket.org/Klokje/public-klokjes-bol-scripts/raw/master/Test/Prodiction/Prodiction.lua")
libDownloader:Add("VPrediction", "https://raw.github.com/Hellsing/BoL/master/common/VPrediction.lua")
libDownloader:Add("SOW",         "https://raw.github.com/Hellsing/BoL/master/common/SOW.lua")
libDownloader:Check()

if libDownloader.downloadNeeded then return end

--[[ Class initializing ]]

for k, _ in pairs(champions) do
    local className = k:gsub("%s+", "")
    class(className)
    champions[k] = _G[className]
end

--[[ Champ variables ]]--
local AAtarget = nil


-- Vi:
local QCasted = nil
local FQRange = nil

--Riven:
local AnimationCancel = {}
local RivenBuffs = {
        Passive = {stacks = 0},
        Q = {stage  = 0}
    }
local R_ON = false
local R_ON_FLAG = false
local Target = nil
local _Q3 = _PASIVE+1
local _RQ = _PASIVE+2
local _RQ3 = _PASIVE+3
local _RW = _PASIVE+4


--[[ Script Variables ]]--

local champ = champions[player.charName]
local menu  = nil
local VP    = nil
local OW    = nil
local STS   = nil
local DM    = nil
local DLib  = nil

local spellData = {}

local spells   = {}
local circles  = {}
local AAcircle = nil

local champLoaded = false
local skip        = false

local skinNumber = nil

local __colors = {
    { current = 255, step = 1, min = 0, max = 255, mode = -1 },
    { current = 255, step = 2, min = 0, max = 255, mode = -1 },
    { current = 255, step = 3, min = 0, max = 255, mode = -1 },
}

local ToInterrupt = {}
local InterruptList = {
    { charName = "Caitlyn", spellName = "CaitlynAceintheHole"},
    { charName = "FiddleSticks", spellName = "Crowstorm"},
    { charName = "FiddleSticks", spellName = "DrainChannel"},
    { charName = "Galio", spellName = "GalioIdolOfDurand"},
    { charName = "Karthus", spellName = "FallenOne"},
    { charName = "Katarina", spellName = "KatarinaR"},
    { charName = "Lucian", spellName = "LucianR"},
    { charName = "Malzahar", spellName = "AlZaharNetherGrasp"},
    { charName = "MissFortune", spellName = "MissFortuneBulletTime"},
    { charName = "Nunu", spellName = "AbsoluteZero"},
    { charName = "Pantheon", spellName = "Pantheon_GrandSkyfall_Jump"},
    { charName = "Shen", spellName = "ShenStandUnited"},
    { charName = "Urgot", spellName = "UrgotSwap2"},
    { charName = "Varus", spellName = "VarusQ"},
    { charName = "Warwick", spellName = "InfiniteDuress"}
}

local ToInterrupt2 = {}
local InterruptList2 = {
    { charName = "Caitlyn", spellName = "CaitlynAceintheHole"},
    { charName = "FiddleSticks", spellName = "Crowstorm"},
    { charName = "Galio", spellName = "GalioIdolOfDurand"},
    { charName = "Karthus", spellName = "FallenOne"},
    { charName = "Katarina", spellName = "KatarinaR"},
    { charName = "Lucian", spellName = "LucianR"},
    { charName = "Malzahar", spellName = "AlZaharNetherGrasp"},
    { charName = "MissFortune", spellName = "MissFortuneBulletTime"},
    { charName = "Nunu", spellName = "AbsoluteZero"},
    { charName = "Pantheon", spellName = "Pantheon_GrandSkyfall_Jump"},
    { charName = "Urgot", spellName = "UrgotSwap2"},
    { charName = "Warwick", spellName = "InfiniteDuress"}
}

--[[ General Callbacks ]]--

function OnLoad()

    -- Load dependencies
    VP   = VPrediction()
    OW   = SOW(VP)
    STS  = SimpleTS()
    DM   = DrawManager()
    DLib = DamageLib()


    -- Load champion
    champ = champ()

    -- Prevent errors
    if not champ then print("There was an error while loading " .. player.charName .. ", please report the shown error to DamnedNOOB, thanks!") return else champLoaded = true end

    -- Auto attack range circle
    AAcircle = DM:CreateCircle(player, OW:MyRange(), 3)

    -- Load menu
    loadMenu()

    --if true then champLoaded = false return end

    -- Regular callbacks registering
    if champ.OnUnload       then AddUnloadCallback(function()                     champ:OnUnload()                  end) end
    if champ.OnExit         then AddExitCallback(function()                       champ:OnExit()                    end) end
    if champ.OnDraw         then AddDrawCallback(function()                       champ:OnDraw()                    end) end
    if champ.OnReset        then AddResetCallback(function()                      champ:OnReset()                   end) end
    if champ.OnSendChat     then AddChatCallback(function(text)                   champ:OnSendChat(text)            end) end
    if champ.OnRecvChat     then AddRecvChatCallback(function(text)               champ:OnRecvChat(text)            end) end
    if champ.OnWndMsg       then AddMsgCallback(function(msg, wParam)             champ:OnWndMsg(msg, wParam)       end) end
    --if champ.OnCreateObj    then AddCreateObjCallback(function(obj)               champ:OnCreateObj(object)         end) end
    if champ.OnDeleteObj    then AddDeleteObjCallback(function(obj)               champ:OnDeleteObj(object)         end) end
    if champ.OnProcessSpell then AddProcessSpellCallback(function(unit, spell)    champ:OnProcessSpell(unit, spell) end) end
    if champ.OnSendPacket   then AddSendPacketCallback(function(p)                champ:OnSendPacket(p)             end) end
    if champ.OnRecvPacket   then AddRecvPacketCallback(function(p)                champ:OnRecvPacket(p)             end) end
    if champ.OnBugsplat     then AddBugsplatCallback(function()                   champ:OnBugsplat()                end) end
    if champ.OnAnimation    then AddAnimationCallback(function(object, animation) champ:OnAnimation()               end) end
    if champ.OnNotifyEvent  then AddNotifyEventCallback(function(event, unit)     champ:OnNotify(event, unit)       end) end
    if champ.OnParticle     then AddParticleCallback(function(unit, particle)     champ:OnParticle(unit, particle)  end) end

    -- Advanced callbacks registering
    if champ.OnGainBuff     then AdvancedCallback:bind('OnGainBuff',   function(unit, buff) champ:OnGainBuff(unit, buff)   end) end
    if champ.OnUpdateBuff   then AdvancedCallback:bind('OnUpdateBuff', function(unit, buff) champ:OnUpdateBuff(unit, buff) end) end
    if champ.OnLoseBuff     then AdvancedCallback:bind('OnLoseBuff',   function(unit, buff) champ:OnLoseBuff(unit, buff)   end) end

end

function OnTick()

    -- Prevent error spamming
    if not champLoaded then return end

    if champ.OnTick then
        champ:OnTick()
    end

    -- Skip combo once
    if skip then
        skip = false
        return
    end

    if champ.OnCombo and menu.combo and menu.combo.active then
        champ:OnCombo()
    elseif champ.OnHarass and menu.harass and menu.harass.active then
        champ:OnHarass()
    end

end

function OnDraw()

    -- Prevent error spamming
    if not champLoaded then return end

    __mixColors()
    AAcircle.color[2] = __colors[1].current
    AAcircle.color[3] = __colors[2].current
    AAcircle.color[4] = __colors[3].current
    AAcircle.range    = OW:MyRange() 
   
    -- Skin changer
    if menu.skin then
        for i = 1, skinNumber do
            if menu.skin["skin"..i] then
                menu.skin["skin"..i] = false
                GenModelPacket(player.charName, i - 1)
            end
        end
    end
    
end

-- Spudgy please...
function OnCreateObj(object) if champLoaded and champ.OnCreateObj then champ:OnCreateObj(object) end end


--[[ Other Functions ]]--

function loadMenu()
    menu = MenuWrapper("[" .. scriptName .. "] " .. player.charName, "unique" .. player.charName:gsub("%s+", ""))
    
    -- Skin changer
    if champ.GetSkins then
        menu:GetHandle():addSubMenu("Skin Changer", "skin")
        for i, name in ipairs(champ:GetSkins()) do
            menu:GetHandle().skin:addParam("skin"..i, name, SCRIPT_PARAM_ONOFF, false)
        end
        skinNumber = #champ:GetSkins()
    end
    
    menu:SetTargetSelector(STS)
    menu:SetOrbwalker(OW)

    -- Apply menu as normal script config
    menu = menu:GetHandle()

    -- Prediction
    --menu:addSubMenu("Prediction", "prediction")
    --    menu.prediction:addParam("predictionType", "Prediction Type", SCRIPT_PARAM_LIST, 1, { "VPrediction", "Prodiction" })
    --    _G.srcLib.spellMenu =  menu.prediction

    -- Combo
    if champ.OnCombo then
    menu:addSubMenu("Combo", "combo")
        menu.combo:addParam("active", "Combo active", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    end

    -- Harass
    if champ.OnHarass then
    menu:addSubMenu("Harass", "harass")
        menu.harass:addParam("active", "Harass active", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
    end

    -- Apply champ menu values
    if champ.ApplyMenu then champ:ApplyMenu() end
end

function initializeSpells()
    -- Create spells and circles
    for id, data in pairs(spellData) do
        -- Range
        local range = type(data.range) == "number" and data.range or data.range[1]
        -- Spell
        local spell = Spell(id, range)
        if data.skillshotType then
            spell:SetSkillshot(VP, data.skillshotType, data.width, data.delay, data.speed, data.collision)
        end
        table.insert(spells, id, spell)
        -- Circle
        local circle = DM:CreateCircle(player, range):LinkWithSpell(spell)
        circle:SetDrawCondition(function() return spell:GetLevel() > 0 end)
        table.insert(circles, id, circle)
    end
end

function getBestTarget(range, condition)
    condition = condition or function() return true end
    local target = STS:GetTarget(range)
    if not target or not condition(target) then
        target = nil
        for _, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy, range) and condition(enemy) then
                if not target or enemy.health < target.health then
                    target = enemy
                end
            end
        end
    end
    return target
end

function skipCombo()
    skip = true
end

function __mixColors()
    for i = 1, #__colors do
        local color = __colors[i]
        color.current = color.current + color.mode * color.step
        if color.current < color.min then
            color.current = color.min
            color.mode = 1
        elseif color.current > color.max then
            color.current = color.max
            color.mode = -1
        end
    end
end

-- Credits to shalzuth for this!
function GenModelPacket(champ, skinId)
    p = CLoLPacket(0x97)
    p:EncodeF(player.networkID)
    p.pos = 1
    t1 = p:Decode1()
    t2 = p:Decode1()
    t3 = p:Decode1()
    t4 = p:Decode1()
    p:Encode1(t1)
    p:Encode1(t2)
    p:Encode1(t3)
    p:Encode1(bit32.band(t4,0xB))
    p:Encode1(1)--hardcode 1 bitfield
    p:Encode4(skinId)
    for i = 1, #champ do
        p:Encode1(string.byte(champ:sub(i,i)))
    end
    for i = #champ + 1, 64 do
        p:Encode1(0)
    end
    p:Hide()
    RecvPacket(p)
end

function GetPredictedPos(unit, delay, speed, source)
    if menu.prediction.predictionType == 1 then
        return VP:GetPredictedPos(unit, delay, speed, source)
    elseif menu.prediction.predictionType == 2 then
        return Prodiction.GetPrediction(unit, math.huge, speed, delay, 1, source)
    end
end

function CountAllyHeroInRange(range, point)
    local n = 0
    for i, ally in ipairs(GetAllyHeroes()) do
        if ValidTarget(ally, math.huge, false) and GetDistanceSqr(point, ally) <= range * range then
            n = n + 1
        end
    end
    return n
end

function GetDistanceToClosestAlly(p)
    local d = GetDistance(p, myHero)
    for i, ally in ipairs(GetAllyHeroes()) do
        if ValidTarget(ally, math.huge, false) then
            local dist = GetDistance(p, ally)
            if dist < d then
                d = dist
            end
        end
    end
    return d
end  

function checkitems()   
    
    Hydra = GetInventorySlotItem(3074)
    RuinedKing = GetInventorySlotItem(3153)
    Omen = GetInventorySlotItem(3143)
    Tiamat = GetInventorySlotItem(3077)
    BilgeWaterCutlass = GetInventorySlotItem(3144)
    Youmuu = GetInventorySlotItem(3142)
    HydraR = (Hydra ~= nil and myHero:CanUseSpell(Hydra))
    RuinedKingR = (RuinedKing ~= nil and myHero:CanUseSpell(RuinedKing))
    OmenR = (Omen ~= nil and myHero:CanUseSpell(Omen))
    TiamatR = (Tiamat ~= nil and myHero:CanUseSpell(Tiamat))
    BilgeWaterCutlassR = (BilgeWaterCutlass ~= nil and myHero:CanUseSpell(BilgeWaterCutlass))
    YoumuuR = (Youmuu ~= nil and myHero:CanUseSpell(Youmuu))
    SwordofDivine = GetInventorySlotItem(3131)
    SwordofDivineR = (SwordofDivine ~= nil and myHero:CanUseSpell(SwordofDivine)) 

end


    
--                                                    /\ \    _ / /\      /\ \       /\ \     _    /\ \         /\ \         / /\      
--                                                    \ \ \  /_/ / /      \ \ \     /  \ \   /\_\ /  \ \       /  \ \       / /  \     
--                                                     \ \ \ \___\/       /\ \_\   / /\ \ \_/ / // /\ \ \     / /\ \ \     / / /\ \    
--                                                     / / /  \ \ \      / /\/_/  / / /\ \___/ // / /\ \ \   / / /\ \ \   / / /\ \ \   
--                                                     \ \ \   \_\ \    / / /    / / /  \/____// / /  \ \_\ / / /  \ \_\ / / /\ \_\ \  
--                                                      \ \ \  / / /   / / /    / / /    / / // / /   / / // / /   / / // / /\ \ \___\ 
--                                                       \ \ \/ / /   / / /    / / /    / / // / /   / / // / /   / / // / /  \ \ \__/ 
--                                                        \ \ \/ /___/ / /__  / / /    / / // / /___/ / // / /___/ / // / /____\_\ \   
--                                                         \ \  //\__\/_/___\/ / /    / / // / /____\/ // / /____\/ // / /__________\  
--                                                          \_\/ \/_________/\/_/     \/_/ \/_________/ \/_________/ \/_____________/  Vi - Script


function Vi:__init()

    ScriptName = "ViNooB"

    UpdateWeb(true, ScriptName, id, HWID)
    
    FQRange = 1100

    spellData = {
        [_Q] =  { range = 250, rangeMax = 715,  skillshotType = SKILLSHOT_LINEAR,   width = 55,   delay = 0.25,  speed = 1500,      collision = false },
        [_E] =  { range = 250,                  skillshotType = SKILLSHOT_CONE,     width = 300,  delay = 0.25,  speed = math.huge, collision = false },
        [_R] =  { range = 800,                                                      width = 1,    delay = 0.25,  speed = math.huge, collision = false },
    }

    initializeSpells()

    -- Finetune spells
    spells[_Q]:SetCharged("ViQ", 3, spellData[_Q].rangeMax, 1.25, function() return spells[_Q]:GetCooldown(true) > 0 end)
    spells[_Q]:SetAOE(true)
    spells[_E].packetCast = true
    spells[_R].packetCast = true


    -- Circle customization
    circles[_Q].color = { 255, 0x0F, 0x37, 0xFF }
    circles[_Q].width = 2
    circles[_R].color = { 255, 0xFF, 0x25, 0x30 }
    circles[_R].width = 2

    -- Minions
    self.enemyMinions  = minionManager(MINION_ENEMY,  spellData[_Q].rangeMax, player, MINION_SORT_MAXHEALTH_DEC)
    self.jungleMinions = minionManager(MINION_JUNGLE, spellData[_Q].rangeMax, player, MINION_SORT_MAXHEALTH_DEC)

    self.mainCombo = { _IGNITE, _Q, _E, _AA, _R }
    self.standartCombo = { _Q, _E, _AA, _R }
    self.ultKS = { _R }
    self.IGKS = { _IGNITE }

    --Register damage sources
    DLib:RegisterDamageSource(_Q, _PHYSICAL, 50,  25, _PHYSICAL, _AD, 0.19, function() return spells[_Q]:IsReady() end)
    DLib:RegisterDamageSource(_E, _PHYSICAL, 5,  20, _PHYSICAL, _AD, 1.74, function() return spells[_E]:IsReady() end)
    DLib:RegisterDamageSource(_R, _PHYSICAL, 200, 125, _PHYSICAL, _AD, 0.10, function() return spells[_R]:IsReady() end) 

    OW:RegisterAfterAttackCallback(function() self:AfterAttack() end)       

    PacketHandler:HookOutgoingPacket(Packet.headers.S_MOVE, function(p) self:OnSendMove(p) end)

    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        for _, champ in pairs(InterruptList) do
                if hero.charName == champ.charName then
                    table.insert(ToInterrupt, champ.spellName)
                end
        end

        for _, champ in pairs(InterruptList2) do
                if hero.charName == champ.charName then
                    table.insert(ToInterrupt2, champ.spellName)
                end
        end
    end

end

function Vi:OnBugsplat()
    UpdateWeb(false, ScriptName, id, HWID)
end

function Vi:OnUnload()
    UpdateWeb(false, ScriptName, id, HWID)
end


function Vi:GetSkins()
    return {
        "Classic",
        "Neon Strike Vi",
        "Officer Vi",
        "Debonair Vi"
    }
end

function Vi:OnCombo() 

    local targets = {
        [_Q] = STS:GetTarget(spellData[_Q].rangeMax), 
        [_E] = STS:GetTarget(spellData[_E].range),
        [_R] = STS:GetTarget(spellData[_R].range)
    }

    self:CastQ()


    if (menu.combo.active and menu.combo.useR) and not spells[_Q]:IsReady() and spells[_R]:IsReady() then
        for i, enemy in ipairs(GetEnemyHeroes()) do
            if _IGNITE and _GetDistanceSqr(enemy.visionPos, myHero.visionPos) < 600 * 600 and DLib:IsKillable(enemy, self.mainCombo) then
                CastSpell(_IGNITE, enemy)
            end
            if ValidTarget(enemy) and _GetDistanceSqr(enemy.visionPos, myHero.visionPos) < spells[_R].range^2 and DLib:IsKillable(enemy, self.mainCombo) then
                    if not DLib:IsKillable(enemy, self.standartCombo) and DLib:IsKillable(enemy, self.mainCombo) then
                        if not HasBuff(enemy, "UndyingRage") and not HasBuff(enemy, "JudicatorIntervention") then
                            spells[_R]:Cast(enemy)
                        end
                    end 
            end
        end
    end
end


function Vi:OnHarass()

    -- Don't harass when Q not ready
    if not spells[_Q]:IsReady() or not (menu.harass.active and menu.harass.useQ) then return end

    -- Don't harass on not enough mana
    if (player.mana / player.maxMana * 100) < menu.harass.mana then return end

    local target = STS:GetTarget(spellData[_Q].rangeMax)

    if target then
        self:CastQ()
    end

end


function Vi:OnFarm()

    local minionsUpdated = false

    if (player.mana / player.maxMana * 100) < menu.farm.mana then return end

        if menu.farm.useQ and spells[_Q]:IsReady() then

            -- Save performance, update minions within here
            self.enemyMinions:update()
            minionsUpdated = true

            if not spells[_Q]:IsCharging() then
                if #self.enemyMinions.objects > 1 then
                    spells[_Q]:Charge()
                end
            else
                local maxRange = spells[_Q].range == spellData[_Q].rangeMax
                local continue = maxRange
                local minions  = SelectUnits(self.enemyMinions.objects, function(t) return ValidTarget(t) and _GetDistanceSqr(t) < spells[_Q].rangeSqr end)
                if not maxRange then
                    local maxRangeMinions = SelectUnits(self.enemyMinions.objects, function(t) return ValidTarget(t) and _GetDistanceSqr(t) < math.pow(spellData[_Q].rangeMax, 2) end)
                    continue = #maxRangeMinions == #minions
                end
                if continue then
                    minions = GetPredictedPositionsTable(VP, minions, spells[_Q].delay, spells[_Q].width, spells[_Q].range, math.huge, player, false)
                    local castPosition = GetBestLineFarmPosition(spells[_Q].range, spells[_Q].width, minions)
                    if castPosition then
                        spells[_Q]:Cast(castPosition.x, castPosition.z)
                    end
                end
            end
        end

    if menu.farm.useE and spells[_E]:IsReady() then

        -- Update minions
        if not minionsUpdated then self.enemyMinions:update() end

        -- ALl minions
        local minions = SelectUnits(self.enemyMinions.objects, function(t) return ValidTarget(t) and _GetDistanceSqr(t) < spells[_E].rangeSqr end)
        if #minions > 1 then
            minions = GetPredictedPositionsTable(VP, minions, spells[_E].delay, spells[_E].width, spells[_E].range + spells[_E].width, math.huge, player, false)
            local castPosition = GetBestLineFarmPosition(spells[_E].range, spells[_E].width, minions)
            if castPosition then
                CastSpell(_E)
            end
        end
    end

end

function Vi:OnJungleFarm()

    local jungleMinionsUpdated = false

    if (player.mana / player.maxMana * 100) < menu.jfarm.mana then return end
        if menu.jfarm.active then

            self.jungleMinions:update()
            local jungleMinionsUpdated = true

            if #self.jungleMinions.objects > 0 then
                if menu.jfarm.useQ and spells[_Q]:IsReady() then
                    if not spells[_Q]:IsCharging() then
                        spells[_Q]:Charge()
                    end
                    if _GetDistanceSqr(self.jungleMinions.objects[1]) <= spells[_Q].rangeSqr then
                        spells[_Q]:Cast(self.jungleMinions.objects[1].x, self.jungleMinions.objects[1].z)
                    end
                end

                if menu.jfarm.useE and spells[_E]:IsReady() and _GetDistanceSqr(self.jungleMinions.objects[1]) <= spells[_E].rangeSqr then
                    CastSpell(_E)
                end
            end
        end

end


function Vi:OnTick()

    AAtarget = OW:GetTarget()

    if AAtarget then
        OW:EnableAttacks()
    end

    checkitems()

    if not menu.combo.active then

        -- Farming
        if menu.farm.active and ((player.mana / player.maxMana * 100) >= menu.farm.mana or spells[_Q]:IsCharging()) then
            self:OnFarm()
        end
        -- Jungle farming
        if menu.jfarm.active and ((player.mana / player.maxMana * 100) >= menu.jfarm.mana or spells[_Q]:IsCharging()) then
            self:OnJungleFarm()
        end
    end

    self:KSstuff()
    --self:ManualQ()
    self:FlashQ()

end


function Vi:KSstuff()

    local targets = {
        [_Q] = STS:GetTarget(spellData[_Q].rangeMax),
        [_R] = STS:GetTarget(spellData[_R].range)
    }
    if targets[_R] and menu.KS.useR then
        if DLib:IsKillable(targets[_R], self.mainCombo) then
            ItemManager:CastOffensiveItems(targets[_R])
        end
    end

    for i, enemy in ipairs(GetEnemyHeroes()) do
        if menu.KS.useR and spells[_R]:IsReady() and targets[_R] then
            if DLib:IsKillable(enemy, self.ultKS) then
                spells[_R]:Cast(enemy)
            end
        end
        if menu.KS.useIG and _IGNITE and DLib:IsKillable(enemy, self.IGKS) and not HasBuff(enemy, "SummonerDot") then
            CastSpell(_IGNITE, enemy)
        end
    end
end

--[[
function Vi:ManualQ()
    if spells[_Q]:IsCharging() and menu.manualQ.release then
        spells[_Q]:Cast(mousePos.x, mousePos.z)
    elseif spells[_Q]:IsReady() and menu.manualQ.charge then
        spells[_Q]:Charge()
    end
end
]]--

function Vi:CastQ()

    local targets = {
        [_Q] = STS:GetTarget(spellData[_Q].rangeMax)
    }

    if spells[_Q]:IsReady() and targets[_Q] and menu.combo.active and menu.combo.useQ then
        if spells[_Q]:IsCharging() then
            local castPosition, hitChance, nTargets = spells[_Q]:GetPrediction(targets[_Q])
            if spells[_Q].range ~= spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range - 200, 2) or spells[_Q].range == spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range, 2) then
                spells[_Q]:Cast(castPosition.x, castPosition.z)
                QCasted = true
            end
            QCasted = false
        else
            spells[_Q]:Charge()
        end
    end
end


function Vi:FlashQ()

    local InRange = nil
    local QFlashed = nil
    local FQTarget = STS:GetTarget(FQRange)
    local targets = {
        [_Q]    = STS:GetTarget(spellData[_Q].rangeMax)
    }

    if menu.manualQ.FlashQ then

        OW:OrbWalk(FQTarget)
        if FQTarget and spells[_Q]:IsReady() and _FLASH and myHero:CanUseSpell(_FLASH) then
            if not spells[_Q]:IsCharging() then
                spells[_Q]:Charge()
            end
        end

        if spells[_Q]:IsCharging() and myHero:CanUseSpell(_FLASH) then

            if GetDistance(FQTarget) < 715 then InRange = true end 

            if spells[_Q].range == spellData[_Q].rangeMax and not InRange then
                local castPosition = FQTarget
                if (_GetDistanceSqr(castPosition) < math.pow(FQRange - 200, 2) or _GetDistanceSqr(castPosition) < math.pow(FQRange, 2)) and not InRange then
                    CastSpell(_FLASH, castPosition.x, castPosition.z)
                    QFlashed = true
                end
            end
        end



        if QFlashed or InRange then
            if targets[_Q] then
                local castPosition, hitChance, nTargets = spells[_Q]:GetPrediction(targets[_Q])
                if spells[_Q].range ~= spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range - 200, 2) or spells[_Q].range == spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range, 2) then
                    spells[_Q]:Cast(castPosition.x, castPosition.z)
                    QFlashed = false
                    QCasted = true
                    InRange = false
                end
                QCasted = false
            end
        end
    end
end

function Vi:CastE()
    if spells[_E]:IsReady() then spells[_E]:Cast() end
end

function Vi:AfterAttack()

    checkitems()

    if not menu.combo.active or menu.jfarm.active then return end

    if QCasted then
        DelayAction(function() self:CastE() end, .25)

    else self:CastE() end

    for _, enemy in ipairs(GetEnemyHeroes()) do
            if TiamatR and GetDistance(enemy) < 500 then CastSpell(Tiamat) end
            if HydraR and GetDistance(enemy) < 500 then CastSpell(Hydra) end
    end
end


function Vi:OnProcessSpell(unit, spell)

    --if unit.isMe and spell.name:lower():find("ViQ") then
    --  DelayAction(function() OW:resetAA() end, .25)
    --end

    if #ToInterrupt > 0 and menu.misc.interrupt.interruptQ and spells[_Q]:IsReady() then
        for _, ability in pairs(ToInterrupt) do
            if spell.name == ability and unit.team ~= myHero.team and GetDistance(unit) < 715 then
                if spells[_Q]:IsCharging() then
                    local castPosition, hitChance, nTargets = spells[_Q]:GetPrediction(unit)
                    if spells[_Q].range ~= spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range - 200, 2) or spells[_Q].range == spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range, 2) then
                        spells[_Q]:Cast(castPosition.x, castPosition.z)
                    end
                end
            end
        end
    end


    if #ToInterrupt2 > 0 and menu.misc.interrupt.interruptR and spells[_R]:IsReady() then
        for _, ability in pairs(ToInterrupt2) do
            if spell.name == ability and unit.team ~= myHero.team and GetDistance(unit2) < spells[_R].range then
                spells[_R]:Cast(unit)
            end
        end
    end

end


function Vi:OnSendMove(p)
    
    -- Block auto-attack while charging
    if spells[_Q]:IsCharging() then
        local packet = Packet(p)
        if packet:get("type") ~= 2 then
            Packet('S_MOVE', { x = mousePos.x, y = mousePos.z }):send()
            p:Block()
        end
    end
end


function Vi:ApplyMenu()

    -- Combo
    menu.combo:addParam("sep",    "",                   SCRIPT_PARAM_INFO, "")
    menu.combo:addParam("useQ",   "Use Q",              SCRIPT_PARAM_ONOFF , true)
    menu.combo:addParam("useE",   "Use E",              SCRIPT_PARAM_ONOFF, true)
    menu.combo:addParam("useR",   "Use R in Combo",     SCRIPT_PARAM_ONOFF, true)


    -- KS options
    menu:addSubMenu("KS options", "KS")
        menu.KS:addParam("sep",  "",                    SCRIPT_PARAM_INFO, "")
        menu.KS:addParam("useR",  "Use Ult to KS",      SCRIPT_PARAM_ONOFF , true)
        menu.KS:addParam("useIG", "Use Ignite to KS",   SCRIPT_PARAM_ONOFF , true)


    -- Harass
    menu.harass:addParam("sep",  "",                         SCRIPT_PARAM_INFO, "")
    menu.harass:addParam("useQ", "Use Q",                    SCRIPT_PARAM_ONOFF , true)
    menu.harass:addParam("mana", "Don't harass if mana < %", SCRIPT_PARAM_SLICE, 10, 0, 100)
    
    -- Farming
    menu:addSubMenu("Farming", "farm")
        menu.farm:addParam("active", "Farming active",         SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        menu.farm:addParam("sep",    "",                       SCRIPT_PARAM_INFO, "")
        menu.farm:addParam("useQ",   "Use Q",                  SCRIPT_PARAM_ONOFF, true)
        menu.farm:addParam("useE",   "Use E",                  SCRIPT_PARAM_ONOFF, false)
        menu.farm:addParam("sep",    "",                       SCRIPT_PARAM_INFO, "")
        menu.farm:addParam("mana",   "Don't farm if mana < %", SCRIPT_PARAM_SLICE, 10, 0, 100)
    
    -- Jungle farming
    menu:addSubMenu("Jungle-Farming", "jfarm")
        menu.jfarm:addParam("active", "Jungle-Farming active", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("J"))
        menu.jfarm:addParam("sep",    "",                      SCRIPT_PARAM_INFO, "")
        menu.jfarm:addParam("useQ",   "Use Q",                 SCRIPT_PARAM_ONOFF, true)
        menu.jfarm:addParam("useE",   "Use E",                 SCRIPT_PARAM_ONOFF, true)
        menu.jfarm:addParam("mana",   "Don't farm if mana < %", SCRIPT_PARAM_SLICE, 10, 0, 100)

    --Manual Q Cast
    menu:addSubMenu("Q-Flash-Q", "manualQ")
        menu.manualQ:addParam("sep", "",                             SCRIPT_PARAM_INFO, "")
    --    menu.manualQ:addParam("charge", "charge Q Cast",             SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
    --    menu.manualQ:addParam("release", "release Charge to Mouse",  SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
        menu.manualQ:addParam("FlashQ", "use Q-Flash-Q",             SCRIPT_PARAM_ONKEYDOWN, false, string.byte("K"))

    -- Misc
    menu:addSubMenu("Misc", "misc")
        menu.misc:addSubMenu("Auto-Interrupt", "interrupt")
            menu.misc.interrupt:addParam("sep", "",                                                 SCRIPT_PARAM_INFO, "")
            menu.misc.interrupt:addParam("interruptQ", "attempt to interrupt with Q",               SCRIPT_PARAM_ONOFF, true)
            menu.misc.interrupt:addParam("interruptR", "interrupt dangerous with Ult",              SCRIPT_PARAM_ONOFF, true)

            

    -- Drawing
    menu:addSubMenu("Drawing", "drawing")
        AAcircle:AddToMenu(menu.drawing, "AA Range", false, true, true)
        DM:CreateCircle(player, FQRange, 2, { 150, 0x0F, 0x46, 0xFF }):AddToMenu(menu.drawing, "Q-Flash-Q Range", true, true, true)
        DM:CreateCircle(player, spellData[_Q].rangeMax, 2, { 150, 0x0F, 0x37, 0xFF }):AddToMenu(menu.drawing, "Q Range (max)", true, true, true)
        for spell, circle in pairs(circles) do
            circle:AddToMenu(menu.drawing, SpellToString(spell).." Range", true, true, true)
        end

        DLib:AddToMenu(menu.drawing, self.mainCombo)

end
    


---                                               _            _    _         _        _            _             _             _            _            _        
--                                              /\ \         /\ \ /\ \    _ / /\     /\ \         /\ \     _    /\ \     _    /\ \         /\ \         / /\      
--                                             /  \ \        \ \ \\ \ \  /_/ / /    /  \ \       /  \ \   /\_\ /  \ \   /\_\ /  \ \       /  \ \       / /  \     
--                                            / /\ \ \       /\ \_\\ \ \ \___\/    / /\ \ \     / /\ \ \_/ / // /\ \ \_/ / // /\ \ \     / /\ \ \     / / /\ \    
--                                           / / /\ \_\     / /\/_// / /  \ \ \   / / /\ \_\   / / /\ \___/ // / /\ \___/ // / /\ \ \   / / /\ \ \   / / /\ \ \   
--                                          / / /_/ / /    / / /   \ \ \   \_\ \ / /_/_ \/_/  / / /  \/____// / /  \/____// / /  \ \_\ / / /  \ \_\ / / /\ \_\ \  
--                                         / / /__\/ /    / / /     \ \ \  / / // /____/\    / / /    / / // / /    / / // / /   / / // / /   / / // / /\ \ \___\ 
--                                        / / /_____/    / / /       \ \ \/ / // /\____\/   / / /    / / // / /    / / // / /   / / // / /   / / // / /  \ \ \__/ 
--                                       / / /\ \ \  ___/ / /__       \ \ \/ // / /______  / / /    / / // / /    / / // / /___/ / // / /___/ / // / /____\_\ \   
--                                      / / /  \ \ \/\__\/_/___\       \ \  // / /_______\/ / /    / / // / /    / / // / /____\/ // / /____\/ // / /__________\  
--                                      \/_/    \_\/\/_________/        \_\/ \/__________/\/_/     \/_/ \/_/     \/_/ \/_________/ \/_________/ \/_____________/ Riven - Script


function Riven:__init()

    ScriptName = "RivenNooB"

    UpdateWeb(true, ScriptName, id, HWID)

    spellData = {    [_Q] =   { skillshotType = SKILLSHOT_CONE,     range = 260, speed = 780, width = 50,   delay = 0.25, Q3range = 300, Q3speed = 565, Q3width = 50, Q3delay = 0.40},
                     [_W] =   { skillshotType = nil,                range = 250},
                     [_E] =   { skillshotType = SKILLSHOT_LINEAR,   range = 325, speed = 1235, width = 100, delay = 0.25},
                     [_R] =   { skillshotType = SKILLSHOT_CONE,     range = 900, speed = 2000, width = 60,  delay = 0.25},
}
    
    initializeSpells()

    -- Finetune spells
    --Q
    spells[_Q]:SetAOE(true)
    spells[_Q]:TrackCasting("RivenTriCleave")
    spells[_Q]:RegisterCastCallback(function(spell) self:OnCastSpells(spell) end)
    spells[_Q].packetCast = true
    
    --W
    spells[_W]:SetAOE(true)
    spells[_W].packetCast = true

    --E
    spells[_E].packetCast = true

    --R
    spells[_R]:SetAOE(true)
    spells[_R].packetCast = true
    

    -- Circle customization
    circles[_Q].color = { 255, 0x0F, 0x37, 0xFF }
    circles[_Q].width = 2
    circles[_E].color = { 255, 0x0F, 0xFF, 0x20 }
    circles[_E].width = 2
    circles[_R].color = { 255, 0xFF, 0x25, 0x30 }
    circles[_R].width = 2

    -- Minions
    self.enemyMinions  = minionManager(MINION_ENEMY,  spellData[_Q].range, player, MINION_SORT_MAXHEALTH_DEC)
    self.jungleMinions = minionManager(MINION_JUNGLE, spellData[_Q].range, player, MINION_SORT_MAXHEALTH_DEC)

    --self.mainCombo = { _IGNITE, _Q, _E, _AA, _R }
    --self.standartCombo = { _Q, _E, _AA, _R }
    --self.ultKS = { _R }
    self.IGKS = { _IGNITE }
    
    --Register damage sources
    --DLib:RegisterDamageSource(_Q, _PHYSICAL, 10,  20, _PHYSICAL, _AD, 0.44, function() return spells[_Q]:IsReady() end)
    DLib:RegisterDamageSource(_W, _PHYSICAL, 50,  30, _PHYSICAL, _AD, 0.18, function() return spells[_E]:IsReady() end)
    --DLib:RegisterDamageSource(_R, _PHYSICAL, 200, 125, _PHYSICAL, _AD, 0.10, function() return spells[_R]:IsReady() end) 
    

    OW:RegisterAfterAttackCallback(function() self:AfterAttack() end)
    --[[
    (function(target,mode)
        if spells[_Q]:IsReady() then         
            if (menu.combo.active and menu.combo.useQ) or (menu.farm.active and menu.farm.useQ) then
                spells[_Q]:Cast(target)
            end
        end
    end)
    ]]--
    --PacketHandler:HookOutgoingPacket(Packet.headers.S_MOVE, function(p) self:OnSendMove(p) end) -- needed for jumpspots?

    self.AnimationCancel = {
    [1] = function() Packet('S_MOVE', {type = 2, x = mousePos.x, y = mousePos.z}):send() end, --"Move"
    [2] = function() SendChat('/l') end, --"Laugh"
    [3] = function() SendChat('/d') end, --"Dance"
    [4] = function() SendChat('/t') end, --"Taunt"
    [5] = function() SendChat('/j') end, --"joke"
    [6] = function() end,
}


    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        for _, champ in pairs(InterruptList) do
                if hero.charName == champ.charName then
                    table.insert(ToInterrupt, champ.spellName)
                end
        end

        for _, champ in pairs(InterruptList2) do
                if hero.charName == champ.charName then
                    table.insert(ToInterrupt2, champ.spellName)
                end
        end
    end

end


function Riven:GetSkins()
    return {
        "Classic",
        "Redeemed Riven",
        "Crimson Elite Riven",
        "Battle Bunny Riven",
        "Championship Riven",
        "Dragonblade Riven"
    }
end


function Riven:ApplyMenu()

    menu.combo:addParam("sep",    "",                                   SCRIPT_PARAM_INFO, "")
        menu.combo:addParam("useQ",   "Use Q",                          SCRIPT_PARAM_ONOFF , true)
        menu.combo:addParam("useW",   "Use W in Combo",                 SCRIPT_PARAM_ONOFF , true)
        menu.combo:addParam("useGC",   "Use gapclose Combo",            SCRIPT_PARAM_ONOFF , true)
    --    menu.combo:addParam("useP",   "Use all passive stacks",       SCRIPT_PARAM_ONOFF , true)
        menu.combo:addParam("useR",   "Use ult if killable",            SCRIPT_PARAM_ONOFF , true)

    menu:addSubMenu("Farming", "farm")
        menu.farm:addParam("active", "Farming active",         SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        menu.farm:addParam("sep",    "",                       SCRIPT_PARAM_INFO, "")
        menu.farm:addParam("useQ",   "Use Q",                  SCRIPT_PARAM_ONOFF, true)
        menu.farm:addParam("useW",   "Use W",                  SCRIPT_PARAM_ONOFF, true)
    --    menu.farm:addParam("useP",   "Use all passive Stacks", SCRIPT_PARAM_ONOFF, true)

    menu:addSubMenu('"Kill-secure" options', "KS")
        menu.KS:addParam("useQ",    "Use Q to KS",             SCRIPT_PARAM_ONOFF, true)
        menu.KS:addParam("useW",    "Use W to KS",             SCRIPT_PARAM_ONOFF, true)
        menu.KS:addParam("useIG",   "Use Ignite to KS",        SCRIPT_PARAM_ONOFF, true)
        menu.KS:addParam("useR",    "Use Ult to KS",           SCRIPT_PARAM_ONOFF, true)

    menu:addParam("flee", "FleeMode",                          SCRIPT_PARAM_ONKEYDOWN, false, string.byte("J"))                   

    menu:addParam("cancel", "Animation Cancel Method",         SCRIPT_PARAM_LIST, 1, { "Move","Laugh","Dance","Taunt","joke","Nothing" })

    --menu:addParam("debug", "debug", SCRIPT_PARAM_ONOFF , true)

end


function Riven:OnCombo()

    local targets = {
    [_Q] = STS:GetTarget(spellData[_Q].range), 
    [_W] = STS:GetTarget(spellData[_W].range),
    }

    if menu.combo.useW then
        if targets[_W] and spells[_W]:IsReady() then
            return spells[_W]:Cast()
        end
    end

    if Target and ValidTarget(Target) and (R_ON == false and spells[_R]:IsReady()) and (self:GetComboDmg(Target,false) < Target.health) and (self:GetComboDmg(Target,true) > Target.health) then        
        R_ON_FLAG = true
        R_ON_FLAG_TARGET = Target
    end

    if menu.combo.useGC and not targets[_Q] then
        self:Gapclose()
    end
end


function Riven:OnFarm()
    self:FarmModes()
end


function Riven:OnTick()

    checkitems()
    self:FleeMode()

    Target = STS:GetTarget(1200)

    AAtarget = OW:GetTarget()


    if AAtarget then
        OW:EnableAttacks()
    end

    if not menu.combo.active then
        -- Farming
        if menu.farm.active then
            self:OnFarm()
        end
    end

    self:KSstuff()

    if menu.combo.useR then
        if ValidTarget(R_ON_FLAG_TARGET, 500) and R_ON_FLAG and spells[_R]:IsReady() then
            CastSpell(_R)
        end
    end

    for _, enemy in pairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) then    
            if (_GetDistanceSqr(enemy) < spells[_R].rangeSqr) and (getDmg("R", enemy, myHero) > enemy.health) then
                if R_ON and spells[_R]:IsReady() then
                    spells[_R]:Cast(enemy)
                end
            end

            if menu.KS.useR then
                if (_GetDistanceSqr(enemy) < spells[_R].rangeSqr) and (getDmg("R", enemy, myHero) > enemy.health) then
                    CastSpell(_R)
                end
            end
        end
    end

end


function Riven:OnGainBuff(unit, buff)
    if unit.isMe then
        if buff.name == 'rivenpassiveaaboost' then
            RivenBuffs.Passive.stacks = 1
            if menu.debug then PrintChat("passive gained") end
        end

        if buff.name == 'RivenFengShuiEngine' then
            R_ON_FLAG = false
            R_ON = true
        end
    end
end


function Riven:OnLoseBuff(unit, buff)
    if unit.isMe then
        if buff.name == 'rivenpassiveaaboost' then
            RivenBuffs.Passive.stacks = 0
            if menu.debug then PrintChat("passive lost") end
        end
        if buff.name == 'RivenTriCleave' then
            RivenBuffs.Q.stage  = 0
            if menu.debug then PrintChat("QstageReset") end
        end
        if buff.name == "RivenFengShuiEngine" then
            R_ON = false
        end
    end
end


function Riven:OnUpdateBuff(unit, buff)
    if unit.isMe then
        if buff.name == 'rivenpassiveaaboost' then
            RivenBuffs.Passive.stacks = buff.stack
            if menu.debug then PrintChat("buffStack") end
        end
    end
end


function Riven:OnProcessSpell(unit, spell)
    if not unit.isMe then return end
    if spell.name == 'RivenTriCleave' then -- _Q
        DelayAction(function() OW:resetAA() end, .25)
        self.AnimationCancel[menu.cancel]()
    elseif spell.name == 'RivenMartyr' then -- _W
        DelayAction(function() OW:resetAA() end, .25)
        self.AnimationCancel[menu.cancel]()
            if TiamatR then CastSpell(Tiamat) end
            if HydraR then CastSpell(Hydra) end
    elseif spell.name == 'RivenFeint'  then -- _E
        DelayAction(function() OW:resetAA() end, .25)
        self.AnimationCancel[menu.cancel]()
    elseif spell.name == 'RivenFengShuiEngine' then -- _R first cast                
        self.AnimationCancel[menu.cancel]()
    end
end


function Riven:OnCastSpells(spell)
    if spell.name == "RivenTriCleave" then
        RivenBuffs.Q.stage  = RivenBuffs.Q.stage + 1
        if menu.debug then PrintChat("Qstage+1") end
    end
end


function Riven:AfterAttack()
    if spells[_Q]:IsReady() and (menu.combo.active and menu.combo.useQ) or (menu.farm.active and menu.farm.useQ) then
        if menu.combo.active then
            CastSpell(_Q, Target)
        elseif menu.farm.active then
            CastSpell(_Q, mousePos.x, mousePos.z)
        end
    end
end


function Riven:FarmModes()

    local minionsUpdated = false
    if menu.farm.useW and menu.farm.active then
        self.enemyMinions:update()
        minionsUpdated = true

        for _, minion in ipairs(self.enemyMinions.objects) do
            if GetDistance(minion) < spells[_W].range and DLib:IsKillable(minion, {_W}) then
                CastSpell(_W)
            end        
        end
    end

end


function Riven:Gapclose()
    if Target and _GetDistanceSqr(Target) <= spells[_E].rangeSqr then
        if spells[_E]:IsReady() then
            spells[_E]:Cast(Target.x, Target.z)
        end
    elseif Target and (_GetDistanceSqr(Target) > spells[_E].rangeSqr) and (_GetDistanceSqr(Target) < spells[_E].rangeSqr + (spells[_Q].rangeSqr*(3-RivenBuffs.Q.stage))) then
        if spells[_E]:IsReady() then
            CastSpell(_E, Target.x, Target.z)
        end
        if spells[_Q]:IsReady() then
            CastSpell(_Q, Target.x, Target.z)
        end
    end
  
end


function Riven:KSstuff()
    for _, enemy in pairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) then
            --W
            if menu.KS.useW and spells[_W]:IsReady() and spells[_W]:IsInRange(enemy) and (getDmg("W", enemy, myHero) > enemy.health) then                
                CastSpell(_W)
            end
            --Q
            if menu.KS.useQ and spells[_Q]:IsReady() and spells[_Q]:IsInRange(enemy) and (getDmg("Q", enemy, myHero) > enemy.health) then
                spells[_Q]:Cast(enemy)
            end
            if not R_ON then
                if _IGNITE and menu.KS.useIG and _GetDistanceSqr(enemy.visionPos, myHero.visionPos) < 600 * 600 and DLib:IsKillable(enemy, self.IGKS) then
                    DelayAction(function() CastSpell(_IGNITE, enemy) end, 1000)
                end
            end
        end
    end
end


function Riven:FleeMode()
    if menu.flee then 
        Packet('S_MOVE', {type = 2, x = mousePos.x, y = mousePos.z}):send()
        if spells[_Q]:IsReady() then
            CastSpell(_Q, mousePos.x, mousePos.z)
        end
        if spells[_E]:IsReady() then
            CastSpell(_E, mousePos.x, mousePos.z)
        end
    end
end


function Riven:GetDmg(slot,target,useR)
    local ad,bad    
    if useR then        
        bad = myHero.addDamage*(1.2)
        ad = myHero.totalDamage+bad
    else        
        ad = myHero.totalDamage
        bad= myHero.addDamage
    end
    
    local DAMAGEs={ 
        [_PASIVE] = function() return ((20+5*math.floor(myHero.level/3))*0.01*ad) end,
        [_Q     ] = function() return 20*myHero:GetSpellData(_Q).level-10+(.05*myHero:GetSpellData(_Q).level+.35)*ad end,
        [_W     ] = function() return 30*myHero:GetSpellData(_W).level+20+bad end,
        [_R     ] = function()
            local hpercent = target.health / target.maxHealth
            if hpercent <= 0.25 then
                return 120 * myHero:GetSpellData(_R).level + 120 + 1.8 * bad
            else
                return (40 * myHero:GetSpellData(_R).level + 40 + 0.6 * bad) * (hpercent) * (- 2.67) + 3.67
            end
        end
    }   
    if slot==_AA then
        return myHero:CalcDamage(target,ad)
    else
        return myHero:CalcDamage(target,DAMAGEs[slot]())
    end
end


function Riven:GetComboDmg(target,useR)
    local count = 0
    local totalDmg = 0
    
    if RivenBuffs.Q.stage == 0 and myHero:CanUseSpell(_Q) == READY then
        count = count + 3
        totalDmg = totalDmg + (self:GetDmg(_Q,target,useR) + self:GetDmg(_AA,target,useR)) * 3
    end

    if RivenBuffs.Q.stage == 1 and myHero:CanUseSpell(_Q) == READY then
        count = count + 2
        totalDmg = totalDmg + (self:GetDmg(_Q,target,useR) + self:GetDmg(_AA,target,useR)) * 2
    end

    if RivenBuffs.Q.stage == 2 and myHero:CanUseSpell(_Q) == READY then
        count = count + 1
        totalDmg = totalDmg + (self:GetDmg(_Q,target,useR) + self:GetDmg(_AA,target,useR))
    end

    if myHero:CanUseSpell(_W) == READY then
        count = count + 1
        totalDmg = totalDmg + self:GetDmg(_W,target,useR)
    end

    if myHero:CanUseSpell(_E) == READY then
        count = count + 1
    end

    if useR then
        count = count + 2
        totalDmg = totalDmg + self:GetDmg(_R,target,useR)
    end

    totalDmg = totalDmg + self:GetDmg(_PASIVE,target,useR)  * count
    return totalDmg
end

function Riven:OnBugsplat()
    UpdateWeb(false, ScriptName, id, HWID)
end

function Riven:OnUnload()
    UpdateWeb(false, ScriptName, id, HWID)
end

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()


--[[ 

Credits to:

Hellsing
Honda
Skeem
Ilikeme(a)n(Riven-Ult-Calcs)
Apple(AIO-Layout)
Dienofail(some Values)
Shalzuth(Skinhack)
Teecolz and Scarra for testing

]]--
