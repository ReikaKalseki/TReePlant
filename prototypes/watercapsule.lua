require("functions")
require("config")

data:extend(
{
    {
    type = "capsule",
    name = "water-capsule",
    icon = "__TreePlant__/graphics/water-capsule.png",
    flags = {"goes-to-quickbar"},
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
              projectile = "water-capsule",
              starting_speed = 0.3
            }
          }
        }
      }
    },
    subgroup = "capsule",
    order = "b[water-capsule]",
    stack_size = 100
   },
     {
    type = "recipe",
    name = "water-capsule",
    category = "crafting-with-fluid",
    enabled = "true",
    energy_required = 2,
    ingredients =
    {
		{"iron-plate", 4},
		{type="fluid", name = "water", amount = 100},
    },
    result = "water-capsule",
  },
   
   
    {
    type = "projectile",
    name = "water-capsule",
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
          entity_name = "water-cloud",
		  trigger_created_entity = "true",
        }
      }
    },
    light = {intensity = 0.5, size = 4},
    animation =
    {
      filename = "__TreePlant__/graphics/water-capsule.png",
      frame_count = 1,
      width = 32,
      height = 32,
      priority = "high"
    },
    shadow =
    {
      filename = "__TreePlant__/graphics/water-capsule-shadow.png",
      frame_count = 1,
      width = 32,
      height = 32,
      priority = "high"
    },
    smoke = capsule_smoke,
  },
  {
    type = "smoke-with-trigger",
    name = "water-cloud",
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
    color = { r = 0.2, g = 0.7, b = 1.0},
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
            perimeter = 30,
            entity_flags = {"breaths-air"},
            action_delivery =
            {
              type = "instant",
              target_effects =
              {
                type = "damage",
                damage = { amount = 0, type = "fire"}
              }
            }
          }
        }
      }
    },
    action_frequency = 10 --was 10
  },
})