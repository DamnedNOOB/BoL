--[[

  tNasus - updated version + SBTW version of Hellsing's nasus
  
  
  ]]

if myHero.charName ~= "Nasus" then return end

local version = 1.02
local AUTOUPDATE = false

require "SOW"
require "VPrediction"
require "Sourcelib"


local SCRIPT_NAME = "tNasus"
local SOURCELIB_URL = "https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua"
local SOURCELIB_PATH = LIB_PATH.."SourceLib.lua"
if FileExist(SOURCELIB_PATH) then
  require("SourceLib")
else
  DOWNLOADING_SOURCELIB = true
  DownloadFile(SOURCELIB_URL, SOURCELIB_PATH, function() print("Required libraries downloaded successfully, please reload") end)
end

if DOWNLOADING_SOURCELIB then print("Downloading required libraries, please wait...") return end

if AUTOUPDATE then
  SourceUpdater(SCRIPT_NAME, version, "raw.github.com", "/teecolz/Scripts/master/"..SCRIPT_NAME..".lua", SCRIPT_PATH .. GetCurrentEnv().FILE_NAME, "/teecolz/Scripts/master/"..SCRIPT_NAME..".version"):CheckUpdate()
end

local RequireI = Require("SourceLib")
RequireI:Add("vPrediction", "https://raw.github.com/Hellsing/BoL/master/common/VPrediction.lua")
RequireI:Add("SOW", "https://raw.github.com/Hellsing/BoL/master/common/SOW.lua")

RequireI:Check()

if RequireI.downloadNeeded == true then return end

--------------------BoL Tracker-----------------------------
HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION")))
-- DO NOT CHANGE. This is set to your proper ID.
id = 15
ScriptName = "tNasus"

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()
-------------------------------------------------

DashList = {
        ['Ahri']        = {true, spell = 'AhriTumble'},
        ['Aatrox']      = {true, spell = 'AatroxQ'},
        ['Akali']       = {true, spell = 'AkaliShadowDance'}, -- Targeted ability
        ['Alistar']     = {true, spell = 'Headbutt'}, -- Targeted ability
        ['Corki']       = {true, spell = 'CarpetBomb'},
        ['Diana']       = {true, spell = 'DianaTeleport'}, -- Targeted ability
        ['Elise']       = {true, spell = 'EliseSpiderQCast'}, -- Targeted ability
        ['Fiora']       = {true, spell = 'FioraQ'}, -- Targeted ability
        ['Fizz']      = {true, spell = 'FizzPiercingStrike'}, -- Targeted ability
        ['Gragas']      = {true, spell = 'GragasE'},
        ['Graves']      = {true, spell = 'GravesMove'},
        ['Hecarim']     = {true, spell = 'HecarimUlt'},
        ['Irelia']      = {true, spell = 'IreliaGatotsu'}, -- Targeted ability
        ['JarvanIV']    = {true, spell = 'jarvanAddition'}, -- Skillshot/Targeted ability
        ['Jax']         = {true, spell = 'JaxLeapStrike'}, -- Targeted ability
        ['Jayce']       = {true, spell = 'JayceToTheSkies'}, -- Targeted ability
        ['Kassadin']    = {true, spell = 'RiftWalk'},
        ['Khazix']      = {true, spell = 'KhazixW'},
        ['Leblanc']     = {true, spell = 'LeblancSlide'},
        ['LeeSin']      = {true, spell = 'blindmonkqtwo'},
        ['Leona']       = {true, spell = 'LeonaZenithBlade'},
        ['Lucian']      = {true, spell = 'LucianE'},
        ['Malphite']    = {true, spell = 'UFSlash'},
        ['Maokai']      = {true, spell = 'MaokaiTrunkLine',}, -- Targeted ability 
    ['MasterYi']    = {true, spell = 'AlphaStrike',}, -- Targeted
        ['MonkeyKing']  = {true, spell = 'MonkeyKingNimbus'}, -- Targeted ability
        ['Nidalee']     = {true, spell = 'Pounce'},
        ['Pantheon']    = {true, spell = 'PantheonW'}, -- Targeted ability
        ['Pantheon']    = {true, spell = 'PantheonRJump'},
        ['Pantheon']    = {true, spell = 'PantheonRFall'},
        ['Poppy']       = {true, spell = 'PoppyHeroicCharge'}, -- Targeted ability
      --['Quinn']       = {true, spell = 'QuinnE',                  range = 725,   projSpeed = 2000, }, -- Targeted ability
        ['Rammus']      = {true, spell = 'PowerBall'},
        ['Renekton']    = {true, spell = 'RenektonSliceAndDice'},
        ['Riven']     = {true, spell = 'RivenFeint'},
        ['Sejuani']     = {true, spell = 'SejuaniArcticAssault'},
        ['Shyvana']     = {true, spell = 'ShyvanaTransformCast'},
        ['Shen']        = {true, spell = 'ShenShadowDash'},
        ['Talon']       = {true, spell = 'TalonCutthroat'},
        ['Tristana']    = {true, spell = 'RocketJump'},
        ['Tryndamere']  = {true, spell = 'Slash'},
        ['Vi']      = {true, spell = 'ViQ'},
        ['XinZhao']     = {true, spell = 'XenZhaoSweep'}, -- Targeted ability
        ['Yasuo']       = {true, spell = 'YasuoDashWrapper'} -- Targeted ability
}

