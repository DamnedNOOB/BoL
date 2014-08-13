local version = 0.003
local scriptName = "ViNooB"
local autoUpdate   = true
local silentUpdate = false


-- Changelog:

-- v.0.003: added Q-Flash-Q

--[[ 

     ____   ____  _   ____  _____   ___      ___   ______     
    |_  _| |_  _|(_) |_   \|_   _|.'   `.  .'   `.|_   _ \    
      \ \   / /  __    |   \ | | /  .-.  \/  .-.  \ | |_) |   
       \ \ / /  [  |   | |\ \| | | |   | || |   | | |  __'.   
        \ ' /    | |  _| |_\   |_\  `-'  /\  `-'  /_| |__) |  
         \_/    [___]|_____|\____|`.___.'  `.___.'|_______/    by DamnedNOOB

]]--                                                              


--- BoL Script Status Connector ---

local ScriptRKey = "XKNJQSMSKSK" -- Your script auth key

local ScriptRVersion = "" -- Leave blank if version url is not registred

function ReportDebug(data)

-- PrintChat(data) -- unquote to debug

end

function ScriptWorking()

GetAsyncWebResult("bol.b00st.eu", "update-"..ScriptRKey.."-"..ScriptRVersion, ReportDebug)

end

-----------------------------------

----- END CONNECTOR ------

local champions = {
    ["Vi"]           = true,
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

--[[ Script Variables ]]--

local champ = champions[player.charName]
local menu  = nil
local VP    = nil
local OW    = nil
local STS   = nil
local DM    = nil
local DLib  = nil

local spellData = {}

local FQRange = nil

local spells   = {}
local circles  = {}
local AAcircle = nil

local interruptTarget = nil
local interruptCastTime = nil

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

    -- Connector
    ScriptWorking()

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
    menu:addSubMenu("Prediction", "prediction")
        menu.prediction:addParam("predictionType", "Prediction Type", SCRIPT_PARAM_LIST, 1, { "VPrediction", "Prodiction" })
        _G.srcLib.spellMenu =  menu.prediction

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

--[[
    
                                                    /\ \    _ / /\      /\ \       /\ \     _    /\ \         /\ \         / /\      
                                                    \ \ \  /_/ / /      \ \ \     /  \ \   /\_\ /  \ \       /  \ \       / /  \     
                                                     \ \ \ \___\/       /\ \_\   / /\ \ \_/ / // /\ \ \     / /\ \ \     / / /\ \    
                                                     / / /  \ \ \      / /\/_/  / / /\ \___/ // / /\ \ \   / / /\ \ \   / / /\ \ \   
                                                     \ \ \   \_\ \    / / /    / / /  \/____// / /  \ \_\ / / /  \ \_\ / / /\ \_\ \  
                                                      \ \ \  / / /   / / /    / / /    / / // / /   / / // / /   / / // / /\ \ \___\ 
                                                       \ \ \/ / /   / / /    / / /    / / // / /   / / // / /   / / // / /  \ \ \__/ 
                                                        \ \ \/ /___/ / /__  / / /    / / // / /___/ / // / /___/ / // / /____\_\ \   
                                                         \ \  //\__\/_/___\/ / /    / / // / /____\/ // / /____\/ // / /__________\  
                                                          \_\/ \/_________/\/_/     \/_/ \/_________/ \/_________/ \/_____________/  Vi - Script
]]--

function Vi:__init()

	FQRange = 1100

    spellData = {
        [_Q] =  { range = 250, rangeMax = 715,  skillshotType = SKILLSHOT_LINEAR,   width = 55,   delay = 0.25,  speed = 1500,      collision = false },
        [_E] =  { range = 250,                  skillshotType = SKILLSHOT_CONE,     width = 300,  delay = 0.25,  speed = math.huge, collision = false },
        [_R] =  { range = 800, 														width = 1, 	  delay = 0.25,  speed = math.huge, collision = false },
    }

    initializeSpells()

    -- Finetune spells
    spells[_Q]:SetCharged("ViQ", 3, spellData[_Q].rangeMax, 1.25, function() return spells[_Q]:GetCooldown(true) > 0 end)
    spells[_Q]:SetAOE(true)
    spells[_Q].packetCast = true
    spells[_E].packetCast = true
    spells[_R].packetCast = true

    -- Circle customization
    circles[_Q].color = { 255, 0x0F, 0x37, 0xFF }
    circles[_Q].width = 2
    circles[_R]:SetEnabled(false)

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

    OW:RegisterAfterAttackCallback(AfterAttack)              

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

    for _, enemy in ipairs(GetEnemyHeroes()) do
        if TiamatR and GetDistance(enemy) < 500 then CastSpell(Tiamat) end
        if HydraR and GetDistance(enemy) < 500 then CastSpell(Hydra) end
    end

   	local AAtarget = OW:GetTarget()

    if AAtarget then
        OW:EnableAttacks()
    end
    
    self:AfterAttack()

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

    OW:EnableAttacks()
    checkitems()

    if not menu.combo.active then

        -- Farming
        if menu.farm.active and ((player.mana / player.maxMana * 100) >= menu.farm.mana or spells[_Q]:IsCharging()) then
            self:OnFarm()
        end
        -- Jungle farming
        if menu.jfarm.active then
            self:OnJungleFarm()
        end
    end

    self:KSstuff()
    self:ManualQ()
--    self:Qinterrupt(interruptTarget)
	self:FlashQ()

end

--[[
function Vi:Qinterrupt(interruptTarget)
    if interruptTarget then
        if spells[_Q]:IsCharging() and os.clock() - interruptCastTime < 1 then
            local castPosition, hitChance, nTargets = spells[_Q]:GetPrediction(interruptTarget)
            if spells[_Q].range ~= spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range - 200, 2) or spells[_Q].range == spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range, 2) then
                spells[_Q]:Cast(castPosition.x, castPosition.z)
            end
        end
    end
    interruptTarget = nil
end
]]--


