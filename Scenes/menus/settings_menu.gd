extends MarginContainer


### Master volume
@onready var h_slider_2 = $MenuBackground/CanvasLayer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HSlider2
@onready var label_2 = $MenuBackground/CanvasLayer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Label2


### Ambience music volume
@onready var h_slider : HSlider = $MenuBackground/CanvasLayer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HSlider
@onready var label = $MenuBackground/CanvasLayer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Label

### Sound Effect volume
@onready var h_slider_3 = $MenuBackground/CanvasLayer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HSlider3
@onready var sound_effects_pcnt = $MenuBackground/CanvasLayer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/SoundEffectsPcnt


@onready var window_sized = $MenuBackground/CanvasLayer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/WindowSized
var window_size = false
# Called when the node enters the scene tree for the first time.
func _ready():
	var initial_master_volume = get_linear_db("Master")
	label_2.text = str(initial_master_volume*100) + "%"
	h_slider_2.value = initial_master_volume*h_slider_2.max_value

	
	var initial_music_volume = get_linear_db("Music")
	label.text = str(initial_music_volume*100) + "%"
	h_slider.value = initial_music_volume*h_slider.max_value
	
	var initial_sfx_volume = get_linear_db("SoundEffects")
	sound_effects_pcnt.text = str(initial_sfx_volume*100) + "%"
	h_slider_3.value = initial_sfx_volume*h_slider_3.max_value



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		


func _on_window_sized_pressed():
	window_size = !window_size
	if window_size:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_h_slider_value_changed(value):
	set_linear_db("Music", value / h_slider.max_value)
	label.text = str(value*100) + "%"


func _on_h_slider_2_value_changed(value):
	set_linear_db("Master", value / h_slider_2.max_value)
	label_2.text = str(value*100) + "%"

func _on_h_slider_3_value_changed(value):
	set_linear_db("SoundEffects", value / h_slider_3.max_value)
	sound_effects_pcnt.text = str(value*100) + "%"
	
	
func get_linear_db(bus_name : String) -> float:
	assert(AudioServer.get_bus_index(bus_name) != -1, "Audiobus with the name " + bus_name + " does not exist.")
	return db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus_name)))


func set_linear_db(bus_name : String, linear_db : float) -> void:
	assert(AudioServer.get_bus_index(bus_name) != -1, "Audiobus with the name " + bus_name + " does not exist.")
	linear_db = clamp(linear_db, 0.0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(linear_db*5))


