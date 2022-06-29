-- * @author         MrFreeman
-- * @modifiedBy     MrFreeman
-- * @maintainedBy   MrFreeman
-- * @version        1.0
-- * @created        2022-06-25
-- * @modified       2022-06-26

arena_lib.on_load("colour_jump", function(arena)

        items = arena.items  
        Red = arena.Red
        Blue = arena.Blue
        Yellow =arena.Yellow
        Orange =arena.Orange
        Brown =arena.Brown
        Pink = arena.Pink
        Green =arena.Green
        Black =arena.Black
        White = arena.White
        putAirNode = {Red, Blue, Yellow, Orange, Brown, Pink, Green, Black, White}
        positions = arena.positions

        for i = 0,2,1 do
                for k=0,2,1 do
                        minetest.set_node({x=Red.x-k, y=Red.y, z=Red.z-i}, {name=Red.name})
                        
                        minetest.set_node({x=Blue.x-k, y=Blue.y, z=Blue.z-i}, {name=Blue.name})
                        
                        minetest.set_node({x=Pink.x-k, y=Pink.y, z=Pink.z-i}, {name=Pink.name})
                        
                        minetest.set_node({x=Orange.x-k, y=Orange.y, z=Orange.z-i}, {name=Orange.name})
                        
                        minetest.set_node({x=Brown.x-k, y=Brown.y, z=Brown.z-i}, {name=Brown.name})
                        
                        minetest.set_node({x=Yellow.x-k, y=Yellow.y, z=Yellow.z-i}, {name=Yellow.name})

                        minetest.set_node({x=Green.x-k, y=Green.y, z=Green.z-i}, {name=Green.name})

                        minetest.set_node({x=Black.x-k, y=Black.y, z=Black.z-i}, {name=Black.name})
                        
                        minetest.set_node({x=White.x-k, y=White.y, z=White.z-i}, {name=White.name})
                end
        end

        for pl_name,stats in pairs(arena.players) do
                minetest.chat_send_player(pl_name, "The minigame will start in a few seconds!")
                minetest.chat_send_player(pl_name, "To win, you have to be the last one standing! Reach the correct platform when it will be show on your screen...GOOD LUCK!") 
        end
end)