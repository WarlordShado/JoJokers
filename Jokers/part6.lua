--Code for Part 6 Stands

local whitesnake = {
    key ="whitesnake",
        name = "Whitesnake",
        loc_txt = {
            name = "Whitesnake",
            text = {
                "Stores {C:attention}Edition{} of {C:attention}Sold Cards{}",
                "Gives {C:attention}stored Editions{} to obtained {C:attention}Jokers{} with {C:attention}No Edition{}",
                "Storage: #1#, #2#, #3#, #4#, #5#",
                "{C:inactive}(Leftmost edition (First stored) is output first.{}",
            }
        },
        config = {extra = {
            name1 = "Empty",
            name2 = "Empty",
            name3 = "Empty",
            name4 = "Empty",
            name5 = "Empty",

            edition1 = "Empty",
            edition2 = "Empty",
            edition3 = "Empty",
            edition4 = "Empty",
            edition5 = "Empty",
        }},
        loc_vars = function(self,info_queue,card)
            local vars = {
                card.ability.extra.name1,
                card.ability.extra.name2,
                card.ability.extra.name3,
                card.ability.extra.name4,
                card.ability.extra.name5,
            }
            return {vars = vars,
                main_end = JOJO.GENERATE_HINT(
                    self,
                    "Collect more DISCs...",
                    "When stored Editions would overflow storage, create a Virus Card instead"
                )}
        end,
        rarity = 2,
        atlas = "JoJokers",
        pos = {x=5,y=13},
        cost = 7,
        blueprint_compat = false,
        calculate = function(self,card,context)
            if context.selling_card and context.card.edition and not context.card.snaked and not context.blueprint then
                context.card.snaked = true
                local foundempty = false
                WSeditionstorage = {
                    ['1'] = card.ability.extra.edition1,
                    ['2'] = card.ability.extra.edition2,
                    ['3'] = card.ability.extra.edition3,
                    ['4'] = card.ability.extra.edition4,
                    ['5'] = card.ability.extra.edition5,
                }
                WSnamestorage = {
                    ['1'] = card.ability.extra.name1,
                    ['2'] = card.ability.extra.name2,
                    ['3'] = card.ability.extra.name3,
                    ['4'] = card.ability.extra.name4,
                    ['5'] = card.ability.extra.name5,
                }
                if context.card.edition ~= nil then
                    for index = 1, 5 do
                        local indexstring = tostring(index)
                        if (WSeditionstorage[indexstring] == "Empty" or WSeditionstorage[indexstring] == nil) and foundempty == false then
                            foundempty = true
                            WSeditionstorage[indexstring] = context.card.edition.key
                            WSnamestorage[indexstring] = context.card.edition.type
                        end
                        if WSeditionstorage[indexstring] == nil then
                            WSeditionstorage[indexstring] = "Empty"
                        end
                    end
                    if foundempty == false then
                        --- Replace Tarot Card with Virus Card when we make those
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                        func = (function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                        local tarotcards = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'tar')
                                        tarotcards:add_to_deck()
                                        G.consumeables:emplace(tarotcards)
                                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1
                                    return true
                                end}))   
                                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})              
                            return true
                        end)}))
                        if self.secAbility == false then
                            return{
                                message = JOJO.ACTIVATE_SECRET_ABILITY(self),
                            }
                        end
                    end
                    card.ability.extra.edition1 = WSeditionstorage["1"]
                    card.ability.extra.edition2 = WSeditionstorage["2"]
                    card.ability.extra.edition3 = WSeditionstorage["3"]
                    card.ability.extra.edition4 = WSeditionstorage["4"]
                    card.ability.extra.edition5 = WSeditionstorage["5"]

                    card.ability.extra.name1 = WSnamestorage["1"] or "Empty"
                    card.ability.extra.name2 = WSnamestorage["2"] or "Empty"
                    card.ability.extra.name3 = WSnamestorage["3"] or "Empty"
                    card.ability.extra.name4 = WSnamestorage["4"] or "Empty"
                    card.ability.extra.name5 = WSnamestorage["5"] or "Empty"
                end
            end
            if context.buying_card and (card.ability.extra.edition1 ~= "Empty" and card.ability.extra.edition1 ~= nil) then
                WSeditionstorage = {
                    ['1'] = card.ability.extra.edition1,
                    ['2'] = card.ability.extra.edition2,
                    ['3'] = card.ability.extra.edition3,
                    ['4'] = card.ability.extra.edition4,
                    ['5'] = card.ability.extra.edition5,
                    ['6'] = "Empty",
                }
                WSnamestorage = {
                    ['1'] = card.ability.extra.name1,
                    ['2'] = card.ability.extra.name2,
                    ['3'] = card.ability.extra.name3,
                    ['4'] = card.ability.extra.name4,
                    ['5'] = card.ability.extra.name5,
                }
                if context.card.edition == nil and
                (
                context.card.ability.set == "Joker" or
                context.card.ability.set == "Planet"
                )
                then
                    context.card:set_edition(WSeditionstorage["1"])
                    for index = 1, 5 do
                        local index2 = index + 1
                        local indexstring = tostring(index)
                        local indexstringnext = tostring(index2)
                        WSeditionstorage[indexstring] = WSeditionstorage[indexstringnext]
                        WSnamestorage[indexstring] = WSnamestorage[indexstringnext]
                    end
                end
                card.ability.extra.edition1 = WSeditionstorage["1"]
                card.ability.extra.edition2 = WSeditionstorage["2"]
                card.ability.extra.edition3 = WSeditionstorage["3"]
                card.ability.extra.edition4 = WSeditionstorage["4"]
                card.ability.extra.edition5 = WSeditionstorage["5"]

                card.ability.extra.name1 = WSnamestorage["1"] or "Empty"
                card.ability.extra.name2 = WSnamestorage["2"] or "Empty"
                card.ability.extra.name3 = WSnamestorage["3"] or "Empty"
                card.ability.extra.name4 = WSnamestorage["4"] or "Empty"
                card.ability.extra.name5 = WSnamestorage["5"] or "Empty"
            end
        end
}

local googoodolls = {
    key ="googoodolls",
    name="GooGooDolls",
    loc_txt = {
        name = "GooGoo Dolls",
        text = {
            "{C:special}Invert{} the rank of number cards",
            "{C:inactive}(Example: 10 = 2){}"
        }
    },
    config = {},
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
    cost = 6,
    blueprint_compat = false
}

local limp_bizkit = {
    key ="limp_bizkit",
    name = "LimpBizkit",
    loc_txt = {
        name = "Limp Bizkit",
        text = {
            "Upon {C:attention}Selling{} a {C:attention}Joker{}",
            ", create a {C:dark_edition}Negative{} {C:sticker}Perishable{} copy",
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
    blueprint_compat = false,
    remove_from_deck= function(self)
        if self.secAbility then
            G.GAME.limpActive = false
        end
        self.secAbility = false
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
    list={googoodolls,whitesnake,limp_bizkit}
}