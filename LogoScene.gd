extends Node2D


onready var game_manager = get_node("..")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.logo_visible = true
	$Fade/AnimationPlayer.play("black_screen")
	yield(get_tree().create_timer(1),"timeout")
	
	
	$Fade/AnimationPlayer.play("medium_fade_in")
	yield(get_tree().create_timer(0.1),"timeout")
	
	$WindowOpening.play()
	yield(get_tree().create_timer(0.2),"timeout")
	
	$NightAmbience.play()
	$Tween.interpolate_property($NightAmbience, "volume_db", -60, 0, 1)
	$Tween.start()
	yield(get_tree().create_timer(2.2),"timeout")
	
	$Fade/AnimationPlayer.play("medium_fade_out")
	yield(get_tree().create_timer(0.7),"timeout")
	
	Global.logo_visible = false
	game_manager.load_scene(game_manager.update_message_screen)
