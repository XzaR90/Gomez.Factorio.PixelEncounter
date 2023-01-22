local Color = require 'utils.color'
local TableUtil = require 'utils.table'
local Print = {}

local function get_position(player)
    local position = TableUtil.copy(player.position);
    position.y = position.y + 1;
    return position
end

function Print.experience(player, xp)
    if player and player.valid and xp ~= 0 then
        local label = string.format("+%.2fXP",xp)
        player.surface.create_entity{name = "flying-text", position = get_position(player), text = label, color = Color.green}
    end
end

function Print.level(player, level)
    if player and player.valid and level ~= 0 then
        local label = string.format("%.0fLVL",level)
        player.surface.create_entity{name = "flying-text", position = get_position(player), text = label, color = Color.purple}
    end
end

return Print;