require 'utils.math'
local PlayerUtil = require 'utils.player'
local Attributes = require 'app.character-base.attributes'

return function(player, global_player)
    if not (player and player.valid) then
        return 0
    end

    global_player = global_player or PlayerUtil.get_global_player(player)
    local start_penalty = Attributes.initialPoint - 2;
    local level_penalty = global_player.level * 0.33;

    local actual_intelligence = math.max(global_player.attributes.intelligence - level_penalty, Attributes.initialPoint) - start_penalty
    return 1.0 + math.min(actual_intelligence * 0.01, 0.50)
end
