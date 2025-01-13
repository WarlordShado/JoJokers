--Code for Part 3 Stands

local star_platinum = {
    key = "star_platinum",
    name = "Star Platinum",
    atlas = "JoJokers",
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    pos = {x = 0, y = 0},
    cost = 7,
    config = {extra = {
        chips = 5,
        basechips = 5,
        hands=5,
        Xmult=0,
        currentPower=0,
        spflag = true,
        timeStopActive=false}
    },
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

        local getMult = function(discards)
            if discards <= 1 then
                return 1.5
            end
            return discards
        end

        if context.individual and context.cardarea == G.play then
            card.ability.extra.spflag = false
            if not context.other_card.debuff then
                local value1 = card.ability.extra.chips
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.basechips

                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.8, 0.8)
                return true end }))

                card.ability.extra.currentPower = card.ability.extra.currentPower + card.ability.extra.chips

                return{
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                    chips = value1,
                    card = card
                }
            end
        end
        if context.before and self.secAbility == true and not context.blueprint then
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

        if context.joker_main and not context.blueprint then
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

local magician_red = {
    key ="magician_red",
    name = "Magician's Red",
    loc_txt = {
        name = "Magician's Red",
        text = {
            "If played cards",
            "are only {C:hearts}Hearts{} and",
            "{C:diamonds}Diamonds, {X:mult,C:white}X#1#{} mult",
        }
    },
    config = {extra = {
        Xmult = 3,
        odds = 2}
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.Xmult,
            card.ability.extra.secAbility,
            card.ability.extra.secAbilityText,
            card.ability.extra.odds,
            (G.GAME.probabilities.normal or 1)
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            self,
            "Play a house of Rich and Caring Royals",
            {"When Cross Fire Hurricane is played, ",
            G.GAME.probabilities.normal.."/"..card.ability.extra.odds.." chance to level it up"
        }
        )}
    end,
    rarity = 2,
    atlas = "JoJokers",
    pos = {x=1,y=0},
    cost = 4,
    calculate = function (self,card,context)   
        if context.before and next(context.poker_hands['jojo_Cross_Fire_Hurricane']) and not context.blueprint and self.secAbility == false then
            return {
                message = JOJO.ACTIVATE_SECRET_ABILITY(self)
            }
        elseif context.before and next(context.poker_hands['jojo_Cross_Fire_Hurricane']) then
            if pseudorandom("magicred") < G.GAME.probabilities.normal/card.ability.extra.odds then
                return {
                    card = card,
                    level_up = true,
                    message = localize('k_level_up_ex')
                }
            end
        end

        if context.joker_main then
            local red_suits = 0
            local all_cards = 0

            for k, _card in ipairs(G.play.cards) do
                all_cards = all_cards + 1
                if _card:is_suit('Hearts', nil, true) or _card:is_suit('Diamonds', nil, true) then
                    red_suits = red_suits + 1
                end
            end

            if red_suits == all_cards then
                return {
                    message = "Magician's Red!",
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end
}

