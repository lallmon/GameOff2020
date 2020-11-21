extends Area2D

export var oxygen_value: int

func _ready():
	oxygen_value = 15
	
func _on_oxygen_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print ("oxygen collected by:", body.name)
		$AudioStreamPlayer.play()
		body.oxygen += oxygen_value
		yield($AudioStreamPlayer, "finished")
		collected()

func initialize(newpos:Vector2, newrot:float):
	position = newpos
	rotation = newrot

func collected():
	queue_free()
