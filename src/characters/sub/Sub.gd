extends RigidBody2D

var thrust = Vector2(0, 250)
var max_torque = 3000
var torque = 0
var gravity = 10

func _integrate_forces(state):
	
	var mouse_position = get_global_mouse_position()
	var rotation_dir = 0
	var dot_angle = position.dot(mouse_position)

	if Input.is_mouse_button_pressed(1) or Input.is_mouse_button_pressed(2):
		if Input.is_mouse_button_pressed(1):
			applied_force = -thrust.rotated(rotation)
				
			if mouse_position.x < position.x:
				rotation_dir = 1
			elif mouse_position.x > position.x:
				rotation_dir = -1
			else:
				rotation_dir = 0
			
			if torque <= max_torque and torque >= 0:
				torque += 100
			
			torque -=50
			applied_torque = rotation_dir * torque
			
		if Input.is_mouse_button_pressed(2):
			applied_force = thrust.rotated(rotation)
			$BoostBubbles.emitting = true
			applied_torque = lerp(applied_torque, 0, 0.1)
	else:
		applied_force = thrust.rotated(rotation)/4
		applied_torque = lerp(applied_torque, 0, 0.1)
		$BoostBubbles.emitting = false
	
	applied_force += Vector2(0,gravity)
