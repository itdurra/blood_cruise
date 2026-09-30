

class_name MenuContext extends Node

signal start_game_requested

@onready var ui_main_menu: UIMainMenu = %ui_main_menu
@onready var ui_settings_menu: UISettingsMenu = %ui_settings_menu
@onready var menu_camera: Camera3D = %menu_camera

var _music_player: AudioStreamPlayer

#build any services or other variables that we need in this context
func build() -> void:
	pass

# pass in and bind any dependencies that this context needs from parent
func bind_dependencies(music_player: AudioStreamPlayer) -> void:
	_music_player = music_player

	ui_settings_menu.bind_dependencies(_music_player)

# at this point, we have all dependencies resolved, and so we can do any
# setup that requires those, e.g. connect signals and use factories etc.
func setup() -> void:
	ui_main_menu.play_requested.connect(handle_play)
	ui_main_menu.quit_requested.connect(handle_quit)
	ui_main_menu.load_requested.connect(handle_show_saved_games)
	ui_main_menu.settings_requested.connect(handle_show_settings_menu)
	ui_settings_menu.back_requested.connect(handle_show_main_menu)
	
	ui_settings_menu.setup()
	
	handle_show_main_menu()

func handle_play() -> void:
	var camera_tween: Tween = create_tween()
	ui_main_menu.hide()
	camera_tween.tween_property(menu_camera, "fov", 30.0, 0.5)
	camera_tween.tween_callback(start_game_requested.emit)

func handle_quit() -> void:
	get_tree().quit()

func handle_show_saved_games() -> void:
	print("Not implemented yet")

func handle_show_main_menu() -> void:
	ui_main_menu.show()
	ui_settings_menu.hide()
	ui_main_menu.get_focus()

func handle_show_settings_menu() -> void:
	ui_settings_menu.show()
	ui_main_menu.hide()
	ui_settings_menu.get_focus()
