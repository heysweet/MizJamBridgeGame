extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text
enum Suit {HEART = 0, DIAMOND, CLUB, SPADE}
const RedCities = []
const BlueCities = []

func _init():
  pass

# Called when the node enters the scene tree for the first time.
func _ready():

  for city in $Cities.get_children():
    if city.suit == Suit.HEART || city.suit == Suit.DIAMOND:
      RedCities.append(city)
    else:
      BlueCities.append(city)
  for cart in $Carts.get_children():
    print(cart.position)
    print(RedCities[0].position)
    var path = $Navigation2D.get_simple_path(cart.position, RedCities[0].position, false)
    print(path)
    cart.set_path_to(path)

  pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
