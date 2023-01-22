local PlayerUtil = require 'utils.player'
local Experience = require 'app.experience'
local Attributes = require 'app.attributes'

local UI = {}

local function build_frame(player, global_player)
    local screen_element = player.gui.screen
    local main_frame = screen_element.add{type="frame", name="pe_main_frame", caption={"ui.frame_character_title"}}
    main_frame.style.size = {400, 500}
    main_frame.auto_center = true

    player.opened = main_frame
    global_player.elements.main_frame = main_frame
    return main_frame;
end

local function row_simple(player, global_player, content_frame, text, name)
    local controls_flow = content_frame.add{type="flow", name="controls_flow_" .. name, direction="horizontal", style="pe_controls_flow"}

    local controls_label = controls_flow.add({type="label", caption={"app." .. name}, name="controls_label_" .. name, style="pe_controls_label"})
    local controls_textfield = controls_flow.add(
        {
            type="textfield",
            name="pe_controls_textfield_" .. name,
            text=text,
            numeric=true,
            allow_decimal=false,
            allow_negative=false,
            style="pe_controls_textfield",
            enabled=false
        })

    global_player.elements["controls_label_" .. name] = controls_label
    global_player.elements["controls_textfield_" .. name] = controls_textfield

    return controls_flow
end

local function attributes_row(player, global_player, content_frame)
    for k, v in pairs(global_player.attributes) do
        local controls_flow = row_simple(player, global_player, content_frame, tostring(v), k)
        local controls_button = controls_flow.add{type="button", name="pe_attribute_add_" .. k, caption="+"}
        global_player.elements["pe_attribute_add_" .. k] = controls_button
    end
end

local function xp_row(player, global_player, content_frame)
    row_simple(player,global_player,content_frame,Experience.xp_label(player),"experience")
end

local function level_row(player, global_player, content_frame)
    local level = global_player.level
    row_simple(player,global_player,content_frame,tostring(level),"level")
end

local function attribute_points_row(player, global_player, content_frame)
    local ap = Attributes.points_left(player)
    row_simple(player,global_player,content_frame,tostring(ap),"attribute_points")
end

function UI.build_interface(player)
    local global_player = PlayerUtil.get_global_player(player);

    local main_frame = build_frame(player,global_player)

    local content_frame = main_frame.add{type="frame", name="content_frame", direction="vertical", style="pe_content_frame"}
    xp_row(player,global_player,content_frame)
    level_row(player,global_player,content_frame)
    attributes_row(player,global_player,content_frame)
    attribute_points_row(player,global_player,content_frame)
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