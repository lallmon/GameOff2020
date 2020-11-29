extends Node2D

onready var settings = {}

func _enter_tree() -> void:
	game.player = $Sub
	game.camera = $Camera2D

func _ready():
	generate_level(100)
	$CanvasModulate.visible = true

func _process(_delta):
	DepthModulate()

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

#super shitty and hacked together obstacle generation, should definitely be trashed
func generate_level(var density:int = 5):
	var obstacle = load("res://Objects/Obstacle/Obstacle.tscn")
	
	for a in density:
		var position = Vector2(randf() * 1920, randf() * 3080)
		var scale = Vector2(1 + randf() * 3, 1)
		var spawn = obstacle.instance()
		spawn.position = position
		spawn.scale = scale
		$Obstacles.add_child(spawn)
