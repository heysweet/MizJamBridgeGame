extends "res://Classes/Movable.gd"
enum Direction {LEFT = 0, UP, RIGHT, DOWN}
var last_key_press = 0
var debounce_millis = 120
var is_controllable = true
var swipe_start
var long_press_timer
var first_tap_time = 0
var num_presses = 0

const double_tap_duration = 240
const TYPE_BRIDGE = 6
const TYPE_EXIT_ARROW = 7
const ENABLE_DEBUG_POSITION = true
const SENSITIVITY = 20
const LONG_PRESS = 0.5

signal time_step
signal bridge_destroy
signal level_exit
signal double_tap

tool

func set_controllable(controllable):
  is_controllable = controllable

func needs_debounce():
  var now = OS.get_ticks_msec()
  var needs_debounce = (last_key_press + debounce_millis) > now
  if (!needs_debounce):
    last_key_press = now
  return needs_debounce

func queue_move(movement : Vector2):
  if needs_debounce():
    return
  try_move(movement)

func _input(ev):
  if is_controllable:
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
    elif ev is InputEventScreenTouch:
      if ev.is_pressed():
        if (OS.get_ticks_msec() - first_tap_time) > (2*double_tap_duration) or (num_presses > 2):
          num_presses = 0
          first_tap_time = 0
        if first_tap_time == 0 and num_presses < 1:
          num_presses = 1
          first_tap_time = OS.get_ticks_msec()
        elif num_presses == 2 and (double_tap_duration + first_tap_time > OS.get_ticks_msec()):
          num_presses = 0
          emit_signal("double_tap")
        swipe_start = ev.position
        long_press_timer = Timer.new()
        long_press_timer.set_wait_time(LONG_PRESS)
        long_press_timer.set_one_shot(true)
        long_press_timer.connect("timeout", self, "_on_long_press_timer_timeout")
        add_child(long_press_timer)
        long_press_timer.start()
      else:
        num_presses = 2
        long_press_timer.stop()
        long_press_timer.queue_free()
        var dir = calc_swipe(ev.position)
        match dir:
          Direction.DOWN:
            num_presses = 0
            queue_move(Vector2(0, -1))
            return
          Direction.RIGHT:
            num_presses = 0
            queue_move(Vector2(-1, 0))
            return
          Direction.UP:
            num_presses = 0
            queue_move(Vector2(0, 1))
            return
          Direction.LEFT:
            num_presses = 0
            queue_move(Vector2(1, 0))
            return
    elif ENABLE_DEBUG_POSITION and ev is InputEventMouseButton:
      var cameraOffset = Vector2(16, 16)
      print("Mouse Click/Unclick at: ", ev.position + cameraOffset)

func calc_swipe(position):
  var delt = swipe_start - position
  if abs(delt.x) > abs(delt.y):
    if abs(delt.x) < SENSITIVITY:
      return
    if delt.x > 0:
      return Direction.LEFT
    return Direction.RIGHT
  else:
    if abs(delt.y) < SENSITIVITY:
      return
    if delt.y > 0:
      return Direction.UP
    return Direction.DOWN

func get_tile_id(collider, direction):
  var tilemap = collider
  var hit_pos = $RayCast2D.get_collision_point()
  var tile_pos = tilemap.world_to_map(hit_pos + direction)
  var tile = tilemap.get_cellv(tile_pos)
  # print("TileId: ", tile)
  return tile

func is_movement_on_tile_allowed(collision, direction):
  var tile_id = get_tile_id(collision, direction)
  match (tile_id):
    -1: # No tile detected
      true
    TYPE_BRIDGE:
      return true
    TYPE_EXIT_ARROW:
      emit_signal("level_exit")
      return true
  return false
  
func can_move(move_vector):
  var offset = move_vector * 16;
  var end_state = target_position + offset
  if end_state.x < 0 || end_state.y < 0:
    return false
  var collision = get_collision(offset)
  if collision != null and collision is TileMap:
    if is_movement_on_tile_allowed(collision, move_vector):
      return true
    return false
  return true

func try_move(move_vector):
  if can_move(move_vector):
    do_move(move_vector)
    $SoundMove.play()
  else:
    $SoundFailMove.play()
    
func destroy_bridge(map_collider):
  var tile_pos = map_collider.world_to_map(target_position)
  map_collider.set_cell(
    tile_pos.x,
    tile_pos.y,
    6, # tile
    false, # flip_x
    false, # flip_y
    false, # transpose
    Vector2(4, 0))# autotile_coord
  map_collider.update_dirty_quadrants()
  emit_signal("bridge_destroy", tile_pos)
  emit_signal("time_step")
  $CPUParticles2D.restart()
  $SoundDestroyBridge.play()
    
func get_collision(delta : Vector2):
  var raycast = $RayCast2D
  raycast.set_cast_to(delta);
  raycast.force_raycast_update()
  return raycast.get_collider()
    
func try_interact():
  if needs_debounce():
    return
  var collision = get_collision(Vector2(8, 8))
  if collision != null and collision is TileMap:
    if get_tile_id(collision, Vector2.ZERO) == TYPE_BRIDGE:
      destroy_bridge(collision)

func do_move(move_vector):
  .do_move(move_vector)
  emit_signal("time_step")
  
func _on_long_press_timer_timeout():
  try_interact()

# Called when the node enters the scene tree for the first time.
func _ready():
  target_position = position
