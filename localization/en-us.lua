-- Welcome to en-us.lua!
-- friendly reminder that in the us we say things like "color" and not "colour"
-- This is also the default file, if there are things here that are "missing" from other files it will use this one instead

return {
    descriptions = {
        Other = {
            default = {
                name = "Boss Soul",
                text = {
                    "Defeat a Boss to",
                    "gain a {C:legendary}Boss Soul{}"
                }
            },
            the_hook = {
                name = "Soul of the Hook",
                text = {
                    "If first {C:attention}discard{} contains 2 cards",
                    "{C:attention}Level Up{} the most played hand"
                }
            },
            the_ox = {
                name = "Soul of the Ox",
                text = {
                    "Spawn a {C:dark_edition}Negative{} Hermit Card",
                    "If first hand is the most played poker hand"
                }
            },
            the_house = {
                name = "Soul of the House",
                text = {
                    "If the first {C:attention}discard{}",
                    "contains {C:attention}5{} cards",
                    "every card gains +15 {C:chips}chips{}"
                }
            },
            the_wall = {
                name = "Soul of the Wall",
                text = {
                    "{C:chips}+150{} Chips"
                }
            },
            the_wheel = {
                name = "Soul of the Wheel",
                text = {
                    "{C:green}1 in 3{} chance to retrigger a played card",
                }
            },
            the_arm = {
                name = "Soul of the Arm",
                text = {
                    "{C:attention}Level Up{} played hand"
                }
            },
            the_club = {
                name = "Soul of the Club",
                text = {
                    "Every card of the {C:club}Club{} Suit",
                    "gives {X:mult,C:white}X1.2{} Mult"
                }
            },
            the_fish = {
                name = "Soul of the Fish",
                text = {
                    "Every card on the first",
                    "hand give {C:money}$2{}"
                }
            },
            the_psychic = {
                name = "Soul of the Psychic",
                text = {
                    "{X:mult,C:white}X2{} Mult if hand contains {C:attention}5{} cards"
                }
            },
            the_goad = {
                name = "Soul of the Goad",
                text = {
                    "Every card of the {C:spade}Spade{} Suit",
                    "gives {X:mult,C:white}X1.2{} Mult"
                }
            },
            the_water = {
                name = "Soul of the Water",
                text = {
                    "Gives {X:mult,C:white}X0.5{} mult per",
                    "remaining discard"
                }
            },
            the_window = {
                name = "Soul of the Window",
                text = {
                    "Every card of the {C:diamond}Diamond{} Suit",
                    "gives {X:mult,C:white}X1.2{} Mult"
                }
            },
            the_manacle = {
                name = "Soul of the Manacle",
                text = {
                    "{C:chips}+10{} chips per card",
                    "left in hand"
                }
            },
            the_eye = {
                name = "Soul of the Eye",
                text = {
                    "{X:mult,C:white}X3{} Mult if hand wasn't",
                    "your most played {C:attention}poker hand{}"
                }
            },
            the_mouth = {
                name = "Soul of the Mouth",
                text = {
                    "{X:mult,C:white}X3{} Mult if played hand",
                    "is your most played {C:attention}poker hand{}"
                }
            },
            the_plant = {
                name = "Soul of the Plant",
                text = {
                    "Every face card gives",
                    "{X:mult,C:white}X1.5{} mult"
                }
            },
            the_serpent = {
                name = "Soul of the Serpent",
                text = {
                    "If played hand or discard",
                    "contains {C:attention}3{} cards",
                    "give {C:money}$3{}"
                }
            },
            the_pillar = {
                name = "Soul of the Pillar",
                text = {
                    "All played cards",
                    "gain {C:chips}+10{} chips"
                }
            },
            the_needle = {
                name = "Soul of the Needle",
                text = {
                    "{X:mult,C:white}X5{} Mult on first played hand"
                }
            },
            the_head = {
                name = "Soul of the Heart",
                text = {
                    "Every card of the {C:heart}Heart{} Suit",
                    "gives {X:mult,C:white}X1.2{} Mult"
                }
            },
            the_tooth = {
                name = "Soul of the Tooth",
                text = {
                    "{C:green}1 in 2{} chance for any",
                    "scoring card to give {C:money}$1{}"
                }
            },
            the_flint = {
                name = "Soul of the Flint",
                text = {
                    "{X:chips,C:white}X1.5{} Chips and {X:mult,C:white}X1.5{} Mult"
                }
            },
            the_mark = {
                name = "Soul of the Mark",
                text = {
                    "On the First Discard",
                    "give every face a random enchancment"
                }
            },
            amber_acorn = {
                name = "Soul of Amber Acorn",
                text = {
                    "Give all scored face cards",
                    "a {C:money}gold{} seal if card doesnt have one"
                }
            },
            verdent_leaf = {
                name = "Soul of Verdent Leaf",
                text = {
                    "When a Joker is Sold",
                    "respawn it and give it {C:dark_edition}Polychrome{}",
                    "{C:inactive}(works one time){}"
                }
            },
            violet_vessel = {
                name = "Soul of Violet Vessel",
                text = {
                    "Every played card",
                    "gains {C:chips}+30{} chips"
                }
            },
            crimson_heart = {
                name = "Soul of Crimson Heart",
                text = {
                    "If hand contains {C:attention}1{} card",
                    "give that card a red seal"
                }
            },
            cerulean_bell = {
                name = "Soul of Cerulean Bell",
                text = {
                    "If discard only contains {C:attention}1{} card",
                    "give that card a {C:chips}blue{} seal"
                }
            },
            default_deck = {
                name = "Empty Attunement",
                text = {
                    "Steal 3 Souls",
                    "to unlock full potential"
                }
            },
            red_deck = {
                name = "Red Deck Attunement",
                text = {
                    "{C:mult}+1{} Discard"
                }
            },
            blue_deck = {
                name = "Blue Deck Attunement",
                text = {
                    "{C:chips}+1{} Hand"
                }
            },
            yellow_deck = {
                name = "Yellow Deck Attunement",
                text = {
                    "Gain {C:money}$5{} at the end of the round"
                }
            },
            green_deck = {
                name = "Green Deck Attunement",
                text = {
                    "Gain {C:money}$2{} extra dollars",
                    "per Discard and Hand left",
                    "at the end of the round"
                }
            },
            black_deck = {
                name = "Black Deck Attunement",
                text = {
                    "+1 Hand",
                    "Retrigger the Leftmost Joker"
                }
            },
            magic_deck = {
                name = "Magic Deck Attunement",
                text = {
                    "Upon leaving the Shop",
                    "Spawn a {C:dark_edition}Negative{} {C:tarot}Fool{} card"
                }
            },
            nebula_deck = {
                name = "Nebula Deck Attunement",
                text = {
                    "Spawn a {C:dark_edition}Negative{} {C:planet}Planet{} Card",
                    "of your most played hand",
                    "at the end of a Shop"
                }
            },
            ghost_deck = {
                name = "Ghost Deck Attunement",
                text = {
                    "{C:spectral}Spectral{} Cards are",
                    "{X:mult,C:white}X2{} more likely ",
                    "to appear in the Shop"
                }
            },
            abandon_deck = {
                name = "Abandon Deck Attunement",
                text = {
                    "Gain {C:mult}+5{} mult for every hand",
                    "that doesnt have a scoring {C:attention}face{} card"
                }
            },
            checkered_deck = {
                name = "Checkered Deck Attunement",
                text = {
                    "Apply {C:attention}Smeared Joker{} effect",
                    "Gain {X:mult,C:white}X0.05{} mult for every",
                    "consecutive {C:attention}Flush{} played"
                }
            },
            zodiac_deck = {
                name = "Zodiac Deck Attunement",
                text = {
                    "All {C:spectral}Spectral{}, {C:tarot}Tarot{}, and {C:planet}Planet{} cards",
                    "and packs are half off"
                }
            },
            painted_deck = {
                name = "Painted Deck Attunement",
                text = {
                    "{C:attention}+2{} Hand Size",
                    "Give {X:mult,C:white}X0.1{} Mult based on hand size",
                    "Double it if you have less than {C:attention}4{} jokers"
                }
            },
            anaglyph_deck = {
                name = "Anaglyph Deck Attunement",
                text = {
                    "Gain an extra {C:attention}Double Tag{}",
                    "upon finishing a {C:attention}Boss Blind{}"
                }
            },
            plasma_deck = {
                name = "Plasma Deck Attunement",
                text = {
                    "{C:chips}+100{} Chips"
                }
            },
            erratic_deck = {
                name = "Erratic Deck Attunement",
                text = {
                    "Every played card on the first hand",
                    "gets a random {C:attention}enchancment{} and {C:attention}seal{}",
                    "Give an {C:dark_edition}edition{} if it is only one card"
                }
            }
        }
    }
}