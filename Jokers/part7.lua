--Part 7 Stands

local tusk = {
    key ="tusk",
    name = "Tusk",
    loc_txt = {
        name = "Tusk",
        text = {
            "{C:special}Switcher{}",
            "{C:green}#2# in #3#{} chance to retrigger a card",
            "{C:inactive}Max of #1# Times{}",
        }
    },
    config = {extra = {
        maxRetrig = 2,
        odds = 5,
        totalSpins = 0}
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.maxRetrig,
            (G.GAME.probabilities.normal or 1),
            card.ability.extra.odds,
            card.ability.extra.totalSpins,
            card.ability.extra.editionOdds}
            
            info_queue[#info_queue+1] = {set = "Other", key = "switcher"}

            return {vars = vars,
            main_end = JOJO.GENERATE_HINT(
            card,
            "Learn the Art of Spin ("..card.ability.extra.totalSpins.."/20)",
            {
                "Boost Spin Odds and Max Retriggers",
                "You can now transform into Tusk Act 2"
            }
        )}
    end,
    rarity = 2,
    atlas = "JoJokers7",
    pos = {x=0,y=0},
    cost = 10,
    add_to_deck = function(self,card)
        if not card.ability.switchKey then
            card.ability.switchKey = SWITCH.GENERATE_KEY("Tusk")
            SWITCH.SWITCHER_KEY_CARD[card.ability.switchKey] = {}
            card.ability.nextSwitch = "Tusk"
        end
    end,
    calculate = function (self,card,context)
        if context.end_of_round and not context.game_over and not context.repetition and not context.blueprint and not card.ability.secret_ability then
            if card.ability.extra.totalSpins >= 5 then
                card.ability.extra.odds = card.ability.extra.odds - 2
                card.ability.extra.maxRetrig = card.ability.extra.maxRetrig + 2

                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.8, 0.8)
                return true end }))
                
                return {
                    message = SWITCH.EVOLVE(self,card,"j_jojo_tusk_two"),
                    card = card
                }
            end
        end

        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            local isDone = false
            local repeats = 0
            
            while isDone == false and repeats <= card.ability.extra.maxRetrig do
                if pseudorandom('tusk') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    repeats = repeats + 1
                    card.ability.extra.totalSpins = card.ability.extra.totalSpins + 1
                else
                    isDone = true
                end

                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.4, 0.4)
                return true end }))
            end

            return{
                message = "Spin!",
                repetitions = repeats,
                card = context.other_card
            }
        end
    end
}

local tusk_two = {
    key ="tusk_two",
    name = "Tusk Act 2",
    loc_txt = {
        name = "Tusk Act 2",
        text = {
            "{C:special}Switcher{}",
            "Cards give {X:mult,C:white}X#4#{} when retrigger by this joker",
            "{C:inactive}Max of #1# Times{}",
        }
    },
    config = {extra = 
        {
            maxRetrig = 2,
            odds = 3,
            x_mult = 1.5,
            totalSpins = 0,
            giveMult = false
        }
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.maxRetrig,
            (G.GAME.probabilities.normal or 1),
            card.ability.extra.odds,
            card.ability.extra.x_mult,
            card.ability.extra.totalSpins,
            card.ability.extra.giveMult}
            
            info_queue[#info_queue+1] = {set = 'Other', key = 'tusk_base_ability', vars = {card.ability.extra.maxRetrig,(G.GAME.probabilities.normal or 1),card.ability.extra.odds,}}
            info_queue[#info_queue+1] = {set = "Other", key = "switcher"}

            return {vars = vars,
            main_end = JOJO.GENERATE_HINT(
            card,
            "Have a chat with Jesus (AKA, Die)",
            {
                "Increase X-Mult",
                "You can now transform into Tusk Act 3"
            }
        )}
    end,
    rarity = 2,
    atlas = "JoJokers7",
    pos = {x=1,y=0},
    cost = 10,
    in_pool = function(self, args) return false end,
    calculate = function (self,card,context)
        if context.game_over and not card.ability.secret_ability then
            card.ability.extra.x_mult = 2
            return {
                message = SWITCH.EVOLVE(self,card,"j_jojo_tusk_three"),
                card = card,
                saved = true,
                colour = G.C.RED
            }
        end

        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            local isDone = false
            local repeats = 0
            
            while isDone == false and repeats <= card.ability.extra.maxRetrig do
                if pseudorandom('tusk') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    repeats = repeats + 1
                    card.ability.extra.totalSpins = card.ability.extra.totalSpins + 1
                    
                else
                    isDone = true
                end

                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.4, 0.4)
                return true end }))
            end

            if repeats > 0 then
                card.ability.extra.giveMult = true
            end

            return{
                message = "Spin!",
                repetitions = repeats,
                card = context.other_card
            }
        end

        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and card.ability.extra.giveMult then
            
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}}, 
                colour = G.C.XMULT,
                x_mult = card.ability.extra.x_mult
            }
        end

        if context.after then
            card.ability.extra.giveMult = false
        end
    end
}

