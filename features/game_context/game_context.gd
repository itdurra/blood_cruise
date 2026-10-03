class_name GameContext extends Node

enum SubContext {
	CutsceneContext,
	ExplorationContext
}
var current_subcontext: SubContext
var current_subcontext_node: Node

@onready var ui_pause_menu: UIPauseMenu = %ui_pause_menu

@export var cutscene_scene: PackedScene
@export var exploration_scene: PackedScene

func build() -> void:
	#build any services or other variables that we need in this context
	pass

func bind_dependencies() -> void:
	# pass in and bind any dependencies that this context needs from parent
	pass

func setup() -> void:
	# at this point, we have all dependencies resolved, and so we can do any
	# setup that requires those, e.g. connect signals and use factories etc.
	
	#TODO: cutscene goes first
	self.mount_exploration_context()
	hide_pause_menu()

#do the work of mounting the cutscene context
func mount_cutscene_context() -> void:
	#tear down old subcontext
	if current_subcontext_node:
		current_subcontext_node.queue_free()

		#may require other teardown steps

	#build new subcontext
	current_subcontext = SubContext.CutsceneContext
	current_subcontext_node = cutscene_scene.instantiate()
	add_child(current_subcontext_node)

	var cutscene_subcontext: CutsceneContext = current_subcontext_node as CutsceneContext
	if cutscene_subcontext == null:
		printerr("Missing subcontext")
		return

	cutscene_subcontext.build()
	cutscene_subcontext.bind_dependencies()
	cutscene_subcontext.setup()

#do the work of mounting the exploration context
func mount_exploration_context() -> void:
	#tear down old subcontext
	if current_subcontext_node:
		current_subcontext_node.queue_free()

		#may require other teardown steps

	#build new subcontext
	current_subcontext = SubContext.ExplorationContext
	current_subcontext_node = exploration_scene.instantiate()
	add_child(current_subcontext_node)

	var exploration_subcontext: ExplorationContext = current_subcontext_node as ExplorationContext
	if exploration_subcontext == null:
		printerr("Missing subcontext")
		return

	exploration_subcontext.build()
	exploration_subcontext.bind_dependencies()
	exploration_subcontext.setup()

func mount_pause_menu() -> void:
	ui_pause_menu.build()
	ui_pause_menu.bind_dependencies()
	ui_pause_menu.setup()
	show_pause_menu()

func show_pause_menu() -> void:
	ui_pause_menu.show()
	get_tree().paused = true

func hide_pause_menu() -> void:
	ui_pause_menu.hide()
	if get_tree().paused:
		get_tree().paused = false
