class_name UIPauseMenu extends Control

@onready var settings_menu: UISettingsMenu = %ui_settings_menu

var player_data: PlayerData

signal settings_changed

#build any services or other variables that we need in this context
func build() -> void:
	pass

# pass in and bind any dependencies that this context needs from parent
func bind_dependencies(player_data_local: PlayerData) -> void:
	player_data = player_data_local

# at this point, we have all dependencies resolved, and so we can do any
# setup that requires those, e.g. connect signals and use factories etc.
func setup() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	settings_menu.build()
	settings_menu.bind_dependencies(player_data)
	settings_menu.setup()
	settings_menu.connect("settings_changed", settings_changed.emit)
