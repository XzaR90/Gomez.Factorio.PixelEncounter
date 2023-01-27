---@diagnostic disable-next-line: unused-local
return function (player, global_player)
    local evolution = string.format("%.2f",game.forces.enemy.evolution_factor * 100)
    return { caption = { "stats_ui.evolution", evolution }, name = "evolution"  }
end