extends Area2D

onready var energy = $Energy
onready var bubbles = $Bubbles

func _on_SpawnSplash_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		energy.emitting = true
		bubbles.emitting = true
		
