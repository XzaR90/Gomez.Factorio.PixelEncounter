local Color = require 'utils.color'
local TableUtil = require 'utils.table'
local Print = {}

local function get_position(player)
    local position = TableUtil.copy(player.position);
    position.y = position.y + 1;
    return position
end

function Print.flying_text(player, label, color)
    if player and player.valid then
        player.surface.create_entity{name = "flying-text", position = get_position(player), text = label, color = color}
    end
end

function Print.experience(player, xp)
    if xp ~= 0 then
        local label = string.format("+%.2fXP",xp)
        Print.flying_text(player,label, Color.green)
    end
end

function Print.level(player, level)
    if level ~= 0 then
        local label = string.format("%.0fLVL",level)
        Print.flying_text(player,label, Color.purple)
    end
end

return Print;