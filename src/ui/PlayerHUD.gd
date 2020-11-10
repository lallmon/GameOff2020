extends Control

func _ready():
	pass

func _on_Sub_player_depth(value):
	#32px = 1meter
	if value < 0:
		return 0
	$DepthGuage/DepthMeasurement.text = ("%d" % (value / 32))
