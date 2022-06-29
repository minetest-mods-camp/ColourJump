-- * @author         MrFreeman
-- * @modifiedBy     MrFreeman
-- * @maintainedBy   MrFreeman
-- * @version        1.0
-- * @created        2022-06-25
-- * @modified       2022-06-26

arena_lib.on_celebration("colour_jump", function(arena, winner_name)

        if type(winner_name) == "string" then
                minetest.chat_send_player(winner_name, "Congrats! You won the game!!")
        end
        -- note that winner_name would be a table, if teams are enabled.
end)