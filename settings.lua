data:extend({
        {
            type = "bool-setting",
            name = "tree-repair",
            setting_type = "startup",
            default_value = false,
            order = "r",
			localised_name = "Repairable trees",
			localised_description = "Enable this to make repair packs work on trees.",
        },
        {
            type = "bool-setting",
            name = "no-tree-attacks",
            setting_type = "startup",
            default_value = true,
            order = "r",
			localised_name = "Biter-proof trees",
			localised_description = "Enable this to disable attacks on trees - i.e. biters destroying trees and rocks to get to their target.",
        },
        {
            type = "bool-setting",
            name = "long-life-stumps",
            setting_type = "startup",
            default_value = true,
            order = "r",
			localised_name = "Long-life stumps",
			localised_description = "Enable this to make stumps last much longer than normal, so that you can repair them more easily.",
        },
        {
            type = "bool-setting",
            name = "mineable-stumps",
            setting_type = "startup",
            default_value = true,
            order = "r",
			localised_name = "Mineable stumps",
			localised_description = "Enable this to make the stumps mineable and drop their parent tree type, placeable anew. This is the core of the mod.",
        },
        {
            type = "bool-setting",
            name = "big-stumps",
            setting_type = "startup",
            default_value = false,
            order = "r",
			localised_name = "Increased stump hitbox",
			localised_description = "Enable this to make stumps have bigger hitboxes to make mining them easier.",
        },
        {
            type = "bool-setting",
            name = "tree-drops",
            setting_type = "startup",
            default_value = true,
            order = "r",
			localised_name = "Trees drop selves",
			localised_description = "Enable this to make trees drop themselves as well as their wood.",
        },
})