------------ Globals ------------

local enemyMinions = nil
local jungleMobs   = nil
local jungleLib    = nil
local menu         = nil

local buffActive = false
local buffStacks = 0
local buffDamage = 0

local attackSpeed = 0

local lastAttack     = 0
local lastWindUpTime = 0
local lastAttackCD   = 0

local debug = {}

----------- Constants -----------

local TRUE_RANGE = 125 + player:GetDistance(player.minBBox)
local BUFF_NAME  = "NasusQ"
local DAMAGE_Q   = { 30, 50, 70, 90, 110 }

local BASE_ATTACKSPEED       = 0.638

local ITEMS = { [3057] = { name = "Sheen",            unique = "SPELLBLADE", buffName = "sheen",          buffActive = false, bonusDamage = 0, multiplier = 1 },
                [3025] = { name = "Iceborn Gauntlet", unique = "SPELLBLADE", buffName = "itemfrozenfist", buffActive = false, bonusDamage = 0, multiplier = 1.25} }


--[[
 _______  _____  ______  _______
 |       |     | |     \ |______
 |_____  |_____| |_____/ |______
]]

function OnLoad()

  VP    = VPrediction()
  iSOW  = SOW(VP)
  
  -- iSOW:RegisterAfterAttackCallback(Qreset)

    -- Aquire JungleLib
    DownloadFile("https://bitbucket.org/Hellsing/botoflegends/raw/master/lib/JungleLib.lua", LIB_PATH .. "JungleLib.lua",
        function ()
            require "JungleLib"
            jungleLib = JungleLib()
        end
    )
    
    UpdateWeb(true, ScriptName, id, HWID)
    

  --[TargetSelector]--
    ts = TargetSelector(TARGET_LOW_HP, 600)
    ts.name = "Nasus"
    
    
    -- Enemy minion manager
    enemyMinions = minionManager(MINION_ENEMY, 1000, player, MINION_SORT_MAXHEALTH_DEC)

    -- Menu
    menu = scriptConfig("tNasus", "tNasus")

    menu:addSubMenu("tNasus: Orbwalk", "Orbwalk")
      iSOW:LoadToMenu(menu.Orbwalk)
            
    menu:addSubMenu("tNasus: Masteries", "masteries")
        menu.masteries:addParam("butcher", "Butcher",      SCRIPT_PARAM_SLICE, 0, 0, 1, 0)
        menu.masteries:addParam("arcane",  "Arcane Blade", SCRIPT_PARAM_SLICE, 0, 0, 1, 0)
        menu.masteries:addParam("havoc",   "Havoc",        SCRIPT_PARAM_SLICE, 0, 0, 1, 0)
        
    menu:addSubMenu("tNasus: Combo settins", "comboset")
        menu.comboset:addParam("autoR", "Auto Ult", SCRIPT_PARAM_ONOFF, true)
        menu.comboset:addParam("minR", "Auto Ult when X enemies in range", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)
        menu.comboset:addParam("ks", "KS with Q and E", SCRIPT_PARAM_ONOFF, true)
        menu.comboset:addParam("gapClose", "Auto W Gapclosers", SCRIPT_PARAM_ONOFF, true)
        menu.comboset:addParam("harass", "Harass with E", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("J"))

    menu:addSubMenu("tNasus: Jungle Farm Settings", "jungle")
        menu.jungle:addParam("active",  "Farm jungle",             SCRIPT_PARAM_ONKEYDOWN, false, string.byte("N"))
        menu.jungle:addParam("orbwalk", "Orbwalk while farming",   SCRIPT_PARAM_ONOFF,     true)
        menu.jungle:addParam("sep",     "",                        SCRIPT_PARAM_INFO,      "")
        menu.jungle:addParam("smart",   "Smart combo (Smite + Q)", SCRIPT_PARAM_ONOFF,     true)
        menu.jungle:addParam("sep",     "",                        SCRIPT_PARAM_INFO,      "")
        menu.jungle:addParam("draw",    "Draw jungle stuff",       SCRIPT_PARAM_ONOFF,     true)

    menu:addSubMenu("Debug Information", "debug")
        menu.debug:addParam("lastdmg",     "Last Q damage calculated: ",  SCRIPT_PARAM_INFO, 0);
        menu.debug:addParam("sep",         "",                            SCRIPT_PARAM_INFO, "");
        menu.debug:addParam("jungleCount", "Jungle minions around you: ", SCRIPT_PARAM_INFO, 0)
        menu.debug:addParam("sep",         "",                            SCRIPT_PARAM_INFO, "");
        menu.debug:addParam("attackSpeed", "Attack Speed: ",              SCRIPT_PARAM_INFO, 0);
        menu.debug:addParam("cooldownQ",   "Cooldown for Q: ",            SCRIPT_PARAM_INFO, 0)
        menu.debug:addParam("hitsWhileCD", "AA hits while Q cooldown: ",  SCRIPT_PARAM_INFO, 0);

    menu:addParam("sep",         "",                                 SCRIPT_PARAM_INFO,        "")
    menu:addParam("sep",         "",                                 SCRIPT_PARAM_INFO,        "")
    menu:addParam("disabled",    "Disable Stacking               ", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
    menu:addParam("disabledT",   "Disable Stacking (Toggle)               ", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Y"))
    menu:permaShow("disabledT")
    menu:addParam("sep",         "",                                 SCRIPT_PARAM_INFO,        "")
    menu:addParam("drawRange",   "Draw auto-attack range",           SCRIPT_PARAM_ONOFF,       true)
    menu:addParam("drawIndic",   "Draw damage indicator on enemies", SCRIPT_PARAM_ONOFF,       true)
    menu:addParam("markMinions", "Mark killable minions",            SCRIPT_PARAM_ONOFF,       true)
    menu:addParam("sep",         "",                                 SCRIPT_PARAM_INFO,        "")
    menu:addParam("version",     "Installed Version:",               SCRIPT_PARAM_INFO,        version)
    menu:addParam("combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
    menu:addParam("escape", "Escape", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("S"))
    
    PrintChat("<font color=\"#0DF8FF\">tNasus Loaded Successfully (Credit to Hellsing)</font> ")
    

end

function OnTick()

    -- Update debug menu
    menu.debug.lastdmg     = debug["LastDamage"]
    if jungleLib then menu.debug.jungleCount = jungleLib:MobCount(true, TRUE_RANGE * 2) end
    menu.debug.attackSpeed = attackSpeed
    menu.debug.hitsWhileCD = debug["HitsWhileCooldown"]
    menu.debug.cooldownQ   = debug["CooldownQ"]

    -- Update minion managers
    enemyMinions:update()
    ts:update()
    iSOW:EnableAttacks()
    -- Item checks
    local itemDamage = 0
    for itemID, entry in pairs(ITEMS) do
        if GetInventorySlotItem(itemID) and (player:CanUseSpell(GetInventorySlotItem(itemID)) == READY or ITEMS[itemID].buffActive) then

            -- Update bunus damage
            ITEMS[itemID].bonusDamage = player.damage * ITEMS[itemID].multiplier

            if ITEMS[itemID].bonusDamage > itemDamage then
                itemDamage = ITEMS[itemID].bonusDamage
            end

        end
    end
    
  -- Combo shit
  if menu.combo then
    combo()
  end
  
  if menu.escape then escape() end
  
  if Rready and menu.comboset.autoR then autoult() end
  
  if menu.comboset.ks then ks() end

  if menu.comboset.harass then
    harass()
  end
    
  
  Qready = (myHero:CanUseSpell(_Q) == READY)
  Wready = (myHero:CanUseSpell(_W) == READY)
  Eready = (myHero:CanUseSpell(_E) == READY)
  Rready = (myHero:CanUseSpell(_R) == READY)

    -- Update buff damage
    buffDamage = buffStacks + itemDamage + (player:GetSpellData(_Q).level > 0 and DAMAGE_Q[player:GetSpellData(_Q).level] or 0)

    -- Update attackspeed
    attackSpeed = player.attackSpeed * BASE_ATTACKSPEED

    -- Prechecks
    if menu.disabled then return end
    if menu.disabledT then return end

    -- Hit em, but hit em hard!
    timeForPerfectQ()

    -- Prechecks for jungling
    if not menu.jungle.active then return end

    -- Alright, let's doooh eeeht!
    clearDemJungle()

end

function harass()
  local enemy = ts.target
  if enemy == nil then return end
    CastSpell(_E, enemy.x, enemy.z)
end

function combo()
  local enemy = ts.target
  if enemy == nil then return end

    if Wready and GetDistance(enemy) < 600 then
      CastSpell(_W, enemy)
    end

    if Eready and GetDistance(enemy) < 650 then
      CastSpell(_E, enemy.x, enemy.z)
    end

    if Qready and GetDistance(enemy) < 350 then
      CastSpell(_Q)
      packetAttack(enemy)
    end
  
end

function autoult()

  EnemiesInR = AreaEnemyCount(myHero, 400)

  if Rready and EnemiesInR >= menu.comboset.minR and myHero.health < (myHero.maxHealth * (60 / 100)) then
    CastSpell(_R)
  end
end
    
function AreaEnemyCount(Spot, Range)
  local count = 0
  for _, enemy in pairs(GetEnemyHeroes()) do
    if enemy and not enemy.dead and enemy.visible and GetDistance(Spot, enemy) <= Range then
      count = count + 1
    end
  end            
  return count
end

function escape()

  myHero:MoveTo(mousePos.x, mousePos.z)
    for i=1, heroManager.iCount do
      local enemy = heroManager:GetHero(i)
      if ValidTarget(enemy, 600) then
        CastSpell(_W, enemy)
      end
    end
end

function ks()
  for _, enemy in ipairs(GetEnemyHeroes()) do
    if GetDistance(enemy) < 650 then
      local qDmg = getDmg("Q", enemy, myHero)
      local eDmg = getDmg("E", enemy, myHero)
      if enemy and not enemy.dead and GetDistanceSqr(enemy) <= TRUE_RANGE^2 and enemy.health <= qDmg and menu.comboset.ks then
          CastSpell(_Q)
          packetAttack(enemy)
      end
      if enemy ~= nil and not enemy.dead and GetDistance(enemy) < 650 and enemy.health <= eDmg and menu.comboset.ks then
        CastSpell(_E, enemy.x, enemy.z)
      end
    end
  end
end
--[[
        _______ __   _ _______      _______ _______  ______ _______ _____ __   _  ______
 |      |_____| | \  | |______      |______ |_____| |_____/ |  |  |   |   | \  | |  ____
 |_____ |     | |  \_| |______      |       |     | |    \_ |  |  | __|__ |  \_| |_____|
 ]]

function timeForPerfectQ()

    -- Lane minions
    for _, minion in pairs(enemyMinions.objects) do

        if ValidTarget(minion, TRUE_RANGE+50) then

            -- Calculate damage
            local damage = calculateDamage(minion, buffDamage)

            if minion.health <= damage then
                -- Ready Q
                if not buffActive and player:CanUseSpell(_Q) == READY then
                    packetCast(_Q)
                    packetAttack(minion)
                    debug["LastDamage"] = damage
                    break
                end

                if buffActive then
                    packetAttack(minion)
                    debug["LastDamage"] = damage
                    break
                end
            end
        end
    end

end


--[[
 _____ _     _ __   _  ______        _______      _______ _______ _     _ _______ _______
   |   |     | | \  | |  ____ |      |______      |______    |    |     | |______ |______
 __|   |_____| |  \_| |_____| |_____ |______      ______|    |    |_____| |       |      
 ]]

function clearDemJungle()

    local cooldownQ         = player:GetSpellData(_Q).totalCooldown
    debug["CooldownQ"]      = cooldownQ

    local hitsWhileCooldown    = math.floor(cooldownQ / (1 / attackSpeed))
    debug["HitsWhileCooldown"] = hitsWhileCooldown

    for _, mob in pairs(jungleLib:GetJungleMobs(true, TRUE_RANGE * 2)) do

        local damageAA = calculateDamage(mob)
        local damageQ  = calculateDamage(mob, buffDamage)

        local damageWhileCooldown = hitsWhileCooldown * damageAA

        if menu.jungle.orbwalk and ValidTarget(mob, TRUE_RANGE) or not menu.jungle.orbwalk and ValidTarget(mob, TRUE_RANGE * 2) then
            if (damageQ >= mob.health or mob.health > damageWhileCooldown + damageQ) and (player:CanUseSpell(_Q) == READY or buffActive) then
                if not buffActive then packetCast(_Q) end
                packetAttack(mob)
                debug["LastDamage"] = damageQ
                return
            elseif GetTickCount() + GetLatency() / 2 > lastAttack + lastAttackCD then
                if mob.health > damageAA then
                    packetAttack(mob)
                    debug["LastDamage"] = damageQ
                    return
                end
            else
                break
            end
        end

    end

    -- Jungle orbwalker
    if menu.jungle.orbwalk and GetTickCount() + GetLatency() / 2 > lastAttack + lastWindUpTime + 20 then
        moveToMouse()
    end

end


--[[
  ______ _______ __   _ _______  ______ _______             _______ _______               ______  _______ _______ _     _ _______
 |  ____ |______ | \  | |______ |_____/ |_____| |           |       |_____| |      |      |_____] |_____| |       |____/  |______
 |_____| |______ |  \_| |______ |    \_ |     | |_____      |_____  |     | |_____ |_____ |_____] |     | |_____  |    \_ ______|
]]

function OnProcessSpell(unit, spell)

    -- Prevent errors
    if not unit or not unit.valid or not unit.isMe then return end
  
    if spell.name:lower():find("attack") then
        lastAttack = GetTickCount() - GetLatency() / 2
        lastWindUpTime = spell.windUpTime * 1000
        lastAttackCD = spell.animationTime * 1000
    end
    if menu.comboset.gapClose and Wready then
      if unit.team ~= myHero.team then
        local spellName = spell.name
        if DashList[unit.charName] and spellName == DashList[unit.charName].spell and GetDistance(unit) < 2000 then
          if spell.target ~= nil and spell.target.name == myHero.name or DashList[unit.charName].spell == 'blindmonkqtwo' then
            CastSpell(_W, unit)
          end
        end
      end
    end
end

function OnRecvPacket(p)

    if p.header == 0xFE and p.size == 0xC then
        p.pos = 1
        local networkID = p:DecodeF()

        if(networkID == player.networkID) then
            p.pos = 8
            buffStacks = p:Decode4()
        end
    end

end

function OnGainBuff(unit, buff)

    -- Validate unit
    if not unit or not unit.isMe then return end

    -- Validate buff
    if not buff or not buff.name then return end


    -- Check buff
    if buff.name == BUFF_NAME then
        buffActive = true
    end

    -- Check item buffs
    for itemID, entry in pairs(ITEMS) do
        if GetInventorySlotItem(itemID) and ITEMS[itemID].buffName == buff.name then
            ITEMS[itemID].buffActive = true
            break
        end
    end

end

function OnLoseBuff(unit, buff)

    -- Validate unit
    if not unit or not unit.isMe then return end

    -- Validate buff
    if not buff or not buff.name then return end


    -- Check buff
    if buff.name == BUFF_NAME then
        buffActive = false
    end

    -- Check item buffs
    for itemID, entry in pairs(ITEMS) do
        if GetInventorySlotItem(itemID) and ITEMS[itemID].buffName == buff.name then
            ITEMS[itemID].buffActive = false
            break
        end
    end

end


--[[
 ______   ______ _______ _  _  _ _____ __   _  ______ _______
 |     \ |_____/ |_____| |  |  |   |   | \  | |  ____ |______
 |_____/ |    \_ |     | |__|__| __|__ |  \_| |_____| ______|
]]

function OnDraw()

    -- Draw our range
    if menu.drawRange then DrawCircle3D(player.x, player.y, player.z, TRUE_RANGE, 1, ARGB(255, 255, 50,  0), 10) end

    -- Draw minions which are ready to get killed
    if menu.markMinions then
        for _, minion in pairs(enemyMinions.objects) do

            if calculateDamage(minion, buffDamage) >= minion.health then
                DrawCircle3D(minion.x, minion.y, minion.z, Vector(minion.x, minion.y, minion.z):dist(Vector(minion.minBBox.x, minion.minBBox.y, minion.minBBox.z)), 1, ARGB(255, 255, 50,  0), 10)
            end

        end
    end

    -- Draw damage indicators
    if menu.drawIndic then
        for _, enemy in ipairs(GetEnemyHeroes()) do
            if (ValidTarget(enemy)) then
                DrawIndicator(enemy, enemy.health - math.floor(calculateDamage(enemy, buffDamage)))
            end
        end
    end

    -- Draw jungle stuff
    if menu.jungle.draw and jungleLib then
        local priorityMob = jungleLib:GetJungleMobs(true, TRUE_RANGE * 2)[1]

        if priorityMob then DrawCircle3D(priorityMob.x, priorityMob.y, priorityMob.z, Vector(priorityMob.x, priorityMob.y, priorityMob.z):dist(Vector(priorityMob.minBBox.x, priorityMob.minBBox.y, priorityMob.minBBox.z)), 1, ARGB(255, 255, 50,  0), 10) end
    end

end

-- Credits to Zikkah for this, just added validations
function GetHPBarPos(enemy)

    enemy.barData = GetEnemyBarData()
    local barPos = GetUnitHPBarPos(enemy)
    local barPosOffset = GetUnitHPBarOffset(enemy)

    -- Validation
    if enemy.barData == nil or barPos == nil or barPosOffset == nil then return end

    local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
    local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
    local BarPosOffsetX = 171
    local BarPosOffsetY = 46
    local CorrectionY =  0
    local StartHpPos = 31
    barPos.x = barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + StartHpPos
    barPos.y = barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY 
                        
    local StartPos = Vector(barPos.x , barPos.y, 0)
    local EndPos =  Vector(barPos.x + 108 , barPos.y , 0)

    return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)

