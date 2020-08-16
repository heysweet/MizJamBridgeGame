extends "res://Classes/Movable.gd"

var last_key_press = 0
var debounce_millis = 80

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

func do_move(move_vector):
  .do_move(move_vector)
  emit_signal("time_step")

# Called when the node enters the scene tree for the first time.
func _ready():
  target_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  position.x = target_position.x
#  Tween
