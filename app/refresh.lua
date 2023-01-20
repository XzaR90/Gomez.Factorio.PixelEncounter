local UI = require 'app.ui'
local PlayerUtil = require 'utils.player'

local Refresh = {}
function Refresh.on_configuration_changed(config_changed_data)
    if config_changed_data.mod_changes["pixelencounter-server-mod"] then
        for _, player in pairs(game.players) do
            local player_global = PlayerUtil.get_global_player(player)
            if player_global.elements.main_frame ~= nil then UI.toggle_interface(player) end
        end
    end
end

return Refresh