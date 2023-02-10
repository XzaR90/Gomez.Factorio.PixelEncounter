local create_sensor = require 'app.stats-ui-sensors.create-sensor'

---@diagnostic disable-next-line: unused-local
return function (player, global_player)
    local evolution = string.format("%.2f",game.forces.enemy.evolution_factor * 100)
    return create_sensor({ "stats_ui.evolution", evolution }, "evolution");
end