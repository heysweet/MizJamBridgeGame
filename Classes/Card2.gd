extends Sprite

enum Suit {HEART = 0, DIAMOND, CLUB, SPADE}
enum Rank {ACE = 1, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING}

tool

# Ace of Hearts
var min_row = 16
var min_col = 20
var width = 16
var height = 16

export(Suit) var suit = Suit.HEART setget set_suit
export(Rank) var rank = Rank.ACE setget set_rank

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_suit(new_suit):
  suit = new_suit
  draw_me()
  #.x = (min_row + new_suit) * 16
 # if $Renderable:
   # $Renderable.set_row(min_row + new_suit)
  
func set_rank(new_rank):
  rank = new_rank
  draw_me()

func draw_me():
  var x_pos = (min_col + rank - 1) * 16
  var y_pos = (min_row + suit) * 16
  region_rect = Rect2(x_pos, y_pos, width, height)
  #if $Renderable:
    #$Renderable.set_col(min_col + new_rank - 1)

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.
