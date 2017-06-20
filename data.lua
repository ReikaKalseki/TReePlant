require("functions")
require("config")
require("prototypes.treecapsule")
require("prototypes.watercapsule")

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