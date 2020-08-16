extends Node2D

var rest_position
var is_placed = false

func isLeftClick(event) -> bool:
  return event is InputEventMouseButton \
    and event.pressed \
    and not event.is_echo() \
    and event.button_index == BUTTON_LEFT
    
func isRightClick(event) -> bool:
  return event is InputEventMouseButton \
    and event.pressed \
    and not event.is_echo() \
    and event.button_index == BUTTON_RIGHT

func _input(event):
  if isLeftClick(event):
    if is_selected() and can_place_bridge():
      place_bridge()
    else:
      var delta = event.position - position
      if abs(delta.x) < 12 and abs(delta.y) < 14:
        get_tree().set_input_as_handled()
        on_card_click()
  elif is_selected():
    if isRightClick(event):
      deselect()
    elif event is InputEventMouseMotion and !is_placed:
      var offset = 10
      var x = int(ceil(event.position.x))
      var y = int(ceil(event.position.y))
      position = Vector2(offset + x - (x % 16), offset + y - (y % 16))

func can_place_bridge() -> bool:
  return true

func place_bridge() -> void:
  is_placed = true
  # Place Bridge
  #queue_free() # safely destroy self

func is_selected() -> bool:
  return $Bridge.visible

func on_card_click():
  rest_position = position
  $Bridge.visible = true
  $Card.visible = false

func deselect():
  position = rest_position
  $Bridge.visible = false
  $Card.visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

#func _process(delta):
#  if isSelected:
#    position = 
