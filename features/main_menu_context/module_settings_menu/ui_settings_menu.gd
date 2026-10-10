class_name UISettingsMenu extends PanelContainer

signal back_requested
signal quit_requested

@onready var audio_tab: UIAudioSettingsTab = %audio_tab
@onready var game_tab: UIGameSettingsTab = %game_tab
@onready var back_button: Button = %back_button
@onready var quit_button: Button = %quit_button

var player_data: PlayerData

#build any services or other variables that we need in this context
func build() -> void:
	pass
	
func bind_dependencies(player_data_local: PlayerData) -> void:
	player_data = player_data_local

func setup() -> void:
	back_button.connect("pressed", back_requested.emit)
	quit_button.connect("pressed", quit_requested.emit)

	game_tab.build()
	game_tab.bind_dependencies(player_data)
	game_tab.setup()

	audio_tab.build()
	audio_tab.bind_dependencies(player_data)
	audio_tab.setup()
