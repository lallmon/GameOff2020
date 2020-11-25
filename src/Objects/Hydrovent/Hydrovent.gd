extends StaticBody2D

export var force_strength:= Vector2(0,-500)
export var damage = 5

var force:Vector2

func _ready() -> void:
	$InfluenceArea/CollisionShape2D.disabled = true
	$AnimationPlayer.play("cycle")

func initialize(newpos:Vector2, newrot:float):
	position = newpos
	rotation = newrot
	
	force = force_strength.rotated(rotation)

func toggle_collision():
	var collision = $InfluenceArea/CollisionShape2D
	collision.set_deferred("disabled", !collision.disabled)

func _on_InfluenceArea_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.vel_modifier += force
		
func _on_InfluenceArea_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		body.vel_modifier -= force
