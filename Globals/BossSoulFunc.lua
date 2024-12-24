--Yes, it gets it's own file  (I hate myself)

SOULS = {}

SOULS.CONSEC = 0 --Used for some deck abilities
SOULS.CURRENT_BOSS_FUNC = nil
SOULS.VERDENT_TRIGGED = false
SOULS.PERM_BONUS_TRIGGED = false

SOULS.VALID_BOSSES = {'The Hook','The Ox','The House','The Wall','The Wheel','The Arm','The Club','The Fish','The Psychic','The Goad','The Water','The Window','The Manacle','The Eye','The Mouth','The Plant','The Serpent','The Pillar','The Needle','The Head','The Tooth','The Flint','The Mark','Amber Acorn','Verdent Leaf','Violet Vessel','Crimson Heart','Cerulean Bell'}

SOULS.BOSS_TEXT_TABLE = {
    ['The Hook'] = {
        key = "the_hook",
        color = HEX('a84023'),
        contextFunc = function(context)
            return context.pre_discard and G.GAME.current_round.discards_used <= 0 and not context.hook and #context.full_hand == 2
        end,
        func = function(self,card,context)
            local text = JOJO.GET_MOST_PLAYED_HAND()
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(text, 'poker_hands'),chips = G.GAME.hands[text].chips, mult = G.GAME.hands[text].mult, level=G.GAME.hands[text].level})
            level_up_hand(context.blueprint_card or card, text, nil, 1)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
        end
    },
    ['The Ox'] = {
        key = "the_ox",
        color = HEX('ba5b09'),
        contextFunc = function(context)
            return context.before and G.GAME.current_round.hands_played <= 0
        end,
        func = function(self,card,context)
            if next(context.poker_hands[JOJO.GET_MOST_PLAYED_HAND()]) then
                local checkCard = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_hermit')
                checkCard:set_edition({negative = true},true)
                checkCard:add_to_deck()
                G.consumeables:emplace(checkCard)
                return {
                    message = "The Ox!"
                }
            end
        end
    },
    ['The House'] = {
        key = "the_house",
        color = HEX('5286a5'),
        contextFunc = function(context)
            return context.discard and G.GAME.current_round.discards_used <= 0 and #context.full_hand == 5
        end,
        func = function(self,card,context)
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + 15
            return {
                message = "The House!"
            }
        end
    },
    ['The Wall'] = {
        key = "the_wall",
        color = HEX('8b59a2'),
        contextFunc = function(context)
            return context.joker_main
        end,
        func = function(self,card,context)
            return {
                message = "The Wall!",
                chip_mod = 150
            }
        end
    },
    ['The Wheel'] = {
        key = "the_wheel",
        color = HEX('57bb7a'),
        contextFunc = function(context)
            return context.cardarea == G.play and context.repetition and not context.repetition_only
        end,
        func = function(self,card,context)
            local probs = (G.GAME.probabilities.normal or 1)
            if pseudorandom("wheel") < probs / 3 then
                return {
                    message = "The Wheel!",
                    repetitions = 1,
                    card = context.other_card
                }
            end
        end
    },
    ['The Arm'] = {
        key = "the_arm",
        color = HEX('6964f2'),
        contextFunc = function(context)
            return context.before and not context.blueprint
        end,
        func = function(self,card,context)
            return {
                card = self,
                level_up = true,
                message = localize('k_level_up_ex')
            }
        end
    },
    ['The Club'] = {
        key = "the_club",
        color = HEX('b9ca93'),
        contextFunc = function(context)
            return context.individual and context.cardarea == G.play and context.other_card:is_suit("Clubs")
        end,
        func = function(self,card,context)
            return {
                x_mult = 1.2,
                card = card
            }
        end
    },
    ['The Fish'] = {
        key = "the_fish",
        color = HEX('3d85be'),
        contextFunc = function(context)
            return context.individual and context.cardarea == G.play and G.GAME.current_round.hands_played <= 0 
        end,
        func = function(self,card,context)
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + 2
            G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
            return {
                dollars = 2,
                card = card
            }
        end
    },
    ['The Psychic'] = {
        key = "the_psychic",
        color = HEX('efc03c'),
        contextFunc = function(context)
            return context.joker_main and #context.full_hand == 5
        end,
        func = function(self,card,context)
            return {
                message = "The Psychic",
                Xmult_mod =  2
            }
        end
    },
    ['The Goad'] = {
        key = "the_goad",
        color = HEX('b95c95'),
        contextFunc = function(context)
            return context.individual and context.cardarea == G.play and context.other_card:is_suit("Spades")
        end,
        func = function(self,card,context)
            return {
                x_mult = 1.2,
                card = card
            }
        end
    },
    ['The Water'] = {
        key = "the_water",
        color = HEX('c5dfeb'),
        contextFunc = function(context)
            return context.joker_main and G.GAME.current_round.discards_left > 0
        end,
        func = function(self,card,context)
            return {
                message = "The Water!",
                Xmult_mod = 1 + (G.GAME.current_round.discards_left * 0.5),
            }
        end
    },
    ['The Window'] = {
        key = "the_window",
        color = HEX('aaa294'),
        contextFunc = function(context)
            return context.individual and context.cardarea == G.play and context.other_card:is_suit("Diamonds")
        end,
        func = function(self,card,context)
            return {
                x_mult = 1.2,
                card = card
            }
        end
    },
    ['The Manacle'] = {
        key = "the_manacle",
        color = HEX('575757'),
        contextFunc = function(context)
            return context.joker_main
        end,
        func = function(self,card,context)
            return {
                message = "The Manacle!",
                chip_mod = 10 * #G.hand.cards
            }
        end
    },
    ['The Eye'] = {
        key = "the_eye",
        color = HEX('4c71e4'),
        contextFunc = function(context)
            return context.joker_main
        end,
        func = function(self,card,context)
            local score = true
            local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
            for k, v in pairs(G.GAME.hands) do
                if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
                    score = false
                end
            end
            if not score then
                return {
                    message = "The Eye!",
                    Xmult_mod = 3,
                }
            end
            
        end
    },
    ['The Mouth'] = {
        key = "the_mouth",
        color = HEX('ae728e'),
        contextFunc = function(context)
            return context.joker_main
        end,
        func = function(self,card,context)
            local score = true
            local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
            for k, v in pairs(G.GAME.hands) do
                if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
                    score = false
                end
            end
            if score then
                return {
                    message = "The Mouth!",
                    Xmult_mod = 3,
                }
            end
            
        end
    },
    ['The Plant'] = {
        key = "the_plant",
        color = HEX('709284'),
        contextFunc = function(context)
            return context.individual and context.cardarea == G.play and context.other_card:is_face()
        end,
        func = function(self,card,context)
            return {
                x_mult = 1.5,
                card = card
            }
        end
    },
    ['The Serpent'] = {
        key = "the_serpent",
        color = HEX('429a4f'),
        contextFunc = function(context)
            return (context.discard and context.other_card == context.full_hand[#context.full_hand]) or context.before and #context.full_hand == 3 
        end,
        func = function(self,card,context)
            ease_dollars(3)
            return{
                message = "The Serpent!"
            }
        end
    },
    ['The Pillar'] = {
        key = "the_pillar",
        color = HEX('7d6652'),
        contextFunc = function(context)
            return context.individual and context.cardarea == G.play
        end,
        func = function(self,card,context)
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + 10
            return {
                message = "The Pillar!"
            }
        end
    },
    ['The Needle'] = {
        key = "the_needle",
        color = HEX('5c6e30'),
        contextFunc = function(context)
            return context.joker_main and G.GAME.current_round.hands_played <= 0
        end,
        func = function(self,card,context)
            return {
                message = "The Needle!",
                Xmult_mod = 5,
            }
        end
    },
    ['The Head'] = {
        key = "the_head",
        color = HEX('ad9db3'),
        contextFunc = function(context)
            return context.individual and context.cardarea == G.play and context.other_card:is_suit("Hearts")
        end,
        func = function(self,card,context)
            return {
                x_mult = 1.2,
                card = card
            }
        end
    },
    ['The Tooth'] = {
        key = "the_tooth",
        color = HEX('b52d2d'),
        contextFunc = function(context)
            return context.individual and context.cardarea == G.play
        end,
        func = function(self,card,context)
            local probs = (G.GAME.probabilities.normal or 1)
            if pseudorandom("tooth") < probs / 3 then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + 1
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                return {
                    dollars = 1,
                    card = card
                }
            end
        end
    },
    ['The Flint'] = {
        key = "the_flint",
        color = HEX('e56a2e'),
        contextFunc = function(context)
            return context.joker_main
        end,
        func = function(self,card,context)
            return {
                message = "The Flint!",
                Xmult_mod = 1.5,
                Xchip_mod = 1.5
            }
        end
    },
    ['The Mark'] = {
        key = "the_mark",
        color = HEX('6b3847'),
        contextFunc = function(context)
            return context.discard and G.GAME.current_round.discards_used <= 0 and context.other_card:is_face()
        end,
        func = function(self,card,context)
            local enhanements = {G.P_CENTERS.m_bonus,G.P_CENTERS.m_gold,G.P_CENTERS.m_lucky,G.P_CENTERS.m_wild,G.P_CENTERS.m_mult,G.P_CENTERS.m_glass,G.P_CENTERS.m_steel,G.P_CENTERS.m_stone}
            local enhance = math.random(1,#enhanements)
            context.other_card:set_ability(enhanements[enhance], nil, true)
            return {
                message = "The Mark!"
            }
        end
    },
    ['Amber Acorn'] = {
        key = "amber_acorn",
        color = HEX('fe9e02'),
        contextFunc = function(context)
            return context.before and not context.blueprint
        end,
        func = function(self,card,context)
            for i, card in ipairs(context.full_hand) do
                if not card.seal then
                    card:set_seal('Gold',true)
                    return {
                        message = "Amber Acorn!"
                    }
                end
            end
        end
    },
    ['Verdent Leaf'] = {
        key = "verdent_leaf",
        color = HEX('53ac85'),
        contextFunc = function(context)
            return context.selling_card and context.card.ability.set == "Joker" and not context.blueprint and SOULS.VERDENT_TRIGGED == false
        end,
        func = function(self,card,context)
            SOULS.VERDENT_TRIGGED = true
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local card = copy_card(context.card, nil)
                    card:set_edition({polychrome = true})
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end}))  
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Restored!"})
        end
    },
    ['Violet Vessel'] = {
        key = "violet_vessel",
        color = HEX('8d71dc'),
        contextFunc = function(context)
            return context.individual and context.cardarea == G.play
        end,
        func = function(self,card,context)
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + 30
            return {
                message = "Violet Vessel!"
            }
        end
    },
    ['Crimson Heart'] = {
        key = "crimson_heart",
        color = HEX('ac2f31'),
        contextFunc = function(context)
            return context.before and #context.full_hand == 1 and not context.blueprint
        end,
        func = function(self,card,context)
            local checkCard = context.full_hand[1]
            checkCard:set_seal('Red',true)
            return{
                message = "Crimson Heart!"
            }
        end
    },
    ['Cerulean Bell'] = {
        key = "cerulean_bell",
        color = HEX('0099ff'),
        contextFunc = function(context)
            return context.pre_discard and #context.full_hand == 1 and not context.blueprint
        end,
        func = function(self,card,context)
            local checkCard = context.full_hand[1]
            checkCard:set_seal('Blue',true)
            return{
                message = "Cerulean Bell!"
            }
        end
    }
}

