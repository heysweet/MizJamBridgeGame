extends Node2D

const EXIT_LEVEL_ARROW_ID = 7
const INVISIBLE_LEVEL_ARROW_ID = 8

export var is_level_complete_on_start = false
var arrow_cells = []

tool

signal restart_level
signal complete_level

var colors = [Color(0,255,255), Color(255,0,0),Color(0,0,255), 
Color(255,0,0),Color(21,255,255), Color(255,0,0)]

func hide_exit():
  if is_level_complete_on_start:
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
  VisualServer.set_default_clear_color(Color(0.14,0.17,0.11,1.0))
  hide_exit()
  setup_group_listeners()
  $Carts.connect("card_kill", self, "_check_level_win")
  $Player.connect("bridge_destroy", self, "_on_bridge_destroyed")
  $Player.connect("level_exit", self, "_fire_level_complete")
  update_cart_pathfinding()

func _fire_level_complete():
  emit_signal("complete_level")

func _check_level_win():
  var is_level_won = true
  for cart in $Carts.get_children():
    is_level_won = is_level_won and !cart.has_path()
    print(cart.has_path())
  if is_level_won:
    on_level_win_unlock()

func update_cart_pathfinding():
  for cart in $Carts.get_children():
    set_closest_target($Cities.get_children(), cart)
    # Fallback to a close cart
    # TODO
#    if !cart.has_path():
#      set_closest_target($Carts.get_children(), cart)
  _check_level_win()
  
func set_closest_target(targets : Array, aggressor):
  var offset = Vector2(8, 8) 
  var min_path
  for target in targets:
    if aggressor.same_team(target):
      continue
    var path = $Navigation2D.get_simple_path(aggressor.position - offset, 
      target.position - offset, true)
    if (!min_path || path.size() < min_path.size()):
      min_path = path
  if min_path:
    aggressor.path_to_target = get_grid_path_to(min_path)

#  Uncomment the below with ctrl+K to show lines for debugging
#  if min_path:
#    var points = []
#    points.append(aggressor.position)
#    for point in aggressor.path_to_target:
#      points.append(point * 16 + offset)
#    var line2d = Line2D.new()
#    line2d.points = points
#    line2d.width = 1
#    line2d.show()
#    line2d.default_color = colors.pop_front()
#    .add_child(line2d)
#    var line2d2 = Line2D.new()
#    line2d2.points = min_path
#    line2d2.width = 1
#    line2d2.show()
#    line2d2.default_color = colors.pop_front()
#    .add_child(line2d2)

func map_to_cell(value : int):
  return int(floor(value / 16))
  
func interpolate_lines(arr: Array) -> Array:
  var points = []
  var last_pt = null
  for i in range(arr.size()):
    var point = arr[i]
    ## Skip our first_entry, as we won't have a last_pt yet
    if i == 0:
      last_pt = point
      points.append(last_pt)
      continue
    var interpolated_points = interpolate_points(last_pt, point)
    # Remove the last point, as it will equal the first in the next line
    points.pop_back()
    points += interpolate_points(last_pt, point)
    last_pt = point
    i += 1
  return points

# Bressenham's Line Drawing Algorithm
func interpolate_points(a: Vector2, b: Vector2) -> Array:
  var steep = false
  var swapped = false
  var points = [] 
  # If we're traveling further on y then x, temporarily swap axes rather than
  # duplicating the code modulo using y instead of x
  if abs(a.x - b.x) < abs(a.y - b.y):
    a = Vector2(a.y, a.x)
    b = Vector2(b.y, b.x)
    steep = true
  # Ensure we're drawing left-to-right
  if a.x > b.x:
    var temp = a
    a = b
    b = temp
    swapped = true
  var x = a.x
  var slope = abs(float((b.y - a.y) / (b.x - a.x))) # Slope
  var accum_error = float(0.0)
  var y = a.y
  var y_inc = -1
  if b.y > a.y:
    y_inc = 1
  # Walk along our x-axis
  while x <= b.x:
    if steep:
      points.append(Vector2(y, x))
    else:
      points.append(Vector2(x, y))
    # Every step we check if enough "x" has passed that we should increment our
    # "y" value.
    accum_error += slope
    if (accum_error > 0.5):
      y += y_inc
      accum_error -= 1.0
    x += 1
  # If we swapped, we'll need to reverse the ordering
  if swapped:
    var reversed = []
    for pt in points:
      reversed.push_front(pt)
    return reversed
  return points

# Takes any movement path and adds horizontal/vertical movement to avoid diagonals
func ensure_manhattan_movement(arr : Array) -> Array:
  if len(arr) == 0:
    return arr
  var result = []
  var last_pt = arr[0]
  for pt in arr:
    if pt.x != last_pt.x && pt.y != last_pt.y:
      result.append(Vector2(pt.x, last_pt.y))
    result.append(pt)
    last_pt = pt
  return result

func get_grid_path_to(arr : Array):
  var seen_nodes = {}
  var new_arr = []
  for pt in arr:
    var v = Vector2(map_to_cell(pt.x), map_to_cell(pt.y))
    var v_str = var2str(v)
    if !(v_str in seen_nodes):
      seen_nodes[v_str] = true
      new_arr.append(v)
  var interpolated = interpolate_lines(new_arr)
  var manhattan_distance = ensure_manhattan_movement(interpolated)
  # Remove first point, which is our start position
  manhattan_distance.pop_front()
  return manhattan_distance
   
func _on_bridge_destroyed():
  update_cart_pathfinding()

func on_level_win_unlock():
  var tile_map = $Navigation2D/TileMap
  for cell in arrow_cells:
    tile_map.set_cellv(cell, EXIT_LEVEL_ARROW_ID)
