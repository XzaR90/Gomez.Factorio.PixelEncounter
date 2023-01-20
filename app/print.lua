local Color = require 'utils.color'
local Print = {}

function Print.experience(player, xp)
    if player and player.valid and xp ~= 0 then
        player.surface.create_entity{name = "flying-text", position = player.position, text = "+" .. tostring(xp) ..' XP', color = Color.green}
    end
end

function Print.level(player, level)
    if player and player.valid and level ~= 0 then
        player.surface.create_entity{name = "flying-text", position = player.position, text = "+" .. tostring(level) ..' LVL', color = Color.purple}
    end
end

return Print;