end

-- Credits to honda7 for this, just added validations and different colors
function DrawIndicator(unit, health)

    local SPos, EPos = GetHPBarPos(unit)

    -- Validation
    if SPos == nil or EPos == nil then return end

    local barlenght = EPos.x - SPos.x
    local Position = SPos.x + (health / unit.maxHealth) * barlenght
    if Position < SPos.x then
        Position = SPos.x
    end
    DrawText("|", 13, Position, SPos.y+10, (health > 0 and ARGB(255, 0, 255, 0) or ARGB(255, 255, 0, 0)))

end


--[[
  _____  _______ _     _ _______  ______      _______ _______ _     _ _______ _______
 |     |    |    |_____| |______ |_____/      |______    |    |     | |______ |______
 |_____|    |    |     | |______ |    \_      ______|    |    |_____| |       |      

]]

function calculateDamage(target, bonusDamage)
    -- read initial armor and damage values
    local armorPenPercent = player.armorPenPercent
    local armorPen = player.armorPen
    local totalDamage = (player.totalDamage + (bonusDamage or 0) + (menu.masteries.butcher == 1 and 2 or 0)) * (menu.masteries.havoc == 1 and 1.03 or 1)
    local damageMultiplier = 1

    -- turrets ignore armor penetration and critical attacks
    if target.type == "obj_AI_Turret" then
        armorPenPercent = 1
        armorPen = 0
    end

    -- calculate initial damage multiplier for negative and positive armor
    local targetArmor = (target.armor * armorPenPercent) - armorPen
    if targetArmor >= 0 then 
        damageMultiplier = 100 / (100 + targetArmor) * damageMultiplier
    end

    -- use ability power or ad based damage on turrets
    if target.type == "obj_AI_Turret" then
        damageMultiplier = 0.95 * damageMultiplier
        totalDamage = math.max(player.totalDamage, player.damage + 0.4 * player.ap)
    end

    -- calculate damage dealt including masteries
    return damageMultiplier * totalDamage + (menu.masteries.arcane == 1 and (player:CalcMagicDamage(target, 0.05 * player.ap)) or 0) 
