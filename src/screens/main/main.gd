extends Node2D

const FIRST_SCN = "res://levels/procedural_test/levelgen.tscn"
const MENU_SCN = ""

func _ready():
	game.main = self
	game.gui = $hud_layer/GameHUD
	load_screen(FIRST_SCN, "", false)

var load_state = 0
var cur_screen

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_btn"):
		toggle_pause()

func load_screen(scrn := "", transition := "", transition_out :=true, transition_in :=true):
	if not scrn.empty():
		load_state = 0
		cur_screen = scrn
	
	match load_state:
		0: #fade out
			load_state = 1
			print ("LOADING SCREEN:", cur_screen)
			get_tree().paused = true
			if transition_out == true: $transition_layer/transition/AnimationPlayer.play("transition_out")
			$screen_timer.set_wait_time(1)
			$screen_timer.start()
		1:
			load_state = 2
			#hide the hud
			#hud_layer/GAME_HUD.hide()
			var children = $levels.get_children()
			if not children.empty():
				children[0].queue_free()
			$screen_timer.set_wait_time(0.3)
			$screen_timer.start()
		2:
			load_state = 3
			var new_level = load(cur_screen).instance()
			$levels.add_child(new_level)
			$screen_timer.set_wait_time(0.3)
			$screen_timer.start()
		3:
			load_state = 4
			if transition_in == true: $transition_layer/transition/AnimationPlayer.play("transition_in")
			if game.gui!=null:
				game.gui.subscribe_to_player()
				$text_layer/zone_text.subscribe_to_player()
			$screen_timer.set_wait_time(0.2)
			$screen_timer.start()
		4:
			load_state = 0
			get_tree().paused=false

#callback to advance the load state
func _on_screen_timer_timeout() -> void:
		load_screen()

func toggle_pause():
	var bg = $pause_layer/pause_bg
	get_tree().paused = !get_tree().paused
	if get_tree().paused ==true:
		bg.visible = true
	else:
		bg.visible = false


