local PlayerUtil = require 'utils.player'
local Attributes = require 'app.character-base.attributes'
local Modifiers = require 'app.modifiers'
local Skills = require 'app.skills'
local TableUtil = require 'utils.table';
local UI = require 'app.ui'
local StatsUI = require 'app.stats-ui'

local Main = {}

function Main.createPlayer()
    return {
        xp = 0,
        level = 1,
        money = 10,
        attributes = Attributes.create(),
        modifiers = Modifiers.create(),
        skills = Skills.create()
    }
end

function Main.createInterface()
    return {
        controls_active = true,
        elements = TableUtil.merge(UI.createGlobals(), StatsUI.createGlobals(), TableUtil.CombineStrategy.second),
    }
end

function Main.createGlobals()
    return TableUtil.merge(Main.createPlayer(),Main.createInterface(), TableUtil.CombineStrategy.second)
end

function Main.initialize_global(player)
    global.players[player.index] = Main.createGlobals()
end

function Main.on_init()
    global.players = {}
    global.entity_players = {}
    
    for _, player in pairs(game.players) do
        Main.initialize_global(player)
        Modifiers.update(player)
    end
end

function Main.on_player_created(event)
    local player = PlayerUtil.get_player(event)
    Main.initialize_global(player)
    Modifiers.update(player)
    Attributes.disable_add_when_ap_zero(player)
end

function Main.on_player_removed(event)
    local player = PlayerUtil.get_player(event)
    global.players[player.index] = nil;
end


return Main;