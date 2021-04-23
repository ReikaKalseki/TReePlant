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

local function addCommands()
	commands.add_command("findStumps", {"cmd.find-stumps-help"}, function(event)
		local count = 0
		local player = game.players[event.player_index]
		local sound = true
		for _,e in pairs(player.surface.find_entities_filtered{type = "corpse"}) do
			if string.find(e.name, "stump") then
				count = count+1
				player.add_custom_alert(e, {type = "virtual", name = "tree-stump-alert"}, {"virtual-signal-name.tree-stump-alert", serpent.block(e.position)}, true)
				if sound then
					player.play_sound{path="utility/console_message", position=player.position, volume_modifier=1}
					sound = false
				end
			end
		end
		game.print("TreePlant: Identified " .. count .. " dead trees.")
	end)
end

addCommands()

script.on_load(function()
	
end)

script.on_init(function()
	initGlobal(true)
end)

script.on_configuration_changed(function()
	initGlobal(true)
end)

script.on_event(defines.events.on_chunk_generated, function(event)
	controlChunk(event.surface, event.area)
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
	onEntityBuilt(event.created_entity, event.stack)
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
	onEntityBuilt(event.created_entity, event.stack)
end)

script.on_event(defines.events.script_raised_destroy, function(event)
	local dropExtra = {}
	onEntityMined(event.entity, nil, dropExtra)
	for _,e in pairs(dropExtra) do
		event.entity.surface.spill_item_stack(event.entity.position, e, true, event.entity.force, false)
	end
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
		else
			
		end
		healStumps(event.entity)
	end
end)

local function onEntityAttacked(event)	
	local entity = event.entity
	local source = event.cause
	if source and source.valid and source.type == "unit" and event.original_damage_amount > 0 and event.final_damage_amount <= 0 and (isRock(entity) or isTree(entity)) then
		source.die()
	end
end

script.on_event(defines.events.on_entity_damaged, onEntityAttacked)

--[[
script.on_event(defines.events.on_pre_build, function(event)	
	local player = game.players[event.player_index]
	local stack = player.cursor_stack
	
	if not (stack.valid_for_read) then
		return
	end
	
	if string.find(stack.name, "rock-var", 1, true) then
		game.print(stack.name)
		return
	end
end)
--]]