local tusk_three = {
    key ="tusk_three",
    name = "Tusk Act 3",
    loc_txt = {
        name = "Tusk Act 3",
        text = {
            "{C:special}Switcher{}",
            "On the first {C:mult}discard{}",
            "You can destroy {C:attention}1{} card",
            "On the first hand",
            "{C:green}#2# in #5#{} to {C:attention}copy{} ",
            "a retriggering card"
        }
    },
    config = {extra = {
        maxRetrig = 2,
        odds = 4,
        totalSpins = 0,
        copy_odds=8
    }
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.maxRetrig,
            (G.GAME.probabilities.normal or 1),
            card.ability.extra.odds,
            card.ability.extra.totalSpins,
            card.ability.extra.copy_odds
        }

        info_queue[#info_queue+1] = {set = 'Other', key = 'tusk_base_ability', vars = {card.ability.extra.maxRetrig,(G.GAME.probabilities.normal or 1),card.ability.extra.odds}}
        info_queue[#info_queue+1] = {set = "Other", key = "switcher"}

        return {vars = vars,
            main_end = JOJO.GENERATE_HINT(
                card,
                "Master the Golden Spin ("..card.ability.extra.totalSpins.."/50)",
                {
                    "Copy odds are increased",
                    "You can now transform into Tusk Act 4"
                }
            )
        }
    end,
    rarity = 3,
    atlas = "JoJokers7",
    pos = {x=2,y=0},
    cost = 10,
    in_pool = function(self, args) return false end,
    calculate = function (self,card,context)
        if context.discard and not context.blueprint and G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 then
            return {
                message = "Destroyed",
                delay = 0.45, 
                remove = true,
                card = self
            }
        end

        if context.end_of_round and not context.game_over then
            if card.ability.extra.totalSpins >= 10 and not card.ability.secret_ability and not context.blueprint then
                card.ability.extra.copy_odds = card.ability.extra.copy_odds - 2

                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.8, 0.8)
                return true end }))
                            
                return {
                    message = SWITCH.EVOLVE(self,card,"j_jojo_tusk_four"),
                    card = card
                }
            end
        end

        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            local isDone = false
            local repeats = 0
            local cardsAdded = false
            
            while isDone == false and repeats <= card.ability.extra.maxRetrig do
                if pseudorandom('tusk') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    repeats = repeats + 1
                    card.ability.extra.totalSpins = card.ability.extra.totalSpins + 1
                else
                    isDone = true
                end

                if pseudorandom('tusk') < G.GAME.probabilities.normal / card.ability.extra.copy_odds and G.GAME.current_round.hands_played == 0 then
                    cardsAdded = true
                    local copy = copy_card(context.other_card, nil, nil, G.playing_card)
                    copy:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, copy)
                    G.hand:emplace(copy)
                end

                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.4, 0.4)
                return true end }))
            end

            return{
                message = "Spin!",
                repetitions = repeats,
                card = context.other_card,
                playing_cards_added = cardsAdded
            }
        end
    end
}

local tusk_four = {
    key ="tusk_four",
    name = "Tusk Act 4",
    loc_txt = {
        name = "Tusk Act 4",
        text = {
            "{C:special}Switcher{}",
            "{C:green}#2# in #5#{} chance to add",
            "a random edition to a played card"
        }
    },
    config = {extra = {
        maxRetrig = 5,
        odds = 3,
        totalSpins = 0,
        editionOdds=8}
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.maxRetrig,
            (G.GAME.probabilities.normal or 1),
            card.ability.extra.odds,
            card.ability.extra.totalSpins,
            card.ability.extra.editionOdds
        }

        info_queue[#info_queue+1] = {set = 'Other', key = 'tusk_base_ability', vars = {card.ability.extra.maxRetrig,(G.GAME.probabilities.normal or 1),card.ability.extra.odds,}}

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            card,
            "Become the Master of Spin, ("..card.ability.extra.totalSpins.."/144)",
            {"Improve Edition Odds"}
        )}
    end,
    rarity = 3,
    atlas = "JoJokers7",
    pos = {x=3,y=0},
    cost = 10,
    in_pool = function(self, args) return false end,
    calculate = function (self,card,context)
        if context.end_of_round and not context.game_over and not context.repetition and not context.blueprint and not card.ability.secret_ability then
            if card.ability.extra.totalSpins >= 144 then
                card.ability.extra.editionOdds =  card.ability.extra.editionOdds - 2
                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.8, 0.8)
                return true end }))
                
                return {
                    message = JOJO.ACTIVATE_SECRET_ABILITY(card)
                }
            end
        end

        local addEdition = function(cardCheck) 
            if pseudorandom('tusk') < G.GAME.probabilities.normal / card.ability.extra.editionOdds then
                JOJO.APPLY_EDITION(cardCheck)
                return true
            end
            return false
        end

        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            local isDone = false
            local repeats = 0

            if not context.other_card.edition and addEdition(context.other_card) and not context.blueprint then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Infinte Rotation!"})
            end
            
            while isDone == false and repeats <= card.ability.extra.maxRetrig do
                if pseudorandom('tusk') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    repeats = repeats + 1
                    card.ability.extra.totalSpins = card.ability.extra.totalSpins + 1
                else
                    isDone = true
                end

                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.4, 0.4)
                return true end }))
            end

            return{
                message = "Spin!",
                repetitions = repeats,
                card = context.other_card
            }
        end
    end
}

