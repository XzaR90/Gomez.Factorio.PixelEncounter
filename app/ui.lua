local Ui = {}

function Ui.build_interface(player)
    local player_global = global.players[player.index]

    local screen_element = player.gui.screen
    local main_frame = screen_element.add{type="frame", name="pe_main_frame", caption={"ugg.hello_world"}}
    main_frame.style.size = {385, 165}
    main_frame.auto_center = true

    player.opened = main_frame
    player_global.elements.main_frame = main_frame

    local content_frame = main_frame.add{type="frame", name="content_frame", direction="vertical", style="pe_content_frame"}
    local controls_flow = content_frame.add{type="flow", name="controls_flow", direction="horizontal", style="pe_controls_flow"}

    local button_caption = (player_global.controls_active) and {"ugg.deactivate"} or {"ugg.activate"}
    controls_flow.add{type="button", name="pe_controls_toggle", caption=button_caption}

    local initial_button_count = player_global.button_count
    local controls_slider = controls_flow.add{type="slider", name="pe_controls_slider", value=initial_button_count, minimum_value=0, maximum_value=#item_sprites, style="notched_slider"}
    player_global.elements.controls_slider = controls_slider
    local controls_textfield = controls_flow.add{type="textfield", name="pe_controls_textfield", text=tostring(initial_button_count), numeric=true, allow_decimal=false, allow_negative=false, style="pe_controls_textfield"}
    player_global.elements.controls_textfield = controls_textfield
end

function Ui.toggle_interface(player)
    local player_global = global.players[player.index]
    local main_frame = player_global.elements.main_frame

    if main_frame == nil then
        Ui.build_interface(player)
    else
        main_frame.destroy()
        player_global.elements = {}
    end
end

return Ui;