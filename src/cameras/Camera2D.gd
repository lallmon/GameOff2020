extends Camera2D

export var player: NodePath = ""

var player_pos = Vector2(0,0)

onready var design_res: Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/width"),ProjectSettings.get_setting("display/window/size/height"))

func _process(_delta: float) -> void:
	player_pos = self.get_node(player).position
	position = player_pos
	
