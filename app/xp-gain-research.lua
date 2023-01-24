local Experience = require 'app.experience'
local PlayerUtil = require 'utils.player'

local XpGainResearch = {}

function XpGainResearch.on_research_finished(event)
    if  game.tick <= 3600 * 2 or not event.research.force then
        return
    end
    
    if event.research.force then
        local force = event.research.force.name
        if force ~='neutral' and force ~='enemy' then
            local xp = event.research.research_unit_count * #event.research.research_unit_ingredients
            xp = math.ceil(xp * (1 + (6 * game.forces["enemy"].evolution_factor)))
            Experience.add_to_all(xp, event.research.force.index)
        end
    end

end

function XpGainResearch.on_player_crafted_item(event)
    local recipe = event.recipe
    if not recipe.energy then
        return
    end

    local player = PlayerUtil.get_player(event)
    if not player or not player.valid then
        return
    end

    if player.cheat_mode then
        return
    end

    local xp = recipe.energy * 0.40 * game.forces["enemy"].evolution_factor + 1
    Experience.add(player, xp)
end

return XpGainResearch