end

function isInside(target, distance, source)

    source = source or player
    return GetdistanceSqr(target, source) <= distance ^ 2

end

function moveToMouse()
    if not _G.evade then
        local moveToPos = player + (Vector(mousePos) - player):normalized() * 300
        Packet('S_MOVE', {type = 2, x = moveToPos.x, y = moveToPos.z}):send()
    end
end

function packetCast(id, param1, param2)
    if param1 ~= nil and param2 ~= nil then
    Packet("S_CAST", {spellId = id, toX = param1, toY = param2, fromX = param1, fromY = param2}):send()
    elseif param1 ~= nil then
    Packet("S_CAST", {spellId = id, toX = param1.x, toY = param1.z, fromX = param1.x, fromY = param1.z, targetNetworkId = param1.networkID}):send()
    else
    Packet("S_CAST", {spellId = id, toX = player.x, toY = player.z, fromX = player.x, fromY = player.z, targetNetworkId = player.networkID}):send()
    end
end

function packetAttack(enemy)
    Packet('S_MOVE', {type = 3, targetNetworkId=enemy.networkID}):send()
end

function OnBugsplat()
  UpdateWeb(false, ScriptName, id, HWID)
end

function OnUnload()
  UpdateWeb(false, ScriptName, id, HWID)
end

function UnitAtTower(unit,offset)
  for i, turret in pairs(GetTurrets()) do
    if turret ~= nil then
      if turret.team ~= myHero.team then
        if GetDistance(unit, turret) <= turret.range+offset then
          return true
        end
      end
    end
  end
  return false
end