SOULS.DECK_TEXT_TABLE = {
    ['Red Deck'] = {
        key = "red_deck",
        color = HEX('db6760'),
        contextFunc = function(context)
            return context.end_of_round and SOULS.PERM_BONUS_TRIGGED == false
        end,
        func = function(self,card,context)
            SOULS.PERM_BONUS_TRIGGED = true
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + 1
			ease_discard(1)
        end
    },
    ['Blue Deck'] = {
        key = "blue_deck",
        color = HEX('229ce7'),
        contextFunc = function(context)
            return context.end_of_round and SOULS.PERM_BONUS_TRIGGED == false
        end,
        func = function(self,card,context)
            SOULS.PERM_BONUS_TRIGGED = true
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
			ease_hands_played(1)
        end
    },
    ['Yellow Deck'] = {
        key = "yellow_deck",
        color = HEX('fcac20'),
        contextFunc = function(context)
            return false
        end,
        func = function()
            return 5
        end
    },
    ['Green Deck'] = {
        key = "green_deck",
        color = HEX('83c0a7'),
        contextFunc = function(context)
            return false
        end,
        func = function()
            return (G.GAME.current_round.discards_left + G.GAME.current_round.hands_left) * 2
        end
    },
    ['Black Deck'] = {
        key = "black_deck",
        color = HEX('4e6362'),
        contextFunc = function(context)
            return context.retrigger_joker_check and not context.retrigger_joker and context.other_card.ability.name == G.jokers.cards[1].ability.name
        end,
        func = function(self,card,context)
            if SOULS.PERM_BONUS_TRIGGED == false then
                SOULS.PERM_BONUS_TRIGGED = true
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
			    ease_hands_played(1)
            end

            return {
				message = localize("k_again_ex"),
				repetitions = 1,
				card = card,
			}
        end
    },
    ['Magic Deck'] = {
        key = "magic_deck",
        color = HEX('8c74e3'),
        contextFunc = function(context)
            return context.ending_shop
        end,
        func = function(self,card,context)
            local checkCard = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_fool')
            checkCard:set_edition({negative = true},true)
            checkCard:add_to_deck()
            G.consumeables:emplace(checkCard)
            return {
                message = "Magic!"
            }
        end
    },
    ['Nebula Deck'] = {
        key = "nebula_deck",
        color = HEX('4f6269'),
        contextFunc = function(context)
            return context.ending_shop
        end,
        func = function(self,card,context)
            local _planet
            local _hand = JOJO.GET_MOST_PLAYED_HAND()
            for i, planet in pairs(G.P_CENTER_POOLS.Planet) do
                if planet.config.hand_type ==  _hand then
                    _planet = planet.key
                end
            end

            local checkCard = create_card('Planet', G.consumeables, nil, nil, nil, nil, _planet)
            checkCard:set_edition({negative = true},true)
            checkCard:add_to_deck()
            G.consumeables:emplace(checkCard)
            return {
                message = "Nebula!"
            }
        end
    },
    ['Ghost Deck'] = {
        key = "ghost_deck",
        color = HEX('dbc464'),
        contextFunc = function(context)
            return context.end_of_round and SOULS.PERM_BONUS_TRIGGED == false
        end,
        func = function(self,card,context)
            SOULS.PERM_BONUS_TRIGGED = true
            G.GAME.spectral_rates = G.GAME.spectral_rates * 2
        end
    },
    ['Abandoned Deck'] = {
        key = "abandon_deck",
        color = HEX('da9b84'),
        contextFunc = function(context)
            return context.before or context.joker_main
        end,
        func = function(self,card,context)
            if context.before then
                local faces = false
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:is_face() then faces = true end
                end
                if faces then
                    if SOULS.CONSEC > 0 then
                        SOULS.CONSEC = 0
                        return {
                            message = localize('k_reset')
                        }
                    end
                else
                    SOULS.CONSEC = SOULS.CONSEC + 5
                    return {
                        message = localize("k_upgrade_ex")
                    }
                end
            end

            if context.joker_main and SOULS.CONSEC > 0 then
                return {
                    message = localize{type='variable',key='a_mult',vars={SOULS.CONSEC}},
                    mult_mod = SOULS.CONSEC
                }
            end
        end
    },
    ['Checkered Deck'] = {
        key = "checkered_deck",
        color = HEX('f16254'),
        contextFunc = function(context)
            return context.end_of_round or context.before or context.joker_main
        end,
        func = function(self,card,context)
            if context.end_of_round and SOULS.PERM_BONUS_TRIGGED == false then
                SOULS.PERM_BONUS_TRIGGED = true
                G.GAME.souls_checkered_smear = true
            end

            if context.before then
                if not next(context.poker_hands['Flush']) then
                    if SOULS.CONSEC > 0 then
                        SOULS.CONSEC = 0
                        return {
                            message = localize('k_reset')
                        }
                    end
                else
                    SOULS.CONSEC = SOULS.CONSEC + 0.05
                    return {
                        message = localize("k_upgrade_ex")
                    }
                end
            end

            if context.joker_main and SOULS.CONSEC > 0 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={SOULS.CONSEC}},
                    Xmult_mod = SOULS.CONSEC
                }
            end
        end
    },
    ['Zodiac Deck'] = {
        key = "zodiac_deck",
        color = HEX('534d79'),
        contextFunc = function(context)
            return context.end_of_round and SOULS.PERM_BONUS_TRIGGED == false
        end,
        func = function(self,card,context)
            SOULS.PERM_BONUS_TRIGGED = true
            G.GAME.souls_zodiac_discount = true
        end
    },
    ['Painted Deck'] = {
        key = "painted_deck",
        color = HEX('e190f3'),
        contextFunc = function(context)
            return context.end_of_round or context.joker_main
        end,
        func = function(self,card,context)
            if context.end_of_round and SOULS.PERM_BONUS_TRIGGED == false then
                SOULS.PERM_BONUS_TRIGGED = true
                G.hand:change_size(2)
            end

            if context.joker_main then
                local handSize = #G.hand.cards + #context.full_hand
                local Xmult
                if #G.jokers < 4 then
                    Xmult = handSize * 0.2
                else
                    Xmult = handSize * 0.1
                end

                return {
                    message = localize{type='variable',key='a_xmult',vars={Xmult}},
                    Xmult_mod = Xmult
                }
            end
        end
    },
    ['Anaglyph Deck'] = {
        key = "anaglyph_deck",
        color = HEX('4f6266'),
        contextFunc = function(context)
            return context.end_of_round and not context.game_over and not context.repetition and G.GAME.blind.boss or context.ending_shop
        end,
        func = function(self,card,context)
            if context.end_of_round and not context.game_over and not context.repetition and G.GAME.blind.boss and SOULS.PERM_BONUS_TRIGGED == false then
                SOULS.PERM_BONUS_TRIGGED = true
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag('tag_double'))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
                return {
                    message = "Anaglyph!"
                }
            end

            if context.ending_shop then
                SOULS.PERM_BONUS_TRIGGED = false
            end
        end
    },
    ['Plasma Deck'] = {
        key = "plasma_deck",
        color = HEX('b2b7e1'),
        contextFunc = function(context)
            return context.joker_main
        end,
        func = function(self,card,context)
            return {
                message = "Plasma!",
                chip_mod = 100
            }
        end
    },
    ['Erratic Deck'] = {
        key = "erratic_deck",
        color = HEX('1296e2'),
        contextFunc = function(context)
            return context.before and G.GAME.current_round.hands_played <= 0
        end,
        func = function(self,card,context)
            local applyBonus = function(card)
                if not card.seal then
                    JOJO.APPLY_SEAL(card)
                end
                if card.ability.name == "Default Base" then
                    JOJO.APPLY_ENCHANCE(card)
                end
            end


            if #context.full_hand > 1 then
                for i, card in ipairs(context.full_hand) do
                    applyBonus(card)
                end
            else
                applyBonus(context.full_hand[1])
                JOJO.APPLY_EDITION(context.full_hand[1])
            end

            return {
                message = "@#$@&"
            }
        end
    }
}

