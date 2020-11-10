extends RigidBody2D

var thrust = Vector2(0, 250)
var max_torque = 1000
var torque = 0
var gravity = 10
signal player_depth

func _ready():
	$BoostBubbles.emitting=false

func _integrate_forces(state):
	emit_signal("player_depth", global_position.y)
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
			$AnimatedSprite.speed_scale = 2
			$EngineNoise.pitch_scale = 1.2
	else:
		applied_force = thrust.rotated(rotation)/4
		applied_torque = lerp(applied_torque, 0, 0.1)
		$BoostBubbles.emitting = false
		$AnimatedSprite.speed_scale = 1
		$EngineNoise.pitch_scale = 1.0
	
	#applied_force += Vector2(0,gravity)

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

