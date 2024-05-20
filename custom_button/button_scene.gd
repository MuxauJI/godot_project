extends VBoxContainer

var grid_cell_count = 20
var mines_count = 10
var mines_field = []
var grid_cell_size = 32

var grid_size = Vector2.ZERO
var cell_size = Vector2(16,16)
var stretch = TextureButton.STRETCH_SCALE
var mine_flag = preload("res://custom_button/minesweeper_flag.svg")

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
	# вычисляем размер клетки +1 (для отступа от края)
	grid_cell_size = screen_size.x / (grid_cell_count + 1)
	print(grid_cell_size)
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
	# Настройка отступов для удаления зазоров
	grid_container.add_theme_constant_override("h_separation", 0)
	grid_container.add_theme_constant_override("v_separation", 0)	
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
	#cell_button.texture_disabled = mine_flag
	cell_button.disabled = true
	cell_button.add_overlay()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	#print(delta)
#	pass
