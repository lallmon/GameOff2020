extends StaticBody2D

func _ready():
	respawn()

func respawn():
		position = Vector2(randf()*1920, randf()*20000)


func _on_VisibilityNotifier2D_viewport_exited(_viewport: Viewport) -> void:
	respawn()
