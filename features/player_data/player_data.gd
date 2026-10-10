class_name PlayerData extends Resource

@export var camera_fov: float
@export var master_volume_slider: float
@export var music_volume_slider: float
@export var sfx_volume_slider: float
@export var ambient_volume_slider: float
@export var voice_volume_slider: float

#getter/setters

func get_camera_fov() -> float:
	return camera_fov

func set_camera_fov(value_local: float) -> void:
	camera_fov = value_local

func get_master_volume_slider() -> float:
	return master_volume_slider

func set_master_volume_slider(value_local: float) -> void:
	master_volume_slider = value_local

func get_music_volume_slider() -> float:
	return music_volume_slider

func set_music_volume_slider(value_local: float) -> void:
	music_volume_slider = value_local

func get_sfx_volume_slider() -> float:
	return sfx_volume_slider

func set_sfx_volume_slider(value_local: float) -> void:
	sfx_volume_slider = value_local

func get_ambient_volume_slider() -> float:
	return ambient_volume_slider

func set_ambient_volume_slider(value_local: float) -> void:
	ambient_volume_slider = value_local

func get_voice_volume_slider() -> float:
	return voice_volume_slider

func set_voice_volume_slider(value_local: float) -> void:
	voice_volume_slider = value_local