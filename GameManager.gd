extends Node2D


var logoscreen = "res://LogoScene.tscn"
var update_message_screen = "res://ui/update_message_screen/UpdateMessageScreen.tscn"
var first_chapter = "res://chapters/01_hadoscaphe/01_hadoscaphe.tscn"


func _ready():
	if Global.DEV_MODE:
		load_scene(first_chapter)
	else:
		load_scene(logoscreen)


func load_scene(scene):
	if get_child_count() > 0:
		for i in get_children():
			remove_child(i)
			i.queue_free()
			
	# Load the next room and the ui node.
	var next_scene = ResourceLoader.load(scene)

	# Instance the next room and the ui node.
	var current_scene = next_scene.instance()
	
	add_child(current_scene)
