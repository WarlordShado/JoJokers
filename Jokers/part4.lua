--Code for Part 4 Stands   

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
    discovered = true,
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
    list = {harvest}
}