extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
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
