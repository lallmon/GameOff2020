extends Node

#assumption that 32 pixels = 1 meter
func pixels_to_meters(position: float) -> int: 
	if position < 0: return 0
	else: return int(position) / 32
