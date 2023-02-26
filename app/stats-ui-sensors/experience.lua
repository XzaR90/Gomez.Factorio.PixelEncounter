local Experience = require 'app.character-base.experience'
local create_sensor = require 'app.stats-ui-sensors.create-sensor'
local Color = require 'utils.color'

---@diagnostic disable-next-line: unused-local
return function (player, global_player)
    local xp = math.floor(global_player.xp)
    local next_level = Experience.next_level(global_player.level)
    local sensor = create_sensor({ "stats_ui.xp", xp, next_level } , "xp");
    sensor.color = Color.green
    return sensor
end