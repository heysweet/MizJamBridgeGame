extends Control

var last_change = 0
var min_time_sample_play = 100
var last_volume = 0

# Called when the node enters the scene tree for the first time.
func _ready():
  last_volume = 600
  $MasterSlider.value = last_volume
  $MusicSlider.value = 700
  $SoundFXSlider.value = 320

func get_db(value : int):
  return 20.0 * (log(value * 0.001) / log(10))

func now_ms():
  return OS.get_ticks_msec()
  
func sample_sound():
  var now = now_ms()
  if now - last_change > min_time_sample_play:
    last_change = now
    $SoundTest.play()
    
func _input(ev):
  if ev is InputEventKey and ev.is_pressed() and not ev.echo:
    match (ev.scancode):
      KEY_M:
        if $MasterSlider.value <= 10:
          $MasterSlider.value = last_volume
        else:
          $MasterSlider.value = 0

func _on_MasterSlider_value_changed(value):
  if (value > 10):
    last_volume = value
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), get_db(value))
  sample_sound()

func _on_MusicSlider_value_changed(value):
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), get_db(value))

func _on_SoundFXSlider_value_changed(value):
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), get_db(value))
  sample_sound()
