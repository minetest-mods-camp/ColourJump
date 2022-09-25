-- * @author         MrFreeman
-- * @modifiedBy     MrFreeman
-- * @maintainedBy   MrFreeman
-- * @version        3.0
-- * @created        2022-06-25
-- * @modified       2022-09-25

local isGameOver = false
local items = {}
local arena_y = 0
local numberPlatforms = 0
local numberOfPlayers = 0
local timerToRemovePlatforms = 0
local timeScreen = 0
local counterOfTimer = 0 
local counterOfRounds = 0 
local mode = 'singleplayer'
colour_jump.HUD_BACKGROUND = {}

-- function created to check if a value is inside a list. Used inside the function above for the random switch positions ( fn randomBlocks() )

local function contains(table, val)
        for i=1,#table do
           if table[i] == val then 
              return true
           end
        end
        return false
end
local winner = {0,''}
local showTimer = false
local function printTimer(time, player, showTimer)
        local valueCounter = math.floor(time)
        if showTimer then
                if valueCounter >= 0 then
                        counterOfTimer = counterOfTimer+1
                        valueCounter = valueCounter - (math.floor(counterOfTimer / numberOfPlayers))
                        if valueCounter > 0 and counterOfRounds ~= 0 then
                                arena_lib.HUD_send_msg("hotbar", player, colour_jump.T('The platforms disappear in: ') .. tostring(valueCounter) .. colour_jump.T(' SECS!'), 1 ,nil,0xFFFFFF)
                        end       
                end
        end
end

local function set_platform(colour)
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

local itemList = 1
local listValues = {} 

