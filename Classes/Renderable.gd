extends Node2D

export var numRows : int
export var numCols : int
export var row : int setget set_row
export var col : int setget set_col

var lastRow = -1
var lastCol = -1

# Run this in the editor
tool

# Called when the node enters the scene tree for the first time.
func _ready():
  $Sprite.region_enabled = true
  updateSprite()

func set_row(new_row):
  row = new_row
  updateSprite()
  
func set_col(new_col):
  col = new_col
  updateSprite()

func updateSprite():
  lastRow = row
  lastCol = col
  if $Sprite:
    $Sprite.region_rect.position.x = col * 16
    $Sprite.region_rect.position.y = row * 16

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if Engine.editor_hint:
    if ((lastRow != row) || (lastCol != col)):
      updateSprite()
#  if not Engine.editor_hint:
#    pass

func getSprite():
  return $Sprite
