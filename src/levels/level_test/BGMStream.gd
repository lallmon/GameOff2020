extends AudioStreamPlayer

func _ready():
	if game.player!=null:
		game.player.connect("depth_status", self, "_on_Sub_depth_status")
	
func _on_Sub_depth_status(depth):
	var meters = Utilities.pixels_to_meters(depth)
	if (meters >= 10 && meters < 12) && playing == false:
		play()
