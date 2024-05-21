extends VBoxContainer

var grid_cell_count = 10
var mines_count = 20
var mines_field = []
var grid_cell_size = 32

var grid_size = Vector2.ZERO
var cell_size = Vector2(16, 16)
var stretch = TextureButton.STRETCH_SCALE
var mine_flag = preload("res://custom_button/flag_button.svg")
var mine_button = preload("res://custom_button/mine_button.svg")

var numbers_textures = [
	preload("res://custom_button/disable_button.svg"),
	preload("res://custom_button/1.png"),
	preload("res://custom_button/2.png"),
	preload("res://custom_button/3.png"),
	preload("res://custom_button/4.png"),
	preload("res://custom_button/5.png"),
	preload("res://custom_button/6.png"),
	preload("res://custom_button/7.png"),
	preload("res://custom_button/8.png")
]

enum Tool { SHOVEL, FLAG }
var current_tool = Tool.SHOVEL
var game_over_flag = false
var restart_button = Button.new()
var toolbar = HBoxContainer.new()
var flags_left_label = Label.new()
var flags_left = mines_count

func _init():
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	get_sizes()
	create_toolbar()
	create_restart_button()
	fill_grid_container()
	place_mines()
	pass

func create_restart_button():
	restart_button.text = "Restart"
	restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	restart_button.visible = false
	add_child(restart_button)

func _on_restart_button_pressed():
	restart_game()
	
func create_toolbar():
	toolbar.alignment = BoxContainer.ALIGNMENT_CENTER
	var shovel_button = Button.new()
	shovel_button.text = "Shovel"
	shovel_button.connect("pressed", Callable(self, "_on_shovel_button_pressed"))
	toolbar.add_child(shovel_button)
	
	var flag_button = Button.new()
	flag_button.text = "Flag"
	flag_button.connect("pressed", Callable(self, "_on_flag_button_pressed"))
	toolbar.add_child(flag_button)
	
	flags_left_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	flags_left_label.text = "Flags left: %d" % [flags_left]
	toolbar.add_child(flags_left_label)
	
	add_child(toolbar)

func _on_shovel_button_pressed():
	current_tool = Tool.SHOVEL

func _on_flag_button_pressed():
	current_tool = Tool.FLAG
	
func get_sizes():
	var screen_size = get_viewport().get_visible_rect().size
	grid_cell_size = screen_size.x / (grid_cell_count + 1)
	grid_size = Vector2(grid_cell_count, grid_cell_count)
	cell_size = Vector2(grid_cell_size, grid_cell_size)

func fill_grid_container():
	var grid_container = GridContainer.new()
	grid_container.columns = grid_cell_count
	grid_container.add_theme_constant_override("h_separation", 0)
	grid_container.add_theme_constant_override("v_separation", 0)
	add_child(grid_container)
	for y in range(grid_size.y):
		mines_field.append([])
		for x in range(grid_size.x):
			var cell_button = SquareButton.new(cell_size, stretch, x, y)
			grid_container.add_child(cell_button)
			cell_button.connect("pressed", func(): _on_button_pressed(x, y))
			mines_field[y].append(cell_button)

func _on_button_pressed(x, y):
	if game_over_flag:
		return
	if current_tool == Tool.SHOVEL:
		handle_shovel_click(x, y)
	elif current_tool == Tool.FLAG:
		handle_flag_click(x, y)

func handle_shovel_click(x, y):
	var cell_button = mines_field[y][x]
	if cell_button.disabled: # already revealed
		return
	if cell_button.is_mine:
		reveal_all_mines()
		game_over()
	else:
		reveal_cell(x, y)
		check_for_win()

func reveal_cell(x, y):
	var cell_button = mines_field[y][x]
	if cell_button.disabled:
		return
	var adjacent_mines = count_adjacent_mines(x, y)
	cell_button.disabled = true
	cell_button.texture_disabled = numbers_textures[adjacent_mines]
	if adjacent_mines == 0:
		for i in range(-1, 2):
			for j in range(-1, 2):
				var nx = x + i
				var ny = y + j
				if nx >= 0 and nx < grid_size.x and ny >= 0 and ny < grid_size.y:
					if not mines_field[ny][nx].disabled:
						reveal_cell(nx, ny)
						
func handle_flag_click(x, y):
	var cell_button = mines_field[y][x]
	if cell_button.disabled: # already revealed
		return
	if cell_button.texture_normal == mine_flag:
		cell_button.texture_normal = null
		flags_left += 1
	else:
		cell_button.texture_normal = mine_flag
		flags_left -= 1
	flags_left_label.text = "Flags left: %d" % [flags_left]
	check_for_win()

func reveal_all_mines():
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			var cell_button = mines_field[y][x]
			if cell_button.is_mine:
				cell_button.texture_normal = mine_button

func game_over():
	print("Game Over")
	game_over_flag = true
	restart_button.visible = true
	toolbar.visible = false

func restart_game():
	for child in get_children():
		if not (child is HBoxContainer or child is Button):
			remove_child(child)
	mines_field.clear()
	game_over_flag = false
	flags_left = mines_count
	flags_left_label.text = "Flags left: %d" % [flags_left]
	fill_grid_container()
	place_mines()
	restart_button.visible = false
	toolbar.visible = true
	print("Game restarted")
	
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
		var x = randi_range(0, grid_cell_count - 1)
		var y = randi_range(0, grid_cell_count - 1)
		var cell_button = mines_field[y][x]
		if not cell_button.is_mine:
			cell_button.is_mine = true
			placed_mines += 1

func check_for_win():
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			var cell_button = mines_field[y][x]
			if cell_button.is_mine and cell_button.texture_normal != mine_flag:
				return
			if not cell_button.is_mine and not cell_button.disabled:
				return
	print("Congratulations! You win!")
	restart_button.visible = true
	game_over_flag = true
