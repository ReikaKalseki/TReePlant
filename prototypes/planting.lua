require "config"
require "functions"

data:extend({
  {
    type = "item",
    name = "tree-planter",
    icon = "__TreePlant__/graphics/tree-planter-ico.png",
	icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "logistic-network",
    order = "b[storage]-c[tree-planter]",
    place_result = "tree-planter",
    stack_size = 10
  },
  {
    type = "recipe",
    name = "tree-planter",
    ingredients = {{"steel-chest", 2}, {"wood", 10}, {"coal", 20}},
    result = "tree-planter",
	enabled = true,
  },
	{
    type = "logistic-container",
    name = "tree-planter", --make the actual planter a roboport which offers big construction area; make that the AOE of the planter (make it use robots to plant (place ghosts)?)? that gates behind robots, which is bad; and lets it allow construction of other things, also bad
    icon = "__TreePlant__/graphics/tree-planter-ico.png",
	icon_size = 32,
    flags = {"placeable-player", "player-creation"},
    minable = {hardness = 0.4, mining_time = 0.75, result = "tree-planter"},
    max_health = 350,
    corpse = "small-remnants",
    collision_box = {{-1.35, -1.35}, {1.35, 1.35}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    resistances =
    {
      {
        type = "fire",
        percent = -40
      },
    },
    fast_replaceable_group = "container",
    inventory_size = 80,
	logistic_slots_count = #getAllTreeItems(false),
    logistic_mode = "requester",
    open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
    close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    picture =
    {
      filename = "__TreePlant__/graphics/tree-planter.png",
      priority = "extra-high",
      width = 214,
      height = 226,
	  scale = 0.5,
      shift = {0.25, 0.25}
    },
    circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
    circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
    circuit_wire_max_distance = 12,
  },
})