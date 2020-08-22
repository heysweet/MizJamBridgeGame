extends Node2D

enum Suit {HEART = 0, DIAMOND, CLUB, SPADE}
var suit_colors = [Color("#66CCEE"), Color("#228833"), Color("#CCBB44"), Color("#AA3377")]

tool

export(Suit) var suit = Suit.HEART setget set_suit
export var tile_row : int = 0 setget set_tile_row
export var tile_col : int = 0 setget set_tile_col

func set_tile_col(col):
  tile_col = col
  position.x = 16 * tile_col
  
func set_tile_row(row):
  tile_row = row
  position.y = 16 * tile_row

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
