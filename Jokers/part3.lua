--Code for Part 3 Stands

local star_platinum = {
    key = "star_platinum",
    name = "Star Platinum",
    atlas = "JoJokers",
    rarity = 2,
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    pos = {x = 0, y = 0},
    cost = 7,
    config = {extra = {chips = 5, basechips = 5,spflag = true}},
    loc_txt = {
        name = "Star Platinum{}",
        text = {
            "Each {C:attention}scored card{} gives {C:blue}+#1# Chips{}",
            "Increases by {C:blue}#2#{} for each {C:attention}consecutive card",
            "{C:attention}scored{} without {C:red}discarding{}",
        }
    },
    loc_vars = function(self, info_queue, card)
        local vars = {
        card.ability.extra.chips, 
        card.ability.extra.basechips,
        card.ability.extra.spflag,
        card.ability.extra.hands,
        card.ability.extra.Xmult,
        card.ability.extra.currentPower,
        card.ability.extra.timeStopActive
        }


        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            self,
            "Achieve 50 power in 1 hand...",
            {"One final hand of the round,","If currents chips is 100 or more","Turn all discards into X Mult"," and gain "..card.ability.extra.hands.." hands","Reset chips and X Mult at end of round"}
        )}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            card.ability.extra.spflag = false
            if not context.other_card.debuff then
                local value1 = card.ability.extra.chips
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.basechips

                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.8, 0.8)
                return true end }))

                return{
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                    chips = value1,
                    card = card
                }
            end
        end
        if context.before and self.secAbility == true then
            if G.GAME.current_round.hands_left == 0 and card.ability.extra.chips >= 100 then 
                card.ability.extra.timeStopActive = true
                local currentDiscards = G.GAME.current_round.discards_left
                ease_discard(-currentDiscards,nil,true)
                ease_hands_played(card.ability.extra.hands)
                card.ability.extra.Xmult = getMult(currentDiscards)
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "The World!"})
            end
        end

        if context.end_of_round and not context.game_over and not context.repetition and G.GAME.blind.boss and not context.blueprint then
            if card.ability.extra.timeStopActive == true then
                card.ability.extra.chips = 0
                card.ability.extra.timeStopActive = false
                card.ability.extra.Xmult = 0
            end
        end

        if context.joker_main then
            if self.secAbility == false then
                if card.ability.extra.currentPower >= 50 then
                    return {
                        message = JOJO.ACTIVATE_SECRET_ABILITY(self)
                    }
                else
                    card.ability.extra.currentPower = 0
                end
            elseif card.ability.extra.timeStopActive == true then 
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
        if context.discard and card.ability.extra.spflag == false and not context.blueprint then
            card.ability.extra.spflag = true
            card.ability.extra.chips = card.ability.extra.basechips

            G.E_MANAGER:add_event(Event({func = function()
                card:juice_up(0.8, 0.8)
            return true end }))

            return{
                card = self,
                message = localize('k_reset')
            }
        end
    end
}

local sliver_chariot = {
    key ="silver_chariot",
    loc_txt = {
        name = "Silver Chariot",
        text = {
            "Gains {C:chips}+#3#{} Chips & {C:mult}+#4#{} Mult",
            "if played hand",
            "contains a {C:attention}Straight Flush{}",
            "{C:inactive}(Currently {C:chips}+#2#{} Chips, {C:mult}+#1#{} Mult){}",
            "{C:attention}#7#{}"
        }
    },
    config = {extra = {mult = 20,chips = 50,mult_gain = 5, chip_gain = 25,Xmult=2.5,secAbility = false,secAbilityText = "Send the Steel Straight Through to unlock full potential..."}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.mult,card.ability.extra.chips,card.ability.extra.chip_gain,card.ability.extra.mult_gain,card.ability.extra.Xmult,card.ability.extra.secAbility,card.ability.extra.secAbilityText}}
    end,
    rarity = 2,
    atlas = "JoJokers",
    pos = {x=4,y=0},
    cost = 4,
    calculate = function (self,card,context)   
        if context.before and next(context.poker_hands['Straight Flush']) and not context.blueprint and card.ability.extra.secAbility == false then
            local steel = 0
            for i = 1,#context.scoring_hand do
                if context.scoring_hand[i].ability.name == 'Steel Card' then
                    steel = steel + 1
                end
            end
            if steel >= 5 then
                card.ability.extra.secAbility = true;
                card.ability.extra.secAbilityText = "All played steel cards give X" .. card.abilit.extra.Xmult .. " mult"

                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.8, 0.8)
                return true end }))

                return {
                    message = 'Secret Ability Active!'
                }
            end
        end

        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and
            context.other_card.ability.name == 'Steel Card' and card.ability.extra.secAbility == true then

            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}, 
                colour = G.C.XMULT,
                x_mult = card.ability.extra.Xmult
            }
        end

        if context.joker_main then
            G.E_MANAGER:add_event(Event({func = function()
                card:juice_up(0.8, 0.8)
            return true end }))
            return {
                message="Fence!",
                mult_mod = card.ability.extra.mult,
                chip_mod = card.ability.extra.chips
            }
        end

        if context.before and next(context.poker_hands['Straight Flush']) and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain 
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain 

            G.E_MANAGER:add_event(Event({func = function()
                card:juice_up(0.8, 0.8)
            return true end }))

            return {
                message = "Charge!",
                card = card
            }
        end
    end
}

