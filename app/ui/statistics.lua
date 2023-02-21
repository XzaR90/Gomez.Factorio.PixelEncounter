local UiUtil = require 'utils.ui'
local PlayerUtil = require 'utils.player'
local get_stats_globals = require 'app.modules.statistics.main'.get_globals

local StatisticsUI = {}

local function rows(global_player, content_frame)
    local stats_global = get_stats_globals()
    _ = UiUtil.row_simple(global_player, content_frame, tostring(stats_global.global_player.average_level), "average_level", "s_global_player")
end

function StatisticsUI.update(global_player)
    local stats_global = get_stats_globals()
    UiUtil.update_if_exists(global_player, "s_global_player_average_level", tostring(stats_global.global_player.average_level))
end

function StatisticsUI.updateAll()
    for _, player in pairs(game.connected_players) do
      local global_player = PlayerUtil.get_global_player(player)
      StatisticsUI.update(global_player)
    end
end

function StatisticsUI.build(global_player)
    local frame = global_player.elements.main_ui.content_frames["statistics"]
    rows(global_player, frame)
end

return StatisticsUI