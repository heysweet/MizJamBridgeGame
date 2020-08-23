extends "res://Classes/Movable.gd"

var last_key_press = 0
var debounce_millis = 120
var is_controllable = true

const TYPE_BRIDGE = 6
const TYPE_EXIT_ARROW = 7
const ENABLE_DEBUG_POSITION = true

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
  elif ENABLE_DEBUG_POSITION and ev is InputEventMouseButton:
    var cameraOffset = Vector2(16, 16)
    print("Mouse Click/Unclick at: ", ev.position + cameraOffset)

func get_tile_id(collider):
  var tilemap = collider
  var hit_pos = $RayCast2D.get_collision_point()
  var tile_pos = tilemap.world_to_map(hit_pos)
  var tile = tilemap.get_cellv(tile_pos)
  print (tile)
  return tile
  
  #var cell_position = target_position + offset
  #print("target: ", target_position)
  #print("position: ", position)
  #var tile_id = collision.get_cell(cell_position.x, cell_position.y)
  #print(tile_id)
  #return tile_id

func is_movement_on_tile_allowed(collision):
  var tile_id = get_tile_id(collision)
  print(tile_id)
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
    if is_movement_on_tile_allowed(collision):
      print("ALLOWED")
      return true
    print("DISALLOWED")
    return false
  print("N/A")
  return true

func try_move(move_vector):
  if can_move(move_vector):
    do_move(move_vector)
    
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
  emit_signal("bridge_destroy")
  emit_signal("time_step")
    
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
    if get_tile_id(collision) == TYPE_BRIDGE:
      destroy_bridge(collision)

func do_move(move_vector):
  .do_move(move_vector)
  emit_signal("time_step")

# Called when the node enters the scene tree for the first time.
func _ready():
  target_position = position
