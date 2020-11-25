extends Node2D

export var level_size:=Vector2(3,35)
export var unit_size = 32
export var chunk_size = 20
export var budget = 100
export var grace_period = 3

var chunks:= []

func _enter_tree() -> void:
	game.player = $Sub
	game.camera = $Camera2D
	
func _ready():
	randomize()
	$CanvasModulate.visible = true
	generate(7,3)
	generate_items(100)

func _process(_delta):
	DepthModulate()
	
func generate(var difficulty_ramp, var difficulty_start):
	
	var budget = 0
	
	for y in range(0,level_size.y):
		for x in range(0, level_size.x):
			
			var chunk
			var prefab = randi()%6
			budget += randi()%(y/(10-difficulty_ramp) + 1) + difficulty_start
		
			match(prefab):
				0:
					chunk = load("res://levels/prefabs/surface/surface_prefab_01.tscn").instance()
				1:
					chunk = load("res://levels/prefabs/surface/surface_prefab_02.tscn").instance()
				2:
					chunk = load("res://levels/prefabs/surface/surface_prefab_03.tscn").instance()
				3:
					chunk = load("res://levels/prefabs/surface/surface_prefab_04.tscn").instance()
				4:
					chunk = load("res://levels/prefabs/surface/surface_prefab_05.tscn").instance()
				5:
					chunk = load("res://levels/prefabs/surface/surface_prefab_06.tscn").instance()
			
			
			
			if budget <= chunk.cost:
				chunk = null
			else:
				budget -= chunk.cost
				var chunkpos = Vector2(x*unit_size*chunk_size,y*unit_size*chunk_size)
				chunk.initialize(chunkpos)
				$Geometry.add_child(chunk)
			
			chunks.append(chunk)



func generate_items(frequency:int):
	
	var freq_modifier=0
	
	for a in chunks:
		#generate a number between 1-100
		if a==null:
			continue
			
		var rand = (randi()%100) - freq_modifier
		if rand<=frequency:
			freq_modifier = 0
			var item = pick_item(randi()%2)
			a.AddItem(item)
		else:
			freq_modifier +=1


#pick item function
#returns an object based on index
#TO DO: Add enum for object list
func pick_item(index:int):

	var item
	
	match index:
		0:
			item = load("res://Objects/Oxygen/oxygen.tscn")
		1:
			item = load("res://Objects/Jet Stream/JetStream.tscn")
		2:
			item = load("res://Objects/Oxygen/oxygen.tscn")
		3:
			item = load("res://Objects/Oxygen/oxygen.tscn")
		4:
			item = load("res://Objects/Oxygen/oxygen.tscn")
	
	if item==null:
		return
	else:
		return item

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
