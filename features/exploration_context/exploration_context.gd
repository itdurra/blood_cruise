class_name ExplorationContext extends Node

@onready var player: CharacterBody3D = %player
@onready var fish_guy: Node3D = %fish_guy

#build any services or other variables that we need in this context
func build() -> void:
	pass

# pass in and bind any dependencies that this context needs from parent
func bind_dependencies() -> void:
	pass

# at this point, we have all dependencies resolved, and so we can do any
# setup that requires those, e.g. connect signals and use factories etc.
func setup() -> void:
	self._mount_player()

#setup player module
func _mount_player() -> void:
	player.build()
	player.bind_dependencies()
	player.setup()