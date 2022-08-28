-- * @author         MrFreeman
-- * @modifiedBy     MrFreeman
-- * @maintainedBy   MrFreeman
-- * @version        3.0
-- * @created        2022-06-25
-- * @modified       2022-08-23

arena_lib.on_celebration('colour_jump', function(arena, winner_name)
    arena_lib.HUD_send_msg_all("title", arena, colour_jump.T('The game is over!'), 2 ,'colour_jump_win',0xAEAE00)
    for pl_name,stats in pairs(arena.players) do
        local player = minetest.get_player_by_name(pl_name)
        if colour_jump.HUD[pl_name] then
            player:hud_remove(colour_jump.HUD[pl_name].scores)
            colour_jump.HUD[pl_name] = nil
        end
        minetest.after(3, function() 
            local l_data = {}
            colour_jump.scores[arena.name][pl_name] = counterOfRounds
            l_data[pl_name]=counterOfRounds
            minetest.show_formspec(pl_name, "cj_scores_mp", colour_jump.get_leader_form_endgame(arena.name,l_data))
        end, 'Done')
    end
end)