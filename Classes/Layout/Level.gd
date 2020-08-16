extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text
enum Suit {HEART = 0, DIAMOND, CLUB, SPADE}
const RedCities = []
const BlueCities = []
var navigation2d : Navigation2D;

func _init():
  navigation2d = Navigation2D.new()
  pass

# Called when the node enters the scene tree for the first time.
func _ready():
  print(navigation2d)
  for city in $Cities.get_children():
    if city.suit == Suit.HEART || city.suit == Suit.DIAMOND:
      RedCities.append(city)
    else:
      BlueCities.append(city)
  for cart in $Carts.get_children():
    print(cart)
    #var cart_suit = cart.get_suit()
   # if cart_suit == Suit.HEART || cart_suit == Suit.DIAMOND:
      #print("should work")
  pass # Replace with function body.

func on_step():     
  pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
