local UI = require 'app.ui'
local PlayerUtil = require 'utils.player'

local Shortcut = {}

function Shortcut.on_lua_shortcut(event)
    if event.prototype_name == "pe_shortcut"
      and event.player_index
      and game.players[event.player_index]
      and game.players[event.player_index].connected
      then
        UI.toggle_interface(PlayerUtil.get_player(event))
    end
  end

return Shortcut