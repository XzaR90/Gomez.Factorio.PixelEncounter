local PlayerUtil = require 'utils.player'
local Main = require 'app.main'
local UI = require 'app.ui'
local EvolutionUI = require 'app.ui.evolution'
local StatsUI = require 'app.stats-ui'
local StatisticsUI = require 'app.ui.statistics'
local CharacterUI = require 'app.ui.character'
local ModifiersUI = require 'app.ui.modifiers'
local Shortcut = require 'app.shortcut'
local Refresh = require 'app.refresh'
local EntityPlayer = require 'app.entity-player'

local Experience = require 'app.character-base.experience'
local Attributes = require 'app.character-base.attributes'
local Modifiers = require 'app.modifiers'

local XpGainSimple = require 'app.xp-gains.simple'
local XpGainResearch = require 'app.xp-gains.research'
local XpGainKill = require 'app.xp-gains.kill'

local Statistics = require 'app.modules.statistics.main'
local EnemyEvolution = require 'app.modules.enemy-evolution.main'
local EnemyEvolutionConfig = require 'app.modules.enemy-evolution.config'

local critical_hit = require 'app.skills.critical-hit'

require 'utils.string'

script.on_nth_tick(EntityPlayer.updateInterval, EntityPlayer.on_nth_tick_update_existing_entity_player)
script.on_nth_tick(EnemyEvolutionConfig.count_every_n_ticks, EnemyEvolution.on_nth_tick_count_pollution)
script.on_nth_tick(EnemyEvolutionConfig.spawner_forget_time, EnemyEvolution.on_nth_tick_forget_spawner_death)
script.on_nth_tick(31, function()
    StatsUI.updateAll()
    CharacterUI.updateAll()
    EvolutionUI.updateAll()
    ModifiersUI.updateAll()
    StatisticsUI.updateAll()
end)

script.on_init(function()
    Main.on_init()
    EnemyEvolution.on_init()
    Statistics.on_init()
end)

script.on_event(defines.events.on_tick, function(event)
    Statistics.tick(event.tick);
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    EnemyEvolutionConfig.on_runtime_mod_setting_changed(event)
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

script.on_event(defines.events.on_player_respawned, function(event)
    Modifiers.on_player_respawned(event)
end)

script.on_event(defines.events.on_player_joined_game, function(event)
    Modifiers.on_player_joined_game(event)
end)

script.on_event(defines.events.on_player_display_resolution_changed, function(event)
    StatsUI.on_player_display_resolution_changed(event);
end)

script.on_event(defines.events.on_player_display_scale_changed, function(event)
    StatsUI.on_player_display_scale_changed(event);
end)


script.on_event("pe_toggle_interface", UI.key_toggle_interface)
script.on_event(defines.events.on_gui_closed, UI.on_gui_closed)


script.on_event(defines.events.on_gui_click, function(event)
    UI.on_gui_click(event)
    Attributes.on_gui_click(event)
end)

script.on_event(Experience.on_player_level_up, function(event)
    local player = PlayerUtil.get_player(event)
    local global_player = PlayerUtil.get_global_player(player)
    CharacterUI.update_ap(player, global_player)
    Attributes.disable_add_when_ap_zero(player, global_player)
    Modifiers.update(player)
end)

script.on_event(Attributes.on_player_attribute_add, function(event)
    local player = PlayerUtil.get_player(event)
    Modifiers.update(player)
    CharacterUI.updateAttribute(player, event.attribute_name)
    CharacterUI.update_ap(player, nil, event.ap_left)
    Attributes.disable_add_when_ap_zero(player, nil, event.ap_left)
end)
  
script.on_event(defines.events.on_lua_shortcut, Shortcut.on_lua_shortcut)

------------------------------------------------------------------------------
script.on_event(defines.events.on_player_repaired_entity, function(event)
    XpGainSimple.on_player_repaired_entity(event)
end)
script.on_event(defines.events.on_player_crafted_item, function(event)
    XpGainResearch.on_player_crafted_item(event)
end)

script.on_event(defines.events.on_entity_died,function(event)
    XpGainKill.on_entity_died(event)
    EnemyEvolution.on_entity_died(event)
end)

script.on_event(defines.events.on_research_finished, function(event)
    XpGainResearch.on_research_finished(event)
end)
script.on_event(defines.events.on_player_mined_entity, function(event)
    XpGainSimple.on_player_mined_entity(event)
    end,
    {{filter = "type", type = "tree"}, {filter = "type", type = "simple-entity"}})

script.on_event(defines.events.on_entity_damaged, function(event)
    critical_hit(event)
    end,
    {{filter = "type", type = "unit"}, {filter = "type", type = "unit-spawner"}, 
    {filter = "type", type = "wall"}, {filter = "type", type = "gate"}, {filter = "type", type = "spider-vehicle"},
    {filter = "type", type = "car"},{filter = "type", type = "electric-turret"}, 
    {filter = "type", type = "artillery-turret"}, {filter = "type", type = "ammo-turret"},  
    {filter = "type", type = "fluid-turret"}, {filter = "type", type = "turret"}, 
    {filter = "type", type = "character"}}) -- event filters 