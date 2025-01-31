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
        abilityStopper = false,
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
            card,
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
    remove_from_deck = function(self,card)
        card.ability.secret_ability = false
        G.GAME.pool_flags.hasGoldChar = false 
    end,
    calculate = function (self,card,context)
        if context.consumeable then
            if context.consumeable.ability.name == "beetle_arrow" and card.ability.extra.req == true then
                JOJO.EVOLVE(self,card,"j_jojo_gold_exp_req")
            end
        end

        if context.end_of_round and not context.game_over and not context.repetition and G.GAME.blind.boss and not context.blueprint and not card.ability.extra.abilityStopper then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.GAME.interest_cap = G.GAME.interest_cap + (card.ability.extra.interInc * 5)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Upgrade!"})
            return true end}))
            card.ability.extra.abilityStopper = true
        end

        if context.ending_shop and card.ability.extra.abilityStopper then --In place so ability only triggers once (it triggered several times without the bool)
            card.ability.extra.abilityStopper = false
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
        interInc = 2,
        abilityStopper = false
    }
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.interInc,
            G.GAME.interest_cap
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            card,
            "Evolves from Golden Experience",
            {"Upon defeating Blind,",
            "Gain the Reward Money 3 more times"}
        )}
    end,
    rarity = 3,
    atlas = "JoJokers",
    pos = {x=4,y=12},
    cost = 6,
    in_pool = function(self, args) return false end,
    add_to_deck = function(self,card)
        card.ability.secret_ability = true
        G.GAME.pool_flags.hasGoldChar = false 
    end,
    calculate = function (self,card,context)
        if context.end_of_round and not context.game_over and not context.repetition and G.GAME.blind.boss and not context.blueprint and not card.ability.extra.abilityStopper then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.GAME.interest_cap = G.GAME.interest_cap + (card.ability.extra.interInc * 5)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!"})
            return true end}))
            card.ability.extra.abilityStopper = true
        end

        if context.ending_shop and card.ability.extra.abilityStopper and not context.blueprint then --In place so ability only triggers once (it triggered several times without the bool)
            card.ability.extra.abilityStopper = false
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

local notorius_big = {
    key ="notorius_big",
    name="Notorius BIG",
    loc_txt = {
        name = "Notorius B.I.G",
        text = {
            "Saves you from {C:attention}Death{}"
        }
    },
    config = {extra = {}},
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.overflow,
            card.ability.extra.secAbility,
            card.ability.extra.secAbilityText,
            card.ability.extra.firstTimeStopper,
            card.ability.extra.abilityStopper}

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            card,
            "I hate my life",
            "Evolve"
        )}
    end,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = false,
    atlas = "JoJokers",
    pos = {x=6,y=11},
    cost = 6,
    calculate = function (self,card,context)
        if context.game_over then
            JOJO.EVOLVE(self,card,"j_jojo_notorius_big_awaken")
            return {
                saved = true,
                colour = G.C.RED
            }
        end
    end
}

local notorius_big_awaken = {
    key ="notorius_big_awaken",
    name="Notorius BIG Awakened",
    loc_txt = {
        name = "Notorius B.I.G Awakened",
        text = {
            "{C:sticker}Eternal{}",
            "This joker gains {C:mult}+#2#{} mult",
            "for every card {C:attention}scored{} this round",
            "{C:inactive}(Currently: {C:mult}+#1#{C:inactive} mult)"
        }
    },
    config = {extra = {
        mult = 0,
        multGain = 2,
        abilityStopper = false
    }},
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.mult,
            card.ability.extra.multGain
        }

        return {vars = vars}
    end,
    rarity = 2,
    blueprint_compat = true,
    atlas = "JoJokers",
    pos = {x=6,y=11},
    cost = 6,
    in_pool = function(self, args) return false end,
    add_to_deck = function(self,card)
        card.ability.eternal = true
    end,
    calculate = function (self,card,context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multGain

            G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.4, 0.4)
            return true end }))

            return {
                message = localize('k_upgrade_ex'),
                card = card
            }
        end

        if context.joker_main then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult
            }
        end

        if context.end_of_round and not context.game_over and not context.repetition and not context.blueprint and not context.individual then
            card.ability.extra.mult = 0
            return{
                card = card,
                message = localize('k_reset')
            }
        end
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
            card,
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

local king_crimson = {
    key ="king_crimson",
    name="KingCrimson",
    loc_txt = {
        name = "King Crimson",
        text = {
            "After {C:attention}Skipping{} a blind",
            "open the {C:attention}Shop{}",
            "{C:inactive}(Rounds will still go up){}"
        }
    },
    config = {extra = {
        Xmult= 3,
        XmultActive = false,
        skipAmt = 0
    }
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.Xmult,
            card.ability.extra.XmultActive,
            card.ability.extra.skipAmt
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            card,
            "Keep Skipping",
            {"X3 Mult on Boss Blind",
            "if Small and Big Blind",
            "were both skipped"}
        )}
    end,
    rarity = 2,
    blueprint_compat = false,
    atlas = "JoJokers",
    pos = {x=1,y=10},
    cost = 6,
    calculate = function (self,card,context)
        if context.skip_blind then
            card.ability.extra.skipAmt = card.ability.extra.skipAmt + 1
            if not card.ability.secret_ability and card.ability.extra.skipAmt >= 5 then
                card.ability.extra.XmultActive = true
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = JOJO.ACTIVATE_SECRET_ABILITY(card)})
            else 
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "King Crimson!"})
            end
        end

        if card.ability.secret_ability and context.setting_blind and not G.GAME.blind.boss then
            card.ability.extra.XmultActive = false
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Inactive"})
        end

        if context.joker_main and G.GAME.blind.boss and card.ability.extra.XmultActive then
            return{
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}, 
                colour = G.C.XMULT,
                x_mult = card.ability.extra.Xmult
              }
        end

        if card.ability.secret_ability and context.end_of_round and not context.game_over and not context.repetition and G.GAME.blind.boss and not context.blueprint and not context.individual then
            card.ability.extra.XmultActive = true
            return{
                message = localize('k_reset')
            }
        end
    end
}

return {
    name="Part 5 Stands",
    list={gold_exp,gold_exp_req,notorius_big,notorius_big_awaken,kraftwork,king_crimson}
}