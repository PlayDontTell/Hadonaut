extends Node2D


onready var current_chapter = get_node("..")
onready var hud = current_chapter.hud
onready var inventory = hud.inventory


func _ready():
	$BackZone.to_room = Global.last_room_name
	initialize_light()


func initialize_light():
	if current_chapter.ship_power == "day":
		pass
	$AnimationPlayer.play(current_chapter.ship_power)
