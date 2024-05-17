extends Node2D

const DEBUG = 1
@onready var window_size = $window_size

# Called when the node enters the scene tree for the first time.
func _ready():
	window_size.visible = DEBUG == 1
	update_windows_size_label()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_windows_size_label()
	pass

func update_windows_size_label():
	var screen_size = get_viewport().get_visible_rect().size
	window_size.text = "Screen Size: Width = %d, Height = %d" % [screen_size.x, screen_size.y]
