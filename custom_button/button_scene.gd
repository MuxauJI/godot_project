extends VBoxContainer

var grid_cell_count = 10
var mines_count = 10
var mines_field = []
var grid_cell_size = 0
var grid_size = Vector2.ZERO
var cell_size = Vector2.ZERO
var stretch = TextureButton.STRETCH_SCALE

func _init():
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	get_sizes()
	create_label()
	fill_grid_container()
	pass # Replace with function body.
	
func get_sizes():
	var screen_size = get_viewport().get_visible_rect().size
	grid_cell_size = screen_size.x / grid_cell_count - 10
	grid_size = Vector2(grid_cell_count, grid_cell_count)
	cell_size = Vector2(grid_cell_size, grid_cell_size)
	
	
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
		mines_field.append([])
		for x in range(grid_size.x):
			var cell_button = SquareButton.new(cell_size, stretch, x, y)
			grid_container.add_child(cell_button)
			# привязка сигнала к лямбда-функции с передачей параметров
			cell_button.connect("pressed", func(): _on_button_pressed(x,y))
			mines_field[y].append(cell_button)

func _on_button_pressed(x,y):
	#print("Button %d %d" % [x,y])
	var cell_button = mines_field[y][x]
	cell_button.disabled = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
