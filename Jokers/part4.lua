--Code for Part 4 Stands   

local crazy_diamond = {
    key ="crazy_diamond",
    name="Crazy Diamond",
    loc_txt = {
        name = "Crazy Diamond",
        text = {
            "When a Card is destroyed while in play,",
            "{C:green}#2# in #1#{} chance to",
            "add a {C:attention}enchanced{} card",
            "of the same rank to your deck.",
        }
    },
    config = {extra = {
        odds = 3,
        cardToRestore = {},
        restorOdds = 8
    }},
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.odds,
            (G.GAME.probabilities.normal or 1),
            card.ability.extra.cardToRestore,
            card.ability.extra.restoreOdds
        }
        
        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            card,
            "Restore 2 lives at once...",
            {G.GAME.probabilities.normal.." in 8 chance to add a ","random seal to a card when restored"}
        )}
    end,
    rarity = 3,
    atlas = "JoJokers",
    pos = {x=0,y=5},
    blueprint_compat = false,
    cost = 6,
    calculate = function (self,card,context)
        if context.remove_playing_cards then
            for i,val in ipairs(context.removed) do
                if pseudorandom('crazydiamond') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    table.insert(card.ability.extra.cardToRestore,val)
                end
            end
            
            if #card.ability.extra.cardToRestore > 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.0,
                    func = function()
                        for i, cardCheck in ipairs(card.ability.extra.cardToRestore) do
                            local copy = copy_card(cardCheck, nil, nil, G.playing_card)
                            JOJO.APPLY_ENCHANCE(copy)
                            if pseudorandom("crazydiamond") < G.GAME.probabilities.normal / card.ability.extra.restoreOdds then
                                JOJO.APPLY_SEAL(copy)
                            end
                            copy:add_to_deck()
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            table.insert(G.playing_cards, copy)
                            G.hand:emplace(copy)
                        end

                        if #card.ability.extra.cardToRestore >= 2 and not card.ability.secret_ability then
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = JOJO.ACTIVATE_SECRET_ABILITY(card)})
                        end

                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Crazy Diamond!"})
                        card.ability.extra.cardToRestore = {}
                    return true end
                }))

                return {
                    playing_cards_added = true
                }
            end
        end
    end
}

local the_hand = {
    key ="the_hand",
    name = "The Hand",
    loc_txt = {
        name = "The Hand",
        text = {
            "{C:chips}-#1#{} Hands",
            "{C:mult}+#2#{} Discards"
        }
    },
    config = {extra = {
            hands = 2,
            discards = 2,
            totalDisThisRound = 0,
            money = 3
        }
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.hands,
            card.ability.extra.discards,
            card.ability.extra.totalDisThisRound,
            card.ability.extra.money
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            card,
            "Remove 2 Dozen cards before attacking",
            "If discard contains 5 cards, Earn $3"
        )}
    end,
    rarity = 1,
    atlas = "JoJokers",
    pos = {x=1,y=5},
    cost = 4,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        ease_discard(card.ability.extra.discards)
        ease_hands_played(-card.ability.extra.hands)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        ease_discard(-card.ability.extra.discards)
        ease_hands_played(card.ability.extra.hands)
    end,
    calculate = function (self,card,context)
        if context.discard and not context.blueprint and not card.ability.secret_ability then
            card.ability.extra.totalDisThisRound = card.ability.extra.totalDisThisRound + 1
            if card.ability.extra.totalDisThisRound >= 24 then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = JOJO.ACTIVATE_SECRET_ABILITY(card)})
            end
        elseif context.pre_discard and not context.blueprint and #context.full_hand == 5 and card.ability.secret_ability then
            ease_dollars(card.ability.extra.money)
            local _message = "The Hand!"

            if jojo_config.meme_respond then
                _message = "ZA HANDO!"
            end

            card_eval_status_text(card, 'extra', nil, nil, nil, {message = _message})
        end
    end
}