SOULS.DOUBLE_FUNC = function(bossTable,deckTable) 
    --WARNING - REALLY BAD CODE (Used to merge tables if both a boss and a deck match context)
    local newTable = bossTable

    if newTable.chip_mod and deckTable.chip_mod then
        newTable.chip_mod = newTable.chip_mod + deckTable.chip_mod 
    elseif not newTable.chip_mod and deckTable.chip_mod then
        newTable.chip_mod = deckTable.chip_mod
    end

    if newTable.Xchip_mod and deckTable.Xchip_mod then
        newTable.Xchip_mod = newTable.Xchip_mod + deckTable.Xchip_mod 
    elseif not newTable.chip_mod and deckTable.chip_mod then
        newTable.Xchip_mod = deckTable.Xchip_mod
    end

    if newTable.mult_mod and deckTable.mult_mod then
        newTable.mult_mod = newTable.mult_mod + deckTable.mult_mod
    elseif not newTable.mult_mod and deckTable.mult_mod then
        newTable.mult_mod = deckTable.mult_mod
    end

    if newTable.Xmult_mod and deckTable.Xmult_mod then
        newTable.Xmult_mod = newTable.Xmult_mod + deckTable.Xmult_mod 
    elseif not newTable.Xmult_mod and deckTable.Xmult_mod then
        newTable.Xmult_mod = deckTable.Xmult_mod
    end

    newTable.message = "Bam!"

    return newTable
