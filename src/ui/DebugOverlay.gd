extends VBoxContainer

var display = {}

func _ready():
	$".".visible = false
	display.width = ProjectSettings.get_setting("display/window/size/width")
	display.height = ProjectSettings.get_setting("display/window/size/height")

func _input(_ev):
	if Input.is_key_pressed(KEY_F12):
		$".".visible = !$".".visible

func _process(_delta):
	$FPS.text = ("FPS: %s" % Engine.get_frames_per_second())
	$Memory.text = ("Static Memory: %s" % String.humanize_size(OS.get_static_memory_usage()))
	$MouseX.text = ("Mouse X: %s" % get_global_mouse_position().x)
	$MouseY.text = ("Mouse Y: %s" % get_global_mouse_position().y)
	$Resolution.text = str("Width: ", display.width, "px\n", "Height: ", display.height, "px")
