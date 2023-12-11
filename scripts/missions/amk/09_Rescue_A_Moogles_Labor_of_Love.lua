-----------------------------------
-- Rescue! A Moogle's Labor of Love
-- A Moogle Kupo d'Etat M9
-- !addmission 10 8
-- Geologist cutscene args : csid, progress, has QC map: 1 or 0, markerset: 1-10
-- Goblin Geologist        : !pos -737 -6 -550 208
-- STONE_OF_SURYA          : !addkeyitem 1145
-- STONE_OF_CHANDRA        : !addkeyitem 1146
-- STONE_OF_MANGALA        : !addkeyitem 1147
-- STONE_OF_BUDHA          : !addkeyitem 1148
-- STONE_OF_BRIHASPATI     : !addkeyitem 1149
-- STONE_OF_SHUKRA         : !addkeyitem 1150
-- STONE_OF_SHANI          : !addkeyitem 1151
-- STONE_OF_RAHU           : !addkeyitem 1152
-- STONE_OF_KETU           : !addkeyitem 1153
-- NAVARATNA_TALISMAN      : !addkeyitem 1158
-----------------------------------
require('scripts/globals/missions')
require('scripts/globals/interaction/mission')
local ID = zones[xi.zone.QUICKSAND_CAVES]
-----------------------------------

local mission = Mission:new(xi.mission.log_id.AMK, xi.mission.id.amk.RESCUE_A_MOOGLES_LABOR_OF_LOVE)

mission.reward =
{
    nextMission = { xi.mission.log_id.AMK, xi.mission.id.amk.ROAR_A_CAT_BURGLAR_BARES_HER_FANGS },
}

