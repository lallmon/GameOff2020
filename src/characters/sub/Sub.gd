extends RigidBody2D

var thrust : Vector2 = Vector2(0, 350)
var idle_thrust : Vector2 = Vector2(0, 35)
var max_torque : int = 6000
var torque : int = 0
var gravity : int = 10
var hull_integrity: int = 100
var oxygen: float = 100
var oxygen_decay = 1.0
var vel_modifier = Vector2(0,0)
var input_disabled = false

signal depth_status(depth)
signal hull_status(hull_integrity)
signal oxygen_status(oxygen)
signal heavy_damage(damage)
signal sub_destroyed

func _ready():
	add_to_group("player")
	input_disabled = true
	$BoostBubbles.emitting = false
	$OxygenTimer.connect("timeout", self, "_on_Oxygen_timeout")
	$OxygenTimer.start()
	spawn_state()

func spawn_state():
	set_axis_velocity(Vector2(0,700))
	$InputActivation.start()

func _integrate_forces(_state):
	emit_signal("depth_status", global_position.y)
	emit_signal("hull_status", hull_integrity)
	var mouse_position = get_global_mouse_position()
	var mouse_vector = mouse_position - position
	var rotation_dir = 0
	
	$Target.rotation = mouse_vector.angle() - rotation
	
	var l_dist = $Left.global_position.distance_to(mouse_position)
	var r_dist = $Right.global_position.distance_to(mouse_position)
	
	if Input.is_mouse_button_pressed(1) or Input.is_mouse_button_pressed(2):
		if Input.is_mouse_button_pressed(1) and not input_disabled:
			
			applied_force = -idle_thrust.rotated(rotation)
			
			
			#NOT SURE IF NEEEDED!!
			#detect colliding bodies
			var collision = get_colliding_bodies()

			#if a collision is detected, bounce the player back
			if collision:
				for a in collision:
					#I can't even remember what this resolves to lol
					applied_force += ((a.position - position).normalized().rotated(rotation)*10)
					#applied_force += (-(mouse_vector.normalized()))
					#set_axis_velocity(-((mouse_position - position).normalized()))
			
			#UNUSED, could be useful?
#			var target_rotation = rad2deg(position.angle_to_point(mouse_position))
#			var angle_diff = rotation  - target_rotation
			
			if l_dist<r_dist:
				rotation_dir = 1
			else:
				rotation_dir = -1
			
			
			if torque <= max_torque and torque >= 0:
				torque += 100
#
			torque -=50
			applied_torque = rotation_dir * torque
			
		if Input.is_mouse_button_pressed(2) and not input_disabled:
			applied_force = thrust.rotated(rotation)
			$AnimatedSprite.speed_scale = 2
			$BoostBubbles.emitting = true
			$EngineNoise.pitch_scale = 1.2
			applied_torque = lerp(applied_torque, 0, 0.5)

	else:
		applied_force = idle_thrust.rotated(rotation)
		applied_torque = lerp(applied_torque, 0, 0.5)
		$AnimatedSprite.speed_scale = 1
		$BoostBubbles.emitting = false
		$EngineNoise.pitch_scale = 1.0

	if Input.is_mouse_button_pressed(3) and not input_disabled:
		TurnOnLights()
			
	#set_axis_velocity(linear_velocity + vel_modifier)
	applied_force += vel_modifier

func TurnOnLights():
	if $AnimationPlayer.is_playing():
		return
	$AnimationPlayer.play("flicker")

func TriggerLights():
	$LeftBeamCone.enabled = !$LeftBeamCone.enabled
	$LeftBeamGlow.enabled = !$LeftBeamGlow.enabled
	$LeftBeamGlow2.enabled = !$LeftBeamGlow2.enabled
	$RightBeamCone.enabled = !$RightBeamCone.enabled
	$RightBeamGlow.enabled = !$RightBeamGlow.enabled
	$RightBeamGlow2.enabled = !$RightBeamGlow2.enabled
	$BackLight.enabled = !$BackLight.enabled
	yield(get_tree().create_timer(1.0), "timeout")

func DestroySub():
	emit_signal("sub_destroyed")
	input_disabled=true

func TakeHullDamage(damage_amount):
	var new_integrity = hull_integrity - damage_amount
	var difference = hull_integrity - new_integrity
	hull_integrity = new_integrity
	if difference >= 5:
		emit_signal("heavy_damage", difference)
	if hull_integrity <= 0:
		hull_integrity = 0
		DestroySub()
	emit_signal("hull_status", hull_integrity)

func _on_Sub_body_entered(body):
	var velocity_force = linear_velocity.length()
	var torque_force = angular_velocity
	print ("velocity: ", velocity_force )
	print ("torque: ", torque_force )
	if velocity_force>= 80:
		TakeHullDamage(body.damage * velocity_force/200)
		TakeHullDamage(body.damage * abs(torque_force))
		
func _on_Oxygen_timeout():
	oxygen -= oxygen_decay
	if oxygen<=0:
		oxygen = 0
		DestroySub()
	emit_signal("oxygen_status", oxygen)

func _on_InputActivation_timeout() -> void:
	$EngineNoise.play()
	$AnimatedSprite.playing=true
	input_disabled = false
