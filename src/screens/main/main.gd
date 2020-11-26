extends Node2D

const FIRST_SCN = "res://levels/procedural_test/levelgen.tscn"
const MENU_SCN = ""
var load_state = 0
var cur_screen

func _ready():
	game.main = self
	game.gui = $hud_layer/GameHUD
	load_screen(FIRST_SCN, "", false)

func subscribe_to_player():
	game.player.connect("depth_status", game.gui, "_on_Sub_depth_status")
	game.player.connect("hull_status", game.gui, "_on_Sub_hull_status")
	game.player.connect("oxygen_status", game.gui, "_on_Sub_oxygen_status")
	game.player.connect("heavy_damage", game.gui, "_on_heavy_damage")
	game.player.connect("sub_destroyed", self, "_on_Game_over")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_btn"):
		toggle_pause()
	if event.is_action_pressed("reset_btn"):
		load_screen(FIRST_SCN)



func load_screen(scrn := "", _transition := "", transition_out :=true, transition_in :=true):
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
				subscribe_to_player()
			$screen_timer.set_wait_time(0.2)
			$screen_timer.start()
		4:
			load_state = 0
			get_tree().paused=false

func _on_Game_over():
	yield(get_tree().create_timer(3),"timeout")
	game.main.load_screen("res://levels/procedural_test/levelgen.tscn")

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


