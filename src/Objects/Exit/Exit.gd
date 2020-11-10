extends Area2D

func _on_Exit_body_entered(_body: Node) -> void:
	get_tree().change_scene("res://levels/main/Main.tscn")
