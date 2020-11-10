extends Area2D


func trigger_exit():
	get_tree().change_scene("res://levels/main/Main.tscn")

func _on_Exit_body_entered(body: Node) -> void:
	trigger_exit()
