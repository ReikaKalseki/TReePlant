require("functions")
require("config")

require "__DragonIndustries__.recipe"

if data.raw.item["rubber"] then
	addItemToRecipe("water-capsule", "rubber", 2)
elseif data.raw.item["bob-rubber"] then
	addItemToRecipe("water-capsule", "bob-rubber", 2)
end

if data.raw.item["fertiliser"] then
	addItemToRecipe("tree-healing-capsule-improved", "fertiliser", 1)
	data.raw.recipe["tree-healing-capsule-improved"].energy_required = 2.5
	replaceItemInRecipe("tree-healing-capsule-improved", "fertiliser", "fertiliser", 0.5)
	data.raw.recipe["tree-healing-capsule-improved"].result_count = 4
end

if Config.placeableTrees then
	for k,v in pairs(data.raw["tree"]) do
		local item = createTreeItem(k, v)
		if item ~= nil then
			data:extend(
			{
			  item
			})
		end
	end
end
	
if Config.movableRocks then
	for k,v in pairs(data.raw["simple-entity"]) do
		if string.find(k, "rock") then
		local item = createRockItems(k, v)
			if item ~= nil and #item > 0 then
				data:extend(item)
				v.flags = {"placeable-neutral", "placeable-player", "not-on-map"}
				v.minable =
				{
				  mining_particle = "stone-particle",
				  mining_time = 2,
				  result = item[1].name,
				}
			end
		end
	end
end

if Config.treeSeeds then
	for k,v in pairs(data.raw["tree"]) do
		local item = createTreeSeed(k, v)
		if item ~= nil then
			data:extend(
			{
			  item
			})
		end
	end
end