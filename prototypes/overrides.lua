require("config")

-- Trees & rocks do not get killed by biters

if Config.noTreeAttack then
	for name,rock in pairs(data.raw["simple-entity"]) do
		if string.find(name, "rock") or string.find(name, "stone") then
			table.insert(rock.resistances,{type="physical",percent=100})
			table.insert(rock.resistances,{type="acid",percent=100})
			log("Making " .. name .. " immune to biter attack")
		end
	end
end

local function createStump(tree)
	local ret = table.deepcopy(data.raw.corpse["tree-01-stump"])
	ret.name = tree.name .. "-stump"
	ret.localised_name = {"entity-name.tree-01-stump"}
	data:extend({
		ret
	})
    tree.corpse = ret.name
	tree.remains_when_mined = ret.name
	return ret
end

for k,tree in pairs(data.raw["tree"]) do
	if tree.subgroup == "trees" then
		if k == nil then
			local msg = "Someone created a tree with a nil name! This is a serious error!"
			if tree.icon ~= nil then
				msg = msg .. " Tree Icon (for help in finding the mod): " .. tree.icon
			end
			error(serpent.block(msg))
		end
		local stumpname = k .. "-stump"
		local stump = data.raw["corpse"][stumpname]
		if not stump then
			stump = createStump(tree)
		end
		log("Processing tree '" .. k .. "', stump = " .. (stump and stumpname or "nil"))
		
		--[[
		if string.find(k, "purple") then
			tree.localised_name = "Purple " .. tree.localised_name
		end
		if string.find(k, "blue") then
			tree.localised_name = "Blue " .. tree.localised_name
		end
		--]]
		
		if Config.noTreeAttack then
			if tree.resistances == nil then
				tree.resistances = {}
			end
			table.insert(tree.resistances,{type="physical",percent=100})
			table.insert(tree.resistances,{type="acid",percent=100})
		end
		if Config.placeableTrees or Config.treesDropSelves or Config.treeSeeds then
			table.insert(tree.flags,"placeable-player")
		end
		if Config.treesDropSelves then
			if tree.minable.result and not tree.minable.results then
				tree.minable.results = {}
				table.insert(tree.minable.results, {name=tree.minable.result, amount=tree.minable.count})
			end
			table.insert(tree.minable.results, {name=k, amount = 1})
			tree.minable.result = nil
		end
		if Config.treeRepair then
			--remove not-repairable flag, but that flag is not even present...
		end
		if stump ~= nil then
			if Config.placeableTrees then
				if not Config.treesDropSelves then
					stump.selectable_in_game = true
					stump.minable = {mining_particle = "wooden-particle", mining_time = 0.4, result = k, count = 1}
					if Config.longLifeStumps then
						stump.time_before_removed = 60 * 60 * 60 * 24 -- 24h
					end
					if Config.bigStumpHitbox then
						stump.selection_box = {{-2.5, -2.5}, {2.5, 2.5}}
					end
				end
			end
			if Config.placeableTrees or Config.treeSeeds then
				--stump.time_before_removed = 1
				
				--stump.minable.result = nil
				--stump.minable.results = nil
				
				tree.remains_when_mined = nil
			end
		end
	end
end