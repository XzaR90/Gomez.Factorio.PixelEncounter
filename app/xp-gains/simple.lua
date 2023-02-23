require 'utils.math'
local PlayerUtil = require 'utils.player'
local Experience = require 'app.character-base.experience'
local get_stats_globals = require 'app.modules.statistics.main'.get_globals
local xp_bonus = require 'app.xp-gains.utils.xp-bonus'

local XpGainSimple = {}
local function add_xp_from_tree_and_rocks(player, ent)
    local xp = 0
    if  ent.prototype.max_health then 
        xp=ent.prototype.max_health
        if ent.type=='tree' then xp=xp/100 else xp=xp/400 end
    end

    local stats_global = get_stats_globals()
    xp = math.ceil(xp * math.random_float(1, math.log(math.max(1,stats_global.global_player.average_level) ,10)))
    if xp > 0 then
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

---comment
---@param event {entity: LuaEntity}
function XpGainSimple.on_player_repaired_entity(event)
    if math.random(1, 4) ~= 1 then
        return
    end

    local entity = event.entity
    if not entity or not entity.valid or not entity.health  then
        return
    end

    local player = PlayerUtil.get_player(event)

    if not player or not player.valid or not player.character then
        return
    end

    local stats_global = get_stats_globals()

    local xp = entity.prototype.max_health - entity.health
    xp = xp * xp_bonus(player)
    xp = xp * math.random_float(1, math.log(math.max(1,stats_global.global_player.average_level) ,10))
    
    if xp > 0 then
        Experience.add(player, xp)
    end
end

return XpGainSimple;
