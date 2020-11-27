extends Node2D

export var level_size:=Vector2(3,35)
export var unit_size = 32
export var chunk_size = 20

var chunks:= []

#NEW
var last_chunk
var last_position
var difficulty_start = 3
var difficulty_modifier = 1.1
var budget:int
export var spawn_distance = 1920

#Prefab list
var prefabs = [
	preload("res://levels/prefabs/surface/surface_prefab_01.tscn"),
	preload("res://levels/prefabs/surface/surface_prefab_02.tscn"),
	preload("res://levels/prefabs/surface/surface_prefab_03.tscn"),
	preload("res://levels/prefabs/surface/surface_prefab_04.tscn"),
	preload("res://levels/prefabs/surface/surface_prefab_05.tscn"),
	preload("res://levels/prefabs/surface/surface_prefab_06.tscn"),
]

#Item list
var items = [
	preload("res://Objects/Oxygen/oxygen.tscn"),
	preload("res://Objects/Jet Stream/JetStream.tscn"),
	preload("res://Objects/Hydrovent/Hydrovent.tscn"),
]

func _enter_tree() -> void:
	game.player = $Sub
	game.camera = $Camera2D
	
func _ready():
	randomize()
	$CanvasModulate.visible = true
	generate_level_row(game.player.position + Vector2(0, 1024), difficulty_modifier)
#	generate(7,3)
#	generate_items(100)

func _process(_delta):
	#if player distance to the last row is less than the spawn distance
	var distance_to_last = game.player.position.distance_to(last_position)
	if distance_to_last <= spawn_distance:
		generate_level_row(last_position, difficulty_modifier)
	DepthModulate()
	track_player()

func generate_level_row(var offset:Vector2, var diff_modifier:float):
	
	print ("generating row")
	var spawn_position = Vector2(0,offset.y) + Vector2(0,chunk_size*unit_size)
	
	last_position = spawn_position
	
	budget = budget + (int(offset.y)/unit_size) * diff_modifier + difficulty_start
	
	print ("generated budget:", budget)
	
	var chunk
	for x in range(0,level_size.x):
		var allowed_budget = randi()%budget
		print ("#", x, ": allowed budget: ", allowed_budget)
		var prefab = randi()%prefabs.size()
		print ("prefab: ", prefab)
		chunk = prefabs[prefab].instance()
		if allowed_budget <= chunk.cost:
			print ("out of budget, setting to null")
			chunk = null
		else:
			("initializing prefab")
			chunk.initialize(spawn_position + Vector2(x*chunk_size*unit_size,0))
			$Geometry.add_child(chunk)
			last_chunk = chunk
			budget = budget - chunk.cost
			
		chunks.append(chunk)
	
	generate_items(100)
	
	chunks.clear()
	
func generate_items(frequency:int):
	
	var freq_modifier=0
	
	for a in chunks:
		#generate a number between 1-100
		if a==null:
			continue
			
		var rand = (randi()%100) - freq_modifier
		if rand<=frequency:
			freq_modifier = 0
			var item = pick_item(randi()%3)
			a.AddItem(item)
		else:
			freq_modifier +=1

#pick item function
#returns an object based on index
#TO DO: Add enum for object list
func pick_item(index:int):
	var item
	if index>=0 and index<items.size():
		item = items[index]
	else:
		item==null
	return item

func track_player():
	$ripple.position.y = game.player.position.y
	$ripple.material.set_shader_param("offset", Vector2(0, game.player.position.y / $ripple.scale.y))

#controls the canvas modulation to darken the light as you descend
func DepthModulate():
	var depth = $Sub.position.y
	var base_brightness = 0.7
	var depth_scale = 0.00025
	var depth_multiplier = 0.05
	
	#calculate the adjusted depth value
	var depth_adjusted = base_brightness - depth * (depth_scale * depth_multiplier)
	
	#stop it from getting too dark
	if depth_adjusted <= 0.15: depth_adjusted = 0.15
	
	#set the canvasmodulate to adjusted depth
	$CanvasModulate.color = Color(depth_adjusted,depth_adjusted,depth_adjusted,0.8)
