extends Node2D

const EXIT_LEVEL_ARROW_ID = 7
const INVISIBLE_LEVEL_ARROW_ID = 8

var arrow_cells = []

tool

signal restart_level
signal complete_level

var colors = [Color(0,255,255), Color(255,0,0),Color(0,255,255), Color(255,0,0),Color(0,255,255), Color(255,0,0)]

func hide_exit():
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
  if is_level_won:
    on_level_win_unlock()

func update_cart_pathfinding():
  for cart in $Carts.get_children():
    set_closest_city($Cities.get_children(), cart)
  _check_level_win()

func set_closest_city(cities, cart):
  var min_path
  for city in cities:
    if cart.same_team(city):
      continue
    var path = $Navigation2D.get_simple_path(cart.position, city.position, true)
    if (!min_path || path.size() < min_path.size()):
      min_path = path
  cart.set_path_to(min_path) 
  var points = []
  points.append(cart.position)
  for point in cart.path_to_city:
    points.append(point * 16)
  var line2d = Line2D.new()
  line2d.points = min_path
  line2d.width = 1
  line2d.show()
  line2d.default_color = colors.pop_front()
  .add_child(line2d)
    
func _on_bridge_destroyed():
  update_cart_pathfinding()

func on_level_win_unlock():
  var tile_map = $Navigation2D/TileMap
  for cell in arrow_cells:
    tile_map.set_cellv(cell, EXIT_LEVEL_ARROW_ID)
