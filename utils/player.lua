local PlayerUtil = {}

function PlayerUtil.get_global_player(player)
    return global.players[player.index]
end

function PlayerUtil.get_player(event)
    return game.players[event.player_index]
end

local function train_type_cause(cause)
    local players = {}
    if cause.train.passengers then
        for _, player in pairs(cause.train.passengers) do
            players[#players + 1] = player
        end
    end
    return players
end

PlayerUtil.get_cause_player = {
    ['character'] = function(cause)
        if not cause.player then
            return
        end
        return {cause.player}
    end,
    ['combat-robot'] = function(cause)
        if not cause.last_user then
            return
        end
        if not game.players[cause.last_user.index] then
            return
        end
        return {game.players[cause.last_user.index]}
    end,
    ['car'] = function(cause)
        local players = {}
        local driver = cause.get_driver()
        if driver then
            if driver.player then
                players[#players + 1] = driver.player
            end
        end
        local passenger = cause.get_passenger()
        if passenger then
            if passenger.player then
                players[#players + 1] = passenger.player
            end
        end
        return players
    end,
    ['spider-vehicle'] = function(cause)
        local players = {}
        local driver = cause.get_driver()
        if driver then
            if driver.player then
                players[#players + 1] = driver.player
            end
        end
        local passenger = cause.get_passenger()
        if passenger then
            if passenger.player then
                players[#players + 1] = passenger.player
            end
        end
        return players
    end,
    ['locomotive'] = train_type_cause,
    ['cargo-wagon'] = train_type_cause,
    ['artillery-wagon'] = train_type_cause,
    ['fluid-wagon'] = train_type_cause
}

return PlayerUtil;