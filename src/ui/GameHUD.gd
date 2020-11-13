extends Control

func _ready():
	pass

func _on_Sub_depth_status(depth : float):
	#32px = 1meter
	if depth < 0:
		return 0
	else:
		depth = depth / 32
	$DepthGuage/Value.text = ("%d" % depth)

func _on_Sub_hull_status(integrity: int):
	$HullIntegrity/Value.text = ("%d" % integrity)
