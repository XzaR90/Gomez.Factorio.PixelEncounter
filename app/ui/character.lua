local UiUtil = require 'utils.ui'
local Experience = require 'app.character-base.experience'
local Attributes = require 'app.character-base.attributes'

local CharacterUI = {}

local function xp_row(player, global_player, content_frame)
    UiUtil.row_simple(global_player,content_frame,Experience.xp_label(player),"experience")
end

local function level_row(global_player, content_frame)
    local level = global_player.level
    UiUtil.row_simple(global_player,content_frame,tostring(level),"level")
end

local function attribute_points_row(player, global_player, content_frame)
    local ap = Attributes.points_left(player)
    UiUtil.row_simple(global_player,content_frame,tostring(ap),"attribute_points")
end

local function attributes_row(global_player, content_frame)
    for k, v in pairs(global_player.attributes) do
        local controls_flow = UiUtil.row_simple(global_player, content_frame, tostring(v), k)
        local controls_button = controls_flow.add({type="button", name="pe_attribute_add_" .. k, caption="+"})
        global_player.elements.main_ui.controls["pe_attribute_add_" .. k] = controls_button
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