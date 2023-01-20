local Main = require 'app.main'
local UI = require 'app.ui'
local Shortcut = require 'app.shortcut'
local Refresh = require 'app.refresh'

local XpGainSimple = require 'app.xp-gain-simple'
local XpGainResearch = require 'app.xp-gain-research'
local XpGainKill = require 'app.xp-gain-kill'

script.on_init(function()
    Main.on_init()
end)

script.on_configuration_changed(function(config_changed_data)
    Refresh.on_configuration_changed(config_changed_data)
end)

script.on_event(defines.events.on_player_created, function(event)
    Main.on_player_created(event);
end)

script.on_event(defines.events.on_player_removed, function(event)
    Main.on_player_removed(event);
end)


script.on_event("pe_toggle_interface", UI.key_toggle_interface)
script.on_event(defines.events.on_gui_closed, UI.on_gui_closed)


-- script.on_event(defines.events.on_gui_click, function(event)
--     if event.element.name == "pe_controls_toggle" then
--         local player_global = global.players[event.player_index]
--         player_global.controls_active = not player_global.controls_active

--         local control_toggle = event.element
--         control_toggle.caption = (player_global.controls_active) and {"ugg.deactivate"} or {"ugg.activate"}

--         player_global.elements.controls_textfield.enabled = player_global.controls_active

--     elseif event.element.tags.action == "pe_select_button" then
--         local player = game.get_player(event.player_index)
--         local player_global = global.players[player.index]

--         local clicked_item_name = event.element.tags.item_name
--         player_global.selected_item = clicked_item_name


--     end
-- end)

-- script.on_event(defines.events.on_gui_text_changed, function(event)
--     if event.element.name == "pe_controls_textfield" then
--         local player = game.get_player(event.player_index)
--         local player_global = global.players[player.index]
--     end
-- end)


  
script.on_event(defines.events.on_lua_shortcut, Shortcut.on_lua_shortcut)

------------------------------------------------------------------------------
script.on_event(defines.events.on_entity_died,XpGainKill.on_entity_died)
script.on_event(defines.events.on_research_finished, function(event)
    XpGainResearch.on_research_finished(event)
end)
script.on_event(defines.events.on_player_mined_entity, function(event)
    XpGainSimple.on_player_mined_entity(event)
    end,
    {{filter = "type", type = "tree"}, {filter = "type", type = "simple-entity"}})