extends Node2D

func _ready():
	var overlay = load("res://levels/start/debug_overlay.tscn").instance()
	
	overlay.add_stat("Player position", $Player, "position", false)
	overlay.add_stat("Mouse position", self, "get_global_mouse_position", true)
	
	add_child(overlay)
