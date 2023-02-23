local PlayerUtil = require 'utils.player'

return {
  ["1.0.4"] = function()
    for _, player in pairs(game.players) do
      local player_global = PlayerUtil.get_global_player(player)
      if player_global.elements.main_frame ~= nil then
        player_global.elements.main_frame.destory()
        player_global.elements = {}
      end
    end
  end,
  ["1.0.9"] = function()
    if not global.entity_players then
      global.entity_players = {}
    end
  end,
}
