-- * @author         MrFreeman
-- * @modifiedBy     MrFreeman
-- * @maintainedBy   MrFreeman
-- * @version        2.0
-- * @created        2022-06-25
-- * @modified       2022-07-05

arena_lib.on_load("colour_jump", function(arena)
        items = {}
        arena_y = arena.arena_y
        numberPlatforms = 0

        function set_platform(colour)
                local poss = {}
                for i = -1,1 do
                   for k = -1,1 do
                       table.insert(poss, vector.new(colour.x-i,arena_y,colour.z-k))
                  end
                end
                minetest.bulk_set_node(poss, {name=colour.name})
             end

        function set_platform_air(colour)
        local poss = {}
        for i = -1,1 do
                for k = -1,1 do
                table.insert(poss, vector.new(colour.x-i,arena_y,colour.z-k))
                end
        end
        minetest.bulk_set_node(poss, {name="air"})
        end

        for prop_nome,prop in pairs(arena) do
                if string.find(prop_nome, "arenaCol_") then
                        set_platform(prop)
                        table.insert(items, prop.id)
                        numberPlatforms = numberPlatforms + 1
                end
        end

        for pl_name,stats in pairs(arena.players) do
                minetest.chat_send_player(pl_name, "The minigame will start in a few seconds!")
                minetest.chat_send_player(pl_name, "To win, you have to be the last one standing! Reach the correct platform when it will be show on your screen...GOOD LUCK!") 
        end
end)