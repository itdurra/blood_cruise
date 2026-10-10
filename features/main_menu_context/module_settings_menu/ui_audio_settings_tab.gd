class_name UIAudioSettingsTab extends VBoxContainer

#TODO: add a playerresource that stores this data

#audio
@onready var master_slider: HSlider = %master_volume_slider
@onready var music_slider: HSlider = %music_volume_slider
@onready var sfx_slider: HSlider = %sfx_volume_slider
@onready var ambient_slider: HSlider = %ambient_volume_slider
@onready var voice_slider: HSlider = %voice_volume_slider

#index for SFX buss
var master_bus: int
var sfx_bus: int
var music_bus: int
var ambient_bus: int
var voice_bus: int

var player_data: PlayerData

#build any services or other variables that we need in this context
func build() -> void:
	master_bus = AudioServer.get_bus_index("Master")
	sfx_bus = AudioServer.get_bus_index("SFX")
	music_bus = AudioServer.get_bus_index("Music")
	ambient_bus = AudioServer.get_bus_index("Ambient")
	voice_bus = AudioServer.get_bus_index("Voice")
	
func bind_dependencies(player_data_local: PlayerData) -> void:
	player_data = player_data_local
	
func setup() -> void:
	master_slider.value = AudioServer.get_bus_volume_db(master_bus)
	sfx_slider.value = AudioServer.get_bus_volume_db(sfx_bus)
	music_slider.value = AudioServer.get_bus_volume_db(music_bus)
	ambient_slider.value = AudioServer.get_bus_volume_db(ambient_bus)
	voice_slider.value = AudioServer.get_bus_volume_db(voice_bus)

	master_slider.value_changed.connect(_handle_master_volume_value_changed)
	music_slider.value_changed.connect(_handle_music_volume_value_changed)
	sfx_slider.value_changed.connect(_handle_sfx_volume_value_changed)
	ambient_slider.value_changed.connect(_handle_ambient_volume_value_changed)
	voice_slider.value_changed.connect(_handle_voice_volume_value_changed)

func _handle_master_volume_value_changed(value_local: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, value_local)

func _handle_music_volume_value_changed(value_local: float) -> void:
	AudioServer.set_bus_volume_db(music_bus, value_local)

func _handle_sfx_volume_value_changed(value_local: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus, value_local)

func _handle_ambient_volume_value_changed(value_local: float) -> void:
	AudioServer.set_bus_volume_db(ambient_bus, value_local)

func _handle_voice_volume_value_changed(value_local: float) -> void:
	AudioServer.set_bus_volume_db(voice_bus, value_local)

