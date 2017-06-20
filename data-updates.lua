require("prototypes.overrides")

if data.raw.item["rubber"] then
	table.insert(data.raw["recipe"]["water-capsule"].ingredients,{"rubber", 2})
end