extends Control

func _ready():
	pass

func subscribe_to_player():
	if game.player == null:
		if game.debug:
			print ("subscribe_to_player(): Player not found!")
		return
		
	game.player.connect("depth_status", self, "_on_Sub_depth_status")
	game.player.connect("hull_status", self, "_on_Sub_hull_status")
	game.player.emit_signal("hull_status", game.player.hull_integrity)
	
func _on_Sub_depth_status(depth : float):
	#32px = 1meter
	if depth < 0:
		return 0
	else:
		depth = depth / 32
	$DepthGuage/Value.text = ("%d" % depth)

func _on_Sub_hull_status(integrity: int):
	$HullIntegrity/Value.text = ("%d" % integrity)
