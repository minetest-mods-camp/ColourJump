-- * @author         MrFreeman
-- * @modifiedBy     MrFreeman
-- * @maintainedBy   MrFreeman
-- * @version        3.0
-- * @created        2022-06-25
-- * @modified       2022-08-25

arena_lib.on_load("colour_jump", function(arena)
        local isGameOver = false
        local items = {}
        local arena_y = arena.arena_y
        local numberPlatforms = 0
        local numberOfPlayers = 0
        local timerToRemovePlatforms = arena.timerToRemovePlatforms
        local timeScreen = arena.timerToRemovePlatforms
        local counterOfTimer = 0 
        local counterOfRounds = 0 
        arena.multi_scores = {}
        local mode = 'singleplayer'
        colour_jump.scores[arena.name] = colour_jump.scores[arena.name] or {}

       local  function set_platform(colour)
                local poss = {}
                for i = -1,1 do
                   for k = -1,1 do
                       table.insert(poss, vector.new(colour.x-i,arena_y,colour.z-k))
                  end
                end
                minetest.bulk_set_node(poss, {name=colour.name})
             end

        local function set_platform_air(colour)
        local poss = {}
        for i = -1,1 do
                for k = -1,1 do
                table.insert(poss, vector.new(colour.x-i,arena_y,colour.z-k))
                end
        end
        minetest.bulk_set_node(poss, {name="air"})
        end

        for prop_nome,prop in pairs(arena) do
                if string.find(prop_nome, "arenaCol_") and prop.isActive == true then
                        set_platform(prop)
                        table.insert(items, prop.id)
                        numberPlatforms = numberPlatforms + 1
                end
        end

        for pl_name,stats in pairs(arena.players) do
                minetest.chat_send_player(pl_name, colour_jump.T("The minigame will start in a few seconds!"))
                minetest.chat_send_player(pl_name, colour_jump.T("To win, you have to be the last one standing! Reach the correct platform when it will be show on your screen...GOOD LUCK!"))
                numberOfPlayers = numberOfPlayers + 1
        end

        if numberOfPlayers > 1 then
                mode = 'multiplayer'
        end
end)