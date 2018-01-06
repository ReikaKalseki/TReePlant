require "config"

local treeItems = {}

function onEntityBuilt(entity, stack)
	--game.print("Built " .. entity.name .. " with " .. ((stack ~= nil and stack.valid and stack.valid_for_read) and stack.name or "nil"))
	if Config.treeSeeds and isTree(entity) and (not isStump(entity)) and stack and stack.valid and stack.valid_for_read then
		--game.print("Removing " .. (entity.name .. "-seed") .. " from:")
		stack.count = stack.count-1
		--if stack.count <= 0 then stack.clear() end --not necessary
	end
	addTreePlanter(entity)
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
	removeTreePlanter(entity)
end

function onEntityDied(entity)
	removeTreePlanter(entity)
end

function onTick(tick)

	initGlobal(false)

	if not global.treeplant.loadTick then		
		for chunk in game.surfaces["nauvis"].get_chunks() do
			table.insert(global.treeplant.chunk_cache, chunk)
		end
		local entities = game.surfaces["nauvis"].find_entities_filtered({name="tree-planter"})
		for _,entity in pairs(entities) do
			addTreePlanter(entity)
		end
		global.treeplant.loadTick = true
	end

	if tick%20 == 0 then
		for _,entity in pairs(global.treeplant.planters) do
			tickTreePlanter(tick, entity)
		end
	end
end

function getAllTreeItems(loaded) --are we in data phase or control phase?
	if treeItems[loaded] == nil then
		treeItems[loaded] = {}
		for name,item in pairs(loaded and game.item_prototypes or data.raw.item) do
			--game.print(stack.name .. " >> " .. tostring(Config.treesDropSelves) .. " / " .. tostring(Config.treeSeeds))
			if (Config.treeSeeds and string.find(name, "seed")) or (Config.treesDropSelves or Config.placeableTrees) then
				local placed = item.place_result --is string in data, entityproto in control
				if placed and string.find(loaded and placed.name or placed, "tree") then
					table.insert(treeItems[loaded], item)
				end
			end
		end
	end
	return treeItems[loaded]
end

function addTreePlanter(entity)
	if entity.name == "tree-planter" then
		table.insert(global.treeplant.planters, entity)
		local i = 1
		for _,item in pairs(getAllTreeItems(true)) do
			if i > entity.request_slot_count then break end
			entity.set_request_slot({name=item.name, count=1000000}, i)
			i = i+1
		end
	end
end

function removeTreePlanter(entity)
	if entity.name == "tree-planter" then
		for i,planter in ipairs(global.treeplant.planters) do
			if planter.position.x == entity.position.x and planter.position.y == entity.position.y then
				table.remove(global.treeplant.planters, i)
				break
			end
		end
	end
end

function tickTreePlanter(tick, entity)
	local surf = entity.surface
	local inv = entity.get_inventory(defines.inventory.chest)
	local slot = math.random(1, #inv)
	local stack = inv[slot]
	if stack and stack.valid_for_read then
		local placed = game.item_prototypes[stack.name].place_result --still need checks here, since can manually input items
		if placed and string.find(placed.name, "tree") then
			local tries = 20
			for i = 1,tries do
				local pos = {x=entity.position.x+math.random(-50, 50), y=entity.position.y+math.random(-50, 50)}
				local dir = math.random(0, 7)
				if surf.can_place_entity({name=placed.name, position=pos, direction=dir, force=game.forces.neutral}) then
					local r = 10
					local forest = surf.find_entities_filtered({type="tree", area = {{pos.x-r, pos.y-r}, {pos.x+r, pos.y+r}}})
					local similar = {}
					for _,tree in pairs(forest) do
						if tree.name == placed.name then
							table.insert(similar, tree)
						end
					end
					if #similar > 2 and #similar > #forest*0.75 then --only place if more than 2 similar trees nearby, and they are at least a 75% majority, indicating either natural worldgen or player placement desire
						surf.create_entity({name=placed.name, position=pos, direction=dir, force=game.forces.neutral})
						stack.count = stack.count-1
						break
					end
				end
			end
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
	icon_size = tree.icon_size and tree.icon_size or 32,
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
	if entity.name == "tree-planter" then return false end
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

function replaceTree(entity)
	if isStump(entity) then
		local tree = getParentTree(entity)
		local newtree = entity.surface.create_entity{name = tree.name, direction = entity.direction, position = entity.position, force = game.forces.neutral, health = 1} --force was player
		newtree.health = 1
		return
	end
	if isTree(entity) then
		local surf = entity.surface
		local force = entity.force
		local name = entity.name
		local dir = entity.direction
		local health = entity.health
		local pos = entity.position
		local var = entity.graphics_variation
		local clr = entity.tree_color_index and entity.tree_color_index or nil
		entity.destroy()
		local ret = surf.create_entity{name = name, direction = dir, position = pos, force = game.forces.neutral, health = health} --force was player
		ret.graphics_variation = var
		ret.health = health
		ret.tree_color_index = clr
	end
end

function healDamagedTrees(entity)
	local trees = entity.surface.find_entities_filtered{area = {{entity.position.x-30, entity.position.y-30}, {entity.position.x+30, entity.position.y+30}}, type="tree"}
	for k,v in pairs(trees) do
		--game.print("Corpse " .. k)
		if isTree(v) then
			replaceTree(v)
			if v.valid then
				v.destroy()
			end
		end
	end
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
end

function extinguishFire(entity)
	local fires = entity.surface.find_entities_filtered{area = {{entity.position.x-20, entity.position.y-20}, {entity.position.x+20, entity.position.y+20}}}
	for k,v in pairs(fires) do
		if isFire(v) then
			v.destroy()
		end
	end
end