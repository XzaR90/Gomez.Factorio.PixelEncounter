local PlayerUtil = require 'utils.player'
local Color = require 'utils.color'
local sensors = require("stats-ui-sensors.index")

local StatsUI = {}

function StatsUI.createGlobals()
  return {
    stats_ui = {
      main_frame = nil,
      labels = {}
    }
  }
end

local function getMainFrame(global_player)
  if not global_player.elements.stats_ui then
    return nil;
  end

  if not global_player.elements.stats_ui.main_frame then
    return nil;
  end


  return global_player.elements.stats_ui.main_frame
end


local function set_width(player, global_player)
  local main_frame = getMainFrame(global_player)
  if not main_frame or not main_frame.valid then
    StatsUI.build(player, global_player)
    main_frame = global_player.elements.stats_ui.main_frame
  end
  main_frame.style.width = (player.display_resolution.width / player.display_scale)
end

--- @param sensor {name:string,caption:table, color:{r:number,g:number,b:number}}
local function addOrUpdateRow(global_player, main_frame, sensor)
  local label_name = "pe_stats_ui_label_" .. sensor.name
  local label = global_player.elements.stats_ui.labels[label_name]
  if not label then
    label = main_frame.add({
      type = "label",
      style = "pe_stats_ui_label",
      name = label_name,
      caption = sensor.caption,
    })

    label.style.font_color = sensor.color or Color.default_font_color
    global_player.elements.stats_ui.labels[label.name] = label
    return
  end

  label.caption = sensor.caption
  label.style.font_color = sensor.color or Color.default_font_color
end

local function init(global_player)
  global_player.elements.stats_ui = {}
  global_player.elements.stats_ui.labels = {}
end

local function build(player, global_player)
  local main_frame = player.gui.screen.add({
    type = "frame",
    style = "pe_stats_ui_frame",
    direction = "vertical",
    ignored_by_interaction = true,
  })

  init(global_player)
  global_player.elements.stats_ui.main_frame = main_frame

  set_width(player, global_player)
  StatsUI.update(player, global_player)
end

function StatsUI.destroy(global_player)
  local main_frame = getMainFrame(global_player)
  if main_frame and main_frame.valid then
    main_frame.destroy()
    for _, label in pairs(global_player.elements.stats_ui.labels) do
      if label and label.valid then
        label.destroy()
      end
    end

    global_player.elements.stats_ui = nil
  end
end

function StatsUI.updateAll()
    for _, player in pairs(game.connected_players) do
      local global_player = PlayerUtil.get_global_player(player)
      StatsUI.update(player, global_player)
    end
end

function StatsUI.update(player, global_player)
  if not player or not player.valid or not player.connected then
    return
  end

  local main_frame = getMainFrame(global_player)
  if not main_frame or not main_frame.valid then
    build(player, global_player)
    main_frame = global_player.elements.stats_ui.main_frame
  end

  for _, sensor_func in pairs(sensors) do
    local sensor = sensor_func(player, global_player)
    addOrUpdateRow(global_player,main_frame, sensor)
  end
end

function StatsUI.on_player_display_resolution_changed(event)
  local player = PlayerUtil.get_player(event)
  local global_player = PlayerUtil.get_global_player(player)
  set_width(player, global_player)
end

function StatsUI.on_player_display_scale_changed(event)
  StatsUI.on_player_display_resolution_changed(event)
end

return StatsUI
