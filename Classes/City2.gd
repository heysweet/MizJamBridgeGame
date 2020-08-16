extends "res://Classes/Renderable2.gd"

enum Suit {HEART = 0, DIAMOND, CLUB, SPADE}
var suit_colors = [Color(0,0,1), Color(0,1,1), Color(1,1,1), Color(0,0,0)]

tool

# Ace of Hearts
var min_row = 16
var min_col = 20

export(Suit) var suit = Suit.HEART setget set_suit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_suit(new_suit):
  suit = new_suit
  modulate = suit_colors[suit]
  
func is_type(type):
  return type == "Card" or .is_type(type)
  
# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.
