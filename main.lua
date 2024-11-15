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
jojoker_config = SMODS.current_mod.config

--Below will be used eventually 
discardHand = function()
    local anySelect = false

    for i, selectedCard in ipairs(G.hand.cards) do
        G.hand:add_to_highlighted(selectedCard, true)
        table.remove(G.hand.card, i)
        anySelect = true
    end
    if anySelect then G.FUNCS.discard_cards_from_highlighted(nil, true) end
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
                SMODS.Joker(item)
            end
        end
    end
end

local standFiles = NFS.getDirectoryItems(mod_dir.."Jokers")
for _,file in ipairs(standFiles) do
    print(file)
    if file == "part7.lua" then
        if jojoker_config["manga_jokers"] then
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





----------------------------------------------
------------MOD CODE END----------------------