local the_world = {
    key ="world",
    loc_txt = {
        name = "The World",
        text = {
            "If a {C:attention}Boss Blind{} is defeated with at least ",
            "{X:mult,C:white}#2#x{} the score requirement,",
            "dont advance an Ante",
            "{C:inactive}(Can only retrigger each ante once){}",
            "{C:attention}#4#{}"
        }
    },
    config = {extra = {ante_reduction = 1,scoreRec = 2,secAbility = false,secAbilityText="Halt Time for 5 seconds...",reducTriggered = false,seconds = 0,repeats = 2,abilityStopper = false}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.ante_reduction,card.ability.extra.scoreRec,card.ability.extra.secAbility,card.ability.extra.secAbilityText,card.ability.extra.reducTriggered,card.ability.extra.seconds,card.ability.extra.repeats,card.ability.extra.abilityStopper}}
    end,
    rarity = 4,
    atlas = "JoJokers",
    pos = {x=6,y=0},
    cost = 10,
    blueprint_compat = false,
    calculate = function (self,card,context)

        if context.cardarea == G.play and context.repetition and not context.repetition_only and card.ability.extra.secAbility == true then
            if context.other_card.base.value == "Ace" then
                return {
                    message = "Muda!",
                    repetitions = card.ability.extra.repeats,
                    card = context.other_card
                }
            end
        end

        if context.end_of_round and not context.game_over and not context.repetition and G.GAME.blind.boss and not context.blueprint then
            if card.ability.extra.reducTriggered == false then
                card.ability.extra.reducTriggered = true
                local ante_mod = 0
                print(card.ability.extra.abilityStopper)
                if card.ability.extra.abilityStopper == false then
                    if G.GAME.chips >= G.GAME.blind.chips * card.ability.extra.scoreRec then
                        card.ability.extra.abilityStopper = true
                        ante_mod = ante_mod - card.ability.extra.ante_reduction
                        ease_ante(ante_mod)
                        if card.ability.extra.seconds >= 5 and card.ability.extra.secAbility == false then
                            card.ability.extra.secAbility = true
                            card.ability.extra.secAbilityText = "Retrigger all Aces Twice"
                            return {
                                message = "You have achieved Greatness!"
                            }
                        elseif card.ability.extra.secAbility == false then
                            card.ability.extra.seconds = card.ability.extra.seconds + 1
                        end
                        return {
                            message = "The World"
                        }
                    end
                else
                    card.ability.extra.abilityStopper = false
                end
            end
        end

        if context.ending_shop and card.ability.extra.reducTriggered == true then --In place so ability only triggers once (it triggered 14 times with the bool)
            card.ability.extra.reducTriggered = false
        end
    end
}

local cream = {
    key ="cream",
    loc_txt = {
        name = "Cream",
        text = {
            "{C:mult}Destroy{} the first card on every hand",
            "{C:attention}#2#{}"
        }
    },
    config = {extra = {secAbility = false,secAbilityText="Destroy a Blue Card...",cardsDestroyed = 0,deactivateDestroy = false}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.secAbility,card.ability.extra.secAbilityText,card.ability.extra.cardsDestroyed,card.ability.extra.deactivateDestroy}}
    end,
    rarity = 3,
    atlas = "JoJokers",
    pos = {x=4,y=4},
    cost = 10,
    calculate = function (self,card,context)
        if context.before then
            card.ability.extra.deactivateDestroy = false
            if card.ability.extra.secAbility == false then
                if context.full_hand[1].seal == "Blue"then
                    card.ability.extra.secAbility = true
                    card.ability.extra.secAbilityText = "Every 4 cards destoryed, spawn a negative black hole"
    
                    G.E_MANAGER:add_event(Event({func = function()
                        card:juice_up(0.8, 0.8)
                    return true end }))
    
                    return {
                        message = "Secert Ability Active!"
                    }
                end
            end
        end

        if context.destroying_card and card.ability.extra.deactivateDestroy == false then
            card.ability.extra.deactivateDestroy = true
            card.ability.extra.cardsDestroyed = card.ability.extra.cardsDestroyed + 1
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Obliterate!",colour=G.C.PURPLE})
            
            return {
                remove = true
            }
        end

        if context.after and not context.repetition then
            if card.ability.extra.secAbility == true then
                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.8, 0.8)
                return true end }))

                if card.ability.extra.cardsDestroyed % 4 == 0 then
                    local checkCard = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_black_hole')
                    checkCard:set_edition({negative = true},true)
                    checkCard:add_to_deck()
                    G.consumeables:emplace(checkCard)
                    play_sound('explosion_buildup1')
                    return {
                        message = "Embrace the Void!"
                    }
                end
            end
            
        end

    end
}

return {
    name = "Part 3 Stands",
    list = {star_platinum,sliver_chariot,cream,the_world}
}