local Experience = require 'app.character-base.experience'
local PlayerUtil = require 'utils.player'
local xp_bonus = require 'app.xp-gains.utils.xp-bonus'

local XpGainKill = {}

local die_cause_turret = {
    ['ammo-turret'] = true,
    ['electric-turret'] = true,
    ['fluid-turret'] = true
}

local entity_xp = {

    ['biter-spawner'] = 64,
    ['biter-explosive-spawner'] = 256,
    ['biter-cold-spawner'] = 256,
    
    ['behemoth-biter'] = 16,
    ['big-biter'] = 8,
    ['medium-biter'] = 4,
    ['small-biter'] = 1,

    ['mother-explosive-biter'] = 48,
    ['leviathan-explosive-biter'] = 32,
    ['behemoth-explosive-biter'] = 24,
    ['big-explosive-biter'] = 16,
    ['medium-explosive-biter'] = 6,
    ['small-explosive-biter'] = 2,

    ['mother-cold-biter'] = 48,
    ['leviathan-cold-biter'] = 32,
    ['behemoth-cold-biter'] = 24,
    ['big-cold-biter'] = 16,
    ['medium-cold-biter'] = 6,
    ['small-cold-biter'] = 2,
    
    --
    ['spitter-spawner'] = 64,
    ['spitter-explosive-spawner'] = 256,
    ['spitter-cold-spawner'] = 256,

    ['mother-explosive-spitter'] = 48,
    ['leviathan-explosive-spitter'] = 32,
    ['behemoth-explosive-spitter'] = 24,
    ['big-explosive-spitter'] = 16,
    ['medium-explosive-spitter'] = 6,
    ['small-explosive-spitter'] = 2,

    ['mother-cold-spitter'] = 48,
    ['leviathan-cold-spitter'] = 32,
    ['behemoth-cold-spitter'] = 24,
    ['big-cold-spitter'] = 16,
    ['medium-cold-spitter'] = 6,
    ['small-cold-spitter'] = 2,
    
    ['behemoth-spitter'] = 16,
    ['big-spitter'] = 8,
    ['medium-spitter'] = 4,
    ['small-spitter'] = 1,

    ['mother-explosive-worm-turret'] = 148,
    ['leviathan-explosive-worm-turret'] = 64,
    ['behemoth-explosive-worm-turret'] = 128,
    ['big-explosive-worm-turret'] = 56,
    ['medium-explosive-worm-turret'] = 36,
    ['small-explosive-worm-turret'] = 24,

    ['mother-cold-worm-turret'] = 148,
    ['leviathan-cold-worm-turret'] = 64,
    ['behemoth-cold-worm-turret'] = 128,
    ['big-cold-worm-turret'] = 56,
    ['medium-cold-worm-turret'] = 36,
    ['small-cold-worm-turret'] = 24,

    ['behemoth-worm-turret'] = 64,
    ['big-worm-turret'] = 48,
    ['medium-worm-turret'] = 32,
    ['small-worm-turret'] = 16,

    --
    ['character'] = 16,
    ['gun-turret'] = 8,
    ['laser-turret'] = 16,
}

function XpGainKill.on_entity_died(event)
    if not event.entity or not event.entity.valid then
        return
    end

    local victim = event.entity
    local attacker = event.cause;

    --Grant XP for hand placed land mines
    if victim.last_user then
        if victim.type == 'land-mine' then
            if attacker then
                if attacker.valid then
                    if attacker.force.index == victim.force.index then
                        return
                    end
                end
            end
            Experience.add(victim.last_user, 1)
            return
        end
    end

    if not attacker or not attacker.valid then
        return
    end


    local type = attacker.type
    if not type then
        goto continue
    end

    if attacker.force.index == 1 then
        if die_cause_turret[type] then
            if entity_xp[victim.name] then
                local xp = entity_xp[victim.name] * (1 + game.forces["enemy"].evolution_factor)
                Experience.add_to_all(xp, attacker.force.index)
                return
            end
        end
    end

    ::continue::

    if attacker.force.index == victim.force.index then
        return
    end

    if not PlayerUtil.get_cause_player[attacker.type] then
        return
    end

    local players = PlayerUtil.get_cause_player[attacker.type](attacker)
    if not players then
        return
    end

    if not players[1] then
        return
    end

    --Grant normal XP
    for _, player in pairs(players) do
        if entity_xp[victim.name] then
            local xp = entity_xp[victim.name]
            xp = xp + game.forces["enemy"].evolution_factor * victim.prototype.max_health;
            xp = xp * xp_bonus(player)

            Experience.add(player, xp)
        else
            Experience.add(player, 1 + game.forces["enemy"].evolution_factor * victim.prototype.max_health)
        end
    end
end

return XpGainKill;