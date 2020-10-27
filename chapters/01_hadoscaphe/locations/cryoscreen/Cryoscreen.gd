extends Node2D


onready var current_chapter = get_node("..")
onready var inventory = get_node("../UI/Inventory")


func _ready():
	initialize_light()


func initialize_light():
	$AnimationPlayer.play(current_chapter.ship_power)
	$ButtonDown.initialize_light()
	$ButtonOk.initialize_light()
	$ButtonUp.initialize_light()
	$PowerButton.initialize_light()
