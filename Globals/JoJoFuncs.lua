JOJO = {}

JOJO.APPLY_ENCHANCE = function(card)
    local enhanements = {G.P_CENTERS.m_bonus,G.P_CENTERS.m_gold,G.P_CENTERS.m_lucky,G.P_CENTERS.m_wild,G.P_CENTERS.m_mult,G.P_CENTERS.m_glass,G.P_CENTERS.m_steel,G.P_CENTERS.m_stone}
    local enhance = math.random(1,#enhanements)
    card:set_ability(enhanements[enhance], nil, true)
end

JOJO.APPLY_SEAL = function(card)
    local seals = {"Red","Purple","Gold","Blue"}
    card:set_seal(seals[math.random(1,4)],true)
end

JOJO.APPLY_EDITION = function(card)
    local edition
    local getEdition = math.random(1,3)
    if getEdition <= 1 then
        edition = {polychrome = true}
    elseif getEdition <= 2 then
        edition = {foil = true}
    else
        edition = {holo = true}
    end

    card:set_edition(edition,true)
end

JOJO.REDUCE_CARD_SELL_VALUE = function (card,reducValue)
    card.sell_cost = math.ceil(card.sell_cost * reducValue)
end

JOJO.GET_MOST_PLAYED_HAND = function()
    local _tally, _hand = 0,nil
    for k, v in ipairs(G.handlist) do
        if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
            _hand = v
            _tally = G.GAME.hands[v].played
        end
    end
    if _hand == "Cross Fire Hurricane" then
        _hand = "Full House"
    end

    return _hand
end

JOJO.REMOVE_JOKER = function(self,card)
    play_sound('tarot1')
    card.T.r = -0.2
    card:juice_up(0.3, 0.4)
    card.states.drag.is = true
    card.children.center.pinch.x = true
    G.E_MANAGER:add_event(Event({
        trigger = 'after', delay = 0.3, blockable = false,
        func = function()
            G.jokers:remove_card(self)
            card:remove()
            card = nil
            return true
        end
    }))
    return true
end

JOJO.EVOLVE = function(self,card,force_key)
    local prevEdition = nil
    local prevPerish = nil
    local prevEternal = nil
    local prevRent = nil

    if card.edition then prevEdition = card.edition end
    if card.ability.perishable then prevPerish = card.ability.perishable end
    if card.ability.rental then prevRent = card.ability.rental end
    if card.ability.eternal then prevEternal = card.ability.eternal end

    G.E_MANAGER:add_event(Event({JOJO.REMOVE_JOKER(self,card)}))

    local tempCard = {set = "Joker",area = G.jokers,key = force_key,no_edition = true}
    local newCard = SMODS.create_card(tempCard)

    if prevEdition then newCard.edition = prevEdition end
    if prevPerish then newCard.ability.perishable = prevPerish end
    if prevEternal then newCard.ability.eternal = prevEternal end
    if prevRent then newCard.ability.rental = prevRent end

    newCard:add_to_deck()
    G.jokers:emplace(newCard)
    return "Evolved!"
end

JOJO.GENERATE_HINT = function(self,hintText,secAbilityText)
    local content = {}
    local textToUse
    local color
    
    if self.secAbility == true  then
        textToUse = secAbilityText
        color = G.C.SECONDARY_SET.Planet
    else
        textToUse = hintText
        color = G.C.UI.TEXT_INACTIVE
    end

    if type(textToUse) == "table" then
        for i=1,#textToUse do
            content[#content + 1] = {n=G.UIT.R,config={align = "cm"},nodes={
                {n=G.UIT.T, config={text = textToUse[i], colour = color, scale = 0.32}},
            }}
        end
    else
        content[1] = {n=G.UIT.R,config={align = "cm"},nodes={}}
        content[1].nodes={
            {n=G.UIT.T, config={text = textToUse, colour = color, scale = 0.32}},
        }
    end
    return {{n=G.UIT.C, config={align = "cm", minh = 0.4}, nodes=content}}
end

JOJO.ACTIVATE_SECRET_ABILITY = function(self)
    self.secAbility = true

    return "Secret Ability Active"
end