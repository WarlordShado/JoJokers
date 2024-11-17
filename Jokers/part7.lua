--Part 7 Stands

local tusk = {
    key ="tusk",
    name = "Tusk",
    loc_txt = {
        name = "Tusk",
        text = {
            "{C:attention}#2# to #3#{} chance to {C:attention}Retrigger{} a card",
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
            {"1/" .. card.ability.extra.editionOdds .. " chance to add","a random edition to a played card"}
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

            if self.secAbility == true and not context.other_card.edition and addEdition(context.other_card) then
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

return {
    name="Part 7 Stands",
    list={tusk}
}