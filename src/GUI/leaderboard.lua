local storage = minetest.get_mod_storage()

function colour_jump.store_scores(data)
    storage:set_string("scores", minetest.serialize(data))
end
function colour_jump.get_scores()
    return minetest.deserialize(storage:get_string("scores"))
end
colour_jump.scores = colour_jump.get_scores() or {}
function colour_jump.get_leader_form(arena_name,sel_idx)
    local p_names = "<no data>"
    sel_idx = sel_idx or 1

    if colour_jump.scores[arena_name] then
        local ordered_names = {}
        local data = colour_jump.scores[arena_name]
        for p_name,score in pairs(data) do
            table.insert(ordered_names,p_name)
        end
        table.sort(ordered_names,function(a,b)
            if colour_jump.scores[arena_name][a] > colour_jump.scores[arena_name][b] then return true else return false end
        end)

        if #ordered_names >=1 then
            p_names = ""
            for idx,u_name in ipairs(ordered_names) do
                local scorestr = tostring(data[u_name])
                local scorelen = string.len(scorestr)
                p_names = p_names .. scorestr
                for i = 1, 20-scorelen do
                    p_names = p_names .. " "
                end
                p_names = p_names .. u_name
                if idx ~= #ordered_names then
                    p_names = p_names .. ","
                end
            end
        end

    end

    return "formspec_version[5]"..
    "size[10.5,10.5]"..
    "background9[-.5,-.5;11.5,11.5;colour_jump_leader_bg.png;false;125]"..
    "style_type[button,textlist;border=false;textcolor=#302C2E;font=normal,bold]"..
    "style[hs_title;font_size=+3]"..
    "button[0.6,0.6;9.3,0.8;hs_title;Colour Jump Leaderboard]"..
    "button[0.6,1.6;9.3,0.8;arena_name;"..arena_name.."]"..
    "textlist[0.6,2.5;9.3,7.4;names;"..p_names..";"..sel_idx..";true]"

end

function colour_jump.get_leader_form_endgame(arena_name,l_data,sel_idx,sel_idx2)
    sel_idx = sel_idx or 1
    sel_idx2 = sel_idx2 or 1
    local p_names = "<no data>"
    local lp_names = "<no data>"
    if colour_jump.scores[arena_name] then

        local ordered_names = {}
        local data = colour_jump.scores[arena_name]
        for p_name,score in pairs(data) do
            table.insert(ordered_names,p_name)
        end
        table.sort(ordered_names,function(a,b)
            if colour_jump.scores[arena_name][a] > colour_jump.scores[arena_name][b] then return true else return false end
        end)

        if #ordered_names >=1 then
            p_names = ""
            for idx,u_name in ipairs(ordered_names) do
                local scorestr = tostring(data[u_name])
                local scorelen = string.len(scorestr)
                p_names = p_names .. scorestr
                for i = 1, 20-scorelen do
                    p_names = p_names .. " "
                end
                p_names = p_names .. u_name
                if idx ~= #ordered_names then
                    p_names = p_names .. ","
                end
            end
        end

    end

    if l_data then
        local ordered_names = {}
        local data = l_data
        for p_name,score in pairs(data) do
            table.insert(ordered_names,p_name)
        end
        table.sort(ordered_names,function(a,b)
            if colour_jump.scores[arena_name][a] > colour_jump.scores[arena_name][b] then return true else return false end
        end)

        if #ordered_names >=1 then
            lp_names = ""
            for idx,u_name in ipairs(ordered_names) do
                local scorestr = tostring(data[u_name])
                local scorelen = string.len(scorestr)
                lp_names = lp_names .. scorestr
                for i = 1, 20-scorelen do
                    lp_names = lp_names .. " "
                end
                lp_names = lp_names .. u_name
                if idx ~= #ordered_names then
                    lp_names = lp_names .. ","
                end
            end
        end

    end

    return "formspec_version[5]"..
    "size[10.5,10.5]"..
    "background9[-.5,-.5;11.5,11.5;colour_jump_leader_bg.png;false;125]"..
    "style_type[button,textlist;border=false;textcolor=#302C2E;font=normal,bold]"..
    "style[hs_title;font_size=+3]"..
    "button[0.6,0.6;9.3,0.8;hs_title;Colour Jump Leaderboard]"..
    "button[0.6,1.6;9.3,0.8;arena_name;"..arena_name.."]"..
    "style_type[button,textlist;border=false;textcolor=#CFC6B8;font=normal,bold]"..
    "textlist[0.6,6.1;9.3,3.8;g_names;"..p_names..";"..sel_idx..";true]"..
    "textlist[0.6,3.3;9.3,2;l_names;"..lp_names..";"..sel_idx2..";true]"..
    "button[0.6,2.7;9.3,0.6;this;This Game]"..
    "button[0.6,5.5;9.3,0.6;high;LeaderBoard]"
end
