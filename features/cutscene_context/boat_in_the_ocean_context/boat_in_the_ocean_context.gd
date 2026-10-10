class_name BoatInTheOceanContext extends Node

@onready var buoey: Buoey = %buoey
@onready var particles: GPUParticles3D = %sea_spray
@onready var anim_player: AnimationPlayer = %anim_player
@onready var ui_introduction: UIIntroduction = %ui_introduction
@onready var cutscene_audio: AudioStreamPlayer = %cutscene_audio
@onready var camera: Camera3D = %camera

@export var anim_name: String = "boat_forward_camera_with_buoey"

signal scene_finished

var player_data: PlayerData

#build any services or other variables that we need in this context
func build() -> void:
	pass

# pass in and bind any dependencies that this context needs from parent
func bind_dependencies(player_data_local: PlayerData) -> void:
	player_data = player_data_local

# at this point, we have all dependencies resolved, and so we can do any
# setup that requires those, e.g. connect signals and use factories etc.
func setup() -> void:
	buoey.build()
	buoey.bind_dependencies()
	buoey.setup()

	self.play_anim()
	cutscene_audio.play()
	ui_introduction.continue_button.connect("pressed", scene_finished.emit)

	#camera
	camera.fov = player_data.get_camera_fov()

#play default animation
func play_anim() -> void:
	if anim_player && anim_player.has_animation(anim_name):
		anim_player.play(anim_name)

#triggered by anim player
func trigger_boat_wake() -> void:
	buoey.start_fast_mode()
	particles.emitting = true

#triggered by anim player
func emit_scene_finished() -> void:
	scene_finished.emit()

#called via anim player
func show_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE