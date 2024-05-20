extends VBoxContainer

var grid_cell_count = 10
var mines_count = 10
var mines_field = []
var grid_cell_size = 32

var grid_size = Vector2.ZERO
var cell_size = Vector2(16,16)
var stretch = TextureButton.STRETCH_SCALE
var mine_flag = preload("res://custom_button/minesweeper_flag.svg")

enum Tool { SHOVEL, FLAG }
var current_tool = Tool.SHOVEL

func _init():
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	get_sizes()
	create_label()
	create_toolbar()
	fill_grid_container()
	place_mines()
	pass # Replace with function body.

func create_toolbar():
	var toolbar = HBoxContainer.new()
	toolbar.alignment = BoxContainer.ALIGNMENT_CENTER
	var shovel_button = Button.new()
	shovel_button.text = "Shovel"
	shovel_button.connect("pressed", Callable(self, "_on_shovel_button_pressed"))
	toolbar.add_child(shovel_button)
	
	var flag_button = Button.new()
	flag_button.text = "Flag"
	flag_button.connect("pressed", Callable(self, "_on_flag_button_pressed"))
	toolbar.add_child(flag_button)
	
	var label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.text = "Mines left: %d" % [mines_count]
	label.visible = false
	toolbar.add_child(label)
	
	add_child(toolbar)

func _on_shovel_button_pressed():
	current_tool = Tool.SHOVEL

func _on_flag_button_pressed():
	current_tool = Tool.FLAG
	
func get_sizes():
	var screen_size = get_viewport().get_visible_rect().size
	# вычисляем размер клетки +1 (для отступа от края)
	grid_cell_size = screen_size.x / (grid_cell_count + 1)
	print(grid_cell_size)
	grid_size = Vector2(grid_cell_count, grid_cell_count)
	cell_size = Vector2(grid_cell_size, grid_cell_size)
	
	
func create_label():
	pass

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
	#var cell_button = mines_field[y][x]
	#cell_button.texture_disabled = mine_flag
	#cell_button.disabled = true
	#cell_button.add_overlay()
	print("clicked!")
	if current_tool == Tool.SHOVEL:
		handle_shovel_click(x, y)
	elif current_tool == Tool.FLAG:
		handle_flag_click(x, y)
		
		
func handle_shovel_click(x, y):
	var cell_button = mines_field[y][x]
	if cell_button.disabled: # already revealed
		return
	if cell_button.is_mine:
		print("ITS MINE! BOOM!")
		reveal_all_mines()
		game_over()
	else:
		var adjacent_mines = count_adjacent_mines(x, y)
		print(adjacent_mines)
		cell_button.disabled = true
		#cell_button.texture_normal = numbers_textures[adjacent_mines]
		if adjacent_mines == 0:
			reveal_empty_neighbors(x, y)

func handle_flag_click(x, y):
	var cell_button = mines_field[y][x]
	if cell_button.disabled: # already revealed
		return
	cell_button.texture_normal = mine_flag

func reveal_all_mines():
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			var cell_button = mines_field[y][x]
			if cell_button.is_mine:
				print("mine %d %d" % [x,y])
				#cell_button.texture_normal = mine_texture
				pass

func game_over():
	print("Game Over")
	# Implement game over logic here

func count_adjacent_mines(x, y):
	var count = 0
	for i in range(-1, 2):
		for j in range(-1, 2):
			if i == 0 and j == 0:
				continue
			var nx = x + i
			var ny = y + j
			if nx >= 0 and nx < grid_size.x and ny >= 0 and ny < grid_size.y:
				if mines_field[ny][nx].is_mine:
					count += 1
	return count

func reveal_empty_neighbors(x, y):
	for i in range(-1, 2):
		for j in range(-1, 2):
			var nx = x + i
			var ny = y + j
			if nx >= 0 and nx < grid_size.x and ny >= 0 and ny < grid_size.y:
				var cell_button = mines_field[ny][nx]
				if not cell_button.disabled and not cell_button.is_mine:
					handle_shovel_click(nx, ny)

func place_mines():
	randomize()
	var placed_mines = 0
	while placed_mines < mines_count:
		var x = randi_range(0,9) # % grid_size.x
		var y = randi_range(0,9) #rand() % grid_size.y
		var cell_button = mines_field[y][x]
		print(x,y)
		if not cell_button.is_mine:
			cell_button.is_mine = true
			placed_mines += 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	#print(delta)
#	pass
