local saint = {
    name = "saintCorpse",
    key = "saint_corpse",
    set = "Tarot",
    loc_txt = {
      name = "A Saint's Corpse",
      text = {
        "Evolves a {C:legendary}Certain Joker{}"
      }
    },
    pos = { x = 0, y = 0 },
    atlas = "Consume",
    cost = 25,
    unlocked = true,
    discovered = true,
    yes_pool_flag = "hasD4C",
    can_use = function()
      return next(find_joker("D4C"))
    end,
    use = function(self,card)
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "You gain the Saint's Power!"})
    end
}

return {
    name="Part 7 Stands",
    list={saint}
}