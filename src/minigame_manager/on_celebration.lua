local T = minetest.get_translator("colour_jump")

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
                    if arena.rounds_counter > highscore[2] then
                            highscore = {pl_name, arena.rounds_counter}
                    end
            end

            local high = highscore[2]
            local l_data = {}
            for pl_name,stats in pairs(arena.players) do
                    l_data[pl_name] = arena.rounds_counter
                    if colour_jump.scores[arena.name][pl_name] then
                            if arena.rounds_counter > colour_jump.scores[arena.name][pl_name] then
                                    colour_jump.scores[arena.name][pl_name] = high
                            end
                    else
                            colour_jump.scores[arena.name][pl_name] = arena.rounds_counter
                    end
            end
            colour_jump.store_scores(colour_jump.scores)
            for pl_name,stats in pairs(arena.players) do
                    local player = minetest.get_player_by_name(pl_name)
                    if player:getpos().y < arena.arena_y-4 then
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
