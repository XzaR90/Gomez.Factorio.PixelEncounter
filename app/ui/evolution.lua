local UiUtil = require 'utils.ui'
local PlayerUtil = require 'utils.player'


local EvolutionUI = {}

local function getStringPercent(value)
    value = value * 100
    return string.format("%.6f%%", value);
end

local function getStringDecimals(value)
    return string.format("%.3f", value);
end

local function factors_row(global_player, content_frame)
    for k, v in pairs(global.enhanced_evolution.factors) do
        _ = UiUtil.row_simple(global_player, content_frame, getStringPercent(v), k, "evo")
    end
end

local function other_rows(global_player, content_frame)
    _ = UiUtil.row_simple(global_player, content_frame, getStringDecimals(global.enhanced_evolution.pollution.neutral), "neutral", "evo")
    _ = UiUtil.row_simple(global_player, content_frame, getStringDecimals(global.enhanced_evolution.pollution.amount), "amount", "evo")
    _ = UiUtil.row_simple(global_player, content_frame, tostring(global.enhanced_evolution.pollution.count), "count", "evo")
    _ = UiUtil.row_simple(global_player, content_frame, getStringDecimals(global.enhanced_evolution.pollution.current_value), "current_value", "evo")
    
end

local function update_if_exists(global_player, k, v)
    if global_player.elements.main_ui.controls["textfield_" .. k] then
        global_player.elements.main_ui.controls["textfield_" .. k].text = v
    end
end

function EvolutionUI.update(global_player)
    for k, v in pairs(global.enhanced_evolution.factors) do
        update_if_exists(global_player, "evo_" .. k, getStringPercent(v))
    end

    update_if_exists(global_player, "evo_neutral", getStringDecimals(global.enhanced_evolution.pollution.neutral))
    update_if_exists(global_player, "evo_amount", getStringDecimals(global.enhanced_evolution.pollution.amount))
    update_if_exists(global_player, "evo_count", tostring(global.enhanced_evolution.pollution.count))
    update_if_exists(global_player, "evo_current_value", getStringDecimals(global.enhanced_evolution.pollution.current_value))
end

function EvolutionUI.updateAll()
    for _, player in pairs(game.connected_players) do
      local global_player = PlayerUtil.get_global_player(player)
      EvolutionUI.update(global_player)
    end
end

function EvolutionUI.build(global_player)
    local frame = global_player.elements.main_ui.content_frames["evolution"]
    factors_row(global_player,frame)
    other_rows(global_player,frame)
end

return EvolutionUI

