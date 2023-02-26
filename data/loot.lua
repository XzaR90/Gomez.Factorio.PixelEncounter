require 'utils.table'
local Logger = require 'utils.logger'

local monster_size = { "small", "medium", "big", "behemoth", "leviathan", "mother" }
local monster_type = { "biter", "spitter", "worm-turret" }
local monster_element_type = { "", "explosive", "cold" }

local spawner_type = { "biter-spawner", "spitter-spawner" }

local monster_entity = {}
monster_entity["biter"] = "unit"
monster_entity["spitter"] = "unit"
monster_entity["worm-turret"] = "turret"
monster_entity["biter-spawner"] = "spawner"
monster_entity["spitter-spawner"] = "spawner"

local size_count_factor = {}
size_count_factor["small"] = 1.0
size_count_factor["medium"] = 1.5
size_count_factor["big"] = 2.5
size_count_factor["behemoth"] = 3.5
size_count_factor["leviathan"] = 4.0
size_count_factor["mother"] = 4.5
size_count_factor["spawner"] = 10.0

local size_probability_factor = {}
size_probability_factor["small"] = 1
size_probability_factor["medium"] = 1.2
size_probability_factor["big"] = 1.3
size_probability_factor["behemoth"] = 1.5
size_probability_factor["leviathan"] = 1.6
size_probability_factor["mother"] = 1.7
size_probability_factor["spawner"] = 1.9

---comment
---@param entity_name string
---@param entity string
---@param loot {count_max:number, count_min:number, item:string, probability:number}[]
local function extend(entity_name, entity, loot)
    if not data.raw[entity] or not data.raw[entity][entity_name] then
        Logger.log_information("Could not add loot to " .. (entity or "unknown") .. " " .. entity_name .. ".")
        return
    end

    
    if(data.raw[entity][entity_name].loot and loot) then
        Logger.log_information("Fuse loot to " .. entity .. " " .. entity_name .. ".")
        data.raw[entity][entity_name].loot = table.concat_array(data.raw[entity][entity_name].loot, loot)
        return
    end

    Logger.log_information("Add loot to " .. entity .. " " .. entity_name .. ".")
    data.raw[entity][entity_name].loot = loot
end

local function add_loot(entity_name, size, entity)
    local count_max = math.ceil(size_count_factor[size] * 3)
    local count_min = math.ceil(size_count_factor[size] * 1)

    extend(entity_name, entity, {
        { count_max = count_max, count_min = count_min, item = "coal",         probability = size_probability_factor[size] * 0.01 },
        { count_max = count_max, count_min = count_min, item = "stone-brick",  probability = size_probability_factor[size] * 0.03 },
        { count_max = count_max, count_min = count_min, item = "iron-plate",   probability = size_probability_factor[size] * 0.03 },
        { count_max = count_max, count_min = count_min, item = "copper-plate", probability = size_probability_factor[size] * 0.03 },
        { count_max = count_max, count_min = count_min, item = "steel-plate",  probability = size_probability_factor[size] * 0.015 },
        { count_max = count_max, count_min = count_min, item = "wood",         probability = size_probability_factor[size] * 0.01 },
    })

    if (size == 'behemoth' or size == 'big' or size == 'medium' or size == "spawner") then
        extend(entity_name, entity, {
            { count_max = count_max, count_min = count_min, item = "crude-oil-barrel", probability = size_probability_factor[size] * 0.03 },
        })
    end

    if (size == 'behemoth' or size == 'big' or size == 'mother' or size == "spawner" or size == "leviathan") then
        extend(entity_name, entity, {
            { count_max = count_max, count_min = count_min, item = "uranium-238",      probability = size_probability_factor[size] * 0.015 },
            { count_max = count_max, count_min = count_min, item = "uranium-235",      probability = size_probability_factor[size] * 0.015 },
        })
    end
end

for _, size in pairs(monster_size) do
    for _, type in pairs(monster_type) do
        for _, element in pairs(monster_element_type) do
            local entity_name = size .. "-" .. type
            if(element ~= "") then
                entity_name = size .. "-" .. element .. "-" .. type
            end

            add_loot(entity_name, size,  monster_entity[type])
        end
    end
end


for _, entity_name in pairs(spawner_type) do
    add_loot(entity_name, "spawner", "spawner" )
end