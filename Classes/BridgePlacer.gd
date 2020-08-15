extends Node2D

func isLeftClick(event) -> bool:
  return event is InputEventMouseButton \
    and event.pressed \
    and not event.is_echo() \
    and event.button_index == BUTTON_LEFT

func _input(event):
  if isLeftClick(event):
    var sprite = $Card.getSprite()
    var delta = event.position - position
    if abs(delta.x) < 16 and abs(delta.y) < 16:
      get_tree().set_input_as_handled()
      print("CLICK!")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
