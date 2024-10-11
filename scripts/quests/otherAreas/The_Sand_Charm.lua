-----------------------------------
-- The Sand Charm
-----------------------------------
-- Log ID: 4, Quest ID: 8
-- Blandine  : !pos 23 -7 41 249
-- Zexu      : !pos 31.511 -9.001 23.496 249
-- Celestina : !pos -37.624 -16.050 75.681 249
-----------------------------------

local quest = Quest:new(xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.THE_SAND_CHARM)

quest.reward =
{
    exp      = 2000,
    gil      = 2000,
    ki       = xi.ki.MAP_OF_BOSTAUNIEUX_OUBLIETTE,
    fameArea = xi.fameArea.WINDURST,
}

quest.sections =
{
    {
        check = function(player, status, vars)
            xPos = player:getXPos()
            zPos = player:getZPos()

            return status == xi.questStatus.QUEST_AVAILABLE and
                player:getFameLevel(xi.fameArea.WINDURST) >= 4
        end,

        [xi.zone.SELBINA] =
        {
            ['Blandine'] =
            {
                onTrigger = function(player, npc)
                    xPos = player:getXPos()
                    zPos = player:getZPos()

                    if (zPos <= 29 or zPos >= 38 or xPos <= 16 or xPos >= 32) then
                        if quest:getVar(player, 'status') == 0 then
                            return quest:progressEvent(125)
                        elseif quest:getVar(player, 'status') == 2 then
                            return quest:progressEvent(124)
                        end
                    end
                end,
            },

            ['Zexu'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'status') == 1 then
                        return quest:progressEvent(123)
                    end
                end,
            },

            ['Celestina'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'status') == 3 then
                        return quest:progressEvent(126, xi.item.SAND_CHARM)
                    end
                end,
            },

            onEventFinish =
            {
                [123] = function(player, csid, option, npc)
                    quest:setVar(player, 'status', 2)
                end,

                [124] = function(player, csid, option, npc)
                    quest:setVar(player, 'status', 3)
                end,

                [125] = function(player, csid, option, npc)
                    quest:setVar(player, 'status', 1)
                end,

                [126] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == xi.questStatus.QUEST_ACCEPTED
        end,

        [xi.zone.MHAURA] =
        {
            ['Celestina'] =
            {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHas(trade, xi.item.SAND_CHARM) then
                        return quest:event(127, 0, xi.item.SAND_CHARM)
                    end
                end,
            },

            onEventFinish =
            {
                [127] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        quest:setVar(player, 'SmallDialogByBlandine', 1)
                    end
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == xi.questStatus.QUEST_COMPLETED
        end,

        [xi.zone.MHAURA] =
        {
            ['Blandine'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'SmallDialogByBlandine') == 1 then
                        return quest:event(128)
                    else
                        return quest:event(129):replaceDefault()
                    end
                end,
            },

            onEventFinish =
            {
                [128] = function(player, csid, option, npc)
                    quest:setVar(player, 'SmallDialogByBlandine', 0)
                end,
            },
        },
    },
}

return quest
