extends Camera2D

export var player: NodePath = ""
export var end_cap: Vector2

var player_pos = Vector2(0,0)

onready var design_res: Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/width"),ProjectSettings.get_setting("display/window/size/height"))

func _process(_delta: float) -> void:
	player_pos = self.get_node(player).position
	position = player_pos
	
	var end_distance = player_pos.y - (design_res.y/2.0)
	if end_distance >= end_cap.y:
		end_cap.y = end_distance
		limit_top = end_cap.y
	
