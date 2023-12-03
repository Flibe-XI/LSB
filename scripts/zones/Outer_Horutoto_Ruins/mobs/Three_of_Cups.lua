-----------------------------------
-- Area: Outer Horutoto Ruins
--  Mob: Three of Cups
-----------------------------------
local entity = {}

entity.onMobDeath = function(mob, player, optParams)
    xi.amk.helpers.cardianOrbDrop(mob, player, xi.ki.ORB_OF_CUPS)
    xi.regime.checkRegime(player, mob, 664, 2, xi.regime.type.GROUNDS)
end

return entity
