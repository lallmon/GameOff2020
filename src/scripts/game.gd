extends Node

var player = null setget _set_player, _get_player
var camera = null setget _set_camera, _get_camera
var gui = null setget _set_gui, _get_gui

var main = null

var debug = true

#--------------------------------------
func _set_player( v ):
	player = weakref( v )
func _get_player():
	if player == null: return null
	return player.get_ref()
#--------------------------------------
func _set_camera( v ):
	camera = weakref( v )
func _get_camera():
	if camera == null: return null
	return camera.get_ref()
#--------------------------------------
func _set_gui( v ):
	gui = weakref( v )
func _get_gui():
	if gui == null: return null
	return gui.get_ref()
#--------------------------------------

func _ready():
	self.pause_mode = PAUSE_MODE_PROCESS #make it process when the game is paused


#OS Input code for fullscreening
var is_fullscreen := false
var window_size : Vector2
var window_pos : Vector2
func _input(_event):
	if Input.is_action_just_pressed( "btn_fullscreen" ):
		if not is_fullscreen:
			OS.set_borderless_window(true)
			window_size = OS.window_size
			OS.window_size = OS.get_screen_size()
			window_pos = OS.window_position
			OS.window_position = Vector2.ZERO
			is_fullscreen = true
		else:
			OS.set_borderless_window(false)
			OS.window_size = window_size
			OS.window_position = window_pos
			is_fullscreen = false
