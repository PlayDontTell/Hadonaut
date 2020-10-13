extends Sprite


onready var menu = get_node("../..")
var mouse_in_windowtab: bool = false


func _on_NoButton_mouse_entered():
	menu.get_node("MenuScroll").play()


func _on_NoButton_pressed():
	menu.get_node("MenuClick").play()


func _on_YesButton_mouse_entered():
	menu.get_node("MenuScroll").play()


func _on_YesButton_pressed():
	menu.get_node("MenuClick").play()
	get_tree().quit()


func _on_InWindowTab_mouse_exited():
	mouse_in_windowtab = false


func _on_InWindowTab_mouse_entered():
	mouse_in_windowtab = true
