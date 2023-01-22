local UI = require 'app.ui'
local PlayerUtil = require 'utils.player'
local TableUtil = require 'utils.table';
local Main = require 'app.main';

local Refresh = {}
function Refresh.on_configuration_changed(config_changed_data)
    if config_changed_data.mod_changes["pixelencounter-server-mod"] and game.players then
        for _, player in pairs(game.players) do
            if player.index then
                local player_global = PlayerUtil.get_global_player(player)
                if player_global.elements.main_frame ~= nil then UI.toggle_interface(player) end
                TableUtil.merge(player_global, Main.createGlobals(), TableUtil.CombineStrategy.first)
            end

        end
    end
end

return Refresh