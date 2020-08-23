extends "res://Classes/Movable.gd"

tool

enum Suit {HEART = 0, DIAMOND, CLUB, SPADE}
enum Rank {ACE = 1, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING}

export(Suit) var suit setget set_suit
export(Rank) var rank setget set_rank

var time_passed = 0
var path_to_city = []
var just_moved = true

func has_path():
  return len(path_to_city)

func set_suit(new_suit):
  suit = new_suit
  $Card2.suit = suit
  
func set_rank(new_rank):
  rank = new_rank
  $Card2.rank = rank
  
func _process(time):
  pass

func take_damage(dmg : int):
  if rank - dmg <= 0:
    queue_free()
  else:
    set_rank(rank - dmg)

func same_team(obj):
  return $Card2.same_team(obj)

func time_step():
  if len(path_to_city) > 0:
    do_move_to(path_to_city.pop_front(), Vector2.ZERO)

func get_tile_id(collision):
  # Find the character's position in tile coordinates
  var tile_pos = collision.collider.world_to_map(position)
  # Find the colliding tile position
  tile_pos -= collision.normal
  # Get the tile id
  return collision.collider.get_cellv(tile_pos)
