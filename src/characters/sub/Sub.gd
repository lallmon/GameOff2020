extends RigidBody2D

var thrust : Vector2 = Vector2(0, 250)
var max_torque : int = 1000
var torque : int = 0
var gravity : int = 10
var hull_integrity: int

signal depth_status(depth)
signal hull_status(hull_integrity)

func _ready():
	$BoostBubbles.emitting = false
	hull_integrity = 100
	emit_signal("hull_status", hull_integrity)

func _integrate_forces(_state):
	emit_signal("depth_status", global_position.y)
	var mouse_position = get_global_mouse_position()
	var rotation_dir = 0

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
			applied_torque = lerp(applied_torque, 0, 0.1)
			$AnimatedSprite.speed_scale = 2
			$BoostBubbles.emitting = true
			$EngineNoise.pitch_scale = 1.2
	else:
		applied_force = thrust.rotated(rotation)/4
		applied_torque = lerp(applied_torque, 0, 0.1)
		$AnimatedSprite.speed_scale = 1
		$BoostBubbles.emitting = false
		$EngineNoise.pitch_scale = 1.0

	if Input.is_mouse_button_pressed(3):
		TurnOnLights()

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

func DestroyShip():
	print("Ship Is Destroyed")
	
func TakeHullDamage(damage_amount):
	hull_integrity = hull_integrity - damage_amount
	if hull_integrity == 0:
		DestroyShip()
	emit_signal("hull_status", hull_integrity)

func _on_Sub_body_entered(body):
	TakeHullDamage(body.damage)

	
