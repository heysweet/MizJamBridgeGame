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
      print("Appending red")
      RedCities.append(city)
    else:
      print("Appending blue")
      BlueCities.append(city)
  print("checking carts")
  for cart in $Carts.get_children():
    print(cart)
    print("Level suit check")
    print(cart.suit)
    if (cart.suit == Suit.HEART || cart.suit == Suit.DIAMOND) && len(RedCities) > 0:
        set_closest_city(RedCities, cart)
    elif (cart.suit == Suit.SPADE || cart.suit == Suit.CLUB) && len(BlueCities) > 0:    
        set_closest_city(BlueCities, cart)

func set_closest_city(cities, cart):
    var min_path 
    cart.position.y += 8
    for city in cities:
        var path = $Navigation2D.get_simple_path(cart.position, city.position, false)
        if (!min_path || path.size() < min_path.size()):
            min_path = path
    cart.set_path_to(min_path) 
