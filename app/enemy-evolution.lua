
local EnemyEvolution = {}

local maximum = {}
maximum.time = 0.15
maximum.tech = 0.10
maximum.spawners = 0.6
maximum.pollution = 0.8

local config = {}
config.count_every_n_ticks = 60
config.chunks_per_counting_tick = 100
config.ticks_for_max_value = 60 * 60 * 60 * 24 -- = 24 hours
config.spawners_for_maximum = 60
config.spawner_forget_time = 60 * 60 * 12 -- = 12 minutes
config.adjustment_per_calculation = 0.08
config.minimum_pollution_neutral = 80000
config.pollution_factor_per_tick = 0.00002

EnemyEvolution.config = config

-- Globals:

local pollution = {}
pollution.surface = nil
pollution.chunks = nil
pollution.amount = 0
pollution.count = 0

local function init_or_reset()
	game.map_settings.enemy_evolution.enabled = false
	game.map_settings.enemy_evolution.time_factor = 0.0
	game.map_settings.enemy_evolution.pollution_factor = 0.0
	game.map_settings.enemy_evolution.destroy_factor = 0.0

	global.spawner_died = 0
	global.pollution_neutral = config.minimum_pollution_neutral
	global.pollution_last_tick = game.tick
	global.pollution_current_value = 0
end
 
function EnemyEvolution.on_configuration_changed()
	init_or_reset()
end

local function load()
    if(pollution.surface ~= nil and  pollution.chunks ~= nil) then
        return
    end

	pollution.surface = game.surfaces["nauvis"]
	pollution.chunks = pollution.surface.get_chunks()
end

function EnemyEvolution.on_init()
	init_or_reset()
	load()
end

local function calculate_factor_time()
	local factor_time = maximum.time
	if game.tick < config.ticks_for_max_value then
		factor_time = (game.tick / config.ticks_for_max_value) ^ 2 * maximum.time
	end

	return factor_time
end

local function calculate_factor_technology()
	
	local researched_technology_count = 0
	local total_technologies = 0

    for k, force in pairs(game.forces) do
		if k ~='neutral' and k ~='enemy' then
			local technologies = force.technologies
			total_technologies = total_technologies + table.get_length(technologies)
			for _, technology in pairs(technologies) do
				if (technology.researched) then
					researched_technology_count = researched_technology_count + 1
				end
			end
		end
    end

	local factor_tech = maximum.tech
	if (researched_technology_count < total_technologies) then
		factor_tech = (researched_technology_count / total_technologies) ^ 2 * maximum.tech
	end

	return factor_tech
end

local function calculate_spawner()
	local factor_spawner = global.spawner_died / config.spawners_for_maximum

	if (factor_spawner <= 1) then
		return factor_spawner * maximum.spawners
	end

	return  maximum.spawners
end

local function calculate_factor (pollution_amount, pollution_count)

	local factor_time = calculate_factor_time()
	local factor_tech = calculate_factor_technology()
	local factor_spawner = calculate_spawner()

	-- pollution factor

	local pollution_value = pollution_amount / math.log(pollution_count)

	local delta_tick = game.tick - global.pollution_last_tick
	global.pollution_last_tick = game.tick

	local delta_pollution = pollution_value - global.pollution_neutral

	global.pollution_neutral = global.pollution_neutral + delta_pollution * config.adjustment_per_calculation

	if (global.pollution_neutral < config.minimum_pollution_neutral) then
		global.pollution_neutral = config.minimum_pollution_neutral
	end

	global.pollution_current_value = global.pollution_current_value + delta_pollution * config.pollution_factor_per_tick * delta_tick

	if (global.pollution_current_value < 0) then
		global.pollution_current_value = 0
	end

	local factor_pollution = maximum.pollution
	if (global.pollution_current_value < maximum.pollution) then
		factor_pollution = global.pollution_current_value
	end
	
	-- factor calculation
	local new_factor = factor_time + factor_tech + factor_spawner + factor_pollution
	local old_factor = game.forces["enemy"].evolution_factor

	new_factor = old_factor + (new_factor - old_factor) * config.adjustment_per_calculation
	new_factor = math.min(new_factor,1.0)

	-- game.forces["enemy"].evolution_factor_by_killing_spawners = factor_spawner;
	-- game.forces["enemy"].evolution_factor_by_time = factor_time;
	-- game.forces["enemy"].evolution_factor_by_pollution = factor_pollution;
	game.forces["enemy"].evolution_factor = new_factor
end

-- Iterate over the chunk list (only some per tick) and count the pollution:
function EnemyEvolution.on_nth_tick_count_pollution()
	local amount = 0
	local count = 0
    load()

	for i = 1, config.chunks_per_counting_tick do
		local chunk = pollution.chunks(nil, nil)
		if (chunk == nil) then
			amount = pollution.amount
			count = pollution.count
			pollution.amount = 0
			pollution.count = 0
			pollution.chunks = pollution.surface.get_chunks()
		else
			pollution.amount = pollution.amount + pollution.surface.get_pollution({chunk.x * 32, chunk.y * 32})
			pollution.count = pollution.count + 1
		end
	end

	if (count ~= 0) then
		calculate_factor(amount, count)
	end
end

-- Count every killed spawner:
function EnemyEvolution.on_entity_died(event)
	if (event.entity.type == 'unit-spawner') then
		global.spawner_died = global.spawner_died + 1
	end
end

-- Reduce the number of known killed spawners so the evolution factor decreases if you are nice again:
function EnemyEvolution.on_nth_tick_forget_spawner_death ()
	if (global.spawner_died > 0) then
		global.spawner_died = global.spawner_died - 1
	end
end

return EnemyEvolution