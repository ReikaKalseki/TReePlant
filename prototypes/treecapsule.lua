require("functions")
require("config")

data:extend(
{
    {
    type = "capsule",
    name = "tree-healing-capsule",
    icon = "__TreePlant__/graphics/tree-capsule.png",
	icon_size = 32,
    flags = {},
    capsule_action =
    {
      type = "throw",
      attack_parameters =
      {
        type = "projectile",
        ammo_category = "capsule",
        cooldown = 5,
        projectile_creation_distance = 0.6,
        range = 50,
        ammo_type =
        {
          category = "capsule",
          target_type = "position",
          action =
          {
            type = "direct",
            action_delivery =
            {
              type = "projectile",
              projectile = "tree-healing-capsule",
              starting_speed = 0.3
            }
          }
        }
      }
    },
    subgroup = "capsule",
    order = "b[tree-healing-capsule]",
    stack_size = 100
   },
     {
    type = "recipe",
    name = "tree-healing-capsule",
    enabled = "true",
    energy_required = 2,
    ingredients =
    {
		{"wood", 5},
		{"coal", 1},
    },
    result = "tree-healing-capsule",
  },
     {
    type = "recipe",
    name = "tree-healing-capsule-improved",
    enabled = "true",
	category = "crafting-with-fluid",
    energy_required = 3,
    ingredients =
    {
		{type = "item", name = "wood", amount=4},
		{type = "item", name = "coal", amount=2},
		{type = "fluid", name = "water", amount=50},
    },
    result = "tree-healing-capsule",
	result_count = 3,
  },
   
   
    {
    type = "projectile",
    name = "tree-healing-capsule",
    flags = {"not-on-map"},
    acceleration = 0.005,
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "create-entity",
          entity_name = "tree-healing-cloud",
		  trigger_created_entity = "true",
        }
      }
    },
    light = {intensity = 0.5, size = 4},
    animation =
    {
      filename = "__TreePlant__/graphics/tree-capsule.png",
      frame_count = 1,
      width = 32,
      height = 32,
      priority = "high"
    },
    shadow =
    {
      filename = "__TreePlant__/graphics/tree-capsule-shadow.png",
      frame_count = 1,
      width = 32,
      height = 32,
      priority = "high"
    },
    smoke = capsule_smoke,
  },
  {
    type = "smoke-with-trigger",
    name = "tree-healing-cloud",
    flags = {"not-on-map"},
    show_when_smoke_off = true,
    animation =
    {
      filename = "__base__/graphics/entity/cloud/cloud-45-frames.png",
      priority = "low",
      width = 256,
      height = 256,
      frame_count = 45,
      animation_speed = 0.5,
      line_length = 7,
      scale = 6,
    },
    slow_down_factor = 0,
    affected_by_wind = false,
    cyclic = true,
    duration = 60 * 10,
    fade_away_duration = 2 * 60,
    spread_duration = 10,
    color = { r = 0.0, g = 0.6, b = 0.0 },
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "nested-result",
          action =
          {
            type = "area",
            radius = 30,
            entity_flags = {"breaths-air"},
            action_delivery =
            {
              type = "instant",
              target_effects =
              {
                type = "damage",
                damage = { amount = -1, type = "electric"}
              }
            }
          }
        }
      }
    },
    action_cooldown = 10 --was 10
  },
  {
    type = "simple-entity-with-force",
    name = "tree-repair-order",
    icon = "__core__/graphics/empty.png",
	icon_size = 1,
    flags = {"placeable-player", "player-creation", "not-on-map", "placeable-off-grid"},
    selectable_in_game = false,
	destructible = false,
	collision_mask = {},
	order = "z",
    render_layer = "object",
    pictures =
    {
      filename = "__core__/graphics/empty.png",
      width = 1,
      height = 1,
      frame_count = 1,
      line_length = 1,
      animation_speed = 1,
    },
    placeable_by = {item = "tree-healing-capsule", count = 1},
	build_sound = { filename = "__base__/sound/item-close.ogg", volume=0.25 },
  },
})