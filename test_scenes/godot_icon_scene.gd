extends Sprite2D

var DEBUG = 0
var speed = 400
var angular_speed = PI

func _init():
	if DEBUG == 1:
		print("Godot Icon Scene demonstration")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	var direction_rotation = 0

	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		direction_rotation = -1
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		direction_rotation = 1
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		velocity = Vector2.UP.rotated(rotation) * speed
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		velocity = Vector2.DOWN.rotated(rotation) * speed
	# для предотвращени переполнения необходимо по достижении 2pi сбрасывать в 0
	# rotation = fmod(rotation + angular_speed * delta, PI * 2)
	
	# вращение	
	rotation = fmod(rotation + angular_speed * delta * direction_rotation, PI * 2)
	# перемещение
	position += velocity * delta
	
	if DEBUG == 1:
		print("Position: [%d, %d], Rotation: %d" % [position.x, position.y, rotation_degrees])
	pass