function Vi:AfterAttack()
	local AAtarget = OW:GetTarget()
	if (spells[_E]:IsReady() and AAtarget) and menu.combo.useE then
        CastSpell(_E)
    end
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


function Vi:ManualQ()
    if spells[_Q]:IsCharging() and menu.manualQ.release then
        spells[_Q]:Cast(mousePos.x, mousePos.z)
    elseif spells[_Q]:IsReady() and menu.manualQ.charge then
        spells[_Q]:Charge()
    end
end


function Vi:CastQ()

    local targets = {
        [_Q] = STS:GetTarget(spellData[_Q].rangeMax)
    }

    if spells[_Q]:IsReady() and targets[_Q] and menu.combo.active and menu.combo.useQ then
        if spells[_Q]:IsCharging() then
            local castPosition, hitChance, nTargets = spells[_Q]:GetPrediction(targets[_Q])
            if spells[_Q].range ~= spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range - 200, 2) or spells[_Q].range == spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range, 2) then
                spells[_Q]:Cast(castPosition.x, castPosition.z)
            end
        else
            spells[_Q]:Charge()
        end
    end
end


function Vi:FlashQ()


	local QFlashed = nil
	local FQTarget = STS:GetTarget(FQRange)
	local targets = {
        [_Q] 	= STS:GetTarget(spellData[_Q].rangeMax)
    }

	if menu.manualQ.FlashQ then
		OW:OrbWalk(FQTarget)
		if FQTarget and spells[_Q]:IsReady() and _FLASH and myHero:CanUseSpell(_FLASH) then
			if not spells[_Q]:IsCharging() then
				spells[_Q]:Charge()
			end
		end

	    if spells[_Q]:IsCharging() then 
	        if spells[_Q].range == spellData[_Q].rangeMax then
		        local castPosition = FQTarget
		    	if _GetDistanceSqr(castPosition) < math.pow(FQRange - 200, 2) or _GetDistanceSqr(castPosition) < math.pow(FQRange, 2) then
		            CastSpell(_FLASH, castPosition.x, castPosition.z)
		            QFlashed = true
		    	end
		    end
	    end



	    if QFlashed and targets[_Q] then
	        local castPosition, hitChance, nTargets = spells[_Q]:GetPrediction(targets[_Q])
	        if spells[_Q].range ~= spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range - 200, 2) or spells[_Q].range == spellData[_Q].rangeMax and _GetDistanceSqr(castPosition) < math.pow(spells[_Q].range, 2) then
	           	spells[_Q]:Cast(castPosition.x, castPosition.z)
	           	QFlashed = false
	        end
	    end
	end
end




function Vi:OnProcessSpell(unit, spell)
--[[
    if #ToInterrupt > 0 and menu.misc.interrupt.interruptQ and spells[_Q]:IsReady() then
        for _, ability in pairs(ToInterrupt) do
            if spell.name == ability and unit.team ~= myHero.team and GetDistance(unit) < 715 then
                spells[_Q]:Charge()
            end
        end
        interruptTarget = unit
        interruptCastTime = os.clock()
    end
]]--
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


    -- Manual Q Cast
    menu:addSubMenu("Manual Q Cast", "manualQ")
        menu.manualQ:addParam("sep", "",                             SCRIPT_PARAM_INFO, "")
        menu.manualQ:addParam("charge", "charge Q Cast",             SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
        menu.manualQ:addParam("release", "release Charge to Mouse",  SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
        menu.manualQ:addParam("FlashQ", "use Q-Flash-Q", 			 SCRIPT_PARAM_ONKEYDOWN, false, string.byte("K"))

    -- Misc
    menu:addSubMenu("Misc", "misc")
    -- Q Flash Q
    	menu.misc:addParam("FlashQ", "use Q-Flash-Q", 				   SCRIPT_PARAM_ONKEYDOWN, false, string.byte("K"))
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

 
--[[ 

Credits to:

Hellsing
Honda
Apple(AIO-Layout)
Dienofail(some Values)
Shalzuth(Skinhack)
Teecolz and Scarra for testing

]]--