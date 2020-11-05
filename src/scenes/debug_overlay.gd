extends CanvasLayer

var stats = []

func _ready():
	pass

func add_stat(stat_name, object, stat_ref, is_method):
	stats.append([stat_name, object, stat_ref, is_method])

func _process(delta):
	var label_text = "Debug \n"
	label_text += "===============\n"
	
	var fps = Engine.get_frames_per_second()
	label_text += str("FPS: ", fps)
	label_text += "\n"
	
	var mem = OS.get_static_memory_usage()
	label_text += str("Static Memory: ", String.humanize_size(mem))
	label_text += "\n"
	
	for s in stats:
		var value = null
		#check if object not null, get a weakref to make sure object not freed
		if s[1] and weakref(s[1]).get_ref():
			#if is method
			if s[3]:
				#call the getter function
				value = s[1].call(s[2])
			else:
				#otherwise get the variable directly
				value = s[1].get(s[2])
		
		#append label with object info
		label_text += str(s[0], ": ", value)
		label_text += "\n"
	
	$Label.text = label_text
		
