require 'utils.math'
local PlayerUtil = require 'utils.player'
local Attributes = require 'app.attributes'

local Modifiers = {}

function Modifiers.create()
    return {
        character_running_speed_modifier = 0,
        character_crafting_speed_modifier = 0,
        character_mining_speed_modifier = 0,

        character_build_distance_bonus = 0,
        character_item_drop_distance_bonus = 0,
        character_item_pickup_distance_bonus = 0,
        character_reach_distance_bonus = 0,
        character_loot_pickup_distance_bonus = 0,
        character_resource_reach_distance_bonus = 0,
    }
end

Modifiers.formats =
{
    character_running_speed_modifier = 'p',
    character_crafting_speed_modifier = 'p',
    character_mining_speed_modifier = 'p',

    character_build_distance_bonus = 'i',
    character_item_drop_distance_bonus = 'i',
    character_item_pickup_distance_bonus = 'i',
    character_reach_distance_bonus = 'i',
    character_loot_pickup_distance_bonus = 'i',
    character_resource_reach_distance_bonus = 'i',
}

function Modifiers.update(player)
    if not player.valid then
        return
    end

    local global_player = PlayerUtil.get_global_player(player)
    local start_penalty = Attributes.initialPoint - 2;

    local actual_strength = math.max(global_player.attributes.strength - global_player.level, Attributes.initialPoint) - start_penalty
    local actual_dexterity = math.max(global_player.attributes.dexterity - global_player.level, Attributes.initialPoint) - start_penalty
    local actual_endruance = math.max(global_player.attributes.endurance - global_player.level, Attributes.initialPoint) - start_penalty
    local actual_intelligence = math.max(global_player.attributes.intelligence - global_player.level, Attributes.initialPoint) - start_penalty

    global_player.modifiers.character_mining_speed_modifier =  math.min(actual_strength * 0.01, 0.5)
    global_player.modifiers.character_running_speed_modifier = math.min(actual_endruance * 0.01, 0.5)
    global_player.modifiers.character_crafting_speed_modifier = math.min(actual_intelligence * 0.01, 0.5)

    global_player.modifiers.character_build_distance_bonus = math.round(math.min(actual_dexterity * 0.01, 60))
    global_player.modifiers.character_item_drop_distance_bonus = math.round(math.min(actual_dexterity * 0.01, 60))
    global_player.modifiers.character_item_pickup_distance_bonus = math.round(math.min(actual_dexterity * 0.01, 60))

    global_player.modifiers.character_reach_distance_bonus = math.round(math.min(actual_dexterity * 0.01, 20))
    global_player.modifiers.character_loot_pickup_distance_bonus = math.round(math.min(actual_dexterity * 0.01, 20))
    global_player.modifiers.character_reach_distance_bonus = math.round(math.min(actual_dexterity * 0.01, 20))

    Modifiers.refresh_ui(global_player)
    Modifiers.set_to_character(global_player)
end

function Modifiers.getStringFormat(key,value)
    if(Modifiers.formats[key] == 'p') then
        local percentage = value * 100;
        return string.format("%.2f%%", percentage)
    end
    if(Modifiers.formats[key] == 'i') then
        return string.format("%.0f", value)
    end
end

function Modifiers.refresh_ui(global_player)
    for k, v in pairs(global_player.modifiers) do
        if global_player.elements["controls_textfield_" .. k] then
            global_player.elements["controls_textfield_" .. k].text = Modifiers.getStringFormat(k,v)
        end
    end
end

function Modifiers.on_player_respawned(event)
    local player = PlayerUtil.get_player(event)
    Modifiers.set_to_character(player)
end

function Modifiers.on_player_joined_game(event)
    local player = PlayerUtil.get_player(event)
    Modifiers.set_to_character(player)
end

function Modifiers.set_to_character(player)
    if not player or not player.valid or not player.character then
        return
    end

    local global_player = PlayerUtil.get_global_player(player)
    for k, v in pairs(global_player.modifiers) do
        player.character[k] = v
    end
end

return Modifiers