local json = require "utils.dkjson"
local PlayerUtil = require 'utils.player'
local TimeSpan = require 'utils.timespan'

local GlobalPlayer = {}

local function get_filename()
    return 'statistic/global-player.json';
end

local function get_statistic()
    local statistic = {
        average_level = 1
    };

    local total_players = 0;
    local total_level = 0;

    for _, player in pairs(game.players) do
        if game.ticks_played - player.last_online < TimeSpan.Days_90  then
            total_players = total_players + 1;
            local player_global = PlayerUtil.get_global_player(player)
            total_level = total_level + player_global.level
        end
    end

    statistic.average_level = math.ceil(total_level / total_players)

    return statistic;
end

local function write_statistic(statistic)
    local file = get_filename();
    game.write_file( file, json.encode(statistic), false, 0 )
end

function GlobalPlayer.save()
    local stats = get_statistic()
    global.statistics.global_player = stats;
    write_statistic(stats);
end

return GlobalPlayer