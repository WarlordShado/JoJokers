local secAbility = {
	key = "secret_ability",
    badge_colour = HEX("b95c95"),
    atlas = "sticker",
    pos = {x=0,y=0},
    sets = {
        Tarot = false,
        Planet = false,
        Spectral = false,
        Ingredient = false,
        Food = false,
        Recipe = false
    },
    prefix_config = {key = false},
    rate = 0.0,
}

return {
    name = "Stickers",
    list = {secAbility}
}