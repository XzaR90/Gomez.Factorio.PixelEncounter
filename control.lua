local Main = require 'app.main'
local UI = require 'app.ui'

script.on_init(function()
    Main.on_init()
end)

script.on_configuration_changed(function(config_changed_data)
    if config_changed_data.mod_changes["pixelencounter-server-mod"] then
        for _, player in pairs(game.players) do
            local player_global = global.players[player.index]
            if player_global.elements.main_frame ~= nil then UI.toggle_interface(player) end
        end
    end
end)


script.on_event(defines.events.on_player_created, function(event)
    Main.on_player_created(event);
end)

script.on_event(defines.events.on_player_removed, function(event)
    Main.on_player_removed(event);
end)


script.on_event("pe_toggle_interface", function(event)
    local player = game.get_player(event.player_index)
    UI.toggle_interface(player)
end)

script.on_event(defines.events.on_gui_closed, function(event)
    if event.element and event.element.name == "pe_main_frame" then
        local player = game.get_player(event.player_index)
        UI.toggle_interface(player)
    end
end)


script.on_event(defines.events.on_gui_click, function(event)
    if event.element.name == "pe_controls_toggle" then
        local player_global = global.players[event.player_index]
        player_global.controls_active = not player_global.controls_active

        local control_toggle = event.element
        control_toggle.caption = (player_global.controls_active) and {"ugg.deactivate"} or {"ugg.activate"}

        player_global.elements.controls_textfield.enabled = player_global.controls_active

    elseif event.element.tags.action == "pe_select_button" then
        local player = game.get_player(event.player_index)
        local player_global = global.players[player.index]

        local clicked_item_name = event.element.tags.item_name
        player_global.selected_item = clicked_item_name


    end
end)

script.on_event(defines.events.on_gui_text_changed, function(event)
    if event.element.name == "pe_controls_textfield" then
        local player = game.get_player(event.player_index)
        local player_global = global.players[player.index]
    end
end)