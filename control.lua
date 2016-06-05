require "defines"
require "util"
require "functions"

script.on_event(defines.events.on_preplayer_mined_item, function(event)
	--game.player.print("Mined " .. event.entity.name)
	if isStump(event.entity) then
		--replaceTree(event.entity)
	end
end)

script.on_event(defines.events.on_trigger_created_entity, function(event)
	--game.player.print("Mined " .. event.entity.name)
	--[[
	local idx = event.entity.name:match'^.*()-'
	if idx ~= nil then
		local sub = string.sub(event.entity.name, idx+1, -1)
		--game.player.print("Stump? " .. sub)
		if sub == "stump" then
			replaceTree(event.entity)
		end
	end
	--]]
	local stumps = event.entity.surface.find_entities_filtered{area = {{event.entity.position.x-30, event.entity.position.y-30}, {event.entity.position.x+30, event.entity.position.y+30}}, type="corpse"}
	for k,v in pairs(stumps) do
		--game.player.print("Corpse " .. k)
		if isStump(v) then
			replaceTree(v)
			v.destroy()
		end
	end
	
	--clear duplicated trees from early mod versions
	local trees = event.entity.surface.find_entities_filtered{area = {{event.entity.position.x-30, event.entity.position.y-30}, {event.entity.position.x+30, event.entity.position.y+30}}, type="tree"}
		for k,v in pairs(trees) do
		--game.player.print("Tree " .. k)
		if v.valid and isTree(v) then
			local same = event.entity.surface.find_entities_filtered{area = {{v.position.x, v.position.y}, {v.position.x, v.position.y}}, type="tree"}
			--game.player.print("Found at position " .. v.position.x .. "," .. v.position.y .. " : " .. #same)
			if #same > 1 then
				local surf = v.surface
				local dir = v.direction
				local pos = v.position
				local t = v.name
				for k2,v2 in pairs(same) do --clear all existing, place new one
					v2.destroy()
				end
				surf.create_entity{name = t, direction = dir, position = {x = pos.x,y = pos.y}, force = game.forces.neutral}
			end
		end
	end
end)