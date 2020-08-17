extends Node2D

export var tile_row : int = 0 setget set_tile_row
export var tile_col : int = 0 setget set_tile_col
var target_position = Vector2()
var tween : Tween

tool

func _ready():
  if !Engine.editor_hint:
    tween = Tween.new()
    .add_child(tween)
    tween.set_owner(get_tree().get_edited_scene_root())
    
func set_tile_col(col):
  tile_col = col
  target_position.x = 16 * tile_col
  if Engine.editor_hint:
    position = target_position
  
func set_tile_row(row):
  tile_row = row
  target_position.y = 16 * tile_row
  if Engine.editor_hint:
    position = target_position

func do_move_to(target_vector : Vector2):
  set_tile_col(target_vector.x)
  set_tile_row(target_vector.y)
  var delta = Vector2(target_vector.x - position.x, target_vector.y - position.y)
  update_tween(delta.normalized())

func do_move(move_vector : Vector2):
  if move_vector.x == 0 and move_vector.y == 0:
    return
  do_move_to(Vector2(tile_col + move_vector.x, tile_row + move_vector.y))

func update_tween(move_vector : Vector2):
  tween.interpolate_property(self, "position",
          position, target_position, 0.130,
          Tween.EASE_IN_OUT, Tween.EASE_IN_OUT)
  tween.interpolate_property(self, "rotation", 0.15 * -move_vector.x, 0, 0.400, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
  tween.interpolate_property(self, "scale", Vector2(1.1, 1.1), Vector2(1, 1), 0.300, Tween.TRANS_BACK, Tween.EASE_OUT)
  tween.start()
