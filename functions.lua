function createTreeItem(name_, tree)

  if tree == nil then
	error(serpent.block("Could not create tree item " .. name_ .. ", parent entity does not exist.")) --equivalent to 'throw new RuntimeException(sg)', since print, aka System.out.println(sg), does not work
  end
  
  if tree.subgroup ~= "trees" then --mod "fake" trees
	return nil
  end
  
  --actual item
  local result =
  {
    type = "item",
    name = name_,
    icon = tree.icon,
    flags = {"goes-to-quickbar"},
    subgroup = "trees",
    order = "a[items]-c[" .. name_ .. "]",
    place_result = name_,
    stack_size = 50
  }, 
	  
  --debug line
  --error(serpent.block("Created tree item " .. name_))
  print("Created tree item " .. name_) --only prints if run from command line
  
  return result
end

function isFire(entity)
	return string.find(entity.name, "fire")
end

function isTree(entity)
	local idx = entity.name:match'^.*()-'
	if idx ~= nil then
		local sub = string.sub(entity.name, 1, idx-1)
		--game.player.print("Tree? " .. sub)
		if sub == "tree" then
			return 1
		end
	end
	return nil
end

function isStump(entity)
	local idx = entity.name:match'^.*()-'
	if idx ~= nil then
		local sub = string.sub(entity.name, idx+1, -1)
		--game.player.print("Stump? " .. sub)
		if sub == "stump" then
			return 1
		end
	end
	return nil
end

--called during game, not loading
function getParentTree(stump)
	local idx = stump.name:match'^.*()-'
	if idx ~= nil then
		local sub = string.sub(stump.name, 1, idx-1)
		--game.player.print("Stump " .. stump.name .. " > Tree " .. sub)
		return game.entity_prototypes[sub]
	end
end

function replaceTree(stump)
	local tree = getParentTree(stump)
	stump.surface.create_entity{name = tree.name, direction = stump.direction, position = {x = stump.position.x,y = stump.position.y}, force = game.forces.neutral, health = 1} --force was player
	local newtree = stump.surface.find_entities_filtered{area = {{stump.position.x, stump.position.y}, {stump.position.x, stump.position.y}}, type="tree"}
	newtree[1].health = 1
end

function healStumps(entity)
	local stumps = entity.surface.find_entities_filtered{area = {{entity.position.x-30, entity.position.y-30}, {entity.position.x+30, entity.position.y+30}}, type="corpse"}
	for k,v in pairs(stumps) do
		--game.player.print("Corpse " .. k)
		if isStump(v) then
			replaceTree(v)
			v.destroy()
		end
	end
	
	--clear duplicated trees from early mod versions
	local trees = entity.surface.find_entities_filtered{area = {{entity.position.x-30, entity.position.y-30}, {entity.position.x+30, entity.position.y+30}}, type="tree"}
		for k,v in pairs(trees) do
		--game.player.print("Tree " .. k)
		if v.valid and isTree(v) then
			local same = entity.surface.find_entities_filtered{area = {{v.position.x, v.position.y}, {v.position.x, v.position.y}}, type="tree"}
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
end

function extinguishFire(entity)
	local fires = entity.surface.find_entities_filtered{area = {{entity.position.x-20, entity.position.y-20}, {entity.position.x+20, entity.position.y+20}}}
	for k,v in pairs(fires) do
		if isFire(v) then
			v.destroy()
		end
	end
end