extends Node2D

const EXIT_LEVEL_ARROW_ID = 7
const INVISIBLE_LEVEL_ARROW_ID = 8
const VALLEY_TILE_ID = 2
const BRIDGE_TILE_ID = 6
const TRAVERSABLE_TILE_IDS = [VALLEY_TILE_ID, BRIDGE_TILE_ID]

export var is_level_complete_on_start = false
var arrow_cells = []
var debug_lines = []
var rand = RandomNumberGenerator.new()
var astar = AStar2D.new()

tool

signal restart_level
signal complete_level

func _input(ev):
  if ev is InputEventKey and ev.is_pressed() and not ev.echo:
    match (ev.scancode):
      KEY_R:
        emit_signal("restart_level")

func get_color():
  rand.randomize()
  return Color(rand.randf_range(0, 1), rand.randf_range(0, 1), 
    rand.randf_range(0, 1))

func add_debug_line_tiles(tiles):
  var points = []
  for tile in tiles:
    points.append(tile * 16)
  add_debug_line(points)

func add_debug_line(points):
  var line2d = Line2D.new()
  line2d.points = points
  line2d.width = 1
  line2d.default_color = get_color()
  line2d.z_index = 99999
  line2d.show()
  .add_child(line2d)
  debug_lines.append(line2d)

func hide_exit():
  if is_level_complete_on_start || Engine.editor_hint:
    return
  var tile_map = $Navigation2D/TileMap
  arrow_cells = tile_map.get_used_cells_by_id(EXIT_LEVEL_ARROW_ID)
  for cell in arrow_cells:
    tile_map.set_cellv(cell, INVISIBLE_LEVEL_ARROW_ID)

func setup_group_listeners():
  for city in $Cities.get_children():
    city.connect("start_city_destroy", self, "_on_city_destroy_start")
    city.connect("city_destroyed", self, "_on_city_destroyed")

func _on_city_destroy_start():
  $Player.set_controllable(false)
  
func _on_city_destroyed():
  emit_signal("restart_level")

# Called when the node enters the scene tree for the first time.
func _ready():
  prepare_grid()
  VisualServer.set_default_clear_color(Color(0.14,0.17,0.11,1.0))
  hide_exit()
  setup_group_listeners()
  $Carts.connect("card_kill", self, "_card_kill")
  $Player.connect("bridge_destroy", self, "_on_bridge_destroyed")
  $Player.connect("level_exit", self, "_fire_level_complete")
  $Player.connect("double_tap", self, "_on_city_destroyed")
  update_cart_pathfinding(Vector2(-10, -10))

func _card_kill():
  if .has_node("SoundCardKill"):
    $SoundCardKill.play()
  _check_level_win()

func _fire_level_complete():
  emit_signal("complete_level")

func _check_level_win():
  var is_level_won = true
  for cart in $Carts.get_children():
    is_level_won = is_level_won and (!cart.has_path() || cart.lame_duck)
  if is_level_won:
    on_level_win_unlock()

func update_cart_pathfinding(bridge_exploded_location: Vector2):
  # Clear debug lines
  for debug_line in debug_lines:
    debug_lines.pop_back().queue_free()
  for cart in $Carts.get_children():
    var curr_tile = cast_point_to_tile(cart.target_position)
    var targets = []
    for city in $Cities.get_children():
      if !cart.same_team(city):
        targets.append(city)
    # If our current cart location is where a bridge just exploded,
    # then create a path from its previous location and prepend that spot
    # to ensure it moves back there on the next step
    if curr_tile == bridge_exploded_location:
      var prev_tile = cast_point_to_tile(cart.previous_location)
      cart.path_to_target = [prev_tile] + get_closest_target(targets, cart.previous_location)
      # If the only point is our movement back, this is for aesthetic reasons
      # and the cart is functionally dead
      if cart.path_to_target.size() == 1:
        cart.lame_duck = true
    # Otherwise, we create a new path from the current location
    else:
      cart.path_to_target = get_closest_target(targets, cart.target_position)
  _check_level_win()
  
func get_closest_target(targets : Array, start_position: Vector2):
  var min_path
  var path_arr = []
  for target in targets:
    var path = get_grid_path(start_position, target.position)
    if (!min_path || path.size() < min_path.size()):
      min_path = path
  if min_path:
    for i in range(min_path.size()):
      if i == 0:
        continue
      path_arr.append(min_path[i])
    if Engine.editor_hint:
      add_debug_line_tiles(path_arr)
    return path_arr
  else:
    return []

func _on_bridge_destroyed(tile_pos):
  astar.remove_point(_get_id_for_tile(tile_pos))
  update_cart_pathfinding(tile_pos)

func show_arrows():
  var tile_map = $Navigation2D/TileMap
  for cell in arrow_cells:
    tile_map.set_cellv(cell, EXIT_LEVEL_ARROW_ID)

func on_level_win_unlock():
  show_arrows()
  
func cast_point_to_tile(point):
  return Vector2(floor(point.x / 16), floor(point.y / 16))
  
func cast_tile_to_point(tile):
  return tile * 16
  
func prepare_grid():
  var used_cells = $Navigation2D/TileMap.get_used_cells()
  var traversable_tiles = []
  for tile in used_cells:
    var tile_type = $Navigation2D/TileMap.get_cellv(tile)
    if tile_type in TRAVERSABLE_TILE_IDS:
      traversable_tiles.append(tile)
  # Add points
  for tile in traversable_tiles:
    var tile_id = _get_id_for_tile(tile)
    astar.add_point(tile_id, Vector2(tile.x, tile.y))
  # Add connections
  for tile in traversable_tiles:
    var tile_id = _get_id_for_tile(tile)
    for x in range(2):
      for y in range(2):
        if x == y:
          continue
        var target = tile + Vector2(x - 1, y - 1)
        if target.x < 0 || target.y < 0:
          continue
        var target_id = _get_id_for_tile(target)
        if tile == target or not astar.has_point(target_id):
          continue
        astar.connect_points(tile_id, target_id, true)
 
func get_grid_path(start : Vector2, finish : Vector2):
  var start_tile = cast_point_to_tile(start)
  var finish_tile = cast_point_to_tile(finish)
  return astar.get_point_path(_get_id_for_tile(start_tile), _get_id_for_tile(finish_tile))

func _get_id_for_tile(tile):
  var used_rect = $Navigation2D/TileMap.get_used_rect()
  return (tile.x - used_rect.position.x) + (tile.y - used_rect.position.y) * used_rect.size.x
