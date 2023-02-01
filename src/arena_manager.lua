local T = minetest.get_translator("colour_jump")

local function contains() end
local function print_timer() end
local function set_platform() end
local function set_platform_air() end
local function random_blocks() end

local takenNumbers = {}
local newPosPlatformsList = {}
local checker = 0
local newPosPlatform = {}


arena_lib.on_load("colour_jump", function(arena)
    colour_jump.scores[arena.name] = colour_jump.scores[arena.name] or {}
    arena.timer_current = arena.timer_initial_duration
    arena.seconds_left = arena.timer_initial_duration

    for prop_name, prop in pairs(arena) do
        if string.find(prop_name, "arenaCol_") and prop.isActive == true then
            prop.y = arena.y
            set_platform(prop)
            table.insert(arena.items, prop.id)
        end
    end

    for pl_name,stats in pairs(arena.players) do
        minetest.chat_send_player(pl_name, T("The minigame will start in a few seconds!"))
        minetest.chat_send_player(pl_name, T("To win, you have to be the last one standing! Reach the correct platform when it will be show on your screen...GOOD LUCK!"))
    end
end)


arena_lib.on_celebration('colour_jump', function(arena, winner_name)
    arena_lib.HUD_send_msg_all("title", arena, T('The game is over!'), 2 ,'colour_jump_win',0xAEAE00)
    for pl_name,stats in pairs(arena.players) do
        local player = minetest.get_player_by_name(pl_name)
        if colour_jump.HUD[pl_name] then
            player:hud_remove(colour_jump.HUD[pl_name].scores)
            player:hud_remove(colour_jump.HUD_BACKGROUND[pl_name].background)
            colour_jump.HUD[pl_name] = nil
        end

        minetest.after(3, function()
            local highscore = {[1]="",[2]=0}
            for pl_name,stats in pairs(arena.players) do
                if arena.rounds_counter_temp > highscore[2] then
                    highscore = {pl_name, arena.rounds_counter_temp}
                end
            end

            local high = highscore[2]
            local l_data = {}

            for pl_name,stats in pairs(arena.players) do
                l_data[pl_name] = arena.rounds_counter_temp
                if colour_jump.scores[arena.name][pl_name] then
                    if arena.rounds_counter_temp > colour_jump.scores[arena.name][pl_name] then
                        colour_jump.scores[arena.name][pl_name] = high
                    end
                else
                    colour_jump.scores[arena.name][pl_name] = arena.rounds_counter_temp
                end
            end

            colour_jump.store_scores(colour_jump.scores)
            for pl_name,stats in pairs(arena.players) do
                local player = minetest.get_player_by_name(pl_name)
                if player:get_pos().y < arena.y -4 then
                    minetest.show_formspec(pl_name, "cj_scores_mp", colour_jump.get_leader_form_endgame(arena.name,l_data))
                end
            end
            if colour_jump.HUD[pl_name] then
                player:hud_remove(colour_jump.HUD[pl_name].scores)
                player:hud_remove(colour_jump.HUD_BACKGROUND[pl_name].background)
                colour_jump.HUD[pl_name] = nil
            end
            minetest.show_formspec(pl_name, "cj_scores_mp", colour_jump.get_leader_form_endgame(arena.name,l_data))
        end, 'Done')
    end
end)


