--Code for Part 6 Stands

local googoodolls = {
    key ="googoodolls",
    name="GooGooDolls",
    loc_txt = {
        name = "GooGoo Dolls",
        text = {
            "{C:attention}Invert{} the rank of number cards",
            "{C:inactive}(Example: 10 = 2){}"
        }
    },
    config = {},
    loc_vars = function(self,info_queue,card)
        return {
        main_end = JOJO.GENERATE_HINT(
            self,
            "WIP",
            "Add a Gold Seal to first played gold card"
        )}
    end,
    rarity = 2,
    atlas = "JoJokers",
    pos = {x=1,y=14},
    cost = 6
}

return {
    name="Part 6 Stands",
    list={googoodolls}
}