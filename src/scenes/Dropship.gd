extends KinematicBody2D

export (int) var speed = 200
export (int) var boost = 400
signal ship_boosting(value)

var velocity = Vector2()
var rotation_dir = 0

func get_input():
	look_at(get_global_mouse_position())
	#TODO: when the tip of the ship hits the mouse pointer, stop the ship.
	velocity = Vector2(speed, 0).rotated(rotation)
	
	if Input.is_mouse_button_pressed(1):
		#TODO: When mouse button clicked, give short burst of speed.
		emit_signal("ship_boosting", true)
		velocity = Vector2(speed + boost, 0).rotated(rotation)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	get_input()
	rotation = get_global_mouse_position().angle_to_point(position)
	velocity = move_and_slide(velocity)

