local beetle_arrow = {
    name = "beetle_arrow",
    key = "beetle_arrow",
    set = "Tarot",
    loc_txt = {
      name = "Beetle Arrow",
      text = {
        "{C:legendary}Evolves certian Jokers{}",
        "{C:attention}This may completely change their abilities{}",
      }
    },
    pos = { x = 1, y = 0 },
    atlas = "Consume",
    cost = 10,
    unlocked = true,
    discovered = true,
    can_use = function(self,card)
        if #G.jokers.highlighted == 1 then
            local choice = G.jokers.highlighted[1]
            if G.localization.descriptions[choice.config.center.set][choice.config.center_key].name == "Gold Experience" then
                return true
            end
        end
        return false
    end,
    use = function(self,card)
        local choice = G.jokers.highlighted[1]
        choice.ability.extra.req = true
    end
}

return {
    name="Part 7 Stands",
    list={beetle_arrow}
}