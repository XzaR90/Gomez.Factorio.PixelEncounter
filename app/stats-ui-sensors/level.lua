local Attribute = require 'app.character-base.attributes'
local create_sensor = require 'app.stats-ui-sensors.create-sensor'

return function (player, global_player)
    local level = global_player.level
    local sensor = create_sensor({ "stats_ui.level", level } , "level");
    sensor.color = { r = 1, g = 1, b = 1, a = 1}
    if(Attribute.points_left(player) > 0) then
        sensor.caption = { "stats_ui.level_plus", level }
        sensor.color = { r = 1, g = 0, b = 0, a = 1}
    end

    return sensor
end