arena_lib.on_time_tick("colour_jump", function(arena)
        if arena.current_time == 1 then
                isGameOver = false
                items = {}
                arena_y = arena.arena_y
                numberPlatforms = 0
                numberOfPlayers = 0
                timerToRemovePlatforms = arena.timerToRemovePlatforms
                timeScreen = arena.timerToRemovePlatforms
                counterOfTimer = 0 
                counterOfRounds = 0 
                arena.counterOfRounds = 0
                arena.multi_scores = {}
                mode = 'singleplayer'
                colour_jump.scores[arena.name] = colour_jump.scores[arena.name] or {}


                for prop_nome,prop in pairs(arena) do
                        if string.find(prop_nome, "arenaCol_") and prop.isActive == true then
                                set_platform(prop)
                                table.insert(items, prop.id)
                                numberPlatforms = numberPlatforms + 1
                        end
                end
        
                for pl_name,stats in pairs(arena.players) do
                        numberOfPlayers = numberOfPlayers + 1
                end
        
                if numberOfPlayers > 1 then
                        mode = 'multiplayer'
                end

        end
        if arena.players_amount == 1 and numberOfPlayers ~= 1 then
                isGameOver = true
        end
        local scores = arena.multi_scores   
        local decreaserTimerPlatforms = arena.timerToDecreaseTimeOfPlatforms
        local score = counterOfRounds
        local stringOfRoundHUD = colour_jump.T('Lap: ').. score .. "\n"
        local function randomBlocks()
                for prop_nome,prop in pairs(arena) do
                        if string.find(prop_nome, "arenaCol_") and prop.isActive == true then
                                local values = {}
                                values = {x = tonumber(prop.x), y = tonumber(arena_y), z = tonumber(prop.z), id = tostring(prop.id), name = tostring(prop.name), hexColor = tostring(prop.hexColor)}
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
                                newPosPlatform.isActive = listValues[checker].isActive
                                newPosPlatform.hexColor = listValues[checker].hexColor
                                set_platform(newPosPlatform)                   
                        end
                        table.insert(takenNumbers, checker)
                        table.insert(newPosPlatformsList, newPosPlatform)
                end
                for prop_nome,prop in pairs(arena) do
                        if string.find(prop_nome, "arenaCol_") and prop.isActive == true then
                                if prop_nome == newPosPlatform.id then
                                        prop = newPosPlatform
                                end
                        end
                end

                for i=1, #takenNumbers do
                        takenNumbers[i] = nil
                end
end
        if ((arena.current_time % 10) == 0 and isGameOver ~= true) then
                counterOfTimer = 0
                counterOfRounds = counterOfRounds + 1
                arena.counterOfRounds = counterOfRounds
                valueCounter = math.floor(timerToRemovePlatforms)
                itemList =  math.random(1, numberPlatforms)
                randomBlocks()
                if timerToRemovePlatforms > 2.5 then
                        timerToRemovePlatforms = timerToRemovePlatforms - decreaserTimerPlatforms
                else
                        timerToRemovePlatforms = 2.5
                end
                timeScreen = timerToRemovePlatforms
                for prop,props in pairs(newPosPlatformsList) do
                        if props.id == tostring(items[itemList]) then
                                arena_lib.HUD_send_msg_all("title", arena, tostring(colour_jump.T(items[itemList])) , 3, nil, tonumber(props.hexColor))
                        end
                end
                
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
                isGameOver = true
                arena_lib.HUD_send_msg_all("title", arena, colour_jump.T('All the players fallen down! Nobody won'), 3, nil, "0xB6D53C")
                for pl_name in pairs(arena.players) do
                        local player = minetest.get_player_by_name(pl_name)
                        if colour_jump.HUD[pl_name] then
                                player:hud_remove(colour_jump.HUD[pl_name].scores)
                                player:hud_remove(colour_jump.HUD_BACKGROUND[pl_name].background)
                                colour_jump.HUD[pl_name] = nil
                        end
                end
                        arena_lib.force_arena_ending('colour_jump', arena, 'ColourJump')
        else
                              
                        for pl_name in pairs(arena.players) do
                                local player = minetest.get_player_by_name(pl_name)
                                if isGameOver ~= true then 
                                        if not colour_jump.HUD[pl_name] then
                                                local new_hud_image = {}
                                                new_hud_image.background = player:hud_add({
                                                hud_elem_type = "image",
                                                position  = {x = 1, y = 0},
                                                offset = {x = -179, y = 32},                                            
                                                name = "colour_jump_background",
                                                text = "HUD_colour_jump_round_counter.png",
                                                alignment = { x = 1.0},
                                                scale     = { x = 1.15, y = 1.15},
                                                z_index = 100                                            
                                                })
                                                colour_jump.HUD_BACKGROUND[pl_name] = new_hud_image

                                                local new_hud = {}
                                                new_hud.scores = player:hud_add({
                                                hud_elem_type = "text",
                                                position  = {x = 1, y = 0},
                                                offset = {x = -155, y = 42},                                          
                                                alignment = {x = 1.0},
                                                scale = {x = 2, y = 2},                                            
                                                name = "colour_jump_highscores",
                                                text = colour_jump.T('Lap: ') .. counterOfRounds,
                                                z_index = 100,
                                                number    = "0xFFFFFF"
                                                })
                                                colour_jump.HUD[pl_name] = new_hud

                                        else
                                                local idText = colour_jump.HUD[pl_name].scores
                                                player:hud_change(idText, "text", stringOfRoundHUD)
                                                local idBackground = colour_jump.HUD_BACKGROUND[pl_name].background
                                                player:hud_change(idBackground, "text", "HUD_colour_jump_round_counter.png")
                                        end
                                end
                       
                        if player:getpos().y < arena_y-4 then
                                local highscore = {[1]="",[2]=0}
                                for pl_name,stats in pairs(arena.players) do
                                        if counterOfRounds > highscore[2] then
                                                highscore = {pl_name,counterOfRounds}
                                        end
                                end

                                local high = highscore[2]
                                local l_data = {}
                                for pl_name,stats in pairs(arena.players) do
                                        l_data[pl_name]=counterOfRounds
                                        if colour_jump.scores[arena.name][pl_name] then
                                                if counterOfRounds > colour_jump.scores[arena.name][pl_name] then
                                                        colour_jump.scores[arena.name][pl_name] = counterOfRounds
                                                end
                                        else
                                                colour_jump.scores[arena.name][pl_name] = counterOfRounds
                                        end
                                end
                                colour_jump.store_scores(colour_jump.scores)
                                for pl_name,stats in pairs(arena.players) do
                                        local player = minetest.get_player_by_name(pl_name)
                                        if player:getpos().y < arena_y-4 then
                                                minetest.show_formspec(pl_name, "cj_scores_mp", colour_jump.get_leader_form_endgame(arena.name,l_data))
                                        end
                                end
                                        if colour_jump.HUD[pl_name] then
                                                player:hud_remove(colour_jump.HUD[pl_name].scores)
                                                player:hud_remove(colour_jump.HUD_BACKGROUND[pl_name].background)
                                                colour_jump.HUD[pl_name] = nil
                                        end
                                        arena_lib.remove_player_from_arena( pl_name , 1 )
                                return

                        end
                end
        end

end)