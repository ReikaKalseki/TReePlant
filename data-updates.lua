require("functions")
require("config")

if data.raw.item["rubber"] then
	table.insert(data.raw["recipe"]["water-capsule"].ingredients,{"rubber", 2})
elseif data.raw.item["bob-rubber"] then
	table.insert(data.raw["recipe"]["water-capsule"].ingredients,{"bob-rubber", 2})
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