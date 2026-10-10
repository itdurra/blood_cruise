class_name UIGameSettingsTab extends VBoxContainer

#TODO: rewrite this to isntead update a playerdata resource that is passed around

#audio
@onready var fov_slider: HSlider = %fov_slider

var player_data: PlayerData

#build any services or other variables that we need in this context
func build() -> void:
	var cameras: Array[Node] = get_tree().get_nodes_in_group("player_camera")
	fov_slider.value = cameras[0].fov

func bind_dependencies(player_data_local: PlayerData) -> void:
	player_data = player_data_local
	
func setup() -> void:
	fov_slider.value_changed.connect(_handle_fov_value_changed)

func _handle_fov_value_changed(value_local: float) -> void:
	var cameras: Array[Node] = get_tree().get_nodes_in_group("player_camera")

	for camera in cameras:
		camera.fov = value_local
