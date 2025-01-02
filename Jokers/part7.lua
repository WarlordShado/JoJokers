--Part 7 Stands

local tusk = {
    key ="tusk",
    name = "Tusk",
    loc_txt = {
        name = "Tusk",
        text = {
            "{C:green}#2# in #3#{} chance to retrigger a card",
            "{C:inactive}Max of #1# Times{}",
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
            card.ability.extra.editionOdds}
        

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            self,
            "The 13th Fibonacci...",
            {"Flat 1 in " .. card.ability.extra.editionOdds .. " chance to add","a random edition to a played card"}
        )}
    end,
    rarity = 3,
    atlas = "JoJokers7",
    pos = {x=0,y=0},
    cost = 10,
    calculate = function (self,card,context)
        if context.end_of_round and not context.game_over and not context.repetition and not context.blueprint and self.secAbility == false then
            if card.ability.extra.totalSpins >= 144 then
                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.8, 0.8)
                return true end }))
                
                return {
                    message = JOJO.ACTIVATE_SECRET_ABILITY(self)
                }
            end
        end

        local addEdition = function(cardCheck) 
            local editionChance = math.random(1,card.ability.extra.editionOdds)
            if editionChance == 1 then
                JOJO.APPLY_EDITION(cardCheck)
                return true
            end
            return false
        end

        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            local isDone = false
            local repeats = 0

            if self.secAbility == true and not context.other_card.edition and addEdition(context.other_card) and not context.blueprint then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Infinte Rotation!"})
            end
            
            while isDone == false and repeats <= card.ability.extra.maxRetrig do
                if pseudorandom('tusk') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    repeats = repeats + 1
                    card.ability.extra.totalSpins = card.ability.extra.totalSpins + 1
                else
                    isDone = true
                end
            end

            G.E_MANAGER:add_event(Event({func = function()
                card:juice_up(0.8, 0.8)
            return true end }))

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
            self,
            "Become the luckiest man alive ("..card.ability.extra.luckyTrigged.."/"..card.ability.extra.luckyNeeded..")",
            {"If a Lucky Card triggers","gain both rewards","If both rewards hit","increase them by 50%"}
        )}
    end,
    rarity = 3,
    atlas = "JoJokers7",
    pos = {x=5,y=0},
    cost = 7,
    blueprint_compat = false,
    add_to_deck = function(self, card)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal * card.ability.extra.oddsMult * math.max(1, (2 ^ #find_joker('Oops! All 6s')))
      end,
      remove_from_deck = function(self, card)
        if self.secAbility then
            G.GAME.lucky_trigger_both = false
        end
        self.secAbility = false
        G.GAME.probabilities.normal = G.GAME.probabilities.normal / card.ability.extra.oddsMult * math.max(1, (2 ^ #find_joker('Oops! All 6s')))
      end,
    calculate = function (self,card,context)
        if context.individual and context.other_card.lucky_trigger and not context.blueprint and not self.secAbility then
            card.ability.extra.luckyTrigged = card.ability.extra.luckyTrigged + 1
            if card.ability.extra.luckyTrigged >= card.ability.extra.luckyNeeded then
                G.GAME.lucky_trigger_both = true
                return {
                    message = JOJO.ACTIVATE_SECRET_ABILITY(self)
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
            self,
            "Assemble a Saint",
            "Evolve"
        )}
    end,
    rarity = 2,
    atlas = "JoJokers7",
    pos = {x=0,y=2},
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
        if context.end_of_round and not context.game_over and not context.repetition and not context.blueprint then
            card.ability.extra.usedRetrigs = card.ability.extra.maxRetrig
            return {message = "Dirty Deeds Done Dirt Cheap!"}
        end

        if context.consumeable and card.ability.extra.usedRetrigs > 0 then
            if context.consumeable.ability.name == "saintCorpse" then
                G.GAME.pool_flags.hasD4C = false
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = JOJO.EVOLVE(self,card,"j_jojo_d4c_love_train")})
            else
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local card = copy_card(context.consumeable, nil)
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end}))  
                card.ability.extra.usedRetrigs = card.ability.extra.usedRetrigs - 1
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Restored!"})
            end
        end

        if context.selling_card and not context.blueprint and card.ability.extra.usedRetrigs > 0 then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local card = copy_card(context.card, nil)
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
        odds = 5,
        wasTriged = false
    }},
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.maxRetrig,
            card.ability.extra.usedRetrigs,
            (G.GAME.probabilities.normal or 1),
            card.ability.extra.odds,
            card.ability.extra.wasTriged
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            self,
            "Evolves from Dirty Deeds",
            {"At the start of a round",
             "Add Misfortune Redirection to a random card",
             "Changes at the end of the round"}
        )}
    end,
    rarity = 4,
    atlas = "JoJokers7",
    pos = {x=2,y=2},
    cost = 10,
    blueprint_compat = false,
    no_pool_flag = false,
    add_to_deck = function(self)
        self.secAbility = true
    end,
    calculate = function (self,card,context)
        if context.end_of_round and not context.game_over and not context.repetition and not context.blueprint and card.ability.extra.wasTriged == false then
            card.ability.extra.usedRetrigs = card.ability.extra.maxRetrig

            local removeEdJoker = SMODS.Edition:get_edition_cards(G.jokers,false)
            for i, joker in ipairs(removeEdJoker) do
                if joker.edition.key == 'e_jojo_misfortune' then
                    print("ran")
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
            
            card.ability.extra.wasTriged = true
            return {message = "Dirty Deeds Done Dirt Cheap!"}
        end

        if context.ending_shop and card.ability.extra.wasTriged == true then
            card.ability.extra.wasTriged = false
        end

        if context.consumeable and card.ability.extra.usedRetrigs > 0 then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local card = copy_card(context.consumeable, nil)
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end}))  
            card.ability.extra.usedRetrigs = card.ability.extra.usedRetrigs - 1
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Restored!"})
        end

        local respawnCard  = function() 
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local card = copy_card(context.card, nil)
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

        if context.selling_card and not context.blueprint then
            if card.ability.extra.usedRetrigs > 0 then
                respawnCard()
            elseif context.card.ability.set == "Joker" and context.card.edition then
                if context.card.edition.key == 'e_jojo_misfortune' then
                    if pseudorandom('lovetrain') > G.GAME.probabilities.normal / card.ability.extra.odds then
                        respawnCard()
                    end
                end
            end
        end
    end
}

return {
    name="Part 7 Stands",
    list={tusk,hey_ya,dirty_deeds,dirty_deeds_love_train}
}