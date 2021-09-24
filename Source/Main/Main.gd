extends Node2D

onready var tile_map: TileMap = $TileMap
onready var bottom_block: KinematicBody2D = $BottomBlock

const STRAIGHT: = [Vector2(-2, 0), Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)]
const SQUARE: = [Vector2(-1, -1), Vector2(-1, 0), Vector2(0, -1), Vector2(0, 0)]
const T: = [Vector2(-1, 0), Vector2(0, -1), Vector2(0, 0), Vector2(1, 0)]
const L: = [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(1, -1)]
const SKEW: = [Vector2(-1, -1), Vector2(0, -1), Vector2(0, 0), Vector2(1, 0)]

const LEFT_MARGIN: int = 14
const RIGHT_MARGIN: int = 26
const BOTTOM_MARGIN: int = 22


var blocks: = [STRAIGHT, SQUARE, T, L, SKEW]

var current_block: int = -1
var current_position: Vector2
var previous_position: Vector2

func _ready():
	randomize()
	current_block = create_tetromino()

func update_bottom_block():
	bottom_block.position = current_position * 32
	bottom_block.position.x += 16
	bottom_block.position.y += 16

func move_down():
	current_position.y += 1 if current_position.y + 1 < BOTTOM_MARGIN else 0
	update_bottom_block()
func move_left():
	current_position.x -= 1 if current_position.x + get_leftmost_block_position().x - 1 > LEFT_MARGIN else 0
	update_bottom_block()
func move_right():
	current_position.x += 1 if current_position.x + get_rightmost_block_position().x + 1 < RIGHT_MARGIN else 0
	update_bottom_block()
func rotate_clockwise():
	pass
func rotate_counter_clockwise():
	pass

func handle_input() -> void:
	if Input.is_action_just_pressed("move_down"):
		move_down()
	if Input.is_action_just_pressed("move_left"):
		move_left()
	if Input.is_action_just_pressed("move_right"):
		move_right()
	if Input.is_action_just_pressed("rotate_clockwise"):
		rotate_clockwise()
	if Input.is_action_just_pressed("rotate_counter_clockwise"):
		rotate_counter_clockwise()
	

func create_tetromino() -> int:
	current_position = Vector2(19, -1)
	update_bottom_block()
	return int(rand_range(0, 5))

func get_leftmost_block_position() -> Vector2:
	var current_shape = blocks[current_block]
	return current_shape[0]
func get_rightmost_block_position() -> Vector2:
	var current_shape = blocks[current_block]
	return current_shape[current_shape.size() - 1]

func remove_block(position: Vector2, index: int) -> void:
	for block in blocks[index]:
		tile_map.set_cell(position.x + block.x, position.y + block.y, -1)

func place_block(position: Vector2, index: int) -> void:
	for block in blocks[index]:
		tile_map.set_cell(position.x + block.x, position.y + block.y, 0)

func _on_Timer_timeout() -> void:
	print(tile_map)
	print(bottom_block.test_move(Transform2D(), Vector2(0, 32+32)))
	move_down()

func _physics_process(_delta: float) -> void:
	if current_block == -1:
		current_block = create_tetromino()
	
	handle_input()
	
	remove_block(previous_position, current_block)
	place_block(current_position, current_block)
	previous_position = current_position
	
