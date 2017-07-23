--require "defines"
require "util"
require "functions"

script.on_event(defines.events.on_preplayer_mined_item, function(event)
	onEntityMined(event.entity, game.players[event.player_index].get_inventory(defines.inventory.player_main))
end)

script.on_event(defines.events.on_robot_mined_entity, function(event)
	onEntityMined(event.entity, event.buffer)
end)

script.on_event(defines.events.on_built_entity, function(event)
	onEntityBuilt(event.created_entity, event.item, game.players[event.player_index].cursor_stack)
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
	onEntityBuilt(event.created_entity, event.item, event.robot.get_inventory(defines.inventory.robot_cargo[1]))
end)

script.on_event(defines.events.on_trigger_created_entity, function(event)
	--game.print("Mined " .. event.entity.name)
	--[[
	local idx = event.entity.name:match'^.*()-'
	if idx ~= nil then
		local sub = string.sub(event.entity.name, idx+1, -1)
		--game.print("Stump? " .. sub)
		if sub == "stump" then
			replaceTree(event.entity)
		end
	end
	--]]
	if event.entity.name == "water-cloud" then
		extinguishFire(event.entity)
	elseif event.entity.name == "tree-healing-cloud" then
		healStumps(event.entity)
	end
end)