local hey_ya = {
    key ="hey_ya",
    name = "Hey Ya",
    loc_txt = {
        name = "Hey Ya!",
        text = {
            "Doubles all {C:attention}listed{}",
            "{C:green}probabilities{}",
            "{C:inactive}(ex:{C:green}1 in 3{C:inactive} -> {C:green}2 in 3{C:inactive}){}",
        }
    },
    config = {extra = {
        oddsMult = 2,
        luckyTrigged = 0,
        luckyNeeded = 20
    }
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.oddsMult
        }
        
        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            card,
            "Become the luckiest man alive ("..card.ability.extra.luckyTrigged.."/"..card.ability.extra.luckyNeeded..")",
            {"If a Lucky Card triggers","gain both rewards","If both rewards hit","increase them by 50%"}
        )}
    end,
    rarity = 3,
    atlas = "JoJokers7",
    pos = {x=5,y=1},
    cost = 7,
    blueprint_compat = false,
    add_to_deck = function(self, card)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal * card.ability.extra.oddsMult * math.max(1, (2 ^ #find_joker('Oops! All 6s')))
      end,
      remove_from_deck = function(self, card)
        if card.ability.secret_ability then
            G.GAME.lucky_trigger_both = false
        end
        card.ability.secret_ability = false
        G.GAME.probabilities.normal = G.GAME.probabilities.normal / card.ability.extra.oddsMult * math.max(1, (2 ^ #find_joker('Oops! All 6s')))
      end,
    calculate = function (self,card,context)
        if context.individual and context.other_card.lucky_trigger and not context.blueprint and not card.ability.secret_ability then
            card.ability.extra.luckyTrigged = card.ability.extra.luckyTrigged + 1
            if card.ability.extra.luckyTrigged >= card.ability.extra.luckyNeeded then
                G.GAME.lucky_trigger_both = true
                return {
                    message = JOJO.ACTIVATE_SECRET_ABILITY(card)
                }
            end
        end
    end
}

local dirty_deeds = {
    key ="d4c",
    name = "D4C",
    loc_txt = {
        name = "Dirty Deeds Done Dirt Cheap",
        text = {
            "Upon {C:attention}Selling or Using{} a Card or Joker,",
            "Respawn the Joker. Max of {C:attention}#1#{} times each round",
            "{C:inactive}(Respawns Left:#2# ){}"
        }
    },
    config = {extra = {
        maxRetrig = 3,
        usedRetrigs = 3
    }},
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.maxRetrig,
            card.ability.extra.usedRetrigs
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            card,
            "Assemble a Saint",
            "Evolve"
        )}
    end,
    rarity = 2,
    atlas = "JoJokers7",
    pos = {x=0,y=3},
    cost = 10,
    blueprint_compat = false,
    add_to_deck = function(self)
		G.GAME.pool_flags.hasD4C = true
	end,
    remove_from_deck = function(self)
        self.secAbility = false
		G.GAME.pool_flags.hasD4C = false
	end,
    calculate = function (self,card,context)
        if context.end_of_round and not context.game_over and not context.repetition and not context.blueprint and not context.individual then
            card.ability.extra.usedRetrigs = card.ability.extra.maxRetrig
            return {message = "Dirty Deeds Done Dirt Cheap!"}
        end

        if context.consumeable and (card.ability.extra.usedRetrigs > 0 or context.consumeable.ability.name == "saintCorpse") and not context.consumeable.train  then
            context.consumeable.train = true
            if context.consumeable.ability.name == "saintCorpse" then
                
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = JOJO.EVOLVE(self,card,"j_jojo_d4c_love_train")})
            else
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local card = copy_card(context.consumeable, nil)
                        card.train = false
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end}))  
                card.ability.extra.usedRetrigs = card.ability.extra.usedRetrigs - 1
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Restored!"})
            end
        end

        if context.selling_card and not context.blueprint and card.ability.extra.usedRetrigs > 0 and not context.card.train then
            context.card.train = true
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local card = copy_card(context.card, nil)
                    card.train = false
                    JOJO.REDUCE_CARD_SELL_VALUE(card,0.25)
                    card:add_to_deck()
                    if context.card.ability.set == "Joker" then
                        G.jokers:emplace(card)
                    else
                        G.consumeables:emplace(card)
                    end
                    
                    G.GAME.consumeable_buffer = 0
                    return true
                end}))  
            card.ability.extra.usedRetrigs = card.ability.extra.usedRetrigs - 1
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Restored!"})
        end
    end
}