local markerIds = {
 -- [qm#] = marker ID
    [1]  = 17629668,
    [8]  = 17629752,
    [9]  = 17629753,
    [10] = 17629754,
    [11] = 17629755,
    [12] = 17629756,
    [13] = 17629757,
    [14] = 17629758,
    [15] = 17629759,
    [16] = 17629760,
    [17] = 17629761,
    [18] = 17629762,
    [19] = 17629763,
    [20] = 17629764,
    [21] = 17629765,
    [22] = 17629766,
    [23] = 17629767,
    [24] = 17629768,
    [26] = 17629770,
    [27] = 17629771,
}

local markerSets = {
    {1, 8,  11, 13, 14, 17, 20, 26, 27},
    {9, 10, 12, 15, 17, 19, 22, 23, 24},
    {8, 12, 13, 14, 16, 18, 21, 26, 27},
    {1, 9,  10, 11, 14, 15, 16, 23, 24},
    {8, 10, 13, 17, 18, 19, 21, 22, 27},
    {1, 9,  11, 12, 14, 15, 20, 24, 26},
    {8, 11, 13, 16, 17, 18, 21, 22, 23},
    {1, 9,  10, 12, 14, 19, 20, 23, 27},
    {8, 10, 13, 15, 16, 17, 22, 24, 26},
    {9, 11, 12, 18, 19, 20, 21, 24, 27},
}

local getMarkerSet = function(player)
    -- markerSet is the setIndex of a random table within markerSets defined above
    local markerSet = player:getCharVar('Mission[10][8]markerSet')
    if markerSet == 0 then
        markerSet = math.random(1, #markerSets)
        player:setCharVar('Mission[10][8]markerSet', markerSet)
    end

    return markerSet
end

local hasAllStones = function(player)
    for offset = 0, 8 do
        if not player:hasKeyItem(xi.ki.STONE_OF_SURYA + offset) then
            return false
        end
    end

    return true
end


mission.sections =
{
    -- 0: Initiate quest, get markers
    {
        check = function(player, currentMission, missionStatus, vars)
            return currentMission == mission.missionId and
            player:getCharVar('Mission[10][8]progress') == 0
        end,

        [xi.zone.QUICKSAND_CAVES] =
        {
            ['Goblin_Geologist'] =
            {
                onTrigger = function(player, npc)
                    local hasMap = player:hasKeyItem(xi.ki.MAP_OF_THE_QUICKSAND_CAVES) and 1 or 0
                    return mission:progressEvent(100, 0, hasMap, getMarkerSet(player))
                end,
            },

            onEventFinish =
            {
                [100] = function(player, csid, option, npc)
                    player:setCharVar('Mission[10][8]progress', 1)
                end,
            },
        },
    },

    -- 1: Have Markers, don't have all stones
    {
        check = function(player, currentMission, missionStatus, vars)
            return currentMission >= mission.missionId and
                player:getCharVar('Mission[10][8]progress') == 1 and
                not hasAllStones(player) and
                not player:hasKeyItem(xi.ki.NAVARATNA_TALISMAN)
        end,

        [xi.zone.QUICKSAND_CAVES] =
        {
            ['Goblin_Geologist'] =
            {
                onTrigger = function(player, npc)
                    local hasMap = player:hasKeyItem(xi.ki.MAP_OF_THE_QUICKSAND_CAVES) and 1 or 0
                    return mission:progressEvent(100, 2, hasMap, getMarkerSet(player))
                end,
            },

            ['qmAMK'] =
            {
                onTrigger = function(player, npc)
                    -- Get set of markers assigned by geologist
                    local amkMarkerSet = player:getCharVar('Mission[10][8]markerSet')
                    if amkMarkerSet == 0 then
                        return mission:messageSpecial(ID.text.NOTHING_OUT_OF_ORDINARY)
                    end

                    -- Determine if QM triggered is in markerset
                    local item = 0
                    for setIndex = 1, 9 do
                        local markerIdIndex = markerSets[amkMarkerSet][setIndex]
                        if npc:getID() == markerIds[markerIdIndex] then
                            item = xi.ki.STONE_OF_SURYA + setIndex - 1
                        end
                    end

                    -- Give KI if QM is correct
                    if item ~= 0 and not player:hasKeyItem(item) then
                        player:addKeyItem(item)
                        return mission:messageSpecial(ID.text.KEYITEM_OBTAINED, item)
                    end
                end,
            },
        },
    },

    -- 2: Have all stones, award talisman
    {
        check = function(player, currentMission, missionStatus, vars)
            return currentMission >= mission.missionId and
                hasAllStones(player) and
                not player:hasKeyItem(xi.ki.NAVARATNA_TALISMAN)
        end,

        [xi.zone.QUICKSAND_CAVES] =
        {
            ['Goblin_Geologist'] =
            {
                onTrigger = function(player, npc)
                    local hasMap = player:hasKeyItem(xi.ki.MAP_OF_THE_QUICKSAND_CAVES) and 1 or 0
                    return mission:progressEvent(100, 1, hasMap, 0)
                end,
            },

            onEventFinish =
            {
                [100] = function(player, csid, option, npc)
                    for i = 0, 8 do
                        player:delKeyItem(xi.ki.STONE_OF_SURYA + i)
                    end

                    player:setCharVar('Mission[10][8]markerSet', 0)
                    npcUtil.giveKeyItem(player, xi.ki.NAVARATNA_TALISMAN)
                end,
            },
        },
    },

    -- 3: Have talisman, CS at shimmering cicle
    {
        check = function(player, currentMission, missionStatus, vars)
            return currentMission == mission.missionId and
                player:hasKeyItem(xi.ki.NAVARATNA_TALISMAN)
        end,

        [xi.zone.QUICKSAND_CAVES] =
        {
            ['Goblin_Geologist'] =
            {
                onTrigger = function(player, npc)
                    player:messageSpecial(ID.text.GRANT_YOU_EASY_ENTRANCE, xi.ki.NAVARATNA_TALISMAN)
                end,
            },
        },

        [xi.zone.CHAMBER_OF_ORACLES] =
        {
            ['Shimmering_Circle'] =
            {
                onTrigger = function(player, npc)
                    return mission:progressEvent(5)
                end
            },

            onEventFinish =
            {
                [5] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
