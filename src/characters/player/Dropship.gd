extends KinematicBody2D
export (int) var speed = 200
export (int) var boost = 400

var velocity = Vector2()

func get_input():
	toggle_exhaust(false)
	look_at(get_global_mouse_position())
	#BUG: when the tip of the ship hits the mouse pointer, it freaks out.
	velocity = Vector2(speed, 0).rotated(rotation)
	
	if Input.is_mouse_button_pressed(1):
		#TODO: Boost should be only for a second.
		velocity = Vector2(speed + boost, 0).rotated(rotation)
		toggle_exhaust(true)
		
func _ready():
	pass

func _physics_process(_delta):
	get_input()
	rotation = get_global_mouse_position().angle_to_point(position)
	velocity = move_and_slide(velocity)

func toggle_exhaust(value: bool):
	var exhaust = get_node("audio-exhaust")
	if value:
		exhaust.pitch_scale = 1.2
	else:
		exhaust.pitch_scale = 1
	get_node("particle-exhaust-1").emitting = value
	get_node("particle-exhaust-2").emitting = value
