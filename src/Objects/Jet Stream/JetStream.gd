extends Area2D

export var stream_size = Vector2(4,8)

onready var collision = $CollisionShape2D
onready var sprite = $Sprite
onready var particles = $Particles2D

func _ready():
	collision.shape.extents = stream_size
#	sprite.scale.x = stream_size.y
#	sprite.scale.x = (stream_size.y/512)
	
	var material = particles.get_process_material()
	material.emission_box_extents = Vector3(stream_size.x,stream_size.y,0)
	
	
