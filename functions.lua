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