extends "res://Classes/Movable.gd"

var last_key_press = 0
var debounce_millis = 80
var queued_move = null

signal time_step

tool

func queue_move(movement : Vector2):
  var now = OS.get_ticks_msec()
  if last_key_press + debounce_millis > now:
    return
  last_key_press = now
  #queued_move = movement
  try_move(movement)

func _input(ev):
  if ev is InputEventKey and ev.is_pressed() and not ev.echo:
    match (ev.scancode):
      KEY_W,KEY_UP:
        queue_move(Vector2(0, -1))
        return
      KEY_A,KEY_LEFT:
        queue_move(Vector2(-1, 0))
        return
      KEY_S,KEY_DOWN:
        queue_move(Vector2(0, 1))
        return
      KEY_D,KEY_RIGHT:
        queue_move(Vector2(1, 0))
        return
      KEY_SPACE:
        try_interact()
        return

func can_move(move_vector):
  var offset = move_vector * 16;
  return !move_and_collide(offset, true, true, true)

func try_move(move_vector):
  if can_move(move_vector):
    do_move(move_vector)
    
func try_interact():
  emit_signal("bridge_destroyed")
  emit_signal("time_step")

func do_move(move_vector):
  .do_move(move_vector)
  emit_signal("time_step")

# Called when the node enters the scene tree for the first time.
func _ready():
  target_position = position

"""func _physics_process(time):
  if queued_move != null:
    var move = queued_move
    queued_move = null
    try_move(move)"""

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  position.x = target_position.x
#  Tween
