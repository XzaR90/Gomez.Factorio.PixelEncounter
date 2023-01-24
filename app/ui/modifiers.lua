local UiUtil = require 'utils.ui'
local Modifiers = require 'app.modifiers'


local ModifiersUI = {}
local function modifiers_row(player, global_player, content_frame)
    for k, v in pairs(global_player.modifiers) do
        _ = UiUtil.row_simple(player, global_player, content_frame, Modifiers.getStringFormat(k,v), k)
    end
end

function ModifiersUI.build(player, global_player)
    local frame = global_player.elements.content_frames["modifiers"]
    modifiers_row(player,global_player,frame)
end

return ModifiersUI