local hermit_purple = {
    key ="hermit_purple",
    name = "Hermit Purple",
    loc_txt = {
        name = "Hermit Purple",
        text = {
            "At the end of a {C:attention}shop{}",
            "{C:attention}Pin{} the joker to the {C:attention}right{}",
            "and retrigger it"
        }
    },
    config = {extra = {
        retrigs = 1,
        pinnedJokerName = ""
    }},
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.retrigs,
            card.ability.extra.pinnedJokerName
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            self,
            "Obatin evidence on Dio's Location",
            {"Upon selling a Photograph"," Create a Negative Stand"," of a random main villian"}
        )}
    end,
    rarity = 2,
    atlas = "JoJokers",
    pos = {x=2,y=0},
    cost = 4,
    calculate = function (self,card,context)   
        if context.retrigger_joker_check and not context.retrigger_joker and context.other_card.ability.name == card.ability.extra.pinnedJokerName then
			return {
				message = localize("k_again_ex"),
				repetitions = card.ability.extra.retrigs,
				card = card,
			}
		end
        if self.secAbility and context.selling_card and not context.blueprint then
            local possibleKeys = {"j_jojo_world","j_jojo_killer_queen"}
            if jojo_config.manga_joker then
                table.insert(possibleKeys,"j_jojo_d4c")
            end
            if context.card.ability.name == "Photograph" then
                local tempCard = {set = "Joker",area = G.jokers,key = possibleKeys[math.random(1,#possibleKeys)],edition = {negative = true}}
                local newCard = SMODS.create_card(tempCard)
                newCard:add_to_deck()
                G.jokers:emplace(newCard)
            end
        end
        if context.ending_shop and not context.blueprint then
            for i, joker in ipairs(G.jokers.cards) do
                if joker.ability.name == "Hermit Purple" and i > 1 then
                    G.jokers.cards[i-1].pinned = true
                    card.ability.extra.pinnedJokerName = G.jokers.cards[i-1].ability.name --Needed for Secert Ability
                    if card.ability.extra.pinnedJokerName == "Photograph" then
                        card_eval_status_text(self, 'extra', nil, nil, nil, {message = JOJO.ACTIVATE_SECRET_ABILITY(self)})
                    end
                    card_eval_status_text(G.jokers.cards[i-1], 'extra', nil, nil, nil, {message = "Pinned!", colour = G.C.CHIPS})
                end
            end
        end
        if not context.repetition and not context.individual and context.end_of_round and not context.blueprint then
            G.jokers.cards[1].pinned = false
            card_eval_status_text(G.jokers.cards[1], 'extra', nil, nil, nil, {message = "Release!", colour = G.C.CHIPS})
        end
    end
}

local sliver_chariot = {
    key ="silver_chariot",
    name = "Silver Chariot",
    loc_txt = {
        name = "Silver Chariot",
        text = {
            "Gains {C:chips}+#3#{} Chips & {C:mult}+#4#{} Mult",
            "if played hand contains a {C:attention}Straight Flush{}",
            "{C:inactive}(Currently {C:chips}+#2#{} Chips, {C:mult}+#1#{} Mult){}",
        }
    },
    config = {extra = {
        mult = 20,
        chips = 50,
        mult_gain = 5,
        chip_gain = 25,
        Xmult=2.5
    }},
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.mult,
            card.ability.extra.chips,
            card.ability.extra.chip_gain,
            card.ability.extra.mult_gain,
            card.ability.extra.Xmult
        }

        return {vars = vars,
        main_end = JOJO.GENERATE_HINT(
            self,
            "Send the Steel Straight Through...",
            "All played steel cards give X" .. card.ability.extra.Xmult .. " mult"
        )}
    end,
    rarity = 2,
    atlas = "JoJokers",
    pos = {x=4,y=0},
    cost = 4,
    calculate = function (self,card,context)   
        if context.before and next(context.poker_hands['Straight Flush']) and not context.blueprint and self.secAbility == false then
            local steel = 0
            for i = 1,#context.scoring_hand do
                if context.scoring_hand[i].ability.name == 'Steel Card' then
                    steel = steel + 1
                end
            end
            if steel >= 5 then
                G.E_MANAGER:add_event(Event({func = function()
                    card:juice_up(0.8, 0.8)
                return true end }))

                return {
                    message = JOJO.ACTIVATE_SECRET_ABILITY(self)
                }
            end
        end

        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and
            context.other_card.ability.name == 'Steel Card' and self.secAbility == true then

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
                message = "Silver Chariot!",
                card = card
            }
        end
    end
}

local osiris = { --Will prolly need to rewrite if SOULS is reused (just make a copy of souls in loc_vars)
    key ="osiris",
    name = "Osiris",
    loc_txt = {
        name = "Osiris",
        text = {
            "Gain a {C:legendary}Boss Soul{} after defeating a boss",
            "Gains a different {C:attention}ability{} depending on boss",
            "{C:inactive}(If boss is modded, select a random soul){}"
        }
    },
    config = {extra = {
            boss = "",
            deck = "",
            souls = 0
        }
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.boss,
            card.ability.extra.deck,
            card.ability.extra.souls
        }
        
        G.GAME.trigedVerdentLeafBoss = false --used to make sure that Verdent Leaf soul ability only triggers once
        SOULS.GENERATE_SOULS_INFO_QUEUE_BOSS(self,card.ability.extra.boss,info_queue)
        SOULS.GENERATE_SOULS_INFO_QUEUE_DECK(self,card.ability.extra.deck,info_queue)

        return {
            vars = vars,
            main_end = SOULS.GENERATE_MAIN_END(self,card.ability.extra.boss,card.ability.extra.deck)
        }
    end,
    rarity = 3,
    atlas = "JoJokers",
    pos = {x=0,y=4},
    cost = 10,
    remove_from_deck = function(self, card, from_debuff) 
        self.secAbility = false
        SOULS.PERM_BONUS_TRIGGED = false
        SOULS.CONSEC = 0
        if card.ability.extra.deck == "Red Deck" then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1
			ease_discard(-1)
        elseif card.ability.extra.deck == "Blue Deck" or card.ability.extra.deck == "Black Deck" then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - 1
			ease_hands_played(-1)
        elseif card.ability.extra.deck == "Ghost Deck" then
            G.GAME.spectral_rates = G.GAME.spectral_rates / 2
        elseif card.ability.extra.deck == "Checkered Deck" then
            G.GAME.souls_checkered_smear = false
        elseif card.ability.extra.deck == "Zodiac Deck" then
            G.GAME.souls_zodiac_discount = false
        end
    end,
    calculate = function (self,card,context)
        if context.end_of_round and not context.game_over and not context.repetition and G.GAME.blind.boss and not context.blueprint and not context.individual then
            card.ability.extra.boss = SOULS.GET_BOSS(G.GAME.blind.name)
            card.ability.extra.souls = card.ability.extra.souls + 1
            if card.ability.extra.souls >= 3 then
                card.ability.extra.deck = G.GAME.selected_back.name
                return {
                    message = JOJO.ACTIVATE_SECRET_ABILITY(self)
                }
            end
            return {
                message = "Stolen!",
                card = card
            }
        end
        
        if card.ability.extra.boss ~= "" then
            if self.secAbility then
                local bossContext = SOULS.BOSS_TEXT_TABLE[card.ability.extra.boss].contextFunc(context)
                local deckContext = SOULS.DECK_TEXT_TABLE[card.ability.extra.deck].contextFunc(context)

                if bossContext and deckContext then
                    local newTab = SOULS.DOUBLE_FUNC(SOULS.BOSS_TEXT_TABLE[card.ability.extra.boss].func(self,card,context),SOULS.DECK_TEXT_TABLE[card.ability.extra.deck].func(self,card,context))
                    return newTab
                else
                    if bossContext then
                        return SOULS.BOSS_TEXT_TABLE[card.ability.extra.boss].func(self,card,context)
                    end
    
                    if deckContext then
                        return SOULS.DECK_TEXT_TABLE[card.ability.extra.deck].func(self,card,context)
                    end
                end
            else
                if SOULS.BOSS_TEXT_TABLE[card.ability.extra.boss].contextFunc(context) then
                    return SOULS.BOSS_TEXT_TABLE[card.ability.extra.boss].func(self,card,context)
                end
            end
        end
    end,
    calc_dollar_bonus = function(self,card)
        if card.ability.extra.deck == "Yellow Deck" or card.ability.extra.deck == "Green Deck" then
            return SOULS.DECK_TEXT_TABLE[card.ability.extra.deck].func()
        end
    end

}

