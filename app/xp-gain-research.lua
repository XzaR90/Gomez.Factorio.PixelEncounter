local Experience = require 'app.experience'

local XpGainResearch = {}

function XpGainResearch.on_research_finished(event)
    if  game.tick <= 3600 * 2 or not event.research.force then
        return
    end
    
    if event.research.force then
        local force = event.research.force.name
        if force~='neutral' and force~='enemy' then
            local xp = event.research.research_unit_count * #event.research.research_unit_ingredients
            xp = math.ceil(xp * (1 + (6 * game.forces["enemy"].evolution_factor)))
            Experience.add_to_all(xp)
        end
    end

end

return XpGainResearch

