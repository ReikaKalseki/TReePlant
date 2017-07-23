require("functions")
require("config")
require("prototypes.overrides")

if data.raw.item["rubber"] then
	table.insert(data.raw["recipe"]["water-capsule"].ingredients,{"rubber", 2})
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