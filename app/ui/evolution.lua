local UiUtil = require 'utils.ui'
local PlayerUtil = require 'utils.player'
local get_evo_globals = require 'app.modules.enemy-evolution.main'.get_globals

local EvolutionUI = {}

local function getStringPercent(value)
    value = value * 100
    return string.format("%.6f%%", value);
end

local function getStringDecimals(value)
    return string.format("%.3f", value);
end

local function factors_row(global_player, content_frame)
    local evo_global = get_evo_globals()
    for k, v in pairs(evo_global.factors) do
        _ = UiUtil.row_simple(global_player, content_frame, getStringPercent(v), k, "evo")
    end
end

local function other_rows(global_player, content_frame)
    local evo_global = get_evo_globals()

    _ = UiUtil.row_simple(global_player, content_frame, getStringDecimals(evo_global.pollution.neutral), "neutral", "evo")
    _ = UiUtil.row_simple(global_player, content_frame, getStringDecimals(evo_global.pollution.amount), "amount", "evo")
    _ = UiUtil.row_simple(global_player, content_frame, tostring(evo_global.pollution.count), "count", "evo")
    _ = UiUtil.row_simple(global_player, content_frame, getStringDecimals(evo_global.pollution.current_value), "current_value", "evo")
    
end

function EvolutionUI.update(global_player)
    local evo_global = get_evo_globals()
    for k, v in pairs(evo_global.factors) do
        UiUtil.update_if_exists(global_player, "evo_" .. k, getStringPercent(v))
    end

    UiUtil.update_if_exists(global_player, "evo_neutral", getStringDecimals(evo_global.pollution.neutral))
    UiUtil.update_if_exists(global_player, "evo_amount", getStringDecimals(evo_global.pollution.amount))
    UiUtil.update_if_exists(global_player, "evo_count", tostring(evo_global.pollution.count))
    UiUtil.update_if_exists(global_player, "evo_current_value", getStringDecimals(evo_global.pollution.current_value))
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

