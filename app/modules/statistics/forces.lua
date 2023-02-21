local json = require "utils.dkjson"

local Forces = {}

---@param force LuaForce
local function get_filename(force)
    return 'statistic/forces/'.. force.name ..'.json';
end

---@param force LuaForce
local function get_statistic(force)
    local statistic = {
        stats = {},
        forceData = {},
        ticks_played = game.ticks_played
    };

    if game.active_mods['teams'] ~= nil then
        for _,data in pairs(remove.call('teams','getFoceData')) do
            if data.cName == force.name then
                statistic.forceData.color = data.color;
                statistic.forceData.title = data.title;
                statistic.forceData.name = data.name;
                statistic.forceData.cName = data.cName;
            end
        end
    else

        statistic.forceData.name = force.name;
        statistic.forceData.color = force.color or {r = 0, g = 0, b = 0, a = 1};
    end

    for _,name in ipairs({
        "item_production_statistics",
        "fluid_production_statistics",
        "kill_count_statistics",
        "entity_build_count_statistics",
    }) do
        statistic.stats[name] = {
            input = force[name].input_counts,
            output = force[name].output_counts,
        }
    end

    return statistic;
end

---@param force LuaForce
local function write_statistic(statistic, force)
    local file = get_filename(force);
    game.write_file( file, json.encode(statistic), false, 0 )    
end

---@param f LuaForce
function Forces.save(f)
    write_statistic(get_statistic(f), f);
end

return Forces