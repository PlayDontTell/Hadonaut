extends Sprite


export var speed_x = -0.1
export var speed_y = 0


# Function to set all the parameters of the sprite
func _ready():
	# SETTINGS
	speed_x = -0.5
	speed_y = 0
	# region_enabled
	region_enabled = true
	# region_rect
	var screen_size = get_viewport().get_visible_rect().size
	region_rect = Rect2(
		0,
		0,
		ceil(screen_size.x) + texture.get_width() * 2,
		ceil(screen_size.y) + texture.get_height() * 2
	)
	# centered
	centered = false
	# position
	position -= texture.get_size()
	

# Function to move the sprite each frame according to the speed parameters.
func _physics_process(_delta):
	
	var current_position = position
	
	current_position.x = current_position.x + speed_x
	current_position.y = current_position.y + speed_y
	
	if current_position.x < 0 - texture.get_width() * 2 or current_position.x > 0:
		current_position.x = 0 - texture.get_width()
	
	if current_position.y < 0 - texture.get_height() * 2 or current_position.y > 0:
		current_position.y = 0 - texture.get_height()
	
	position = current_position
