require "config"

function onEntityBuilt(entity, item, stack)
	--game.print("Built " .. entity.name .. " with " .. (item ~= nil and item or "nil"))
	if Config.treeSeeds and isTree(entity) and (not isStump(entity)) and stack.valid and stack.valid_for_read then-- and item and string.find(item, "seed") then
		--inventory.remove({name=--[[item--]]entity.name .. "-seed", count=1})
		--game.print("Removing " .. (entity.name .. "-seed") .. " from:")
		--local stack = inventory.find_item_stack((entity.name .. "-seed"))
		stack.count = stack.count-1
		--if stack.count <= 0 then stack.clear() end --not necessary
	end
end

function onEntityMined(entity, inventory)
	--game.print("Mined " .. entity.name)
	if isStump(entity) then
		--replaceTree(entity)
	end
	if Config.treeSeeds and isTree(entity) and (not isStump(entity)) then
		local amt = 0
		if math.random() < 0.5 then
			amt = math.random(1, 3)
			if math.random() < 0.8 then
				amt = 1
			end
		end
		if amt > 0 then
			--game.print("Dropped " .. amt .. " saplings")
			inventory.insert({name=entity.name .. "-seed", count=amt})
		end
	end
end

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
  }

  --log("Created tree item " .. name_)
  
  return result
end

function createTreeSeed(name_, tree)
  if tree == nil then
	error(serpent.block("Could not create tree item " .. name_ .. ", parent entity does not exist."))
  end
  
  if tree.subgroup ~= "trees" then --mod "fake" trees
	return nil
  end
  
  --actual item
  local result =
  {
    type = "item",
    name = name_ .. "-seed",
    icons = {{icon=tree.icon}, {icon="__TreePlant__/graphics/seed.png"}},
    flags = {"goes-to-quickbar"},
    subgroup = "trees",
	localised_name = {"item-name.tree-seed"},--{"entity-name." .. name_, {"item-name.tree-seed"}},--{{"entity-name." .. name_}, "item-name.tree-seed"},
    order = "a[items]-c[" .. name_ .. "]",
    place_result = name_,
    stack_size = 100
  }
	  
  --log("Created tree seed for " .. name_)
  
  return result
  
end

function isFire(entity)
	return string.find(entity.name, "fire")
end

function isTree(entity)
	local idx = entity.name:match'^.*()-'
	--game.print(idx)
	if idx ~= nil then
		local sub = string.sub(entity.name, 1, idx-1)
		--game.print("Tree? " .. sub)
		if string.find(sub, "tree") then
			return true
		end
	end
	return false
end

function isStump(entity)
	local idx = entity.name:match'^.*()-'
	if idx ~= nil then
		local sub = string.sub(entity.name, idx+1, -1)
		--game.print("Stump? " .. sub)
		if sub == "stump" then
			return true
		end
	end
	return false
end

--called during game, not loading
function getParentTree(stump)
	local idx = stump.name:match'^.*()-'
	if idx ~= nil then
		local sub = string.sub(stump.name, 1, idx-1)
		--game.print("Stump " .. stump.name .. " > Tree " .. sub)
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
		--game.print("Corpse " .. k)
		if isStump(v) then
			replaceTree(v)
			v.destroy()
		end
	end
	
	--clear duplicated trees from early mod versions
	local trees = entity.surface.find_entities_filtered{area = {{entity.position.x-30, entity.position.y-30}, {entity.position.x+30, entity.position.y+30}}, type="tree"}
		for k,v in pairs(trees) do
		--game.print("Tree " .. k)
		if v.valid and isTree(v) then
			local same = entity.surface.find_entities_filtered{area = {{v.position.x, v.position.y}, {v.position.x, v.position.y}}, type="tree"}
			--game.print("Found at position " .. v.position.x .. "," .. v.position.y .. " : " .. #same)
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