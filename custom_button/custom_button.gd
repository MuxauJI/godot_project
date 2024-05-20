extends TextureButton

class_name SquareButton

var texture_white = preload("res://custom_button/clear_button32.svg")
var pressed_button = preload("res://custom_button/disable_button.svg")
var flag_button = preload("res://custom_button/flag_button.svg")
var x : int
var y : int
var is_mine : bool = false

func _init(default_size, stretch, xx, yy):
	custom_minimum_size = default_size
	stretch_mode = stretch
	ignore_texture_size = true
	x = xx
	y = yy
	#print("x = %d, y = %d" % [x,y])
	
func _ready():
	texture_normal = texture_white
	texture_pressed = pressed_button
	texture_disabled = pressed_button

func add_overlay():
	pass
