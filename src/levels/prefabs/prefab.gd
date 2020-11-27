extends Node2D

export var cost: = 10
export var randomize_transform = true

var debug = true

func _ready() -> void:
	pass

#initialize the prefab object
func initialize(newpos: Vector2):
	
	position = newpos
	
	if randomize_transform == true:
		RandomizeTerrain()
	

		

#randomize rotatation of objects for variation
func RandomizeTerrain():
	var children = $Objects.get_children()
	if children.empty():
		return
	for a in children:
		a.rotation_degrees = randi()%360

#function for adding an item to the prefab
#takes an object reference and then uses the spawn ray casts in the
#objectspawns node to place items on prefab objects
func AddItem(object):
	
	#get all the object spawn raycasts
	var spawn_locations = $ObjectSpawns.get_children()
	
	# if there aren't any print to the console and return fail (null)
	if spawn_locations.empty():
		if game.debug == true and self.debug==true:
			print("AddObject(): no spawners on prefab %d, skipping...", name)
		return null
	
	#check through the spawn locations and check if any are already colliding
	#and if there are remove them from the list
	#TO DO: fix so it advances the position of the ray iteratively to see if it
	#can be nudged out of collision space
	for c in spawn_locations.size():
		if spawn_locations[c].is_colliding():
			spawn_locations.remove(c)
	
	#pick one of the spawn locations
	var pick = randi()%(spawn_locations.size())
	
	#cast the ray 10 units(32) away and force and update
	spawn_locations[pick].cast_to *= 10
	spawn_locations[pick].force_raycast_update()
	
	var normal
	var point
	
	#if the ray is colliding
	if spawn_locations[pick].is_colliding()==true:
		
		#get the collision point and normal of the collision
		point = spawn_locations[pick].get_collision_point()
		normal = spawn_locations[pick].get_collision_normal()
		
		if game.debug==true and self.debug==true:
			print("AddObject(): collision found @", point)
			print("AddObject(): collision normal @", normal)
	else: #else delete the spawn location and return fail (null)
		spawn_locations[pick].queue_free()
		if game.debug==true and self.debug==true:
			print("AddObject(): No collision, returning")
		return null

	#instance the item
	var item = object.instance()
	
	var newposition = point-global_position + (normal * 16)
	var newrotation = normal.angle() + PI/2
	
	$Objects.add_child(item)
	
	item.initialize(newposition, newrotation)
	
	print ("adding ", item.name, " at position", item.position)
	

	
	$ObjectSpawns.queue_free()
	
		
