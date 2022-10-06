local T = minetest.get_translator("colour_jump")
local modname = "colour_jump"

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
        privs = "colour_jump_admin",
    })



minetest.register_chatcommand("colourjumpscores", {
    params = "<arena name>",

    description = "Show leaderboard",

    func = function(name, param)
        if param then
            if colour_jump.scores[param] then
                minetest.show_formspec(name, "cj_scores", colour_jump.get_leader_form(param))
            else
                return false, T('[!] No data for that arena or that arena does not exist!')
            end
        end
    end,
})
