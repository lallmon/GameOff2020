extends AudioStreamPlayer

func _ready():
	stream_paused = true
	
func _on_Sub_depth_status(depth):
	if (depth / 32) > 40:
		stream_paused = false
