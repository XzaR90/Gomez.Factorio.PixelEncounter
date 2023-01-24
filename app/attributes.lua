
local PlayerUtil = require 'utils.player'
require 'utils.string'

local Attributes = {}

Attributes.on_player_attribute_add = script.generate_event_name() --uint

Attributes.initialPoint = 5;
function Attributes.create()
    return {
        strength = Attributes.initialPoint,
        dexterity = Attributes.initialPoint,
        endurance = Attributes.initialPoint,
        intelligence = Attributes.initialPoint,
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

function Attributes.add(player, global_player, attribute_name, amount)
    local ap_left = Attributes.points_left(player) - amount;
    if(ap_left < 0) then
        return
    end

    global_player.attributes[attribute_name] = global_player.attributes[attribute_name] + amount
    
    if(global_player.elements["controls_textfield_" .. attribute_name]) then
        global_player.elements["controls_textfield_" .. attribute_name].text = tostring(global_player.attributes[attribute_name])
    end

    Attributes.refresh_ap(player, global_player, ap_left)
    Attributes.disable_add_when_ap_zero(player, global_player, ap_left)
    script.raise_event(Attributes.on_player_attribute_add, {player_index = player.index, attribute_name = attribute_name, amount = amount })
end

function Attributes.refresh_ap(player, global_player, ap_left)
    if(ap_left == nil) then
        ap_left = Attributes.points_left(player);
    end

    if(global_player.elements["controls_textfield_attribute_points"]) then
        global_player.elements["controls_textfield_attribute_points"].text = tostring(ap_left)
    end
end

-- disable_add_when_ap_zero
-- @param player LuaPlayer
-- @param[opt=global_player] will be fetched if nil 
-- @param[opt=ap_left] ap_left will be fetched if nil 
function Attributes.disable_add_when_ap_zero(player, global_player, ap_left)
    if ap_left == nil then
        ap_left = Attributes.points_left(player);
    end

    if global_player == nil then
        global_player = PlayerUtil.get_global_player(player)
    end

    for k, _ in pairs(global_player.attributes) do
        if  global_player.elements["pe_attribute_add_" .. k] then
            global_player.elements["pe_attribute_add_" .. k].enabled = true
            if ap_left == 0  then
                global_player.elements["pe_attribute_add_" .. k].enabled = false
            end
        end
    end
end

return Attributes;