end

SOULS.GET_BOSS = function(boss)
    for i,_boss in ipairs(SOULS.VALID_BOSSES) do 
        if boss == _boss then
            return boss
        end
    end
    return SOULS.VALID_BOSSES[math.random(1,#SOULS.VALID_BOSSES)]
end


SOULS.GENERATE_SOULS_INFO_QUEUE_BOSS = function(self,bossName,info_queue)
    local _boss
    if bossName == "" then
        _boss = "default"
    else
        _boss = SOULS.BOSS_TEXT_TABLE[bossName].key
    end
    info_queue[#info_queue+1] = {set = 'Other',key = _boss}
end

SOULS.GENERATE_SOULS_INFO_QUEUE_DECK = function(self,deck,info_queue)
    local _deck
    if self.secAbility and deck ~= "" then
        _deck = SOULS.DECK_TEXT_TABLE[deck].key
    else
        _deck = "default_deck"
    end
    info_queue[#info_queue+1] = {set = 'Other',key = _deck}
end

SOULS.GENERATE_MAIN_END = function(self,boss,deck)
    local content = {}
    local textToUse
    local color

    local _deck
    if self.secAbility == true and deck ~= ""  then
        textToUse = "Gain an Ability based on Current Deck"
        _deck = deck
        color = G.C.SECONDARY_SET.Planet
    else
        textToUse = "Steal 3 Souls"
        color = G.C.UI.TEXT_INACTIVE
    end

    local _boss
    if boss == "" then
        _boss = "No Soul"
    else
        _boss = boss
    end

    local bossColor
    if _boss == "No Soul" then
        bossColor = G.C.UI.TEXT_INACTIVE
    else
        bossColor = SOULS.BOSS_TEXT_TABLE[_boss].color
    end

    content[#content + 1] = {n=G.UIT.R,config={align = "cm"},nodes={
        {n=G.UIT.T, config={text ="Current Soul: ".. _boss, colour = bossColor, scale = 0.32}},
    }}

    content[#content + 1] = {n=G.UIT.R,config={align = "cm"},nodes={
        {n=G.UIT.T, config={text = textToUse, colour = color, scale = 0.32}},
    }}

    if self.secAbility and deck ~= "" then
        content[#content + 1] = {n=G.UIT.R,config={align = "cm"},nodes={
            {n=G.UIT.T, config={text = "Current Deck: ".._deck, colour = SOULS.DECK_TEXT_TABLE[_deck].color, scale = 0.32}},
        }}
    end
    
    return {{n=G.UIT.C, config={align = "cm", minh = 0.4}, nodes=content}}
end