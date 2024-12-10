local applyShader = function()
    SMODS.Shader({key="misfortune",path="LoveTrain.fs"})
end

local misfortune = ({
    key = "misfortune",
    loc_txt = {
        name = "Misfortune Redirection",
        label = "Love Train",
        text = {
            "When this card is {C:attention}Sold{},",
            "Respawn this Card. {C:green}1 in 5{} chance to not respawn.",
            "{C:inactive}(Use D4C's respawns first){}",
            "{X:mult,C:white}X2{} Mult"
        }
    },
    shader = "misfortune",
    config = {
        x_mult = 2
    },
    in_shop = false,
    extra_cost = 12,
    sound = {sound="polychrome1",per = 1.2,vol = 0.4}
})

return {
    name = "Editions",
    init = applyShader,
    list = {misfortune}
}