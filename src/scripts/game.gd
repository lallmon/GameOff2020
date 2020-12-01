extends Node

var player = null setget _set_player, _get_player
var camera = null setget _set_camera, _get_camera
var gui = null setget _set_gui, _get_gui

var main = null
var _filename = "game.dat"

var deepest:int
var longest:int

var debug = false

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

func save():
		var save_dict = {
	        "_filename" : _filename,
			"longest" : longest,
			"deepest" : deepest,
	    }
		return save_dict

# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game():
	var save_game = File.new()
	save_game.open("user://" + _filename, File.WRITE)

	# Call the node's save function.
	var node_data = save()

	# Store the save dictionary as a new line in the save file.
	save_game.store_line(to_json(node_data))
	save_game.close()

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://" + _filename):
		return # Error! We don't have a save to load.

    # Load the file line by line and process that dictionary to restore
    # the object it represents.
	save_game.open("user://" + _filename, File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		# Now we set the remaining variables.
		for i in node_data.keys():
			self.set(i, node_data[i])

	save_game.close()


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
