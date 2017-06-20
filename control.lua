--require "defines"
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
	if event.entity.name == "water-cloud" then
		extinguishFire(event.entity)
	elseif event.entity.name == "tree-healing-cloud" then
		healStumps(event.entity)
	end
end)