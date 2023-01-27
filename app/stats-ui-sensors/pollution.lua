
---@diagnostic disable-next-line: unused-local
return function (player, global_player)
    local pollution = string.format("%.2f", player.surface.get_pollution(player.position))
    return { caption = { "stats_ui.pollution", pollution }, name = "pollution"  }
end

