local UiUtil = require 'utils.ui'
local PlayerUtil = require 'utils.player'
local Experience = require 'app.character-base.experience'
local Attributes = require 'app.character-base.attributes'
local Color = require 'utils.color'

local CharacterUI = {}

local function xp_row(player, global_player, content_frame)
    UiUtil.row_simple(global_player,content_frame,Experience.xp_label(player),"experience", "character")
end

local function level_row(global_player, content_frame)
    local level = global_player.level
    UiUtil.row_simple(global_player,content_frame,tostring(level),"level", "character")
end

local function attribute_points_row(player, global_player, content_frame)
    local ap = Attributes.points_left(player)
    UiUtil.row_simple(global_player,content_frame,tostring(ap),"attribute_points", "character")
end

local function attributes_row(global_player, content_frame)
    for k, v in pairs(global_player.attributes) do
        local controls_flow = UiUtil.row_simple(global_player, content_frame, tostring(v), k, "character")
        local controls_button = controls_flow.add({type="button", name="pe_attribute_add_" .. k, caption="+"})
        --controls_button.style.color = Color.darkred
        global_player.elements.main_ui.controls["pe_attribute_add_" .. k] = controls_button
    end
end
 
function CharacterUI.update_ap(player, global_player, ap_left)
    if(ap_left == nil) then
        ap_left = Attributes.points_left(player);
    end

    if(global_player == nil) then
        global_player = PlayerUtil.get_global_player(player)
    end

    if(global_player.elements.main_ui.controls["textfield_character_attribute_points"]) then
        global_player.elements.main_ui.controls["textfield_character_attribute_points"].text = tostring(ap_left)
    end
end

function CharacterUI.update(global_player, player)
    if global_player.elements.main_ui.controls["textfield_character_level"] then
        global_player.elements.main_ui.controls["textfield_character_level"].text = tostring(global_player.level)
    end

    if global_player.elements.main_ui.controls["textfield_character_experience"] then
        global_player.elements.main_ui.controls["textfield_character_experience"].text = Experience.xp_label(player)
    end
end

function CharacterUI.updateAttribute(player, attribute_name)
    local global_player = PlayerUtil.get_global_player(player)
    if(global_player.elements.main_ui.controls["textfield_character_" .. attribute_name]) then
        global_player.elements.main_ui.controls["textfield_character_" .. attribute_name].text = tostring(global_player.attributes[attribute_name])
    end
end

function CharacterUI.updateAll()
    for _, player in pairs(game.connected_players) do
      local global_player = PlayerUtil.get_global_player(player)
      CharacterUI.update(global_player, player)
    end
end

function CharacterUI.build(player, global_player)
    local frame = global_player.elements.main_ui.content_frames["character"]

    xp_row(player,global_player,frame)
    level_row(global_player,frame)
    attributes_row(global_player,frame)
    attribute_points_row(player,global_player,frame)
end

return CharacterUI