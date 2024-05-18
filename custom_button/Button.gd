extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_minimum_size())
	custom_minimum_size = Vector2(200,200)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
