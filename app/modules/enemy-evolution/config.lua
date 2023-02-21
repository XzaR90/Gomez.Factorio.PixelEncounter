local TimeSpan = require 'utils.timespan'
local Config = {}

---@diagnostic disable-next-line: unused-local
function Config.on_runtime_mod_setting_changed(event)
    global.enhanced_evolution.settings.minimum_pollution_neutral = settings.global["pe_minimum_pollution_neutral"].value
    if(global.enhanced_evolution.pollution.neutral > global.enhanced_evolution.settings.minimum_pollution_neutral) then
        global.enhanced_evolution.pollution.neutral = global.enhanced_evolution.settings.minimum_pollution_neutral
    end
end

Config.count_every_n_ticks = 4
Config.chunks_per_counting_tick = 100
Config.ticks_for_max_value = TimeSpan.Day
Config.spawners_for_maximum = 60
Config.spawner_forget_time = TimeSpan.Minute * 12
Config.adjustment_per_calculation = 0.08
Config.pollution_factor_per_tick = 0.00002

local maximum = {}
maximum.time = 0.15
maximum.tech = 0.10
maximum.spawners = 0.6
maximum.pollution = 0.8

Config.maximum = maximum
return Config

