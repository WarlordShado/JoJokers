--- STEAMODDED HEADER
--- MOD_NAME: JoJokers
--- MOD_ID: JojoMod
--- MOD_AUTHOR: [Warlord Shado]
--- MOD_DESCRIPTION: Adds Stands.
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-0812d]
--- BADGE_COLOR: c7638f
--- PREFIX: mvan
----------------------------------------------
------------MOD CODE -------------------------

--Creates an atlas for cards to use
SMODS.Atlas {
    -- Key for code to find it with
    key = "JoJokers",
    -- The name of the file, for the code to pull the atlas from
    path = "JoJokers.png",
    -- Width of each sprite in 1x size
    px = 71,
    -- Height of each sprite in 1x size
    py = 95
}

SMODS.Joker {
    key ="silverChariot",
    loc_txt = {
        name = "Silver Chariot",
        text = {
            "Gains {C:chips}+#3#{} Chips & {C:mult}+#4#{} Mult",
            "if played hand",
            "contains a {C:attention}Straight Flush{}",
            "{C:inactive}(Currently {C:chips}+#2#{} Chips, {C:mult}+#1#{} Mult){}",
            "{C:attention}#7#{}"
        }
    },
    config = {extra = {mult = 20,chips = 50,mult_gain = 5, chip_gain = 25,Xmult=2.5,secAbility = false,secAbilityText = "Send the Steel Straight Through to unlock full potential..."}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.mult,card.ability.extra.chips,card.ability.extra.chip_gain,card.ability.extra.mult_gain,card.ability.extra.Xmult,card.ability.extra.secAbility,card.ability.extra.secAbilityText}}
    end,
    rarity = 2,
    atlas = "JoJokers",
    pos = {x=0,y=0},
    cost = 4,
    calculate = function (self,card,context)   
        if context.before and next(context.poker_hands['Straight Flush']) and not context.blueprint and card.ability.extra.secAbility == false then
            local steel = 0
            for i = 1,#context.scoring_hand do
                if context.scoring_hand[i].ability.name == 'Steel Card' then
                    steel = steel + 1
                end
            end
            if steel >= 5 then
                card.ability.extra.secAbility = true;
                card.ability.extra.secAbilityText = "All played steel cards give X" .. card.abilit.extra.Xmult .. " mult"
                return {
                    message = 'Secret Ability Active!'
                }
            end
        end

        if context.cardarea == G.play and context.individual and not context.other_card.debuff and not context.end_of_round and
            context.other_card.ability.name == 'Steel Card' and card.ability.extra.secAbility == true then
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
                message = "Charge!",
                card = card            
            }
        end
    end
}

SMODS.Joker {
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
    pos = {x=1,y=0},
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

SMODS.Joker { --Make Secret Ability able to retrigger jokers 
    key ="tusk",
    loc_txt = {
        name = "Tusk",
        text = {
            "{C:attention}#2# to #3#{} chance to {C:attention}Retrigger{} a card",
            "{C:inactive}Max of #1# Times{}",
            "{C:attention}#5#{}"
        }
    },
    config = {extra = {maxRetrig = 5,odds = 3,secAbility = false,secAbilityText="The 13th Fibonacci...",totalSpins = 0,editionOdds=8}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.maxRetrig,(G.GAME.probabilities.normal or 1), card.ability.extra.odds,card.ability.extra.secAbility,card.ability.extra.secAbilityText,card.ability.extra.totalSpins,card.ability.extra.editionOdds}}
    end,
    rarity = 3,
    atlas = "JoJokers",
    pos = {x=2,y=0},
    cost = 10,
    calculate = function (self,card,context)
        if context.end_of_round and not context.game_over and not context.repetition and not context.blueprint and card.ability.extra.secAbility == false then
            if card.ability.extra.totalSpins >= 10 then
                card.ability.extra.secAbility = true
                card.ability.extra.secAbilityText = "1/" .. card.ability.extra.editionOdds .. " chance to add a random edition to a played card"
                
                return {
                    message = "Secert Ability Active!"
                }
            end
        end

        local addEdition = function(cardCheck) 
            local editionChance = math.random(1,card.ability.extra.editionOdds)
            if editionChance == 1 then
                local edition
                local getEdition = math.random(1,3)
                if getEdition <= 1 then
                    edition = {polychrome = true}
                elseif getEdition <= 2 then
                    edition = {foil = true}
                else
                    edition = {holo = true}
                end

                cardCheck:set_edition(edition,true)
                return true
            end
            return false
        end

        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            local isDone = false
            local repeats = 0
            local mes = "Spin!"

            if card.ability.extra.secAbility == true and not context.other_card.edition and addEdition(context.other_card) then
                mes = "Infinite Rotation!"
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
                message = mes,
                repetitions = repeats,
                card = context.other_card
            }
        end


    end
}

----------------------------------------------
------------MOD CODE END----------------------