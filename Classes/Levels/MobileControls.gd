extends Node2D

func _ready():
  if !OS.has_touchscreen_ui_hint():
    $TextDisplay2.hide()
