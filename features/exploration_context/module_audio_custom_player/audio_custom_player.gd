class_name AudioCustomPlayer extends Node

@onready var exploration_ambient: AudioStreamPlayer = %exploration_ambient
@onready var shuffle_playlist: AudioStreamPlayer = %shuffle_playlist
@export var playlist: Array[AudioStreamPlayer]

var is_in_dialogue: bool = false
var index: int = 0

func build() -> void:
	pass

# pass in and bind any dependencies that this context needs from parent
func bind_dependencies() -> void:
	pass

func setup() -> void:
	# at this point, we have all dependencies resolved, and so we can do any
	# setup that requires those, e.g. connect signals and use factories etc.
	self.update_music(false)

func update_music( 
	is_in_dialogue_local: bool, 
) -> void:
	is_in_dialogue = is_in_dialogue_local

	exploration_ambient.play()
	
	if is_in_dialogue:
		shuffle_playlist.stop()
		return

	shuffle_playlist.play()
