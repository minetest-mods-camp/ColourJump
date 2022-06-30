-- * @author         MrFreeman
-- * @modifiedBy     MrFreeman
-- * @maintainedBy   MrFreeman
-- * @version        1.0
-- * @created        2022-06-25
-- * @modified       2022-06-26

-- function created to check if a value is inside a list. Used inside the function above for the random switch positions ( fn randomBlocks() )
local function contains(table, val)
        for i=1,#table do
           if table[i] == val then 
              return true
           end
        end
        return false
end
     
local itemList = math.random(1, 9)
     
-- In this function is going to restore from block Air to Wool
function restoreBlocks()
        for i = 0,2,1 do
                for k=0,2,1 do
                        
                        minetest.set_node({x=Red.x-k, y=Red.y, z=Red.z-i}, {name=Red.name})
                        
                        minetest.set_node({x=Blue.x-k, y=Blue.y, z=Blue.z-i}, {name=Blue.name})
                        
                        minetest.set_node({x=Pink.x-k, y=Pink.y, z=Pink.z-i}, {name=Pink.name})
                        
                        minetest.set_node({x=Orange.x-k, y=Orange.y, z=Orange.z-i}, {name=Orange.name})
                        
                        minetest.set_node({x=Brown.x-k, y=Brown.y, z=Brown.z-i}, {name=Brown.name})
                        
                        minetest.set_node({x=Yellow.x-k, y=Yellow.y, z=Yellow.z-i}, {name=Yellow.name})

                        minetest.set_node({x=Green.x-k, y=Green.y, z=Green.z-i}, {name=Green.name})

                        minetest.set_node({x=Black.x-k, y=Black.y, z=Black.z-i}, {name=Black.name})
                        
                        minetest.set_node({x=White.x-k, y=White.y, z=White.z-i}, {name=White.name})
                end

        end
end
     
-- Here is where are mapped all the platform positions. This function is going to change all the platform position Switching them randomly
function randomBlocks()
        local posRed = {x = Red.x, y = Red.y, z = Red.z}
        local posBlue = {x = Blue.x, y = Blue.y, z = Blue.z}
        local posYellow = {x = Yellow.x, y = Yellow.y, z = Yellow.z}
        local posOrange = {x = Orange.x, y = Orange.y, z = Orange.z}
        local posBrown = {x = Brown.x, y = Brown.y, z = Brown.z}
        local posPink = {x = Pink.x, y = Pink.y, z = Pink.z}
        local posGreen = {x = Green.x, y = Green.y, z = Green.z}
        local posBlack = {x = Black.x, y = Black.y, z = Black.z}
        local posWhite = {x = White.x, y = White.y, z = White.z}

        local listNewPosPlatforms = {posRed,posBlue,posYellow,posOrange,posBrown,posPink, posGreen, posBlack, posWhite}
        maxCheck = 9
        minCheck = 1
        takenNumbers = {}   
        checker = math.random(minCheck, maxCheck)
        for i=1,9 do
                while (contains(takenNumbers, checker)) do
                        checker = math.random(minCheck, maxCheck)
                        if not contains(takenNumbers, checker) then break end
                end

                if  (not contains(takenNumbers, checker)) then
                        listNewPosPlatforms[checker].x = positions[i].x
                        listNewPosPlatforms[checker].z = positions[i].z                       
                end
                table.insert(takenNumbers, checker)
        end

        Blue.x = posBlue.x
        Blue.z = posBlue.z

        Red.x = posRed.x
        Red.z = posRed.z

        Pink.x = posPink.x
        Pink.z = posPink.z

        Brown.x = posBrown.x
        Brown.z = posBrown.z

        Yellow.x = posYellow.x
        Yellow.z = posYellow.z

        Orange.x = posOrange.x
        Orange.z = posOrange.z

        Green.x = posGreen.x
        Green.z = posGreen.z

        Black.x = posBlack.x
        Black.z = posBlack.z

        White.x = posWhite.x
        White.z = posWhite.z

        for i=1, #takenNumbers do
                takenNumbers[i] = nil
        end

end

arena_lib.on_time_tick("colour_jump", function(arena)

        if ((arena.current_time % 5) == 0) then
                itemList =  math.random(1, 9)
                randomBlocks()
                restoreBlocks()
                arena_lib.HUD_send_msg_all("title", arena, tostring(items[itemList]), 3, nil, "0xB6D53C")
                minetest.after(2.5, function() 
                        for n=1,9 do                      
                                if tostring(items[itemList]) ~= putAirNode[n].id then
                                        for i = 0,2,1 do
                                                        for k=0,2,1 do                                               
                                                        minetest.set_node({x=putAirNode[n].x-k, y=putAirNode[n].y, z=putAirNode[n].z-i}, {name="air"})
                                                        end
                                        end
                                end
                        end
                end, 'Done')
        end

        for pl_name in pairs(arena.players) do
                local player = minetest.get_player_by_name(pl_name)
                if player:getpos().y < Red.y-4 then
                        arena_lib.remove_player_from_arena( pl_name , 1 )
                end
        end

end)