local UI = require 'app.ui'
local PlayerUtil = require 'utils.player'
local TableUtil = require 'utils.table';
local Main = require 'app.main';
local EnemyEvolution = require 'app.modules.enemy-evolution.main'
local Statistics = require 'app.modules.statistics.main'
local StatsUI = require 'app.stats-ui'
local EntityPlayer = require 'app.entity-player'

local Refresh = {}
function Refresh.on_configuration_changed(config_changed_data)
    if config_changed_data.mod_changes["pixelencounter-server-mod"] then
        if not global.players then
            Main.on_init()
            return
        end

        if not global.entity_players then
            EntityPlayer.on_init()
        end

        for _, player in pairs(game.players) do
            local player_global = PlayerUtil.get_global_player(player)
            TableUtil.merge(player_global, Main.createGlobals(), TableUtil.CombineStrategy.first)
            if player_global.elements.main_ui.main_frame ~= nil then UI.toggle_interface(player) end
            StatsUI.destroy(player_global)
            StatsUI.update(player, player_global)
        end

        EnemyEvolution.on_configuration_changed()
        Statistics.on_configuration_changed()
    end
end

return Refresh