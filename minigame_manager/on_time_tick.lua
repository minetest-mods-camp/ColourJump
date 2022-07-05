-- * @author         MrFreeman
-- * @modifiedBy     MrFreeman
-- * @maintainedBy   MrFreeman
-- * @version        2.0
-- * @created        2022-06-25
-- * @modified       2022-07-05

-- function created to check if a value is inside a list. Used inside the function above for the random switch positions ( fn randomBlocks() )
local function contains(table, val)
        for i=1,#table do
           if table[i] == val then 
              return true
           end
        end
        return false
end

local itemList = 1
local listValues = {} 

arena_lib.on_time_tick("colour_jump", function(arena)
        function randomBlocks()
                for prop_nome,prop in pairs(arena) do
                        if string.find(prop_nome, "arenaCol_") then
                                local values = {}
                                values = {x = tonumber(prop.x), y = tonumber(arena_y), z = tonumber(prop.z), id = tostring(prop.id), name = tostring(prop.name)}
                                table.insert(listValues, values)
                        end
                end

                takenNumbers = {}    
                newPosPlatformsList = {}    
                checker = math.random(1, numberPlatforms)
                for i=1,numberPlatforms do
                        while (contains(takenNumbers, checker)) do
                                checker = math.random(1, numberPlatforms)
                                if not contains(takenNumbers, checker) then break end
                        end
        
                        if  (not contains(takenNumbers, checker)) then
                                newPosPlatform = {}   
                                newPosPlatform.x = listValues[i].x
                                newPosPlatform.y = arena_y
                                newPosPlatform.z = listValues[i].z
                                newPosPlatform.id = listValues[checker].id
                                newPosPlatform.name = listValues[checker].name
                                set_platform(newPosPlatform)                   
                        end
                        table.insert(takenNumbers, checker)
                        table.insert(newPosPlatformsList, newPosPlatform)
                end
                for prop_nome,prop in pairs(arena) do
                        if string.find(prop_nome, "arenaCol_") then
                                if prop_nome == newPosPlatform.id then
                                        prop = newPosPlatform
                                end
                        end
                end

                for i=1, #takenNumbers do
                        takenNumbers[i] = nil
                end
end
        if ((arena.current_time % 5) == 0) then
                itemList =  math.random(1, numberPlatforms)
                randomBlocks()
                arena_lib.HUD_send_msg_all("title", arena, tostring(items[itemList]), 3, nil, "0xB6D53C")
                minetest.after(2.5, function() 
                        for prop,props in pairs(newPosPlatformsList) do
                                        if props.id ~= tostring(items[itemList]) then
                                                set_platform_air(props)
                                        end
                        end
                        newPosPlatformsList = {}
                end, 'Done')
        end

        for pl_name in pairs(arena.players) do
                local player = minetest.get_player_by_name(pl_name)
                if player:getpos().y < arena_y-4 then
                        arena_lib.remove_player_from_arena( pl_name , 1 )
                end
        end
end)