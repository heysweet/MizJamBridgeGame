extends Node2D

enum Suit {HEART = 0, DIAMOND, CLUB, SPADE}
enum Rank {ACE = 1, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING}

tool

# Ace of Hearts
var min_row = 16
var min_col = 20

export(Suit) var suit = Suit.HEART setget set_suit
export(Rank) var rank = Rank.ACE setget set_rank

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_suit(new_suit):
  suit = new_suit
  if $Renderable:
    $Renderable.set_row(min_row + new_suit)
  
func set_rank(new_rank):
  rank = new_rank
  if $Renderable:
    $Renderable.set_col(min_col + new_rank - 1)

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func getSprite() -> Sprite:
  return $Renderable.getSprite()
  
func containsPoint(targetVector : Vector2) -> bool:
  return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
