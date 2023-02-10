require 'utils.string'
local PlayerUtil = require 'utils.player'
local CharacterUI = require 'app.ui.character'
local ModifiersUI = require 'app.ui.modifiers'
local EvolutionUI = require 'app.ui.evolution'

local UI = {}

function UI.createGlobals()
    return {
      main_ui = {
        main_frame = nil,
        grid_frame = nil,
        menu_frame = nil,
        menu_buttons = {},
        content_frames = {},
        controls = {}
      }
    }
  end

local function build_frame(player, global_player)
    local screen_element = player.gui.screen
    local main_frame = screen_element.add{type="frame", name="pe_main_frame", caption={"ui.frame_character_title"}}
    main_frame.style.size = {700, 500}
    main_frame.auto_center = true

    player.opened = main_frame
    global_player.elements.main_ui.main_frame = main_frame
    return main_frame;
end

local function build_menu_items(global_player, menu_frame)
    local menu_btn_character = menu_frame.add({type="button", enabled = false,  name="pe_menu_button_character", caption={"ui.menu_item_character"}})
    local menu_btn_modifiers = menu_frame.add({type="button", name="pe_menu_button_modifiers", caption={"ui.menu_item_modifiers"}})
    local menu_btn_evolution = menu_frame.add({type="button", name="pe_menu_button_evolution", caption={"ui.menu_item_evolution"}})

    global_player.elements.main_ui.menu_buttons = {};
    global_player.elements.main_ui.menu_buttons["character"] = menu_btn_character
    global_player.elements.main_ui.menu_buttons["modifiers"] = menu_btn_modifiers
    global_player.elements.main_ui.menu_buttons["evolution"] = menu_btn_evolution
end

local function build_content_frames(global_player, grid_frame)
    local character_content_frame = grid_frame.add{type="frame", name="pe_character_content_frame", direction="vertical", visible = true}
    local modifiers_content_frame = grid_frame.add{type="frame", name="pe_modifiers_content_frame", direction="vertical", visible = false}
    local evolution_content_frame = grid_frame.add{type="frame", name="pe_evolution_content_frame", direction="vertical", visible = false}
    
    global_player.elements.main_ui.content_frames = {}
    global_player.elements.main_ui.content_frames["character"] = character_content_frame
    global_player.elements.main_ui.content_frames["modifiers"] = modifiers_content_frame
    global_player.elements.main_ui.content_frames["evolution"] = evolution_content_frame
end

local function toggleMenuItem(global_player, menuName)
    for k, v in pairs(global_player.elements.main_ui.menu_buttons) do
        v.enabled = true
        global_player.elements.main_ui.content_frames[k].visible = false
        if menuName == k then
            v.enabled = false
            global_player.elements.main_ui.content_frames[k].visible = true
        end
    end
end

function UI.build_interface(player)
    local global_player = PlayerUtil.get_global_player(player);

    local main_frame = build_frame(player,global_player)
    local grid_frame = main_frame.add{type="frame", name="pe_grid_frame", direction="horizontal", style="pe_content_frame"}
    global_player.elements.main_ui.grid_frame = grid_frame
    
    local menu_frame = grid_frame.add{type="frame", name="pe_menu_frame", direction="vertical"}
    global_player.elements.main_ui.menu_frame = menu_frame

    build_content_frames(global_player, grid_frame)
    build_menu_items(global_player, menu_frame)

    CharacterUI.build(player,global_player)
    ModifiersUI.build(global_player)
    EvolutionUI.build(global_player)
end

function UI.toggle_interface(player)
    
    local global_player = PlayerUtil.get_global_player(player);
    if not global_player.elements.main_ui then
        global_player.elements.main_ui = UI.createGlobals()
    end

    local main_frame = global_player.elements.main_ui.main_frame
    if main_frame == nil then
        UI.build_interface(player)
    else
        main_frame.destroy()
        global_player.elements.main_ui = UI.createGlobals().main_ui
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

function UI.on_gui_click(event)
    local element = event.element
    if not element then
        return
    end
    
    local btn_name_prefix = "pe_menu_button_"
    if element.name:starts_with(btn_name_prefix) then
        local player = PlayerUtil.get_player(event)
        local global_player = PlayerUtil.get_global_player(player)
        
        local menuName = string.sub(element.name, string.len(btn_name_prefix) + 1)
        toggleMenuItem(global_player, menuName)
    end
end

return UI;