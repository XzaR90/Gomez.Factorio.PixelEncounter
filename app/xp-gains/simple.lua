local PlayerUtil = require 'utils.player'
local Experience = require 'app.character-base.experience'

local XpGainSimple = {}
local function add_xp_from_tree_and_rocks(player, ent)
    local xp = 0
    if  ent.prototype.max_health then 
        xp=ent.prototype.max_health
        if ent.type=='tree' then xp=xp/100 else xp=xp/400 end
    end

    local global_player = PlayerUtil.get_global_player(player)
    if xp > 0 then
        xp = math.ceil(xp * (global_player.xp + 1) * 0.3)
        Experience.add(player, xp)
    end
end

function XpGainSimple.on_player_mined_entity(event)
    local player = PlayerUtil.get_player(event)
    if not player.valid then return end

    local ent = event.entity
    local name= ent.name

    if ent.type=='tree' or (ent.type=='simple-entity' and name:find('rock')) then 
        add_xp_from_tree_and_rocks(player,ent)
    end
end

function XpGainSimple.on_player_repaired_entity(event)
    if math.random(1, 4) ~= 1 then
        return
    end

    local entity = event.entity
    if not entity or not entity.valid or not not entity.health  then
        return
    end

    local player = PlayerUtil.get_player(event)

    if not player or not player.valid or not player.character then
        return
    end

    Experience.add(player, 0.05 * entity.health)
end

return XpGainSimple;