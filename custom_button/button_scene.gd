extends VBoxContainer

const grid_cell_count = 13
const grid_cell_size = 32
var mines_count = 10
var grid_size = Vector2(grid_cell_count, grid_cell_count)
var cell_size = Vector2(grid_cell_size, grid_cell_size)
var stretch = TextureButton.STRETCH_SCALE
# Called when the node enters the scene tree for the first time.
func _ready():
	create_label()
	fill_grid_container()
	pass # Replace with function body.

func create_label():
	var label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.text = "Mines left: %d" % [mines_count]
	add_child(label)

func fill_grid_container():
	var grid_container = GridContainer.new()
	grid_container.columns = grid_cell_count
	add_child(grid_container)
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			var cell_button = SquareButton.new(cell_size, stretch)
			grid_container.add_child(cell_button)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
