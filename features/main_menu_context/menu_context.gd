class_name MenuContext extends Node

signal start_game_requested

@onready var ui_main_menu: UIMainMenu = %ui_main_menu
@onready var ui_settings_menu: UISettingsMenu = %ui_settings_menu
@onready var menu_camera: Camera3D = %menu_camera
@onready var buoey: Buoey = %buoey
@onready var ps1_convert_materials: Node = %ps1_convert_materials
@onready var menu_theme: AudioStreamPlayer = %menu_theme

var player_data: PlayerData

#build any services or other variables that we need in this context
func build() -> void:
	pass

# pass in and bind any dependencies that this context needs from parent
func bind_dependencies(player_data_local: PlayerData) -> void:
	player_data = player_data_local
	#loop through all materials and add a ps1 shader
	ps1_convert_materials.convert_all_materials(self)

# at this point, we have all dependencies resolved, and so we can do any
# setup that requires those, e.g. connect signals and use factories etc.
func setup() -> void:
	ui_main_menu.play_requested.connect(handle_play)
	ui_main_menu.quit_requested.connect(handle_quit)
	ui_main_menu.load_requested.connect(handle_show_saved_games)
	ui_main_menu.settings_requested.connect(handle_show_settings_menu)
	ui_settings_menu.back_requested.connect(handle_show_main_menu)
	
	ui_settings_menu.build()
	ui_settings_menu.bind_dependencies(player_data)
	ui_settings_menu.setup()
	
	handle_show_main_menu()

	buoey.build()
	buoey.bind_dependencies()
	buoey.setup()

	#audio
	menu_theme.play()

	#camera settings
	menu_camera.fov = player_data.get_camera_fov()

func handle_play() -> void:
	var camera_tween: Tween = create_tween()
	ui_main_menu.hide()
	#camera_tween.tween_property(menu_camera, "fov", 30.0, 0.5)
	camera_tween.tween_callback(start_game_requested.emit)

func handle_quit() -> void:
	get_tree().quit()

func handle_show_saved_games() -> void:
	print("Not implemented yet")

func handle_show_main_menu() -> void:
	ui_main_menu.show()
	ui_settings_menu.hide()
	#ui_main_menu.get_focus()

func handle_show_settings_menu() -> void:
	ui_settings_menu.show()
	ui_main_menu.hide()
	#ui_settings_menu.get_focus()
