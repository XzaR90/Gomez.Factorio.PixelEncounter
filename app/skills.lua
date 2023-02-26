local Skills = {}

--- @return {cooldowns:{critical_hit: number, repair: number}}
function Skills.create()

    return {
        cooldowns = {
            critical_hit = 0,
            repair = 0
        }
    }
end

return Skills