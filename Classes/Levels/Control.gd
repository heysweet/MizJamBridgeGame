extends Control

var last_change = 0
var min_time_sample_play = 100

# Called when the node enters the scene tree for the first time.
func _ready():
  _on_MasterSlider_value_changed(600)
  _on_MusicSlider_value_changed(700)
  _on_SoundFXSlider_value_changed(320)

func get_db(value : int):
  return 20.0 * (log(value * 0.001) / log(10))

func now_ms():
  return OS.get_ticks_msec()
  
func sample_sound():
  var now = now_ms()
  if now - last_change > min_time_sample_play:
    last_change = now
    $SoundTest.play()

func _on_MasterSlider_value_changed(value):
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), get_db(value))
  sample_sound()

func _on_MusicSlider_value_changed(value):
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), get_db(value))

func _on_SoundFXSlider_value_changed(value):
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), get_db(value))
  sample_sound()
