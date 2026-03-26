-----------------------------------
-- Area: Buburimu Peninsula
--  Mob: Puffer Pugil
-- Single mob possible to catch during Brigand's Chart quest
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.IDLE_DESPAWN, 180)
end

return entity
