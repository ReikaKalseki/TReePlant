require("config")

-- Trees & rocks do not get killed by biters

if Config.noTreeAttack then
	table.insert(data.raw["simple-entity"]["stone-rock"].resistances,{type="physical",percent=100})
	table.insert(data.raw["simple-entity"]["stone-rock"].resistances,{type="acid",percent=100})
end
for k,tree in pairs(data.raw["tree"]) do
	if tree.subgroup == "trees" then
		local stumpname = k .. "-stump"
		if Config.noTreeAttack then
			if tree.resistances == nil then
				tree.resistances = {}
			end
			table.insert(tree.resistances,{type="physical",percent=100})
			table.insert(tree.resistances,{type="acid",percent=100})
		end
		if Config.placeableTrees then
			table.insert(tree.flags,"placeable-player")
		end
		if Config.treesDropSelves and data.raw["corpse"][stumpname] ~= nil then
			table.insert(tree.mineable.results, {name=stumpname})
		end
		if Config.treeRepair then
			--remove not-repairable flag, but that flag is not even present...
		end
		local stump = data.raw["corpse"][stumpname]
		if stump ~= nil then
			if Config.placeableTrees then
				stump.selectable_in_game = true
				stump.minable = {mining_particle = "wooden-particle", mining_time = 0.4, result = k, count = 1}
				if Config.bigStumpHitbox then
					stump.selection_box = {{-2.5, -2.5}, {2.5, 2.5}}
				end
			end
			if Config.longLifeStumps then
				stump.time_before_removed = 60 * 60 * 60 * 24 -- 24h
			end
		end
	end
end