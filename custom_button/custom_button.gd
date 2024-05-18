extends TextureButton

class_name SquareButton

var texture_white = preload("res://custom_button/white_button.png")
var texture_grey = preload("res://custom_button/grey_button.png")
var stretch = TextureButton.STRETCH_SCALE
var default_size = Vector2(32,32)

func _init(default_size, stretch):
	custom_minimum_size = default_size
	stretch_mode = stretch
	
func _ready():
	texture_normal = texture_white
	texture_pressed = texture_grey
	
