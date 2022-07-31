-- * @author         MrFreeman
-- * @modifiedBy     MrFreeman
-- * @maintainedBy   MrFreeman
-- * @version        2.0
-- * @created        2022-06-25
-- * @modified       2022-07-31

-- function created to check if a value is inside a list. Used inside the function above for the random switch positions ( fn randomBlocks() )
local function contains(table, val)
        for i=1,#table do
           if table[i] == val then 
              return true
           end
        end
        return false
end

local showTimer = false
local function printTimer(time, player, showTimer)
        local valueCounter = math.floor(time)
        if showTimer then
                if valueCounter >= 0 then
                        counterOfTimer = counterOfTimer+1
                        valueCounter = valueCounter - (math.floor(counterOfTimer / numberOfPlayers))
                        if valueCounter >= 0 then
                                arena_lib.HUD_send_msg("hotbar", player, colour_jump.T('The platforms disappear in: ') .. tostring(valueCounter) .. colour_jump.T(' SECS!'), 1 ,nil,0xFFFFFF)
                        end       
                end
        end
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
        if ((arena.current_time % 10) == 0) then
                counterOfTimer = 0
                valueCounter = math.floor(timerToRemovePlatforms)
                itemList =  math.random(1, numberPlatforms)
                randomBlocks()
                if timerToRemovePlatforms ~= 2.5 then
                        timerToRemovePlatforms = timerToRemovePlatforms - 0.1
                else
                        timerToRemovePlatforms = 2.5
                end
                timeScreen = timerToRemovePlatforms
                arena_lib.HUD_send_msg_all("title", arena, tostring(colour_jump.T(items[itemList])) , 3, nil, "0xB6D53C")
                showTimer = true
                minetest.after(timerToRemovePlatforms, function() 
                        for prop,props in pairs(newPosPlatformsList) do
                                        if props.id ~= tostring(items[itemList]) then
                                                set_platform_air(props)
                                        end
                        end
                        newPosPlatformsList = {}
                end, 'Done')
        end
        local countPeopleFallen = 0

        for pl_name in pairs(arena.players) do
                local player = minetest.get_player_by_name(pl_name)
                printTimer(timeScreen, pl_name, showTimer)
                if player:getpos().y < arena_y-4 then
                        countPeopleFallen = countPeopleFallen + 1
                end
        end

        if (countPeopleFallen == numberOfPlayers) and numberOfPlayers ~= 1 then
                arena_lib.HUD_send_msg_all("title", arena, colour_jump.T('All the players fallen down! Nobody won'), 3, nil, "0xB6D53C")
                minetest.after(2.5, function() 
                        arena_lib.force_arena_ending('colour_jump', arena, 'ColourJump')
                end, 'Done')
        else
                for pl_name in pairs(arena.players) do
                        local player = minetest.get_player_by_name(pl_name)
                        if player:getpos().y < arena_y-4 then
                                arena_lib.remove_player_from_arena( pl_name , 1 )
                        end
                end
        end

end)