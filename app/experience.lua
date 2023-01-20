local Print = require 'app.print'
local PlayerUtil = require 'utils.player'

local Experience = {}

local function bump_level(player)
    local global_player = PlayerUtil.get_global_player(player)
    if(global_player.xp >= Experience.next_level(global_player.level)) then
        global_player.xp = 0
        global_player.level = global_player.level + 1
        if(global_player.elements.controls_textfield_level) then
            global_player.elements.controls_textfield_level.text = tostring(global_player.level)
        end
        
        Print.level(player, global_player.level)
    end
end

function Experience.xp_label(player)
    local global_player = PlayerUtil.get_global_player(player)
    return tostring(global_player.xp) .. "/" .. tostring(Experience.next_level(global_player.level))
end



function Experience.add_to_all(xp)
    for _, player in pairs(game.players) do
        if player.connected then
            Experience.add(player, xp)
        end
    end
end

function Experience.add(player, xp)
    local global_player = PlayerUtil.get_global_player(player)
    global_player.xp = global_player.xp + xp

    bump_level(player)
    
    Print.experience(player, xp)
    if(global_player.elements.controls_textfield_xp) then
        global_player.elements.controls_textfield_xp.text = Experience.xp_label(player)
    end
end

function Experience.next_level(currentLevel)
    currentLevel = math.max(1, currentLevel);
    return math.ceil(0.04 * (currentLevel ^ 3) + 0.8 * (currentLevel ^ 2) + 2 * currentLevel);
end

return Experience;