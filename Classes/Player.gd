extends "res://Classes/Renderable2.gd"

export var tile_row : int = 0 setget set_tile_row
export var tile_col : int = 0 setget set_tile_col

var last_key_press = 0
var debounce_millis = 80
var target_position = Vector2()
var movement_tween : Tween

signal time_step

tool

func _input(ev):
  if ev is InputEventKey and ev.is_pressed() and not ev.echo:
    match (ev.scancode):
      KEY_W,KEY_UP:
        try_move(Vector2(0, -1))
        return
      KEY_A,KEY_LEFT:
        try_move(Vector2(-1, 0))
        return
      KEY_S,KEY_DOWN:
        try_move(Vector2(0, 1))
        return
      KEY_D,KEY_RIGHT:
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
  target_position.x = 16 * tile_col
  if Engine.editor_hint:
    position = target_position
  
func set_tile_row(row):
  tile_row = row
  target_position.y = 16 * tile_row
  if Engine.editor_hint:
    position = target_position

func update_tween(move_vector : Vector2):
  var tween = $Tween
  tween.interpolate_property(self, "position",
          position, target_position, 0.130,
          Tween.EASE_IN_OUT, Tween.EASE_IN_OUT)
  tween.interpolate_property(self, "rotation", 0.15 * -move_vector.x, 0, 0.400, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
  tween.interpolate_property(self, "scale", Vector2(1.1, 1.1), Vector2(1, 1), 0.300, Tween.TRANS_BACK, Tween.EASE_OUT)
  tween.start()

func do_move(move_vector):
  if move_vector.x == 0 and move_vector.y == 0:
    return
  if move_vector.x != 0:
    set_tile_col(tile_col + move_vector.x)
  else:
    set_tile_row(tile_row + move_vector.y)
  emit_signal("time_step")
  update_tween(move_vector)

# Called when the node enters the scene tree for the first time.
func _ready():
  target_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  position.x = target_position.x
#  Tween
