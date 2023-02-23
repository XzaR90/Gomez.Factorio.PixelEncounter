local Color = require 'utils.color'
local TableUtil = require 'utils.table'
local Print = {}

local function get_position(entity)
    local position = TableUtil.copy(entity.position);
    position.y = position.y + 1;
    return position
end

function Print.flying_text(entity, label, color)
    if entity and entity.valid then
        entity.surface.create_entity{name = "flying-text", position = get_position(entity), text = label, color = color}
    end
end

function Print.damage(entity, value)
    if value ~= 0 then
        local label = string.format("+%.2fDMG",value)
        Print.flying_text(entity, label, Color.red)
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