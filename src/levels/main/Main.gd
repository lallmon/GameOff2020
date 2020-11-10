extends Node2D

onready var settings = {}

func _ready():
	
#	settings.display_width = ProjectSettings.get_setting("display/window/size/width")
#	settings.display_height = ProjectSettings.get_setting("display/window/size/height")
	
	#var overlay = load("res://levels/start/debug_overlay.tscn").instance()
	
#	overlay.add_stat("Display height", settings, "display_width", false)
#	overlay.add_stat("Player position", $Sub, "position", false)
#	overlay.add_stat("Player rotation", $Sub, "rotation_degrees", false)
#	overlay.add_stat("Mouse position", self, "get_global_mouse_position", true)
	
	
	#add_child(overlay)
	
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
