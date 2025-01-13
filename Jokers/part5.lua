--Code for Part 5 Stands

local gold_exp = {
    key ="gold_exp",
    name="gold_experience",
    loc_txt = {
        name = "Gold Experience",
        text = {
            "Gain {X:mult,C:white}X0.1{} based on",
            "the {C:money}Interest Cap{}",
            "Add {C:attention}#1#{} to the interest cap upon",
            "a {C:attention}Boss Blind's{} defeat"
        }
    },
    config = {extra = {
        interInc = 1,
        req = false
    }
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.interInc,
            card.ability.extra.req,
            G.GAME.interest_cap
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            self,
            "Obtain Requiem",
            "Evolve"
        )}
    end,
    rarity = 2,
    atlas = "JoJokers",
    pos = {x=0,y=9},
    cost = 6,
    add_to_deck = function(self)
        G.GAME.pool_flags.hasGoldChar = true 
    end,
    remove_from_deck = function(self)
        self.secAbility = false
        G.GAME.pool_flags.hasGoldChar = false 
    end,
    calculate = function (self,card,context)
        if context.consumeable then
            if context.consumeable.ability.name == "beetle_arrow" and card.ability.extra.req == true then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = JOJO.EVOLVE(self,card,"j_jojo_gold_exp_req")})
            end
        end

        if context.end_of_round and not context.game_over and not context.repetition and G.GAME.blind.boss and not context.blueprint and not context.individual then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.GAME.interest_cap = G.GAME.interest_cap + (card.ability.extra.interInc * 5)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Upgrade!"})
            return true end}))
        end

        if context.joker_main then
            local xMult = (1+((G.GAME.interest_cap/(card.ability.extra.interInc * 5)) * 0.1))
            return{
                message = "Gold Experience!", 
                colour = G.C.CHIPS,
                Xmult_mod = xMult
              }
        end
    end
}

local gold_exp_req = {
    key ="gold_exp_req",
    name="gold_experience_requiem",
    loc_txt = {
        name = "Gold Experience Requiem",
        text = {
            "Gain {X:mult,C:white}X0.2{} based on",
            "the {C:money}Interest Cap{}",
            "Add {C:attention}#1#{} to the interest cap upon",
            "a {C:attention}Boss Blind's{} defeat"
        }
    },
    config = {extra = {
        interInc = 2
    }
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.interInc,
            G.GAME.interest_cap
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            self,
            "Evolves from Golden Experience",
            {"Upon defeating Blind,",
            "Gain the Reward Money 3 more times"}
        )}
    end,
    rarity = 3,
    atlas = "JoJokers",
    pos = {x=4,y=12},
    cost = 6,
    no_pool_flag = false,
    add_to_deck = function(self)
        self.secAbility = true
        G.GAME.pool_flags.hasGoldChar = false 
    end,
    calculate = function (self,card,context)
        if context.end_of_round and not context.game_over and not context.repetition and G.GAME.blind.boss and not context.blueprint and not context.individual then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.GAME.interest_cap = G.GAME.interest_cap + (card.ability.extra.interInc * 5)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!"})
            return true end}))
        end

        if context.joker_main then
            local xMult = (1+((G.GAME.interest_cap/(card.ability.extra.interInc * 5)) * 0.2))
            return{
                message = "Gold Experience Requiem", 
                colour = G.C.CHIPS,
                Xmult_mod = xMult
              }
        end
        
    end,
    calc_dollar_bonus = function(self,card)
        local bonus = G.GAME.blind.dollars * 3
        G.E_MANAGER:add_event(Event({func = function()
            card:juice_up(0.8, 0.8)
        return true end }))
        if bonus > 0 then return bonus end
    end
}

local kraftwork = {
    key ="kraftwork",
    name="Kraftwork",
    loc_txt = {
        name = "Kraft Work",
        text = {
            "Gives {C:attention}score{} at the beginning of the",
            "round. Amount given is the {C:attention}score{}",
            "{C:attention}overflow{} from previous blind",
            "{C:mult}Can only gain 3/4 of total blind score{}"
        }
    },
    config = {extra = {
        overflow = 0,}
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.overflow
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            self,
            "WIP",
            "Add a Gold Seal to first played gold card"
        )}
    end,
    rarity = 3,
    blueprint_compat = false,
    atlas = "JoJokers",
    pos = {x=4,y=10},
    cost = 6,
    calculate = function (self,card,context)
        if context.end_of_round and not context.repetition and not context.game_over and not context.blueprint and not context.individual then
            local chips = G.GAME.chips
            local blindChips = G.GAME.blind.chips

            if to_big ~= nil then
                chips = to_big(chips)
                blindChips = to_big(blindChips)
            end
            if G.GAME.chips >= G.GAME.blind.chips  then
                card.ability.extra.overflow = chips - blindChips
                
                return{
                    message = "Stored!"
                }
            end
        end
        if context.setting_blind and not context.blueprint then
            local overflow = card.ability.extra.overflow
            local blindChips = G.GAME.blind.chips
            local modifier = 0.75
            local zero = 0

            if to_big ~= nil then
                overflow = to_big(overflow)
                blindChips = to_big(blindChips)
                modifier = to_big(modifier)
                zero = to_big(zero)
            end

            if overflow > zero then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.0,
                    func = function()
                        if overflow > blindChips * modifier then
                            overflow = blindChips * modifier
                        end
                        ease_chips(overflow)
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Kraft Work!"})
                    return true end}))
            end
        end
    end
}

return {
    name="Part 5 Stands",
    list={gold_exp,gold_exp_req,kraftwork}
}