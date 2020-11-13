extends AudioStreamPlayer

func _ready():
	if game.player!=null:
		game.player.connect("depth_status", self, "_on_Sub_depth_status")
	
func _on_Sub_depth_status(depth):
	if (depth / 32) > 40:
		print ("depth achieved")
		if playing == false: 
			play()