local dirty_deeds_love_train = {
    key ="d4c_love_train",
    name = "D4CLoveTrain",
    loc_txt = {
        name = "D4C: Love Train",
        text = {
            "Upon {C:attention}Selling or Using{} a Card or Joker,",
            "Respawn the Joker. Max of {C:attention}#1#{} times each ante",
            "{C:inactive}(Respawns Left:#2# ){}"
        }
    },
    config = {extra = {
        maxRetrig = 5,
        usedRetrigs = 5,
        odds = 5
    }},
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.maxRetrig,
            card.ability.extra.usedRetrigs,
            (G.GAME.probabilities.normal or 1),
            card.ability.extra.odds
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            card,
            "Evolves from Dirty Deeds",
            {"At the start of a round",
             "Add Misfortune Redirection to a random card",
             "Changes at the end of the round"}
        )}
    end,
    rarity = 4,
    atlas = "JoJokers7",
    pos = {x=2,y=3},
    cost = 10,
    blueprint_compat = false,
    in_pool = function(self, args) return false end,
    add_to_deck = function(self,card)
        if not next(find_joker("D4C")) then
            G.GAME.pool_flags.hasD4C = false
        end
        card.ability.secret_ability = true
    end,
    calculate = function (self,card,context)
        if context.end_of_round and not context.game_over and not context.repetition and not context.blueprint and not context.individual then
            card.ability.extra.usedRetrigs = card.ability.extra.maxRetrig

            local removeEdJoker = SMODS.Edition:get_edition_cards(G.jokers,false)
            for i, joker in ipairs(removeEdJoker) do
                if joker.edition.key == 'e_jojo_misfortune' then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        func = function()
                            joker.set_edition(joker)
                            return true
                        end
                    }))
                    break
                end
            end

            local eligibleJokers = SMODS.Edition:get_edition_cards(G.jokers,true)
            for i,joker in ipairs(eligibleJokers) do
                print(joker.ability.name)
                if joker.ability.name == "D4CLoveTrain" then
                    table.remove(eligibleJokers,i)
                    break
                end
            end

            if #eligibleJokers > 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    func = function()
                        local selected_joker = pseudorandom_element(eligibleJokers, pseudoseed('misfortune'))
                        selected_joker.set_edition(selected_joker, 'e_jojo_misfortune')
                        return true
                    end
                }))
            end
            
            return {message = "Dirty Deeds Done Dirt Cheap!"}
        end

        if context.consumeable and card.ability.extra.usedRetrigs > 0 then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local card = copy_card(context.consumeable, nil)
                    card.train = false
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end}))  
            card.ability.extra.usedRetrigs = card.ability.extra.usedRetrigs - 1
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Restored!"})
        end

        local respawnCard  = function(train) 
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local card = copy_card(context.card, nil)
                    JOJO.REDUCE_CARD_SELL_VALUE(card,0.25)
                    card.train = false
                    card:add_to_deck()
                    if context.card.ability.set == "Joker" then
                        G.jokers:emplace(card)
                    else
                        G.consumeables:emplace(card)
                    end
                    
                    G.GAME.consumeable_buffer = 0
                    return true
                end}))  
            if not train then
                card.ability.extra.usedRetrigs = card.ability.extra.usedRetrigs - 1
            end
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Restored!"})
        end

        if context.selling_card and not context.blueprint and not context.card.train then
            context.card.train = true
            if card.ability.extra.usedRetrigs > 0 then
                respawnCard(false)
            elseif context.card.ability.set == "Joker" and context.card.edition then
                if context.card.edition.key == 'e_jojo_misfortune' then
                    if pseudorandom('lovetrain') > G.GAME.probabilities.normal / card.ability.extra.odds then
                        respawnCard(true)
                    end
                end
            end
        end
    end
}

return {
    name="Part 7 Stands",
    list={tusk,tusk_two,tusk_three,tusk_four,hey_ya,dirty_deeds,dirty_deeds_love_train}
}