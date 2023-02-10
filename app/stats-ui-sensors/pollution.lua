local create_sensor = require 'app.stats-ui-sensors.create-sensor'

---@diagnostic disable-next-line: unused-local
return function (player, global_player)
    local pollution = string.format("%.2f", player.surface.get_pollution(player.position))
    return create_sensor({ "stats_ui.pollution", pollution }, "pollution");
end

