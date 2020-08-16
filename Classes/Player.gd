extends "res://Classes/Renderable2.gd"

export var tile_row : int = 0 setget set_tile_row
export var tile_col : int = 0 setget set_tile_col

var last_key_press = 0
var debounce_millis = 80

tool

func _input(ev):
  if ev is InputEventKey and ev.is_pressed() and not ev.echo:
    match (ev.scancode):
      KEY_W:
        try_move(Vector2(0, -1))
        return
      KEY_A:
        try_move(Vector2(-1, 0))
        return
      KEY_S:
        try_move(Vector2(0, 1))
        return
      KEY_D:
        try_move(Vector2(1, 0))
        return

func can_move(move_vector):
  return true

func try_move(move_vector):
  var now = OS.get_ticks_msec()
  if last_key_press + debounce_millis > now:
    return
  last_key_press = now
  if can_move(move_vector):
    do_move(move_vector)
    
func set_tile_col(col):
  tile_col = col
  position.x = 16 * tile_col
  
func set_tile_row(row):
  tile_row = row
  position.y = 16 * tile_row

func do_move(move_vector):
  if move_vector.x != 0:
    set_tile_col(tile_col + move_vector.x)
  elif move_vector.y != 0:
    set_tile_row(tile_row + move_vector.y)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
