--Code for Part 5 Stands

local kraftwork = {
    key ="kraftwork",
    loc_txt = {
        name = "Kraft Work",
        text = {
            "Gives {C:attention}score{} at the beginning of the",
            "round. Amount given is the {C:attention}score{}",
            "{C:attention}overflow{} from previous blind",
            "{C:mult}Can only gain 3/4 of total blind score{}"
        }
    },
    config = {extra = {overflow = 0,secAbility = false,abilityStopper=false,firstTimeStopper = true}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.overflow,card.ability.extra.secAbility,card.ability.extra.secAbilityText,card.ability.extra.firstTimeStopper,card.ability.extra.abilityStopper}}
    end,
    rarity = 3,
    atlas = "JoJokers",
    pos = {x=4,y=10},
    cost = 6,
    calculate = function (self,card,context)
        if context.end_of_round and not context.game_over and not context.blueprint then
            if card.ability.extra.firstTimeStopper == true then --Prevents a crash with talisman. Comparing a number with table.
                card.ability.extra.firstTimeStopper = false
            end
            if G.GAME.chips >= G.GAME.blind.chips and card.ability.extra.abilityStopper == false then
                card.ability.extra.abilityStopper = true
                card.ability.extra.overflow = to_big(G.GAME.chips - G.GAME.blind.chips)
                print(type(card.ability.extra.overflow))
                
                return{
                    message = "Stored!"
                }
            end
        end

        if context.setting_blind and not context.blueprint and card.ability.extra.firstTimeStopper == false then
            card.ability.extra.abilityStopper = false
            if  to_big(card.ability.extra.overflow) > to_big(0) then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.0,
                    func = function()
                        if to_big(card.ability.extra.overflow) > to_big(G.GAME.blind.chips) * to_big(0.75) then
                            card.ability.extra.overflow = to_big(G.GAME.blind.chips) * to_big(0.75)
                        end
                        ease_chips(to_big(card.ability.extra.overflow))
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Bam!"})
                    return true end}))
            end
        end
    end
}

return {
    name="Part 5 Stands",
    list={kraftwork}
}