local harvest = {
    key ="harvest",
    name = "Harvest",
    loc_txt = {
        name = "Harvest",
        text = {
            "Gains {C:money}$#2#{}",
            "if first hand has exactly 1 scoring {C:attention}Gold Card{}",
            "{C:inactive}(Currently: {C:money}$#1#{C:inactive}){}"
        }
    },
    config = {extra = {
        money = 0,
        money_gain = 1,
        }
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.money,
            card.ability.extra.money_gain
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            card,
            "Play the Golden Three...",
            "Add a Gold Seal to first played gold card"
        )}
    end,
    rarity = 3,
    atlas = "JoJokers",
    pos = {x=3,y=7},
    cost = 6,
    calculate = function (self,card,context)
        if context.before and next(context.poker_hands['Three of a Kind']) and #context.full_hand == 3 and not context.blueprint and not card.ability.secret_ability then
            local gold = 0
            for i = 1,#context.scoring_hand do
                if context.scoring_hand[i].ability.name == 'Gold Card' then
                    gold = gold + 1
                end
            end
            if gold >= 3 then
                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.8, 0.8)
                return true end }))

                return {
                    message = JOJO.ACTIVATE_SECRET_ABILITY(card)
                }
            end
        end

        if context.before and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 and not context.blueprint then
            local checkCard = context.full_hand[1]
            if checkCard.ability.name == 'Gold Card' then
                card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_gain 
                if card.ability.secret_ability then
                    checkCard:set_seal('Gold',true)
                end
                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.8, 0.8)
                return true end }))
                return {
                    message = "Harvest!"
                }
            end
        end
    end,
    calc_dollar_bonus = function(self,card)
        local bonus = card.ability.extra.money
        G.E_MANAGER:add_event(Event({func = function()
            card:juice_up(0.8, 0.8)
        return true end }))
        if bonus > 0 then return bonus end
    end
}

local killer_queen = {
    key ="killer_queen",
    name = "Killer Queen",
    loc_txt = {
        name = "Killer Queen",
        text = {
            "{X:mult,C:white}X#1#{} mult",
            "Increases by {X:mult,C:white}X#3#{} every {C:attention}3{} discards",
            "{C:attention}Destroy{} a random card on this discard"
        }
    },
    config = {extra = {
            Xmult = 1,
            currentDiscards = 0,
            Xmult_Gain = 0.5,
            cardsDestroyed = 0,
            handSize = 0,
            alreadyDestroy = false,
            cardCount = 1
        }
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.Xmult,
            card.ability.extra.currentDiscards,
            card.ability.extra.Xmult_Gain,
            card.ability.extra.cardsDestroyed,
            card.ability.extra.handSize,
            card.ability.extra.alreadyDestroy,
            card.ability.extra.cardCount
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            card,
            "Keep Discarding",
            {"Gives +"..card.ability.extra.handSize.." hand size",
             "Increases every 3 cards destroyed"}
        )}
    end,
    rarity = 3,
    atlas = "JoJokers",
    pos = {x=6,y=5},
    cost = 6,
    remove_from_deck = function(self,card)
        if card.ability.secret_ability then
            G.hand:change_size(-card.ability.extra.handSize)
        end
    end,
    calculate = function (self,card,context)
        if context.pre_discard and not context.blueprint then
            card.ability.extra.alreadyDestroy = false
            card.ability.extra.currentDiscards = card.ability.extra.currentDiscards + 1

            if not card.ability.secret_ability and card.ability.extra.currentDiscards >= 3 then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_Gain
                return {
                    message = JOJO.ACTIVATE_SECRET_ABILITY(card),
                    card = card
                }
            elseif card.ability.extra.currentDiscards % 3 == 0 then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_Gain
                return {
                    message = localize('k_upgrade_ex')
                }
            end
        end

        if context.discard and card.ability.extra.currentDiscards % 3 == 0 and not context.blueprint and not card.ability.extra.alreadyDestroy then
            if pseudorandom('killerqween') > card.ability.extra.cardCount / #context.full_hand then
                card.ability.extra.cardCount = 1
                card.ability.extra.alreadyDestroy = true
                card.ability.extra.cardsDestroyed = card.ability.extra.cardsDestroyed + 1

                if card.ability.secret_ability and card.ability.extra.cardsDestroyed % 3 == 0 then
                    card.ability.extra.handSize = card.ability.extra.handSize + 1
                    G.hand:change_size(1)
                end

                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Obliterate!",colour=G.C.PURPLE})
            
                return {
                    remove = true
                }
            end
            card.ability.extra.cardCount = card.ability.extra.cardCount + 1
        end

        if context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}, 
                colour = G.C.XMULT,
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

return {
    name = "Part 4 Stands",
    list = {crazy_diamond,the_hand,harvest,killer_queen}
}