extends RigidBody2D

export var thrust_y : int = 300
export var idle_thrust_y : int = 75
export var oxygen_decay_per_second : float = 0.5

var thrust : Vector2 = Vector2(0, thrust_y)
var idle_thrust : Vector2 = Vector2(0, idle_thrust_y)
var vel_modifier = Vector2(0,0)
var torque : int = 0
var max_torque : int = 6000
var hull_integrity: int = 100
var oxygen_level: float = 100
var input_disabled

signal depth_status(depth)
signal hull_status(hull_integrity)
signal oxygen_status(oxygen_level)
signal sub_destroyed

func _ready():
	add_to_group("player")
	input_disabled = false
	$BoostBubbles.emitting = false
	$OxygenTimer.connect("timeout", self, "_on_Oxygen_timeout")
	$OxygenTimer.start()

func _integrate_forces(_state):
	emit_signal("depth_status", global_position.y)
	var mouse_position = get_global_mouse_position()
	var mouse_vector = mouse_position - position
	var rotation_dir = 0
	
	$Target.rotation = mouse_vector.angle() - rotation
	
	var l_dist = $Left.global_position.distance_to(mouse_position)
	var r_dist = $Right.global_position.distance_to(mouse_position)
	
	if not input_disabled:
		applied_force = idle_thrust.rotated(rotation)

		#NOT SURE IF NEEEDED!!
		#detect colliding bodies
		var collision = get_colliding_bodies()

		#if a collision is detected, bounce the player back
		if collision:
			for a in collision:
				#I can't even remember what this resolves to lol
				applied_force += ((a.position - position).normalized().rotated(rotation) * 10)
				#applied_force += (-(mouse_vector.normalized()))
				#set_axis_velocity(-((mouse_position - position).normalized()))
		
		#UNUSED, could be useful?
#			var target_rotation = rad2deg(position.angle_to_point(mouse_position))
#			var angle_diff = rotation  - target_rotation
		
		if l_dist < r_dist:
			rotation_dir = 1
		else:
			rotation_dir = -1
		
		if torque <= max_torque and torque >= 0:
			torque += 100
		torque -=50
		
		applied_torque = rotation_dir * torque
			
		if Input.is_mouse_button_pressed(1) and not input_disabled:
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
	if game.debug:
		print("Sub Is Destroyed")
	emit_signal("sub_destroyed")
	
	input_disabled=true
	
	yield(get_tree().create_timer(3),"timeout")
	game.main.load_screen("res://levels/procedural_test/levelgen.tscn")
	
func TakeHullDamage(damage_amount):
	print("Took Damage %s" % damage_amount)
	hull_integrity = hull_integrity - damage_amount
	if hull_integrity <= 0:
		hull_integrity = 0
		DestroySub()
	emit_signal("hull_status", hull_integrity)

func _on_Sub_body_entered(body):
	TakeHullDamage(linear_velocity.length() / body.damage)
		
func _on_Oxygen_timeout():
	oxygen_level -= oxygen_decay_per_second
	if oxygen_level <= 0:
		oxygen_level = 0
		DestroySub()
	emit_signal("oxygen_status", oxygen_level)
