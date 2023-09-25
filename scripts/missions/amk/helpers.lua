-----------------------------------
-- A Moogle Kupo d'Etat Helpers
-----------------------------------
xi = xi or {}
xi.amk = xi.amk or {}
xi.amk.helpers = xi.amk.helpers or {}

local validRegions = set{
    xi.region.RONFAURE,
    xi.region.ZULKHEIM,
    xi.region.NORVALLEN,
    xi.region.GUSTABERG,
    xi.region.DERFLAND,
    xi.region.SARUTABARUTA,
    xi.region.KOLSHUSHU,
    xi.region.ARAGONEU,
    xi.region.FAUREGANDI,
    xi.region.VALDEAUNIA,
    xi.region.QUFIMISLAND,
    xi.region.LITELOR,
    xi.region.KUZOTZ,
    xi.region.VOLLBOW,
    xi.region.ELSHIMOLOWLANDS,
    xi.region.ELSHIMOUPLANDS,
    xi.region.SANDORIA,
    xi.region.BASTOK,
    xi.region.WINDURST,
    xi.region.JEUNO,
    xi.region.DYNAMIS,
}

xi.amk.helpers.helmTrade = function(player, helmType, broke)
    local amkChance = 5
    local regionId = player:getCurrentRegion()

    if
        player:getCurrentMission(xi.mission.log_id.AMK) == xi.mission.id.amk.WELCOME_TO_MY_DECREPIT_DOMICILE and
        broke ~= 1
    then
        if
            helmType == xi.helm.type.MINING and
            not player:hasKeyItem(xi.ki.STURDY_METAL_STRIP) and
            validRegions[regionId] and
            math.random(1, 100) <= amkChance
        then
            npcUtil.giveKeyItem(player, xi.ki.STURDY_METAL_STRIP)
        elseif
            helmType == xi.helm.type.LOGGING and
            not player:hasKeyItem(xi.ki.PIECE_OF_RUGGED_TREE_BARK) and
            validRegions[regionId] and
            math.random(1, 100) <= amkChance
        then
            npcUtil.giveKeyItem(player, xi.ki.PIECE_OF_RUGGED_TREE_BARK)
        elseif
            helmType == xi.helm.type.HARVESTING and
            not player:hasKeyItem(xi.ki.SAVORY_LAMB_ROAST) and
            validRegions[regionId] and
            math.random(1, 100) <= amkChance
        then
            npcUtil.giveKeyItem(player, xi.ki.SAVORY_LAMB_ROAST)
        end
    end
end

local digZoneIds =
{
    xi.zone.VALKURM_DUNES,
    xi.zone.JUGNER_FOREST,
    xi.zone.KONSCHTAT_HIGHLANDS,
    xi.zone.PASHHOW_MARSHLANDS,
    xi.zone.TAHRONGI_CANYON,
    xi.zone.BUBURIMU_PENINSULA,
    xi.zone.MERIPHATAUD_MOUNTAINS,
    xi.zone.THE_SANCTUARY_OF_ZITAH,
    xi.zone.YUHTUNGA_JUNGLE,
    xi.zone.YHOATOR_JUNGLE,
    xi.zone.WESTERN_ALTEPA_DESERT,
    xi.zone.EASTERN_ALTEPA_DESERT,
}

-- AMK07 - Select/lookup the digging zone
xi.amk.helpers.getDiggingZone = function(player)
    local diggingZone = player:getCharVar('AMK6_DIGGING_ZONE')
    if diggingZone == 0 then
        -- 1 = Valkurm Dunes
        -- 2 = Jugner Forest
        -- 3 = Konschtat Highlands
        -- 4 = Pashhow Marshlands
        -- 5 = Tahrongi Canyon
        -- 6 = Buburimu Peninsula
        -- 7 = Meriphataud Mountains
        -- 8 = The Sanctuary of Zi'tah
        -- 9 = Yuhtunga Jungle
        -- 10 = Yhoator Jungle
        -- 11 = Western Altepa Desert
        -- 12 = Eastern Altepa Desert
        diggingZone = math.random(1, 12)
        player:setCharVar('AMK6_DIGGING_ZONE', diggingZone)
    end

    return diggingZone
end

