extends StaticBody2D
export var damage : int = 5

func _ready():
	add_to_group("obstacle")
#	respawn()

func respawn():
	position = Vector2(randf()*1920, randf()*20000)

func _on_VisibilityNotifier2D_viewport_exited(_viewport: Viewport) -> void:
	respawn()
