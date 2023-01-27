local UiUtil = require 'utils.ui'
local Modifiers = require 'app.modifiers'


local ModifiersUI = {}
local function modifiers_row(global_player, content_frame)
    for k, v in pairs(global_player.modifiers) do
        _ = UiUtil.row_simple(global_player, content_frame, Modifiers.getStringFormat(k,v), k)
    end
end

function ModifiersUI.build(global_player)
    local frame = global_player.elements.main_ui.content_frames["modifiers"]
    modifiers_row(global_player,frame)
end

return ModifiersUI