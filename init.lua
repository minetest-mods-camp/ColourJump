local modname = "colour_jump"
colour_jump = {}
colour_jump.HUD = {}
arena_lib.register_minigame( modname , {

        properties = {
                arenaCol_Red = {x = 5, z = 69, name="wool:red", id="Red", isActive=true, hexColor="0xFF1616"},
                arenaCol_Blue = {x = 1, z = 69, name = "wool:blue", id="Blue", isActive=true, hexColor="0x0C2DFD"},
                arenaCol_Yellow = {x = -3, z = 69, name = "wool:yellow", id="Yellow", isActive=true, hexColor="0xFFF415"},
                arenaCol_Orange = {x = -3, z = 74, name="wool:orange", id="Orange", isActive=true, hexColor="0xFF9515"},
                arenaCol_Brown = {x = 1, z = 74, name="wool:brown", id="Brown", isActive=true, hexColor="0x421C2E"},
                arenaCol_Pink = {x = 5, z = 74, name="wool:pink", id="Pink", isActive=true, hexColor="0xDDBDC6"},
                arenaCol_Green = {x = 5, z = 79, name="wool:green", id="Green", isActive=true, hexColor="0x3EF23B"},
                arenaCol_Black = {x = 1, z = 79, name="wool:black", id="Black", isActive=true, hexColor="0x000000"},
                arenaCol_White = {x = -3, z = 79, name="wool:white", id="White", isActive=true, hexColor="0xFFFFFF"},
                arena_y = 30,
                timer_initial_duration = 7.1,
                timer_min_duration = 1.5,
                timer_decrease_value = 0.1,
                timer_current = 0,
                seconds_left = 0,
                rounds_counter = 0,
            },

        prefix = "["..modname.."] ",
        time_mode = 'incremental',
        name = "Colour Jump",
        icon = "colour_jump_icon.png",
        disabled_damage_types = {"fall","punch","set_hp"},
})

--====================================================
--====================================================
--            Calling the other files
--====================================================
--====================================================


local srcpath = minetest.get_modpath(modname) .. "/src/"

if not minetest.get_modpath("lib_chatcmdbuilder") then
        dofile(srcpath .. "libraries/chatcmdbuilder.lua")
end

dofile(srcpath .. "commands.lua")
dofile(srcpath .. "privs.lua")

-- this callback runs when the game starts and it has been loaded
local manager_path = srcpath .. "/minigame_manager/"
dofile(manager_path .. "on_load.lua")

-- this callback runs when a winner is decided
dofile(manager_path .. "on_celebration.lua")

-- this callback runs about every second while the game is running (if time_mode == "incremental" or "decremental")
dofile(manager_path .. "on_time_tick.lua")
dofile(manager_path .. "leaderboard.lua")
