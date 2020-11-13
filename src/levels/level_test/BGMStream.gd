extends AudioStreamPlayer

func _ready():
	if game.player!=null:
		game.player.connect("depth_status", self, "_on_Sub_depth_status")
	
func _on_Sub_depth_status(depth):
	var meters = depth / 32 #TODO: extract to reusable function
	if (meters >= 10 && meters < 12) && playing == false:
		play()
