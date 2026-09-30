class_name RootContext extends Node

enum SubContext {
	GameContext,
	MenuContext,
}
var current_subcontext: SubContext
var current_subcontext_node: Node

@export var game_scene: PackedScene
@export var menu_scene: PackedScene

var _music_player: AudioStreamPlayer

func _ready() -> void:
	self.build()
	self.bind_dependencies()
	self.setup()

func build() -> void:
	#build any services or other variables that we need in this context
	_music_player = AudioStreamPlayer.new()
	_music_player.autoplay = true
	add_child(_music_player)

func bind_dependencies() -> void:
	# pass in and bind any dependencies that this context needs from parent
	pass

func setup() -> void:
	# at this point, we have all dependencies resolved, and so we can do any
	# setup that requires those, e.g. connect signals and use factories etc.
	self.mount_menu()

func mount_game() -> void:
	#tear down old subcontext
	if current_subcontext_node:
		current_subcontext_node.queue_free()

		#may require other teardown steps

	#build new subcontext
	current_subcontext = SubContext.GameContext
	current_subcontext_node = game_scene.instantiate()
	add_child(current_subcontext_node)

	var game_subcontext: GameContext = current_subcontext_node as GameContext
	if game_subcontext == null:
		printerr("Missing subcontext")
		return

	if OS.is_debug_build():
		print("game")

	game_subcontext.build()
	game_subcontext.bind_dependencies()
	game_subcontext.setup()

func mount_menu() -> void:
	#tear down old subcontext
	if current_subcontext_node:
		current_subcontext_node.queue_free()

		#may require other teardown steps

	#build new subcontext
	current_subcontext = SubContext.MenuContext
	current_subcontext_node = menu_scene.instantiate()
	add_child(current_subcontext_node)

	#connect to signals
	current_subcontext_node.connect("start_game_requested", mount_game)

	var menu_subcontext: MenuContext = current_subcontext_node as MenuContext
	if menu_subcontext == null:
		printerr("Missing subcontext")
		return

	menu_subcontext.build()
	menu_subcontext.bind_dependencies(_music_player)
	menu_subcontext.setup()