xi.amk.helpers.digSites =
{
    -- NOTE: These have been picked at random, and not checked against
    --       possible points that might exist in retail
    -- la theine
    [0] =
    {
    -- (L-10)
    -- (F-7)
    -- (F-9)
    -- (G-8)
    -- (D-7)
    -- (G-11)
    -- (G-6) (NW corner of carby circle)
    -- (K-5) (on  a small gray patchin the grass)
    -- (K-10) (SE corner bottom of ramp)
    -- (G-11) (small gray plot near edge of cliffer
    -- (I-11) (slightly to left of lone tree)
    },

    -- 1 = Valkurm Dunes
    [1] =
    {
        -- (B-7)
        -- (H-8)
        -- (E-7)
        -- (D-7)
        -- (D-6) (ne corner near tree)
        -- (J-7) (5 yalms from flowers near a laorge rock)
        -- (K-8) (on corner of road)
        -- (F-7) (next to root closest to trees)

        
    },
    -- 2 = Jugner Forest
    [2] =
    {
        -- (K-6)
        -- (G-7) (nw corner)
        -- (G-8) (SW corner)
        -- (G-9) (W side)
        -- (I-5)
        -- (I-9)
        -- (J-5)
        -- (L-7)
    },
    -- 3 = Konschtat Highlands
    [3] =
    {
        -- (E-6)
        -- (E-9) (center a bit NW of big rock)
        -- (F-5)
        -- (G-9)
        -- (G-12)
        -- (K-5)
        -- (K-7)
        -- (H-5)
        -- (H-12)
        -- (J-4)
        
    },
    -- 4 = Pashhow Marshlands
    [4] =
    {
        -- (L-7)
        -- (K-6)
        -- (I-7)
        -- (I-8)
        -- (H-6)
        -- (G-7/8)
        -- (F-5)
        -- (E/F-10)
        -- (K-10)
    },
    -- 5 = Tahrongi Canyon
    [5] =
    {
        -- (H-4) (Center)
        -- (H-9)
        -- (H-10)
        -- (E-9)
        -- (G-4)
        -- (I-7)
        -- (J-7)
        -- (I-9)
        -- (J-10) SW corner near a green patch
        -- (F-5) SW corner on a green patch
        -- (G-9) NW corner
        -- (F-6) directly on center of grid
    },
    -- 6 = Buburimu Peninsula
    [6] =
    {
        -- (G-9)
        -- (E-9)
        -- (F-6)
        -- (F-8)
        -- (J-6)
        -- (J-7)
        -- (H-6)
        -- (F-9)
        -- (K-9)
    },
    -- 7 = Meriphataud Mountains
    [7] =
    {
        -- (J-4)
        -- (H-11)
        -- (H-3)
        -- (K-10)
        -- (K-7)
        -- (D-8)
        -- (D-6) W of center
        -- (H-5) NW corner
        -- (D-10)
        -- (H-7) Middle on top of little ledge
    },
    -- 8 = The Sanctuary of Zi'tah
    [8] =
    {
        { x = 421, z = -303 },
    },
    -- 9 = Yuhtunga Jungle
    [9] =
    {
        { x = -162, z = 250 },
    },
    -- 10 = Yhoator Jungle
    [10] =
    {
        { x = 198, z = -487 },
    },
    -- 11 = Western Altepa Desert
    [11] =
    {
        { x = -37, z = 398 },
    },
    -- 12 = Eastern Altepa Desert
    [12] =
    {
        { x = 14, z = 187 },
    },
}

xi.amk.helpers.tryRandomlyPlaceDiggingLocation = function(player)
    local diggingZoneOffset = xi.amk.helpers.getDiggingZone(player)
    local diggingSiteTable  = xi.amk.helpers.digSites[diggingZoneOffset]

    player:setLocalVar('AMK_DIG_SITE_INDEX', math.random(1, #diggingSiteTable))
end

xi.amk.helpers.chocoboDig = function(player, zoneID, text)
    local diggingZoneOffset = xi.amk.helpers.getDiggingZone(player)

    if
        player:hasKeyItem(xi.ki.MOLDY_WORM_EATEN_CHEST) or
        player:getZoneID() ~= digZoneIds[diggingZoneOffset]
    then
        return false
    end

    local playerPos = player:getPos()

    -- Get target position from the digSites table using AMK_DIG_SITE_INDEX
    local diggingSiteTable  = xi.amk.helpers.digSites[diggingZoneOffset]
    local digSiteIndex      = player:getLocalVar('AMK_DIG_SITE_INDEX')

    local targetPos = diggingSiteTable[digSiteIndex]
    local targetX   = targetPos.x
    local targetZ   = targetPos.z

    local distance = player:checkDistance(targetX, playerPos.y, targetZ)

    -- Success!
    if distance < 2.5 then
        npcUtil.giveKeyItem(player, xi.ki.MOLDY_WORM_EATEN_CHEST)
        return true
    end

    -- Angle between points
    -- NOTE: This is mapped to 0-255
    local angle = player:getWorldAngle(targetX, playerPos.y, targetZ)

    -- Map angle from 0-255 to 0-7 for the messageSpecial arg, with a small offset for cardinal direction
    local offset = 255 / 8
    local direction = math.floor(((7 - 0) / (255 - 0)) * ((angle + offset) - 0))

    -- Your Chocobo is pulling at the bit
    -- You Sense that it is leading you to the [compass direction]
    player:messageSpecial(text.AMK_DIGGING_OFFSET + 6, direction)

    -- No additional hint (Approx: 201'+ from target)
    if distance > 200 then
    -- You have a hunch this area would be favored by moogles... (Approx. 81-200' from target or two map grids)
    elseif distance > 80 then
        player:messageSpecial(text.AMK_DIGGING_OFFSET + 5, direction)
    -- You have a vague feeling that a moogle would enjoy traversing this terrain... (Approx. 51-80' from target)
    elseif distance > 50 then
        player:messageSpecial(text.AMK_DIGGING_OFFSET + 4, direction)
    -- You suspect that the scenery around here would be to a moogle's liking... (Approx. 21-50' from target)
    elseif distance > 20 then
        player:messageSpecial(text.AMK_DIGGING_OFFSET + 3, direction)
    -- You have a feeling your moogle friend has been through this way... (Approx. 11-20' from target)
    elseif distance > 10 then
        player:messageSpecial(text.AMK_DIGGING_OFFSET + 2, direction)
    -- You get the distinct sense that your moogle friend frequents this spot... (Approx. 5-10' from target)
    elseif distance > 5 then
        player:messageSpecial(text.AMK_DIGGING_OFFSET + 1, direction)
    -- You are convinced that your moogle friend has been digging in the immediate vicinity. (Less than 5' from target)
    elseif distance > 2.5 then
        player:messageSpecial(text.AMK_DIGGING_OFFSET + 0, direction)
    end

    return false
end
