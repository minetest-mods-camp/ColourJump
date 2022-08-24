-- * @author         MrFreeman
-- * @modifiedBy     MrFreeman
-- * @maintainedBy   MrFreeman
-- * @version        3.0
-- * @created        2022-06-25
-- * @modified       2022-08-23

arena_lib.on_celebration('colour_jump', function(arena, winner_name)
    for pl_name,stats in pairs(arena.players) do
        local player = minetest.get_player_by_name(pl_name)
        if colour_jump.HUD[pl_name] then
            player:hud_remove(colour_jump.HUD[pl_name].scores)
            colour_jump.HUD[pl_name] = nil
        end
    end
end)