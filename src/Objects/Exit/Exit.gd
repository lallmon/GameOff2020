extends Area2D

export var scene:String = ""

func _on_Exit_body_entered(_body: Node) -> void:
	if _body.is_in_group("player"):
		if game.main!=null:
			game.main.load_screen(scene)
