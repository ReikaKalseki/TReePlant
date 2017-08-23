--require "defines"
require "util"
require "functions"

function initGlobal(force)
	if not global.treeplant then
		global.treeplant = {}
	end
	if force or global.treeplant.loadTick == nil then
		global.treeplant.loadTick = false
	end
	if force or global.treeplant.chunk_cache == nil then
		global.treeplant.chunk_cache = {}
	end
	if force or global.treeplant.planters == nil then
		global.treeplant.planters = {}
	end
end

initGlobal(true)

script.on_init(function()
	initGlobal(true)
end)

script.on_configuration_changed(function()
	initGlobal(true)
end)

script.on_event(defines.events.on_entity_died, function(event)
	onEntityDied(event.entity)
end)

script.on_event(defines.events.on_player_mined_entity, function(event)
	onEntityMined(event.entity, event.buffer)
end)

script.on_event(defines.events.on_robot_mined_entity, function(event)
	onEntityMined(event.entity, event.buffer)
end)

script.on_event(defines.events.on_built_entity, function(event)
	onEntityBuilt(event.created_entity, event.item, game.players[event.player_index].cursor_stack)
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
	onEntityBuilt(event.created_entity, event.item, event.robot and event.robot.get_inventory and event.robot.get_inventory(defines.inventory.robot_cargo)[1] or nil)
end)

script.on_event(defines.events.on_tick, function(event)
	onTick(game.tick)
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
		if Config.treePollutionRepair then
			healDamagedTrees(event.entity)
		end
		healStumps(event.entity)
	end
end)