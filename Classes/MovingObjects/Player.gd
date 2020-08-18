extends "res://Classes/Movable.gd"

var last_key_press = 0
var debounce_millis = 80

const TYPE_BRIDGE_MOV = 6
const TYPE_BRIDGE_ATK = -1

signal time_step
signal bridge_destroy

tool

func queue_move(movement : Vector2):
  var now = OS.get_ticks_msec()
  if last_key_press + debounce_millis > now:
    return
  last_key_press = now
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

func get_tile_id(collision):
  # Find the character's position in tile coordinates
  var tile_pos = collision.collider.world_to_map(position)
  # Find the colliding tile position
  tile_pos -= collision.normal
  # Get the tile id
  return collision.collider.get_cellv(tile_pos)

func can_move(move_vector):
  var offset = move_vector * 16;
  var collision = move_and_collide(offset, true, true, true)
  if collision and collision.collider is TileMap:
    return get_tile_id(collision) == TYPE_BRIDGE_MOV
  return true

func try_move(move_vector):
  if can_move(move_vector):
    do_move(move_vector)
    
func destroy_bridge(collision):
  emit_signal("time_step")
  var tile_pos = collision.collider.world_to_map(position)
  collision.collider.set_cell(
    tile_pos.x,
    tile_pos.y,
    6, # tile
    false, # flip_x
    false, # flip_y
    false, # transpose
    Vector2(4, 0))# autotile_coord
  emit_signal("bridge_destroy")
    
    
func try_interact():
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
