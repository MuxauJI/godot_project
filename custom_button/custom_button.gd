extends TextureButton

class_name SquareButton

var texture_white = preload("res://custom_button/clear_button32.svg")
var pressed_button = preload("res://custom_button/disable_button.svg")
var flag_button = preload("res://custom_button/flag_button.svg")
var stretch = TextureButton.STRETCH_SCALE
var default_size = Vector2(32,32)
var x: int = 0
var y: int = 0

func _init(default_size, stretch, x, y):
	custom_minimum_size = default_size
	stretch_mode = stretch
	self.x = x
	self.y = y
	#print("x = %d, y = %d" % [x,y])
	
func _ready():
	texture_normal = texture_white
	texture_pressed = pressed_button
	texture_disabled = flag_button

func add_overlay():
	pass
