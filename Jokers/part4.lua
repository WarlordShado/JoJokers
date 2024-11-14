--Code for Part 4 Stands   

local crazy_diamond = {
    key ="crazy_diamond",
    loc_txt = {
        name = "Crazy Diamond",
        text = {
            "When a Card is ",
            "{C:mult}Destroyed{} while in play,",
            "{C:green}#2#/#1#{} chance to",
            "add a {C:attention}enchanced{} card",
            "of the same rank to your deck.",
            "{C:attention}#5#{}"
        }
    },
    config = {extra = {odds = 3,cardToRestore = {},secAbility = false,secAbilityText="Restore 2 lives at once..."}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.odds,(G.GAME.probabilities.normal or 1),card.ability.extra.cardToRestore,card.ability.extra.secAbility,card.ability.extra.secAbilityText}}
    end,
    rarity = 3,
    atlas = "JoJokers",
    pos = {x=0,y=5},
    blueprint_compat = false,
    cost = 6,
    calculate = function (self,card,context)
        if context.remove_playing_cards then
            print(#context.removed)
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
                            local enhanements = {G.P_CENTERS.m_bonus,G.P_CENTERS.m_gold,G.P_CENTERS.m_lucky,G.P_CENTERS.m_wild,G.P_CENTERS.m_mult,G.P_CENTERS.m_glass,G.P_CENTERS.m_steel,G.P_CENTERS.m_stone}
                            local enhance = math.random(1,#enhanements)
                            copy:set_ability(enhanements[enhance], nil, true)
                            if card.ability.extra.secAbility == true and math.random(1,8) == 1 then
                                local seals = {"Red","Purple","Gold","Blue"}
                                copy:set_seal(seals[math.random(1,4)],true)
                            end
                            copy:add_to_deck()
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            table.insert(G.playing_cards, copy)
                            G.hand:emplace(copy)
                        end

                        if #card.ability.extra.cardToRestore >= 2 and card.ability.extra.secAbility == false then
                            card.ability.extra.secAbility=true
                            card.ability.extra.secAbilityText="Flat 1/8 chance to add a random seal to a card when restored"
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Secert Ability Active!"})
                        end

                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Restored!"})
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
    loc_txt = {
        name = "Harvest",
        text = {
            "Gains {C:attention}$2{}",
            "if first hand has 1 scoring {C:attention}Gold Card{}",
            "{C:inactive}(Currently {C:attention}$#1#{} ){}",
            "{C:attention}#3#{}"
        }
    },
    config = {extra = {money = 0,money_gain = 2,secAbility = false,secAbilityText="Play the Golden Three to unlock full potential"}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.money,card.ability.extra.secAbility,card.ability.extra.secAbilityText}}
    end,
    rarity = 3,
    atlas = "JoJokers",
    pos = {x=3,y=7},
    cost = 6,
    calculate = function (self,card,context)
        if context.before and next(context.poker_hands['Three of a Kind']) and #context.full_hand == 3 and not context.blueprint and card.ability.extra.secAbility == false then
            local gold = 0
            for i = 1,#context.scoring_hand do
                if context.scoring_hand[i].ability.name == 'Gold Card' then
                    gold = gold + 1
                end
            end
            if gold >= 3 then
                card.ability.extra.secAbility = true;
                card.ability.extra.secAbilityText = "Add a Gold Seal to first played gold card"

                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.8, 0.8)
                return true end }))

                return {
                    message = 'Secret Ability Active!'
                }
            end
        end

        if context.before and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 and not context.blueprint then
            local checkCard = context.full_hand[1]
            if checkCard.ability.name == 'Gold Card' then
                card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_gain 
                if card.ability.extra.secAbility == true then
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

return {
    name = "Part 4 Stands",
    list = {harvest,crazy_diamond}
}