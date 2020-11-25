extends Area2D

onready var energy = $Energy
onready var bubbles = $Bubbles

var triggered = false

func _on_SpawnSplash_body_entered(body: Node) -> void:
	if body.is_in_group("player") and triggered == false:
		triggered = true
		energy.emitting = true
		bubbles.emitting = true
		$AudioStreamPlayer.play()
		
