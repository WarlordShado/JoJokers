local skip_blind_old = G.FUNCS.skip_blind
G.FUNCS.skip_blind = function (e)
    skip_blind_old(e)
    if next(SMODS.find_card("j_jojo_king_crimson")) then
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext1').config.object.pop_delay = 0
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext1').config.object:pop_out(5)
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext2').config.object.pop_delay = 0
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext2').config.object:pop_out(5) 
        G.E_MANAGER:add_event(Event({
            trigger = 'before', delay = 0.2,
            func = function()
                G.blind_prompt_box.alignment.offset.y = -10
                G.blind_select.alignment.offset.y = 40
                G.blind_select.alignment.offset.x = 0
                return true
         end}))
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                ease_round(1)
                G.blind_select:remove()
                G.blind_prompt_box:remove()
                G.blind_select = nil
                delay(0.3)
                G.STATE = G.STATES.SHOP
                G.STATE_COMPLETE = false
                return true
        end}))
    end
end

local end_consume_old = G.FUNCS.end_consumeable
G.FUNCS.end_consumeable = function(e, delayfac)
    end_consume_old(e,delayfac)
    if next(SMODS.find_card("j_jojo_king_crimson")) then
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                G.STATE = G.STATES.SHOP
                G.STATE_COMPLETE = false
                return true
        end}))
    end
end