arena_lib.on_time_tick("colour_jump", function(arena)

    local stringOfRoundHUD = T('Lap: ').. arena.rounds_counter_temp .. "\n"

    if ((arena.current_time % 10) == 0 and not arena.in_celebration) then
        arena.rounds_counter_temp = arena.rounds_counter_temp + 1
        arena.seconds_left = math.floor(arena.timer_current)
        local right_platform_id = math.random(1, arena.platforms_amount)
        random_blocks(arena)
        if arena.timer_current > arena.timer_min_duration then
            arena.timer_current = arena.timer_current - arena.timer_decrease_value
        else
            arena.timer_current = arena.timer_min_duration
        end
        for prop,props in pairs(newPosPlatformsList) do
            if props.id == tostring(arena.items[right_platform_id]) then
                arena_lib.HUD_send_msg_all("title", arena, tostring(T(arena.items[right_platform_id])) , 3, nil, tonumber(props.hexColor))
            end
        end

        arena.show_timer = true
        minetest.after(arena.timer_current, function()
            for prop,props in pairs(newPosPlatformsList) do
                if props.id ~= tostring(arena.items[right_platform_id]) then
                    set_platform_air(props)
                end
            end
            newPosPlatformsList = {}
        end, 'Done')
    end

    if arena.show_timer then
        arena.seconds_left = arena.seconds_left -1
        if arena.seconds_left > 0 then                                      -- TODO globalstep to display float values
            print_timer(arena.players, arena.seconds_left, arena.rounds_counter_temp)
        end
    end

    local countPeopleFallen = 0

    for pl_name in pairs(arena.players) do
        local player = minetest.get_player_by_name(pl_name)
        if player:get_pos().y < arena.y -4 then
                countPeopleFallen = countPeopleFallen + 1
        end
    end

    if (countPeopleFallen == arena.players_amount) and arena.players_amount > 1 then
        arena_lib.HUD_send_msg_all("title", arena, T('All the players fallen down! Nobody won'), 3, nil, "0xB6D53C")
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
        -- TODO: move HUD into a separate file
        for pl_name in pairs(arena.players) do
            local player = minetest.get_player_by_name(pl_name)
            if not arena.in_celebration then
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
                    text = T('Lap: ') .. arena.rounds_counter_temp,
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

            if player:get_pos().y < arena.y -4 then
                local highscore = {[1]="",[2]=0}
                for pl_name,stats in pairs(arena.players) do
                    if arena.rounds_counter_temp > highscore[2] then
                        highscore = {pl_name,arena.rounds_counter_temp}
                    end
                end

                local high = highscore[2]
                local l_data = {}
                for pl_name,stats in pairs(arena.players) do
                    l_data[pl_name] = arena.rounds_counter_temp
                    if colour_jump.scores[arena.name][pl_name] then
                        if arena.rounds_counter_temp > colour_jump.scores[arena.name][pl_name] then
                            colour_jump.scores[arena.name][pl_name] = arena.rounds_counter_temp
                        end
                    else
                        colour_jump.scores[arena.name][pl_name] = arena.rounds_counter_temp
                    end
                end
                colour_jump.store_scores(colour_jump.scores)
                for pl_name,stats in pairs(arena.players) do
                    local player = minetest.get_player_by_name(pl_name)
                    if player:get_pos().y < arena.y -4 then
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



--- LOCAL FUNCTIONS

-- function created to check if a value is inside a list. Used inside the function above for the random switch positions ( fn random_blocks() )
function contains(table, val)
    for i=1,#table do
       if table[i] == val then
          return true
       end
    end
    return false
end

function print_timer(pl_names, time, round)
    for pl_name, _ in pairs(pl_names) do
        if round ~= 0 then
            arena_lib.HUD_send_msg("hotbar", pl_name, T('The platforms disappear in: ') .. time .. T(' SECS!'), 1 ,nil,0xFFFFFF)
        end
    end
end

function set_platform(colour)
    local poss = {}
    for i = -1,1 do
        for k = -1,1 do
            table.insert(poss, vector.new(colour.x-i,colour.y,colour.z-k))
        end
    end
    minetest.bulk_set_node(poss, {name=colour.name})
end

function set_platform_air(colour)
    local poss = {}
    for i = -1,1 do
        for k = -1,1 do
            table.insert(poss, vector.new(colour.x-i,colour.y,colour.z-k))
        end
    end
    minetest.bulk_set_node(poss, {name="air"})
end

function random_blocks(arena)

  local list_values = arena.list_values

    for prop_nome,prop in pairs(arena) do
        if string.find(prop_nome, "arenaCol_") and prop.isActive == true then
            local values = {}
            values = {x = tonumber(prop.x), y = tonumber(arena.y), z = tonumber(prop.z), id = tostring(prop.id), name = tostring(prop.name), hexColor = tostring(prop.hexColor)}
            table.insert(list_values, values)
        end
    end

    local platforms_amount = arena.platforms_amount

    takenNumbers = {}
    newPosPlatformsList = {}
    checker = math.random(1, platforms_amount)
    for i=1, platforms_amount do
        while (contains(takenNumbers, checker)) do
            checker = math.random(1, platforms_amount)
            if not contains(takenNumbers, checker) then break end
        end

        if  (not contains(takenNumbers, checker)) then
            newPosPlatform = {}
            newPosPlatform.x = list_values[i].x
            newPosPlatform.y = arena.y
            newPosPlatform.z = list_values[i].z
            newPosPlatform.id = list_values[checker].id
            newPosPlatform.name = list_values[checker].name
            newPosPlatform.isActive = list_values[checker].isActive
            newPosPlatform.hexColor = list_values[checker].hexColor
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
