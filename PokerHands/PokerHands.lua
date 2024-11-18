--Some jokers have their own poker hands

local redFury = {
    key = 'Cross_Fire_Hurricane',
    chips = 200,
    mult = 15,
    l_chips = 50,
    l_mult = 10,
    example = {
        { 'H_K',    true },
        { 'H_K',    true },
        { 'D_K',    true },
        { 'D_Q',    true },
        { 'H_Q',    true },
    },
    loc_txt = {
        ['en-us'] = {
            name = 'Cross Fire Hurricane',
            description = {
                'A Full House made of',
                'King of Hearts and Diamonds and',
                'Queen of Hearts and Diamonds',
                "Must have Magician's Red"
            }
        }
    },
    visible = false,
    evaluate = function(parts, hand)
        if next(find_joker("Magician's Red")) then
            if next(parts._3) and next(parts._2) then
                local _crossfire = SMODS.merge_lists(parts._2,parts._3)
                
                --local isRedFury = true
                local kingCounter = 0
                local queenCounter = 0
                for j = 1, #_crossfire do
                    local _card = _crossfire[j]
                    local rank = SMODS.Ranks[_card.base.value]
                    if rank.key =="King" and (_card:is_suit("Hearts") or _card:is_suit("Diamonds")) then kingCounter = kingCounter + 1 end
                    if rank.key =="Queen" and (_card:is_suit("Hearts") or _card:is_suit("Diamonds")) then queenCounter = queenCounter + 1 end
                end
                
                if ((kingCounter == 3 and queenCounter == 2) or (kingCounter == 2 and queenCounter == 3)) then return {_crossfire} end
            end
        end
    end,
}

return {
    name="Poker Hands",
    list={redFury}
}