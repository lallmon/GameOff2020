extends Label

func _ready():
	pass

func subscribe_to_player():
	if game.player == null:
		if game.debug:
			print ("subscribe_to_player(): Player not found!")
		return
		
	game.player.connect("depth_status", self, "_on_Sub_depth_status")

func _on_Sub_depth_status(depth):
	
	depth = depth / 32
	
	if depth >0 and depth < 30:
		text = "Sunlight Zone"
	elif depth >200 and depth<230:
		text = "Twilight Zone"
	elif depth >1000 and depth <1030:
		text = "Midnight Zone"
	elif depth >3000 and depth <4030:
		text = "The Abyss"
	elif depth >6000 and depth <6030:
		text = "Basin"
	elif depth >7000 and depth <7030:
		text = "The Trenches"
	else:
		text = ""
		
