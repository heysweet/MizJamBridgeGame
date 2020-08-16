extends "res://Classes/Renderable.gd"

enum Suit {HEART = 0, DIAMOND, CLUB, SPADE}
enum Rank {ACE = 1, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING}

var suit_colors = [Color("#66CCEE"), Color("#228833"), Color("#CCBB44"), Color("#AA3377")]

tool

# Ace of Hearts
var min_row = 16
var min_col = 20

export(Suit) var suit = Suit.HEART setget set_suit
export(Rank) var rank = Rank.ACE setget set_rank

# Declare member variables here. Examples:
# var a = 2
# var b = "text

func _init():
  pass

func set_suit(new_suit):
  suit = new_suit
  modulate = suit_colors[suit]
  set_row(min_row + suit)
  
func set_rank(new_rank):
  rank = new_rank
  set_col(min_col + rank - 1)
  
# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.
