require "utils.math"
local create_sensor = require 'app.stats-ui-sensors.create-sensor'

---@diagnostic disable-next-line: unused-local
return function (player, global_player)
    local position = player.position
    return create_sensor({ "stats_ui.position", math.round(position.x), math.round(position.y) }, "position");
end