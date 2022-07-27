-- * @author         MrFreeman
-- * @modifiedBy     MrFreeman
-- * @maintainedBy   MrFreeman
-- * @version        2.0
-- * @created        2022-06-25
-- * @modified       2022-07-05

local modname = "colour_jump"
arena_lib.register_minigame( modname , {

        properties = {
                arenaCol_Red = {x = 5, z = 69, name="wool:red", id="Red"},
                arenaCol_Blue = {x = 1, z = 69, name = "wool:blue", id="Blue"},
                arenaCol_Yellow = {x = -3, z = 69, name = "wool:yellow", id="Yellow"},
                arenaCol_Orange = {x = -3, z = 74, name="wool:orange", id="Orange"},
                arenaCol_Brown = {x = 1, z = 74, name="wool:brown", id="Brown"},
                arenaCol_Pink = {x = 5, z = 74, name="wool:pink", id="Pink"},
                arenaCol_Green = {x = 5, z = 79, name="wool:green", id="Green"},
                arenaCol_Black = {x = 1, z = 79, name="wool:black", id="Black"},
                arenaCol_White = {x = -3, z = 79, name="wool:white", id="White"},
                arena_y = 30
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