local cream = {
    key ="cream",
    name = "Cream",
    loc_txt = {
        name = "Cream",
        text = {
            "Destroy the {C:attention}first{} card on every {C:chips}hand{}",
        }
    },
    config = {extra = {
        cardsDestroyed = 0,
        deactivateDestroy = false}
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.cardsDestroyed,
            card.ability.extra.deactivateDestroy
        }
        return {
            vars = vars,
            main_end = JOJO.GENERATE_HINT(
                self,
                "Destroy a Blue Card...",
                {"Every 4 cards destoryed,",
                "create a negative black hole"}
            )}
    end,
    rarity = 3,
    atlas = "JoJokers",
    pos = {x=4,y=4},
    cost = 10,
    calculate = function (self,card,context)
        if context.before and not context.blueprint then
            card.ability.extra.deactivateDestroy = false
            if self.secAbility == false then
                if context.full_hand[1].seal == "Blue"then
                    G.E_MANAGER:add_event(Event({func = function()
                        card:juice_up(0.8, 0.8)
                    return true end }))
    
                    return {
                        message = JOJO.ACTIVATE_SECRET_ABILITY(self)
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
            if self.secAbility == true then
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

local the_world = {
    key ="world",
    name = "The World",
    loc_txt = {
        name = "The World",
        text = {
            "If a {C:attention}Boss Blind{} is defeated with at least ",
            "{X:mult,C:white}X#2#{} the score requirement,",
            "dont advance an Ante",
            "{C:inactive}(Can only retrigger each ante once){}",
        }
    },
    config = {extra = {
        ante_reduction = 1,
        scoreRec = 2,
        seconds = 0,
        repeats = 2,}
    },
    loc_vars = function(self,info_queue,card)
        local vars = {
            card.ability.extra.ante_reduction,
            card.ability.extra.scoreRec,
            card.ability.extra.seconds,
            card.ability.extra.repeats,
        }

        return {vars = vars,
            main_end = JOJO.GENERATE_HINT(
                self,
                "Halt Time for 5 seconds...",
                "Retrigger all Aces Twice"
            )}
    end,
    rarity = 4,
    atlas = "JoJokers",
    pos = {x=6,y=0},
    cost = 10,
    blueprint_compat = false,
    calculate = function (self,card,context)

        if context.cardarea == G.play and context.repetition and not context.repetition_only and self.secAbility == true then
            if context.other_card.base.value == "Ace" then
                return {
                    message = "Muda!",
                    repetitions = card.ability.extra.repeats,
                    card = context.other_card
                }
            end
        end

        if context.end_of_round and not context.game_over and not context.repetition and G.GAME.blind.boss and not context.blueprint and not context.individual then
            local ante_mod = 0
            if G.GAME.chips >= G.GAME.blind.chips * card.ability.extra.scoreRec then
                ante_mod = ante_mod - card.ability.extra.ante_reduction
                ease_ante(ante_mod)
                if card.ability.extra.seconds >= 5 and not card.ability.secret_ability then
                    return {
                        message = JOJO.ACTIVATE_SECRET_ABILITY(card)
                    }
                elseif not card.ability.secret_ability then
                    card.ability.extra.seconds = card.ability.extra.seconds + 1
                end
                return {
                    message = "The World"
                }
            end
        end
    end
}



return {
    name = "Part 3 Stands",
    list = {star_platinum,magician_red,hermit_purple,sliver_chariot,osiris,cream,the_world}
}