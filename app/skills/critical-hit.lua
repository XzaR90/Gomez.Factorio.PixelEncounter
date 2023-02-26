require 'utils.math'
local PlayerUtil = require 'utils.player'
local Attributes = require 'app.character-base.attributes'
local Particles = require 'app.particles'
local XpGainKill = require 'app.xp-gains.kill'
local Print = require 'app.utils.print'
local EntityPlayer = require 'app.entity-player'

local function create_critical_hit_effect(entity, level, damage)
    level = math.max(1, level % 100)
    level = math.ceil(level)

    if string.find(entity.type, 'unit') or entity.type == 'character' or entity.type == 'turret' then
        Particles.create_blood_particles(entity.surface, 200 + level * 10, entity.position, 2 + level / 10)
        Particles.create_guts_particles(entity.surface, 40 + level * 2, entity.position, 2 + level / 10)
    else
        Particles.create_remnants_particles(entity.surface, level, entity.position, 1 + level / 10)
    end

    entity.surface.play_sound { path = 'utility/axe_fighting', position = entity.position, volume_modifier = 1 }
    Print.damage(entity, damage)
end

local function get_entity_pot(entity, start_penalty)
    local global_victim
    if(entity.type == 'character') then
        global_victim = PlayerUtil.get_global_player(entity)
    else
        global_victim = EntityPlayer.get(entity)
        if not global_victim then
            global_victim = EntityPlayer.replace_and_get(entity)
        end
    end

    local entity_level_penalty = global_victim.level * 0.33;
    local entity_actual_dexterity= math.max(global_victim.attributes.dexterity - entity_level_penalty, Attributes.initialPoint) - start_penalty
    return  entity_actual_dexterity
end

return function(event)
    local entity = event.entity
    local damage_type = event.damage_type
    local original_damage_amount = event.original_damage_amount
    local cause = event.cause

    if not (cause and cause.valid and entity and entity.valid and entity.health > 0 and damage_type and original_damage_amount) then
        return
    end

    if cause.type == 'character' and damage_type.name ~= 'poison' and damage_type.name ~= 'cold' then
        local player = cause.player

        if not (player and player.valid) then
            return
        end

        local global_player = PlayerUtil.get_global_player(player)
        local start_penalty = Attributes.initialPoint - 2;
        local level_penalty = global_player.level * 0.33;
    
        local actual_strength = math.max(global_player.attributes.strength - level_penalty, Attributes.initialPoint) - start_penalty
        local actual_dexterity = math.max(global_player.attributes.dexterity - level_penalty, Attributes.initialPoint) - start_penalty

        local new_damage = original_damage_amount

        if (string.find(entity.type, 'unit') or string.find(entity.type, 'turret') or entity.type == 'car'
            or entity.type == 'character' or entity.type == 'spider-vehicle') then
            
            local entity_pot = get_entity_pot(entity, start_penalty)

            -- CRITICAL HITS
            local improbability_pot = 100 + actual_dexterity + entity_pot
            if damage_type.name == 'fire' then --because damage per tick
                improbability_pot = improbability_pot * 60
            end

            improbability_pot = math.floor(improbability_pot)
            if actual_dexterity > math.random(0, improbability_pot) then
                local interval = 1.5
                if global_player.skills.cooldowns.critical_hit + 60 * interval < game.tick then
                    global_player.skills.cooldowns.critical_hit = game.tick
                    new_damage = math.min(new_damage * 2,new_damage * math.log(actual_strength, 10))
                    create_critical_hit_effect(entity, actual_dexterity - global_player.level / 0.5, new_damage)
                end
            end
        end

        if new_damage > original_damage_amount then
			local dif = new_damage - original_damage_amount
			if entity.health < dif then  -- give kill xp to player because the extra damage will kill entity
                XpGainKill.on_entity_died(event)
            end

            if entity.valid then
                entity.health = entity.health + event.final_damage_amount
                entity.damage(new_damage, player.force, damage_type.name) -- this fires the event again	
            end
        end
    end
end
