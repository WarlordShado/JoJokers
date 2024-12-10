--Code for Part 6 Stands

local googoodolls = {
    key ="googoodolls",
    name="GooGooDolls",
    loc_txt = {
        name = "GooGoo Dolls",
        text = {
            "{C:attention}Invert{} the rank of number cards",
            "{C:inactive}(Example: 10 = 2){}"
        }
    },
    config = {extra = {
        overflow = 0,
        secAbility = false,
        abilityStopper=false,
        firstTimeStopper = true}
    },
    loc_vars = function(self,info_queue,card)
        return {
        main_end = JOJO.GENERATE_HINT(
            self,
            "WIP",
            "Add a Gold Seal to first played gold card"
        )}
    end,
    rarity = 2,
    atlas = "JoJokers",
    pos = {x=1,y=14},
    cost = 6
}

local limp_bizkit = {
    key ="limp_bizkit",
    name = "LimpBizkit",
    loc_txt = {
        name = "Limp Bizkit",
        text = {
            "Upon {C:attention}Selling{} a {C:attention}Joker{}",
            ", create a {C:dark_edition}Negative Perishable{} copy",
            "{C:inactive}(Doesn't work if Joker is already Perishable){}"
        }
    },
    config = {extra = {
        jokerCount = 0
        }
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.jokerCount
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            self,
            "Grow the Army ("..card.ability.extra.jokerCount.."/15)",
            "All Jokers and Buffoon Packs in shop are 50% Cheaper"
        )}
    end,
    rarity = 4,
    atlas = "JoJokers",
    pos = {x=5,y=14},
    cost = 6,
    remove_from_deck= function(self)
        if self.secAbility then
            G.GAME.limpActive = false
        end
    end,
    calculate = function (self,card,context)
        if context.selling_card and not context.blueprint then
            if context.card.ability.set == "Joker" and not context.card.ability.perishable then

                G.E_MANAGER:add_event(Event({
                    func = function() 
                    local card = copy_card(context.card, nil)
                    card.ability.perishable = true
                    card.ability.perish_tally = G.GAME.perishable_rounds
                    card:set_edition({negative = true},true)
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end}))  
                card.ability.extra.jokerCount = card.ability.extra.jokerCount + 1
                if card.ability.extra.jokerCount >= 15 and not self.secAbility then
                    G.GAME.limpActive = true --Used for secret ability 
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = JOJO.ACTIVATE_SECRET_ABILITY(self)})
                else
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Restored!"})
                end
            end
        end
    end
}

return {
    name="Part 6 Stands",
    list={googoodolls,limp_bizkit}
}