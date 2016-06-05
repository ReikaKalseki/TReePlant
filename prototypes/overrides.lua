require("config")

-- Trees & rocks do not get killed by biters

if Config.noTreeAttack then
	table.insert(data.raw["simple-entity"]["stone-rock"].resistances,{type="physical",percent=100})
	table.insert(data.raw["simple-entity"]["stone-rock"].resistances,{type="acid",percent=100})
end
for k,v in pairs(data.raw["tree"]) do
	if v.subgroup == "trees" then
		if Config.noTreeAttack then
			if v.resistances == nil then
				v.resistances = {}
			end
			table.insert(v.resistances,{type="physical",percent=100})
			table.insert(v.resistances,{type="acid",percent=100})
		end
		if Config.placeableTrees then
			table.insert(v.flags,"placeable-player")
		end
		if Config.treeRepair then
			--remove not-repairable flag, but that flag is not even present...
		end
		local stump = data.raw["corpse"][k .. "-stump"]
		if stump ~= nil then
			if Config.placeableTrees then
				stump.selectable_in_game = true
				stump.minable = {mining_particle = "wooden-particle", mining_time = 0.4, result = k, count = 1}
			end
			if Config.longLifeStumps then
				stump.time_before_removed = 60 * 60 * 60 * 24 -- 24h
			end
		end
	end
end