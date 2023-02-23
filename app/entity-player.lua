local RandomAttribute = require 'app.utils.random-attribute'
local TimeSpan = require 'utils.timespan'
local get_stats_globals = require 'app.modules.statistics.main'.get_globals

local EntityPlayer = {}
EntityPlayer.updateInterval = TimeSpan.Minute * 6

function EntityPlayer.on_init()
    global.entity_players = {}
end

function EntityPlayer.create()
    local stats_global = get_stats_globals()
    local level = stats_global.global_player.average_level * (1 + game.forces["enemy"].evolution_factor)
    local attributes = RandomAttribute.random(level)

    return {
        attributes = attributes,
        level = level,
    }
end

function EntityPlayer.replace_and_get(entity)
    global.entity_players[entity.name] = EntityPlayer.create()
    return EntityPlayer.get(entity)
end

function EntityPlayer.get(entity)
    if not global.entity_players then
        global.entity_players = {}
    end

    return global.entity_players[entity.name]
end

function EntityPlayer.on_nth_tick_update_existing_entity_player()
    if not global.entity_players then
        return
    end

    for k, _ in pairs(global.entity_players) do
        global.entity_players[k] = EntityPlayer.create()
    end
end

return EntityPlayer