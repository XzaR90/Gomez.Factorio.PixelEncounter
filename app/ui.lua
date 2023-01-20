local PlayerUtil = require 'utils.player'
local Experience = require 'app.experience'

local UI = {}

local function build_frame(player, global_player)
    local screen_element = player.gui.screen
    local main_frame = screen_element.add{type="frame", name="pe_main_frame", caption={"ui.frame_character_title"}}
    main_frame.style.size = {400, 680}
    main_frame.auto_center = true

    player.opened = main_frame
    global_player.elements.main_frame = main_frame
    return main_frame;
end

local function xp_row(player, global_player, content_frame)
    local controls_flow = content_frame.add{type="flow", name="controls_flow_xp", direction="horizontal", style="pe_controls_flow"}

    local controls_label = controls_flow.add({type="label", caption={"app.experience"}, style="pe_controls_label"})
    local controls_textfield = controls_flow.add(
        {
            type="textfield", 
            name="pe_controls_textfield_xp", 
            text=Experience.xp_label(player), 
            numeric=true, 
            allow_decimal=false, 
            allow_negative=false, 
            style="pe_controls_textfield",
            enabled=false
        })

    global_player.elements.controls_label_xp = controls_label
    global_player.elements.controls_textfield_xp = controls_textfield
end

local function level_row(player, global_player, content_frame)
    local controls_flow = content_frame.add{type="flow", name="controls_flow_level", direction="horizontal", style="pe_controls_flow"}
    
    local level = global_player.level

    local controls_label = controls_flow.add({type="label", caption={"app.level"}, style="pe_controls_label"})
    local controls_textfield = controls_flow.add(
        {
            type="textfield", 
            name="pe_controls_textfield_level", 
            text=tostring(level), 
            numeric=true, 
            allow_decimal=false, 
            allow_negative=false, 
            style="pe_controls_textfield",
            enabled=false
        })

    global_player.elements.controls_label_level = controls_label
    global_player.elements.controls_textfield_level = controls_textfield
end

function UI.build_interface(player)
    local global_player = PlayerUtil.get_global_player(player);

    local main_frame = build_frame(player,global_player)

    local content_frame = main_frame.add{type="frame", name="content_frame", direction="vertical", style="pe_content_frame"}
    xp_row(player,global_player,content_frame)
    level_row(player,global_player,content_frame)
end

function UI.toggle_interface(player)
    
    local player_global = PlayerUtil.get_global_player(player);
    local main_frame = player_global.elements.main_frame

    if main_frame == nil then
        UI.build_interface(player)
    else
        main_frame.destroy()
        player_global.elements = {}
    end
end

function UI.on_gui_closed(event)
    if event.element and event.element.name == "pe_main_frame" then
        local player = PlayerUtil.get_player(event);
        UI.toggle_interface(player)
    end
end

function UI.key_toggle_interface(event)
    local player = PlayerUtil.get_player(event);
    UI.toggle_interface(player)
end

return UI;