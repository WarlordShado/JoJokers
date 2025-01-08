SMODS.Atlas({
	key = "modicon",
	path = "icon.png",
	px = 32,
	py = 32
}):register()

SMODS.Atlas({
	key = "JoJokers",
	path = "JoJokers.png",
	px = 71,
	py = 95
}):register()

SMODS.Atlas({
    key = "JoJokers7",
	path = "part7.png",
	px = 71,
	py = 95
}):register()

SMODS.Atlas({
    key = "Consume",
	path = "consume.png",
	px = 71,
	py = 95
}):register()

SMODS.Atlas({
    key = "sticker",
	path = "sticker.png",
	px = 71,
	py = 95
}):register()

local jojocolors = loc_colour
function loc_colour(_c, _default)
  if not G.ARGS.LOC_COLOURS then
    jojocolors()
  end
  G.ARGS.LOC_COLOURS["sticker"] = HEX('c75985')
  G.ARGS.LOC_COLOURS["special"] = HEX('25ba00')
  G.ARGS.LOC_COLOURS["soul"] = HEX('0084d6')
  return jojocolors(_c, _default)
end