
local Main = {}

function Main.initialize_global(player)
    global.players[player.index] = { controls_active = true, xp = 0, level = 1, elements = {} }
end

function Main.on_init()
    global.players = {}
    for _, player in pairs(game.players) do
        Main.initialize_global(player)
    end
end

function Main.on_player_created(event)
    local player = game.get_player(event.player_index)
    Main.initialize_global(player)
end

function Main.on_player_removed(event)
    local player = game.get_player(event.player_index)
    global.players[player.index] = nil;
end


return Main;