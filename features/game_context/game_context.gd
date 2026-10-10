class_name GameContext extends Node

enum SubContext {
	CutsceneContext,
	ExplorationContext
}

@onready var ps1_convert_materials: Node = %ps1_convert_materials

@export var cutscene_scene: PackedScene
@export var exploration_scene: PackedScene
@export var pause_scene: PackedScene

signal return_to_main_menu

var current_subcontext: SubContext
var current_subcontext_node: Node
var ui_pause_menu: UIPauseMenu
var player_data: PlayerData

func build() -> void:
	#build any services or other variables that we need in this context
	pass

func bind_dependencies(player_data_local: PlayerData) -> void:
	# pass in and bind any dependencies that this context needs from parent
	player_data = player_data_local

func setup() -> void:
	# at this point, we have all dependencies resolved, and so we can do any
	# setup that requires those, e.g. connect signals and use factories etc.
	
	self.mount_cutscene_context()

	#loop through all materials and add a ps1 shader
	ps1_convert_materials.convert_all_materials(self)

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
	cutscene_subcontext.bind_dependencies(player_data)
	cutscene_subcontext.setup()
	cutscene_subcontext.connect("cutscenes_finished", self.mount_exploration_context)

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
	exploration_subcontext.bind_dependencies(player_data)
	exploration_subcontext.setup()



func mount_pause_menu() -> void:
	if pause_scene == null:
		return

	var pause_scene_node_local: Node = pause_scene.instantiate()
	add_child(pause_scene_node_local)

	ui_pause_menu = pause_scene_node_local as UIPauseMenu
	if ui_pause_menu == null:
		printerr("Missing subcontext")
		return

	ui_pause_menu.build()
	ui_pause_menu.bind_dependencies(player_data)
	ui_pause_menu.setup()
	ui_pause_menu.settings_menu.connect("back_requested", hide_pause_menu)
	ui_pause_menu.settings_menu.connect("quit_requested", return_to_main_menu.emit)
	show_pause_menu()

func show_pause_menu() -> void:
	ui_pause_menu.show()
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func hide_pause_menu() -> void:
	#handle exceptions for when to not capture the mouse
	if (
		current_subcontext == SubContext.CutsceneContext &&
		current_subcontext_node.current_subcontext == current_subcontext_node.SubContext.BoatInTheOceanContext &&
		current_subcontext_node.current_subcontext_node.ui_introduction.is_visible_in_tree()
	):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	ui_pause_menu.hide()
	ui_pause_menu.queue_free()
	if get_tree().paused:
		get_tree().paused = false

#pause handler
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if get_tree().paused:
			hide_pause_menu()
		else:
			mount_pause_menu()
