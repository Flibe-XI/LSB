-----------------------------------
-- ID: 5329
-- Item: Tarutaru snare
-- Used in Pirates Chart quest
-- When used on one of the quest nms, lowers its damage to 1 for 60 seconds
-----------------------------------
---@type TItem
local itemObject = {}

itemObject.onItemCheck = function(target, item, param, caster)
    return xi.piratesChart.onItemCheck(target, item, param, caster)
end

itemObject.onItemUse = function(target)
    target:setDmgMultiplier(1)
    target:timer(60000, function(mobArg)
        if mobArg then
            mobArg:setDmgMultiplier(100)
        end
    end)
end

return itemObject
