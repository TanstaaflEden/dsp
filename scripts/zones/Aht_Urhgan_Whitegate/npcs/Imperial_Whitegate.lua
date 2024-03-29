-----------------------------------
-- Area: Aht Urhgan Whitegate
--  NPC: Imperial Whitegate
-- pos: 152, -2, 0, 50
-----------------------------------
require("scripts/globals/missions")
require("scripts/globals/status")
require("scripts/globals/titles")
require("scripts/globals/besieged")
require("scripts/globals/npc_util")
require("scripts/zones/Aht_Urhgan_Whitegate/Shared")
local ID = require("scripts/zones/Aht_Urhgan_Whitegate/IDs")
-----------------------------------

function onTrade(player,npc,trade)
end

function onTrigger(player,npc)
    if player:getEquipID(dsp.slot.MAIN) == 0 and player:getEquipID(dsp.slot.SUB) == 0 then
        if player:getCurrentMission(TOAU) == GUESTS_OF_THE_EMPIRE and player:getVar("AhtUrganStatus") == 1 and
                doRoyalPalaceArmorCheck(player) == true then
            player:startEvent(3078,0,1,0,0,0,0,0,1,0)
        elseif player:getCurrentMission(TOAU) == SEAL_OF_THE_SERPENT then
            player:startEvent(3111)
        elseif player:getCurrentMission(TOAU) == IMPERIAL_CORONATION and
                doRoyalPalaceArmorCheck(player) == true then
            player:startEvent(3140,getMercenaryRank(player),player:getTitle(),0,0,0,0,0,0,0)
        elseif player:getCurrentMission(TOAU) >= IMPERIAL_CORONATION and
                doRoyalPalaceArmorCheck(player) == true then
            local ring = player:getVar("TOAU_RINGTIME")
            local standard = player:hasItem(129)

            local ringParam = 0

            if ring == 0 then
                ringParam = 1
            end

            local standardParam = 0

            if standard == false then
                standardParam = 1
            end

            if ringParam > 0 or standardParam > 0 then
                player:startEvent(3155,standardParam,ringParam,0,0,0,0,0,0,0)
            end
        end
    end
end

function onEventUpdate(player,csid,option)
    if csid == 3140 or csid == 3155 then
        if option == 1 and npcUtil.giveItem(player,15807) then
            player:setVar("TOAU_RINGTIME", os.time())
            player:setVar("TOAU_RINGRECV", 1)
        elseif option == 2 and npcUtil.giveItem(player,15808) then
            player:setVar("TOAU_RINGTIME", os.time())
            player:setVar("TOAU_RINGRECV", 1)
        elseif option == 3 and npcUtil.giveItem(player,15809) then
            player:setVar("TOAU_RINGTIME", os.time())
            player:setVar("TOAU_RINGRECV", 1)
        elseif option == 4 then
            npcUtil.giveItem(player,129)
        elseif option == 99 then
            player:updateEvent(15807,15808,15809)
        end
    end
end

function onEventFinish(player,csid,option)
    if csid == 3078 and npcUtil.giveItem(player,2186) then
        player:completeMission(TOAU,GUESTS_OF_THE_EMPIRE)
        player:setVar("AhtUrganStatus",0)
        player:addTitle(dsp.title.OVJANGS_ERRAND_RUNNER)
        player:needToZone(true)
        player:setVar("TOAUM18_STARTDAY", VanadielDayOfTheYear())
        player:addMission(TOAU,PASSING_GLORY)
    elseif csid == 3111 then
        player:completeMission(TOAU,SEAL_OF_THE_SERPENT)
        player:addMission(TOAU,MISPLACED_NOBILITY)
    elseif csid == 3140 and player:getVar("TOAU_RINGRECV") == 1 then
        player:completeMission(TOAU,IMPERIAL_CORONATION)
        player:addMission(TOAU,THE_EMPRESS_CROWNED)
        player:setVar("TOAU_RINGRECV", 0)
    elseif csid == 3155 and option == 6 then
        npcUtil.giveItem(player,129)
    end
end
