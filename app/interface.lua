
local Experience = require 'app.experience'
local Interface = {}

function Interface.get_on_player_level_up()
    return Experience.on_player_level_up
    end
        -- Returns :
        -- event.player_index = Index of the player that has just leveled up
        -- event.level        = Player current XP Level 

remote.add_interface("pe", Interface )
return Interface;
