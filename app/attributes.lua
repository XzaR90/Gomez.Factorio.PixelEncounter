
local PlayerUtil = require 'utils.player'
local Logger = require 'utils.logger';

local Attributes = {}

function Attributes.create()
    return {
        strength = 5,
        dexterity = 5,
        endurance = 5,
        intelligence = 5,
    }
end

function Attributes.max_points(player)
    local global_player = PlayerUtil.get_global_player(player)
    return 5 + 5 + 5 + 5 + ((global_player.level - 1) * 5)
end

function Attributes.points_left(player)
    local global_player = PlayerUtil.get_global_player(player)
    local max_points = Attributes.max_points(player);
    local spent_points = 0
    for _, v in pairs(global_player.attributes) do
        spent_points = spent_points + v
    end

    return max_points - spent_points;
end

function Attributes.on_gui_click(event)
    local element = event.element
    if not element then
        return
    end
    
    local btn_name_prefix = "pe_attribute_add_"
    if element.name:starts_with(btn_name_prefix) then
        local player = PlayerUtil.get_player(event)
        local global_player = PlayerUtil.get_global_player(player)
        
        local attributeName = string.sub(element.name, string.len(btn_name_prefix) + 1)
        Attributes.add(player, global_player,attributeName, 1);
    end
end

function Attributes.add(player, global_player, attributeName, amount)
    local ap_left = Attributes.points_left(player) - amount;
    if(ap_left < 0) then
        return
    end

    global_player.attributes[attributeName] = global_player.attributes[attributeName] + amount
    
    if(global_player.elements["controls_textfield_" .. attributeName]) then
        global_player.elements["controls_textfield_" .. attributeName].text = tostring(global_player.attributes[attributeName])
    end

    Attributes.refresh_ap(player, global_player, ap_left)
    Attributes.disable_add_when_ap_zero(player, global_player, ap_left)
end

function Attributes.refresh_ap(player, global_player, ap_left)
    if(ap_left == nil) then
        ap_left = Attributes.points_left(player);
    end

    if(global_player.elements["controls_textfield_attribute_points"]) then
        global_player.elements["controls_textfield_attribute_points"].text = tostring(ap_left)
    end
end

function Attributes.disable_add_when_ap_zero(player, global_player, ap_left)
    if(ap_left == nil) then
        ap_left = Attributes.points_left(player);
    end

    for k, _ in pairs(global_player.attributes) do
        if  global_player.elements["pe_attribute_add_" .. k] then
            global_player.elements["pe_attribute_add_" .. k].enabled = true
            if(ap_left == 0 ) then
                global_player.elements["pe_attribute_add_" .. k].enabled = false
            end
        end
    end
end

return Attributes;