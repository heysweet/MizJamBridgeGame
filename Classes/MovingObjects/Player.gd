extends "res://Classes/Movable.gd"

var last_key_press = 0
var debounce_millis = 70
var is_controllable = true

const TYPE_BRIDGE_MOV = 6
const TYPE_EXIT_ARROW = 7
const TYPE_BRIDGE_ATK = -1

signal time_step
signal bridge_destroy
signal level_exit

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
  if is_controllable and ev is InputEventKey and ev.is_pressed() and not ev.echo:
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

func get_tile_id(collision):
  # Find the character's position in tile coordinates
  var tile_pos = collision.collider.world_to_map(position)
  # Find the colliding tile position
  tile_pos -= collision.normal
  # Get the tile id
  return collision.collider.get_cellv(tile_pos)

func is_movement_on_tile_allowed(collision):
  var tile_id = get_tile_id(collision)
  match (tile_id):
    TYPE_BRIDGE_MOV:
      return true
    TYPE_EXIT_ARROW:
      emit_signal("level_exit")
      return true
  return false
  
func can_move(move_vector):
  var offset = move_vector * 16;
  var end_state = position + offset
  if end_state.x < 0 || end_state.y < 0:
    return false
  var collision = move_and_collide(offset, true, true, true)
  if collision and collision.collider is TileMap:
    if is_movement_on_tile_allowed(collision):
      return true
    return false
  return true

func try_move(move_vector):
  if can_move(move_vector):
    do_move(move_vector)
    
func destroy_bridge(collision):
  var tile_pos = collision.collider.world_to_map(target_position)
  collision.collider.set_cell(
    tile_pos.x,
    tile_pos.y,
    6, # tile
    false, # flip_x
    false, # flip_y
    false, # transpose
    Vector2(4, 0))# autotile_coord
  collision.collider.update_dirty_quadrants()
  emit_signal("bridge_destroy")
  emit_signal("time_step")
    
func try_interact():
  if needs_debounce():
    return
  var collision = move_and_collide(Vector2.ZERO, true, true, true)
  if collision and collision.collider is TileMap:
    if get_tile_id(collision) == TYPE_BRIDGE_ATK:
      destroy_bridge(collision)

func do_move(move_vector):
  .do_move(move_vector)
  emit_signal("time_step")

# Called when the node enters the scene tree for the first time.
func _ready():
  target_position = position
