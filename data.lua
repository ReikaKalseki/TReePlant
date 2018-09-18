require("functions")
require("config")

require("prototypes.treecapsule")
require("prototypes.watercapsule")

data:extend({
{
	type = "virtual-signal",
	name = "tree-stump-alert",
	icon = "__TreePlant__/graphics/alert.png",
	icon_size = 64,
	subgroup = "virtual-signal-special",
	order = name,
	hidden = true,
},
})