SWITCH = {}

SWITCH.SWITCHER_KEY_CARD = {
    
}

SMODS.Keybind({
    key = "checkSwitcher",
    key_pressed = "p",
    action = function(controller)
        if G.STAGE == G.STAGES.RUN then
            if G.CONTROLLER.hovering.target and G.CONTROLLER.hovering.target:is(Card)then
                local card = G.CONTROLLER.hovering.target
                if card.ability.set == "Joker" then
                    if card.ability.isSwitcher then
                        sendDebugMessage ("SwitchKey: "..card.ability.switchKey.." nextSwitch: "..card.ability.nextSwitch)
                        SWITCH.SWITCH(card,card.ability.switchKey,card.ability.nextSwitch)
                    end
                end
            end
        end
    end
})

SWITCH.EVOLVE = function (self,card,key)
    local nextKey = card.ability.switchKey
    local name = card.ability.name
    local prevEdition = nil
    local prevPerish = nil
    local prevEternal = nil
    local prevRent = nil

    card.ability.secret_ability = true
    card.ability.isSwitcher = true

    SWITCH.SWITCHER_KEY_CARD[nextKey][name] = card
    
    if card.edition then prevEdition = card.edition end
    if card.ability.perishable then prevPerish = card.ability.perishable end
    if card.ability.rental then prevRent = card.ability.rental end
    if card.ability.eternal then prevEternal = card.ability.eternal end

    G.E_MANAGER:add_event(Event({JOJO.REMOVE_JOKER(card)}))

    local tempCard = {set = "Joker",area = G.jokers,key = key,no_edition = true}
    local newCard = SMODS.create_card(tempCard)

    newCard.ability.switchKey = nextKey
    newCard.ability.nextSwitch = card.ability.nextSwitch
    newCard.ability.isSwitcher = true
    SWITCH.SWITCHER_KEY_CARD[nextKey][name].ability.nextSwitch = newCard.ability.name

    if prevEdition then newCard.edition = prevEdition end
    if prevPerish then newCard.ability.perishable = prevPerish end
    if prevEternal then newCard.ability.eternal = prevEternal end
    if prevRent then newCard.ability.rental = prevRent end

    newCard:add_to_deck()
    G.jokers:emplace(newCard)
end

SWITCH.SWITCH = function(beforeCard,switchKey,nextSwitch)
    local _card = SWITCH.SWITCHER_KEY_CARD[switchKey][nextSwitch]

    G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.2, func = function()
        SWITCH.SWITCHER_KEY_CARD[switchKey][beforeCard.ability.name] = beforeCard
        JOJO.REMOVE_JOKER(beforeCard)
    return true end }))

    G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.4, func = function()
        local card = copy_card(_card, nil, nil, nil, _card.edition and _card.edition.negative)
        card:start_materialize()
        card:add_to_deck()
        if card.edition and card.edition.negative then
            card:set_edition(nil, true)
        end
        G.jokers:emplace(card)
    return true end }))
end

SWITCH.GENERATE_KEY = function(family_name) 
    local switcherKey = ""
    local foundKey = false
    local count = 1

    repeat
        local keyCheck = family_name..count
        if not SWITCH.SWITCHER_KEY_CARD[keyCheck] then
            foundKey = true
            switcherKey = keyCheck
        end
        count = count + 1
    until foundKey

    return switcherKey
end
