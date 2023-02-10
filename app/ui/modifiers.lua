local UiUtil = require 'utils.ui'
local Modifiers = require 'app.modifiers'
local PlayerUtil = require 'utils.player'

local ModifiersUI = {}
local function modifiers_row(global_player, content_frame)
    for k, v in pairs(global_player.modifiers) do
        _ = UiUtil.row_simple(global_player, content_frame, Modifiers.getStringFormat(k,v), k, "modi")
    end
end

function ModifiersUI.build(global_player)
    local frame = global_player.elements.main_ui.content_frames["modifiers"]
    modifiers_row(global_player,frame)
end

function ModifiersUI.updateAll()
    for _, player in pairs(game.connected_players) do
        local global_player = PlayerUtil.get_global_player(player)
        ModifiersUI.update(global_player)
      end
end

function ModifiersUI.update(global_player)
    for k, v in pairs(global_player.modifiers) do
        if global_player.elements.main_ui.controls["textfield_modi_" .. k] then
            global_player.elements.main_ui.controls["textfield_modi_" .. k].text = Modifiers.getStringFormat(k,v)
        end
    end
end

return ModifiersUI