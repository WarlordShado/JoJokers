--- STEAMODDED HEADER
--- MOD_NAME: JoJokers
--- MOD_ID: JoJokers
--- MOD_AUTHOR: [Warlord Shado, Maratby, Lanuzo]
--- MOD_DESCRIPTION: JoJo Meets Balatro!
--- DEPENDENCIES: [Talisman>=2.0.0-beta8,Steamodded>=1.0.0~ALPHA-0812d]
--- BADGE_COLOR: eb4eac
--- PREFIX: jojo
----------------------------------------------
------------MOD CODE -------------------------

mod_dir = ''..SMODS.current_mod.path
jojo_config = SMODS.current_mod.config

--Load Sprites
local sprite, load_error = SMODS.load_file("sprites.lua")
if load_error then
    sendDebugMessage("The error is:"..load_error)
else
    sprite()
end

local basefuncs, load_error = SMODS.load_file("Globals/JoJoFuncs.lua")
if load_error then
  sendDebugMessage ("The error is: "..load_error)
else
  basefuncs()
end

local osirisfuncs, load_error = SMODS.load_file("Globals/BossSoulFunc.lua")
if load_error then
  sendDebugMessage ("The error is: "..load_error)
else
    osirisfuncs()
end

local SwitcherFunc, load_error = SMODS.load_file("Globals/SwitcherFunc.lua")
if load_error then
  sendDebugMessage ("The error is: "..load_error)
else
    SwitcherFunc()
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
    if file == "part7.lua" then
        print(jojo_config.manga_joker)
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


local sticker = NFS.getDirectoryItems(mod_dir.."stickers")

for _, file in ipairs(sticker) do
    sendDebugMessage ("The file is: "..file)
    local sticker, load_error = SMODS.load_file("stickers/"..file)
    if load_error then
        sendDebugMessage ("The error is: "..load_error)
    else
        local curr_consumable = sticker()
        if curr_consumable.init then curr_consumable:init() end
    
        for i, item in ipairs(curr_consumable.list) do
            item.discovered = true
            item.unlocked = true
            SMODS.Sticker(item)
        end
    end
end 

----------------------------------------------
------------MOD CODE END----------------------