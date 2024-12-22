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
            self,
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

                        if #card.ability.extra.cardToRestore >= 2 and self.secAbility == false then
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = JOJO.ACTIVATE_SECRET_ABILITY(self)})
                        end

                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Crazy Diamond!"})
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

local harvest = {
    key ="harvest",
    name = "Harvest",
    loc_txt = {
        name = "Harvest",
        text = {
            "Gains {C:money}$#2#{}",
            "if first hand has 1 scoring {C:attention}Gold Card{}",
            "{C:inactive}(Currently {C:money}$#1#{} ){}"
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
            self,
            "Play the Golden Three...",
            "Add a Gold Seal to first played gold card"
        )}
    end,
    rarity = 3,
    atlas = "JoJokers",
    pos = {x=3,y=7},
    cost = 6,
    calculate = function (self,card,context)
        if context.before and next(context.poker_hands['Three of a Kind']) and #context.full_hand == 3 and not context.blueprint and self.secAbility == false then
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
                    message = JOJO.ACTIVATE_SECRET_ABILITY(self)
                }
            end
        end

        if context.before and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 and not context.blueprint then
            local checkCard = context.full_hand[1]
            if checkCard.ability.name == 'Gold Card' then
                card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_gain 
                if self.secAbility == true then
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
            "Every {C:attention}Joker{} has a",
            "{C:green}#6# in #5#{} chance to {C:attention}Upgrade{}",
            "This joker by {C:chips}#2# Chips{} and {C:mult}#4# Mult{}",
            "If upgrade succeeds, {C:green}#6# in #7#{} chance to destroy said joker",
            "{C:inactive}(Currently: {C:chips}#1# Chips{} and {C:mult}#3# Mult{}){}"
        }
    },
    config = {extra = {
        chips = 0,
        chip_gain = 15,
        mult = 0,
        mult_gain = 5,
        upgradeOdds = 2,
        explodeOdds = 6,
        handOdds = 10,
        handSize = 0,
        currentJoker = 1,
        destroyedJokers = 0,
        lastCard = nil
        }
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.chips,
            card.ability.extra.chip_gain,
            card.ability.extra.mult,
            card.ability.extra.mult_gain,
            card.ability.extra.upgradeOdds,
            (G.GAME.probabilities.normal or 1),
            card.ability.extra.explodeOdds,
            card.ability.extra.handOdds,
            card.ability.extra.handSize,
            card.ability.extra.destroyedJokers,
            card.ability.extra.lastCard
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            self,
            "Kill a dozen people",
            {(G.GAME.probabilities.normal or 1).." in "..card.ability.extra.handOdds.." chance upon killing a joker",
            "to gain +1 hand size",
            "Currently: +"..card.ability.extra.handSize.." hand size"}
        )}
    end,
    rarity = 3,
    atlas = "JoJokers",
    pos = {x=6,y=5},
    cost = 6,
    remove_from_deck = function(self,card)
        if self.secAbility then
            G.hand:change_size(-card.ability.extra.handSize)
        end
    end,
    calculate = function (self,card,context)
        if context.other_joker and card ~= context.other_joker and not context.blueprint then
            if context.other_joker ~= card.ability.extra.lastCard  then --FIX, TRIGGERING TWICE
                card.ability.extra.lastCard = context.other_joker
                if pseudorandom("killerqueen") < G.GAME.probabilities.normal / card.ability.extra.upgradeOdds then
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                    G.E_MANAGER:add_event(Event({func = function()
                        context.other_joker:juice_up(0.8, 0.8)
                    return true end }))

                    if pseudorandom("killerqueen") < G.GAME.probabilities.normal / card.ability.extra.explodeOdds then
                        local slicedCard = context.other_joker
                        slicedCard.getting_sliced = true
                        G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                        G.E_MANAGER:add_event(Event({func = function()
                            G.GAME.joker_buffer = 0
                            card:juice_up(0.8, 0.8)
                            slicedCard:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        return true end }))
                        card.ability.extra.destroyedJokers = card.ability.extra.destroyedJokers + 1
                        if  card.ability.extra.destroyedJokers >= 12 and not self.secAbility then
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = JOJO.ACTIVATE_SECRET_ABILITY(self)})
                        elseif self.secAbility and pseudorandom("killerqueen") < G.GAME.probabilities.normal / card.ability.extra.handOdds then
                            card.ability.extra.handSize = card.ability.extra.handSize + 1
                            G.hand:change_size(1)
                            card_eval_status_text(context.other_joker, 'extra', nil, nil, nil, {message = "+1 Hand Size!"})
                        else
                            card_eval_status_text(context.other_joker, 'extra', nil, nil, nil, {message = "Kaboom!"})
                        end
                    else
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!"})
                    end
                end
            end
        end

        if context.joker_main then
            return {
                message = "Killer Queen!",
                mult_mod = card.ability.extra.mult,
                chip_mod = card.ability.extra.chips
            }
        end
    end
}

return {
    name = "Part 4 Stands",
    list = {harvest,crazy_diamond,killer_queen}
}