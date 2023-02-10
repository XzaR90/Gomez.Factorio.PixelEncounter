local UiUtil = require 'utils.ui'
local PlayerUtil = require 'utils.player'


local EvolutionUI = {}

local function getStringFormat(value)
    value = value * 100
    return string.format("%.6f%%", value);
end

local function factors_row(global_player, content_frame)
    for k, v in pairs(global.enhanced_evolution.factors) do
        _ = UiUtil.row_simple(global_player, content_frame, getStringFormat(v), k, "evo")
    end
end

function EvolutionUI.update(global_player)
    for k, v in pairs(global.enhanced_evolution.factors) do
        if global_player.elements.main_ui.controls["textfield_evo_" .. k] then
            global_player.elements.main_ui.controls["textfield_evo_" .. k].text = getStringFormat(v)
        end
    end
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
end

return EvolutionUI

