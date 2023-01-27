
local Experience = require 'app.character-base.experience'
local Attributes = require 'app.character-base.attributes'
local Interface = {}

function Interface.get_on_player_level_up()
    return Experience.on_player_level_up
    end
        -- Returns :
        -- event.player_index = Index of the player that has just leveled up
        -- event.level        = Player current XP Level 

function Interface.get_on_player_attribute_add()
    return Attributes.on_player_attribute_add
    end
        -- Returns :
        -- event.player_index = Index of the player that has just leveled up
        -- event.attribute_name     = name of the attribute 
        -- event.amount             = amount added to the attribute

remote.add_interface("pe", Interface )
return Interface;
