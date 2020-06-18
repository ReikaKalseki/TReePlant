Config = {}

--Enable this to make repair packs work on trees.
Config.treeRepair = settings.startup["tree-repair"].value--true

--Enable this to disable attacks on trees - i.e. biters destroying trees and rocks to get to their target.
Config.noTreeAttack = settings.startup["no-tree-attacks"].value--true

--Enable this to make stumps last much longer than normal, so that you can repair them more easily
Config.longLifeStumps = settings.startup["long-life-stumps"].value--true

--Enable this to make the stumps mineable and drop their parent tree type, placeable anew. This is the core of the mod.
Config.placeableTrees = settings.startup["mineable-stumps"].value--true

--Enable this to make stumps have bigger hitboxes to make mining them easier.
Config.bigStumpHitbox = settings.startup["big-stumps"].value--true

--Enable this to make trees drop themselves as well as their wood.
Config.treesDropSelves = settings.startup["tree-drops"].value--true

Config.treeSeeds = settings.startup["tree-seeds"].value--false

Config.treePollutionRepair = settings.startup["tree-pollution-repair"].value--false

Config.movableRocks = settings.startup["movable-rocks"].value--true

Config.replantDeco = settings.startup["replant-decoratives"].value--true

Config.repairRetrogen = false