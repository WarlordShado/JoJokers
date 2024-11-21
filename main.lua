--- STEAMODDED HEADER
--- MOD_NAME: JoJokers
--- MOD_ID: JoJokers
--- MOD_AUTHOR: [Warlord Shado, Modlich, Maratby]
--- MOD_DESCRIPTION: JoJo Meets Balatro!
--- DEPENDENCIES: [Talisman>=2.0.0-beta8,Steamodded>=1.0.0~ALPHA-0812d]
--- BADGE_COLOR: eb4eac
--- PREFIX: jojo
----------------------------------------------
------------MOD CODE -------------------------

mod_dir = ''..SMODS.current_mod.path
jojo_config = SMODS.current_mod.config

JOJO = {}

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
            {n=G.UIT.T, config={text = "("..textToUse..")", colour = color, scale = 0.32}},
        }
    end
    return {{n=G.UIT.C, config={align = "cm", minh = 0.4}, nodes=content}}
end

JOJO.ACTIVATE_SECRET_ABILITY = function(self)
    self.secAbility = true

    return "Secret Ability Active"
end

--Load Sprites
local sprite, load_error = SMODS.load_file("sprites.lua")
if load_error then
    sendDebugMessage("The error is:"..load_error)
else
    sprite()
end

--Load Joker Files
load_Joker = function (file)
    sendDebugMessage("The File is:"..file)
    local joker, load_error = SMODS.load_file("Jokers/"..file)
    if load_error then
        sendDebugMessage ("The error is: "..load_error)
    else
        local curr_jokers = joker()
        if curr_jokers.init then  curr_jokers:init() end

        if curr_jokers.list and #curr_jokers.list > 0 then
            for i, item in ipairs(curr_jokers.list) do
                item.discovered = true
                item.unlocked = true
                item.secAbility = false
                SMODS.Joker(item)
            end
        end
    end
end

local standFiles = NFS.getDirectoryItems(mod_dir.."Jokers")
for _,file in ipairs(standFiles) do
    if file == "part7.lua" then
        if jojo_config.manga_joker then
            load_Joker(file)
        end
    else
        load_Joker(file)
    end
end

local pokerFile = NFS.getDirectoryItems(mod_dir.."PokerHands")
for _,file in ipairs(pokerFile) do
    sendDebugMessage("The File is:"..file)
    local pokerHand, load_error = SMODS.load_file("PokerHands/"..file)
    if load_error then
        sendDebugMessage ("The error is: "..load_error)
    else
        local curr_hands = pokerHand()
        if curr_hands.init then  curr_hands:init() end

        if curr_hands.list and #curr_hands.list > 0 then
            for i, item in ipairs(curr_hands.list) do
                print(file)
                SMODS.PokerHand(item)
            end
        end
    end
end

--Load Joker Files
load_Consume = function (file)
    sendDebugMessage("The File is:"..file)
    local consume, load_error = SMODS.load_file("Consumables/"..file)
    if load_error then
        sendDebugMessage ("The error is: "..load_error)
    else
        local curr_consume = consume()
        if curr_consume.init then  curr_consume:init() end

        if curr_consume.list and #curr_consume.list > 0 then
            for i, item in ipairs(curr_consume.list) do
                item.discovered = true
                item.unlocked = true
                SMODS.Consumable(item)
            end
        end
    end
end

local consumeFiles = NFS.getDirectoryItems(mod_dir.."Consumables")
for _,file in ipairs(consumeFiles) do
    if file == "corpse.lua" then
        if jojo_config.manga_joker then
            load_Consume(file)
        end
    else
        load_Consume(file)
    end
end

local editions = NFS.getDirectoryItems(mod_dir.."Editions")

for _, file in ipairs(editions) do
    sendDebugMessage ("The file is: "..file)
    local edition, load_error = SMODS.load_file("Editions/"..file)
    if load_error then
        sendDebugMessage ("The error is: "..load_error)
    else
        local curr_edition = edition()
        if curr_edition.init then curr_edition:init() end
      
        for i, item in ipairs(curr_edition.list) do
            SMODS.Edition(item)
        end
    end
end





----------------------------------------------
------------MOD CODE END----------------------