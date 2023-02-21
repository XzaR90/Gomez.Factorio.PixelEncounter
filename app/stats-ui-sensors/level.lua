local Attribute = require 'app.character-base.attributes'
local create_sensor = require 'app.stats-ui-sensors.create-sensor'
local Color = require 'utils.color'

return function (player, global_player)
    local level = global_player.level
    local sensor = create_sensor({ "stats_ui.level", level } , "level");
    sensor.color = Color.default_font_color
    if(Attribute.points_left(player) > 0) then
        sensor.caption = { "stats_ui.level_plus", level }
        sensor.color = Color.red
    end

    return sensor
end