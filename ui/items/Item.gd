extends TextureButton


var spawn_duration: float
var distance_from_spawn

onready var item_name: String
onready var item_id: int = GlobalInventory.char_inventory.find(item_name)
onready var item_default_position: Vector2 = Vector2(112 + 32 * item_id,236)
onready var item_spawn_position: Vector2
onready var inventory_node = get_node("../..")
onready var items = get_node("..")


func _ready():
	$ItemHover.visible = false
	$ItemTexture.visible = true
	rect_position = item_default_position
	$ItemShade/ItemAnimation.play(item_name)
	$ItemTexture/ItemAnimation.play(item_name)
	
	if not item_spawn_position == Vector2(0, 0):
		
		distance_from_spawn = item_default_position.distance_to(item_spawn_position)
		spawn_duration =  sqrt(distance_from_spawn) / 16
		
		# When first created, the item slides in the inventory.
		$Tween.interpolate_property($ItemTexture, "position"
		, item_spawn_position - item_default_position - Vector2(16 , 16),
		Vector2(0, 0), spawn_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		inventory_node.item_spawn_positions[item_name] = Vector2(0, 0)
		# When first created, the item slowly appears.
		$Tween.interpolate_property($ItemTexture, "modulate"
		, Color(1,1,1,0), Color(1,1,1,1), 
		spawn_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.interpolate_property($ItemShade, "modulate"
		, Color(0,0,0,0), Color(0,0,0,1), 
		spawn_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
		
		$ItemTexture.z_index = +32
		yield(get_tree().create_timer(spawn_duration), "timeout")
		$ItemTexture.z_index = 0
		
		$Tween.interpolate_property($ItemTexture, "modulate"
		, $ItemTexture.modulate, Color(0.7,0.7,0.7), 
		0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()


func _on_Item_mouse_entered():
	$ItemHover.visible = true
	$ItemTexture.modulate = Color(1,1,1)
	Global.mouse_hovering_count += 1
	Global.force_hand_cursor = true
	Global.mouse_hovering_inventory = true
	GlobalInventory.item_hovered = item_name


func _on_Item_mouse_exited():
	$ItemHover.visible = false
	if not GlobalInventory.item_used == item_name:
		$ItemTexture.modulate = Color(0.7,0.7,0.7)
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1
		Global.force_hand_cursor = false
		Global.mouse_hovering_inventory = false
		GlobalInventory.item_hovered = ""


func draw_item():
	$Tween.stop($ItemTexture, "modulate")
	$ItemTexture.modulate = Color(0.7,0.7,0.7)
	$Tween.stop($ItemTexture, "position")
	$ItemTexture.position = Vector2(0, 0)
	$Tween.stop($ItemShade, "modulate")
	$ItemTexture.modulate = Color(0,0,0,1)
	GlobalInventory.is_using_item = true
	GlobalInventory.item_used = item_name
	$ItemTexture.z_index = +32
	$ItemTexture.modulate = Color(1,1,1)
	if item_name in ["cryopod_trap_key"]:
		$Sounds/Keys.play()
	if item_name in ["screwdriver"]:
		$Sounds/Tool.play()
	if item_name in ["map_module"]:
		$Sounds/PadModule.play()
	
	print("Char is using " + item_name)


func holster_item():
	GlobalInventory.is_using_item = false
	GlobalInventory.item_used = ""
	yield(get_tree(), "idle_frame")
	$ItemTexture.position = Vector2(0,0)
	$ItemTexture.z_index = 0
	$ItemTexture.modulate = Color(0.7,0.7,0.7)
	print("Char not using " + item_name)
	inventory_node.get_node("BagSound").play()


func _input(event):
	var specific_offset: Vector2
	if not Global.mouse_hovering_inventory and GlobalInventory.item_used in ["screwdriver"]:
		specific_offset = Vector2(-31, -28)
		
	if event is InputEventMouseMotion:
		if GlobalInventory.item_used == item_name:
			$ItemTexture.position = event.position - item_default_position + specific_offset
