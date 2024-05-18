extends Node2D

var window_size = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().connect("size_changed", Callable(self, "_on_size_changed"))
	_on_size_changed()
	pass # Replace with function body.

func _on_size_changed():
	# Получаем размеры окна
	window_size = get_viewport().size
	#self.scale = window_size
	print("x=%d y=%d" % [window_size.x, window_size.y])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
