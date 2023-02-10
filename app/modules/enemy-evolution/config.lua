local Config = {}

Config.count_every_n_ticks = 119
Config.chunks_per_counting_tick = 100
Config.ticks_for_max_value = 60 * 60 * 60 * 24 -- = 24 hours
Config.spawners_for_maximum = 60
Config.spawner_forget_time = 60 * 60 * 12 -- = 12 minutes
Config.adjustment_per_calculation = 0.08
Config.minimum_pollution_neutral = 80000
Config.pollution_factor_per_tick = 0.00002

local maximum = {}
maximum.time = 0.15
maximum.tech = 0.10
maximum.spawners = 0.6
maximum.pollution = 0.8

Config.maximum = maximum
return Config