extends Node2D

const EXIT_LEVEL_ARROW_ID = 7
const INVISIBLE_LEVEL_ARROW_ID = 8

var arrow_cells = []

tool

func hide_exit():
  var tile_map = $Navigation2D/TileMap
  arrow_cells = tile_map.get_used_cells_by_id(EXIT_LEVEL_ARROW_ID)
  for cell in arrow_cells:
    tile_map.set_cellv(cell, INVISIBLE_LEVEL_ARROW_ID)

# Called when the node enters the scene tree for the first time.
func _ready():
  VisualServer.set_default_clear_color(Color(0,0,0,1.0))
  hide_exit()
  $Node/Player.connect("bridge_destroy", self, "_on_bridge_destroyed")
  update_cart_pathfinding()

func update_cart_pathfinding():
  for cart in $Carts.get_children():
    set_closest_city($Cities.get_children(), cart)

func set_closest_city(cities, cart):
  var min_path
  cart.position.y += 8
  for city in cities:
    if !cart.same_team(city):
      continue
    var path = $Navigation2D.get_simple_path(cart.position, city.position, false)
    if (!min_path || path.size() < min_path.size()):
      min_path = path
  cart.set_path_to(min_path) 
  cart.position.y -= 8
    
func _on_bridge_destroyed():
  update_cart_pathfinding()

func on_level_win():
  var tile_map = $Navigation2D/TileMap
  for cell in arrow_cells:
    tile_map.set_cellv(cell, EXIT_LEVEL_ARROW_ID)
