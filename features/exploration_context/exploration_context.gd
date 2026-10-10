class_name ExplorationContext extends Node

@onready var interactables_parent: Node3D = %quest_and_dialogue_triggers
@onready var random_interactables_parent: Node3D = %random_interaction_triggers
@onready var player: PlayerCharacter = %player
@onready var ui_dialogue: UIDialogue = %ui_dialogue
@onready var ui_quest: UIQuest = %ui_quest
@onready var anim_player: AnimationPlayer = %anim_player
@onready var audio_custom_player: AudioCustomPlayer = %audio_custom_player

#all these nodes should be InteractableDialogueWithQuests class
#but throws error when trying to cast them from get_child/Array[Node]
var interactables: Array[Node]
var random_interactables: Array[Node]
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
	self._mount_player()

	#handle dialogue ui
	ui_dialogue.connect("dialogue_ended", _hide_dialogue_module_and_enable_player)
	ui_dialogue.connect("animation_requested", _play_anim)
	self._hide_dialogue_module()

	#handle character interaction triggers
	self._mount_interactables()
	self._mount_random_interactables()
	self._setup_first_quest()
	
	#audio player
	self._mount_audio()

func _mount_audio() -> void:
	audio_custom_player.build()
	audio_custom_player.bind_dependencies()
	audio_custom_player.setup()

#setup player module
func _mount_player() -> void:
	player.build()
	player.bind_dependencies(player_data)
	player.setup()

#do the work of mounting the context
func _mount_dialogue_module(dialogue_res_local: DialogueResource) -> void:
	self._show_dialogue_module()
	ui_dialogue.build()
	ui_dialogue.bind_dependencies(dialogue_res_local)
	ui_dialogue.setup()

func _hide_dialogue_module() -> void:
	audio_custom_player.update_music(false)
	ui_dialogue.hide()
	ui_quest.show()

func _hide_dialogue_module_and_enable_player() -> void:
	audio_custom_player.update_music(false)
	ui_dialogue.hide()
	ui_quest.show()
	player.enable_player()

func _show_dialogue_module() -> void:
	audio_custom_player.update_music(true)
	ui_dialogue.show()
	ui_quest.hide()
	player.disable_player()

func _setup_first_quest() -> void:
	if interactables.size() == 0:
		return

	interactables[0].enable_interaction()
	interactables[0].start_quest()
	var name_local = interactables[0].get_quest_description()
	self._update_quest_ui(name_local)

#end last active quest and start next quest
func _update_quests(description_local: String) -> void:
	var next_quest_gate: bool = false 

	for interaction in interactables:
		if next_quest_gate:
			interaction.enable_interaction()
			break

		if interaction.is_active_quest():
			interaction.end_quest()
			interaction.disable_interaction()
			next_quest_gate = true

	
	self._update_quest_ui(description_local)

func _update_quest_ui(description_local: String) -> void:
	ui_quest.update_quest_ui(description_local)

func _mount_interactables() -> void:
	interactables = interactables_parent.get_children()

	for interaction in interactables:
		interaction.connect("dialogue_requested", _mount_dialogue_module)
		interaction.connect("quest_started", _update_quests)
		interaction.build()
		interaction.bind_dependencies(player)
		interaction.setup()

	self._setup_first_quest()

func _mount_random_interactables() -> void:
	random_interactables = random_interactables_parent.get_children()

	for interaction in random_interactables:
		interaction.connect("dialogue_requested", _mount_dialogue_module)
		interaction.connect("quest_started", _update_quests)
		interaction.build()
		interaction.bind_dependencies(player)
		interaction.setup()

func _play_anim(anim_name_local: String) -> void:
	if anim_player && anim_player.has_animation(anim_name_local):
		anim_player.play(anim_name_local)
