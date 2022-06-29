-- * @author         MrFreeman
-- * @modifiedBy     MrFreeman
-- * @maintainedBy   MrFreeman
-- * @version        1.0
-- * @created        2022-06-25
-- * @modified       2022-06-26

local modname = "colour_jump"
arena_lib.register_minigame( modname , {

        properties = {

                items = { "Red", "Yellow", "Blue", "Orange", "Brown", "Pink", "Green", "Black", "White" },
                Red = {x = 3, y = 30, z = 75, name="wool:red", id="Red"},
                Blue = {x = -1, y = 30, z = 70, name = "wool:blue", id="Blue"},
                Yellow = {x = -1, y = 30, z = 75, name = "wool:yellow", id="Yellow"},
                Orange = {x = 7, y = 30, z = 70, name="wool:orange", id="Orange"},
                Brown = {x = 7, y = 30, z = 75, name="wool:brown", id="Brown"},
                Pink = {x = 3, y = 30, z = 70, name="wool:pink", id="Pink"},
                Green = {x = 7, y = 30, z = 80, name="wool:green", id="Green"},
                Black = {x = 3, y = 30, z = 80, name="wool:black", id="Black"},
                White = {x = -1, y = 30, z = 80, name="wool:white", id="White"},
                positions = {{x = 3, z = 75},
                                {x = -1, z = 70},
                                {x = -1, z = 75},
                                {x = 7, z = 70},
                                {x = 7, z = 75},
                                {x = 3, z = 70 },
                                {x = 7, z = 80 },
                                {x = 3, z = 80 },
                                {x = -1, z = 80 }}
        },

        prefix = "["..modname.."] ",
        time_mode = 'incremental',
        disabled_damage_types = {"fall","punch","set_hp"},
})

--====================================================
--====================================================
--            Calling the other files
--====================================================
--====================================================


local path = minetest.get_modpath(modname)


if not minetest.get_modpath("lib_chatcmdbuilder") then
        dofile(path .. "/libraries/chatcmdbuilder.lua")
end

-- this callback runs when the game starts and it has been loaded
local manager_path = path .. "/minigame_manager/"
dofile(manager_path .. "on_load.lua")

-- this callback runs when a winner is decided
dofile(manager_path .. "on_celebration.lua")

-- this callback runs about every second while the game is running (if time_mode == "incremental" or "decremental")
dofile(manager_path .. "on_time_tick.lua")

--====================================================
--====================================================
--                   Chatcommands
--====================================================
--====================================================

--needed for creating, enabling, and editing arenas

minetest.register_privilege( modname .."_admin", "Create and edit ".. modname .. " arenas")


local required_privs = {}

required_privs[modname .."_admin" ] = true


ChatCmdBuilder.new(modname, function(cmd)
        -- create arena
        cmd:sub("create :arena", function(name, arena_name)
            arena_lib.create_arena(name, modname, arena_name)
        end)
      
        cmd:sub("create :arena :minplayers:int :maxplayers:int", function(name, arena_name, min_players, max_players)
            arena_lib.create_arena(name, modname, arena_name, min_players, max_players)
        end)
      
        -- remove arena
        cmd:sub("remove :arena", function(name, arena_name)
            arena_lib.remove_arena(name, modname, arena_name)
        end)
      
        -- list of the arenas
        cmd:sub("list", function(name)
            arena_lib.print_arenas(name, modname)
        end)
      
        -- enter editor mode
        cmd:sub("edit :arena", function(sender, arena)
            arena_lib.enter_editor(sender, modname, arena)
        end)
      
        -- enable and disable arenas
        cmd:sub("enable :arena", function(name, arena)
            arena_lib.enable_arena(name, modname, arena)
        end)
      
        cmd:sub("disable :arena", function(name, arena)
            arena_lib.disable_arena(name, modname, arena)
        end)
      
      end, {
        description = [[
      
          (/help ]] .. modname .. [[)
      
          Use this to configure your arena:
          - create <arena name> [min players] [max players]
          - edit <arena name>
          - enable <arena name>
      
          Other commands:
          - remove <arena name>
          - disable <arena>
          - list (lists are created arenas)
          ]],
          privs = required_privs,
      })