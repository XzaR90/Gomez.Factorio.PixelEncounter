local TimeSpan = require 'utils.timespan'
local Forces = require "app.modules.statistics.forces"
local GlobalPlayer = require "app.modules.statistics.global-player"

--- @class Statistics
local Statistics = {}

local function init_or_reset()
	global.statistics = {}
    global.statistics.global_player = {
        average_level = 1
    }
end

--- @return {global_player:{average_level: number}}
function Statistics.get_globals()
    return global.statistics;
end

function Statistics.on_configuration_changed()
	init_or_reset()
end

function Statistics.on_init()
	init_or_reset()
end

function Statistics.tick(tick)
    if tick % TimeSpan.Minute == 0 then
        for _, f in pairs(game.forces) do
            Forces.save(f)
        end

        GlobalPlayer.save()
    end
end

return Statistics;