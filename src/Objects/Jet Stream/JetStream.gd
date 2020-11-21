extends Area2D

export var stream_size = Vector2(8,4)
export var strength:= 200

onready var collision = $CollisionShape2D
onready var sprite = $Sprite
onready var particles = $Particles2D

onready var particle_material = particles.get_process_material()

func _ready():
	pass


func initialize(newpos:Vector2, newrot:float):
	
	position = newpos
	rotation = newrot
	
	collision.shape.extents = stream_size
#	sprite.scale.x = stream_size.y
#	sprite.scale.x = (stream_size.y/512)
	particle_material.emission_box_extents = Vector3(stream_size.x,stream_size.y,0)
	
	print ("material angle: ", particle_material.angle)

func _on_JetStream_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		var vel = Vector2(cos(rotation),sin(rotation))
		print ("vel", vel)
		body.vel_modifier = vel*strength
		print ("vel", body.vel_modifier)
		
		print ("rotation: ", rotation_degrees)
		print ("material angle: ", particle_material.angle)


func _on_JetStream_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		body.vel_modifier = Vector2(0,0)
