
local Config = require 'app.modules.enemy-evolution.config'

local EnemyEvolution = {}

local function init_or_reset()
	game.map_settings.enemy_evolution.enabled = false
	game.map_settings.enemy_evolution.time_factor = 0.0
	game.map_settings.enemy_evolution.pollution_factor = 0.0
	game.map_settings.enemy_evolution.destroy_factor = 0.0

	global.enhanced_evolution = {}
	global.enhanced_evolution.spawner_died = 0

	local settings = {}
	settings.minimum_pollution_neutral = 80000

	local pollution = {}
	pollution.chunks = nil
	pollution.amount = 0
	pollution.count = 0
	pollution.neutral = settings.minimum_pollution_neutral
	pollution.last_tick = game.tick
	pollution.current_value = 0

	local factors = {}
	factors.time = 0
	factors.technology = 0
	factors.spawner = 0
	factors.pollution = 0

	global.enhanced_evolution.pollution = pollution
	global.enhanced_evolution.factors = factors
	global.enhanced_evolution.settings = settings
end

local function get_surface()
	local surfaceIndex = 1
    for k, s in pairs(game.surfaces) do
		if s.name == "Lobby" then goto continue end
		surfaceIndex = k
		::continue::
    end

	return game.surfaces[surfaceIndex]
end

function EnemyEvolution.get_globals()
    return global.enhanced_evolution;
end

function EnemyEvolution.on_configuration_changed()
	init_or_reset()
end

local function load()
    if global.enhanced_evolution.pollution.chunks then
        return
    end

	global.enhanced_evolution.pollution.chunks = get_surface().get_chunks()
end

function EnemyEvolution.on_init()
	init_or_reset()
	load()
end

local function calculate_factor_time()
	local factor_time = Config.maximum.time
	local interval_tick = math.max(game.tick % Config.ticks_for_max_value, 1)
	if interval_tick < Config.ticks_for_max_value then
		factor_time = (interval_tick/ Config.ticks_for_max_value) ^ 2 * Config.maximum.time
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

	local factor_tech = Config.maximum.tech
	if (researched_technology_count < total_technologies) then
		factor_tech = (researched_technology_count / total_technologies) ^ 2 * Config.maximum.tech
	end

	return factor_tech
end

local function calculate_spawner()
	local factor_spawner = global.enhanced_evolution.spawner_died / Config.spawners_for_maximum

	if (factor_spawner <= 1) then
		return factor_spawner * Config.maximum.spawners
	end

	return  Config.maximum.spawners
end

local function calculate_pollution(pollution_amount, pollution_count)
	local pollution_value = pollution_amount / math.log(pollution_count)

	local delta_tick = game.tick - global.enhanced_evolution.pollution.last_tick
	global.enhanced_evolution.pollution.last_tick = game.tick

	local delta_pollution = pollution_value - global.enhanced_evolution.pollution.neutral

	global.enhanced_evolution.pollution.neutral = global.enhanced_evolution.pollution.neutral + delta_pollution * Config.adjustment_per_calculation

	local min_neutral = (1 - (global.enhanced_evolution.factors.time / Config.maximum.time) / 3) * global.enhanced_evolution.settings.minimum_pollution_neutral
	if (global.enhanced_evolution.pollution.neutral < min_neutral) then
		global.enhanced_evolution.pollution.neutral = min_neutral
	end

	global.enhanced_evolution.pollution.current_value = global.enhanced_evolution.pollution.current_value + delta_pollution * Config.pollution_factor_per_tick * delta_tick

	if (global.enhanced_evolution.pollution.current_value < 0) then
		global.enhanced_evolution.pollution.current_value = 0
	end

	if (global.enhanced_evolution.pollution.current_value < Config.maximum.pollution) then
		return global.enhanced_evolution.pollution.current_value
	end

	return Config.maximum.pollution
end

local function calculate_factor (pollution_amount, pollution_count)

	global.enhanced_evolution.factors.time = calculate_factor_time()
	global.enhanced_evolution.factors.technology = calculate_factor_technology()
	global.enhanced_evolution.factors.spawner = calculate_spawner()
	global.enhanced_evolution.factors.pollution = calculate_pollution(pollution_amount, pollution_count)

	-- factor calculation
	local new_factor = global.enhanced_evolution.factors.time + global.enhanced_evolution.factors.technology +
		global.enhanced_evolution.factors.spawner + global.enhanced_evolution.factors.pollution;
	local old_factor = game.forces["enemy"].evolution_factor

	new_factor = old_factor + (new_factor - old_factor) * Config.adjustment_per_calculation
	new_factor = math.min(new_factor, 1.0)

	game.forces["enemy"].evolution_factor = new_factor
end

-- Iterate over the chunk list (only some per tick) and count the pollution:
function EnemyEvolution.on_nth_tick_count_pollution()
	local amount = 0
	local count = 0
	local max = Config.chunks_per_counting_tick;

	load()

---@diagnostic disable-next-line: unused-local
	for i = 1, max do
		local chunk = global.enhanced_evolution.pollution.chunks(nil, nil)
		if (chunk == nil) then
			amount = global.enhanced_evolution.pollution.amount
			count = global.enhanced_evolution.pollution.count
			global.enhanced_evolution.pollution.amount = 0
			global.enhanced_evolution.pollution.count = 0
			global.enhanced_evolution.pollution.chunks = get_surface().get_chunks()
			break
		else
			global.enhanced_evolution.pollution.amount = global.enhanced_evolution.pollution.amount + get_surface().get_pollution({chunk.x * 32, chunk.y * 32})
			global.enhanced_evolution.pollution.count = global.enhanced_evolution.pollution.count + 1
		end
	end

	if (count ~= 0) then
		calculate_factor(amount, count)
	end
end

-- Count every killed spawner:
function EnemyEvolution.on_entity_died(event)
	if (event.entity.type == 'unit-spawner') then
		global.enhanced_evolution.spawner_died = global.enhanced_evolution.spawner_died + 1
	end
end

-- Reduce the number of known killed spawners so the evolution factor decreases if you are nice again:
function EnemyEvolution.on_nth_tick_forget_spawner_death ()
	if (global.enhanced_evolution and global.enhanced_evolution.spawner_died > 0) then
		global.enhanced_evolution.spawner_died = global.enhanced_evolution.spawner_died - 1
	end
end

return EnemyEvolution