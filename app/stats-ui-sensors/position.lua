require "utils.math"

---@diagnostic disable-next-line: unused-local
return function (player, global_player)
    local position = player.position
    return { caption = { "stats_ui.position", math.round(position.x), math.round(position.y) }, name = "position"  }
end