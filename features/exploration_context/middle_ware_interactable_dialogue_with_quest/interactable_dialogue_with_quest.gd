class_name InteractableDialogueWithQuests extends Node 

#middleware for connecting three systems (Dialogue, Interactions, Quests)
#using middleware prevents coupling of the modules themselves

#data resources
@export var dialogue_res: DialogueResource
@export var quest_res: QuestResource
@export var enable_from_start: bool = false

#node
@onready var interaction: Interactable = %interaction
@onready var marker: DragCharacterTo3DMarker = %drag_character_to_3d_marker

signal dialogue_requested(dialogue_res_local: DialogueResource)
signal quest_started(quest_description_local: String)

var player_char: PlayerCharacter

#build any services or other variables that we need in this context
func build() -> void:
	pass

# pass in and bind any dependencies that this context needs from parent
func bind_dependencies(player_char_local: PlayerCharacter) -> void:
	player_char = player_char_local

# at this point, we have all dependencies resolved, and so we can do any
# setup that requires those, e.g. connect signals and use factories etc.
func setup() -> void:
	self.mount_interactable()
	self.mount_marker()
	interaction.connect("interaction_triggered", trigger_interaction)

	if enable_from_start:
		self.enable_interaction()

func is_active_quest() -> bool:
	return quest_res.is_active_quest()

func mount_interactable() -> void:
	interaction.build()
	interaction.bind_dependencies()
	interaction.setup()

func mount_marker() -> void:
	marker.build()
	marker.bind_dependencies(player_char)
	marker.setup()

#trigger dialogue/quest if they exist
func trigger_interaction() -> void:
	if dialogue_res != null:
		self._start_dialogue()

	if quest_res != null:
		self.start_quest()

#emit start dialogue signal if it exists
func _start_dialogue() -> void:
	if dialogue_res == null:
		return

	marker.drag_character()

	emit_signal("dialogue_requested", dialogue_res)

#start quest and emit signal if it exists
func start_quest() -> void:
	if quest_res == null:
		return

	quest_res.start_quest()
	emit_signal("quest_started", quest_res.get_quest_description())

#start quest without sending a signal
#needed for the first quest
func _start_quest_no_signal() -> void:
	if quest_res == null:
		return

	quest_res.start_quest()
	#emit_signal("quest_started", quest_res.get_quest_description())

func get_quest_description() -> String:
	if quest_res == null:
		return ""

	return quest_res.get_quest_description()

#end quest and emit signal
func end_quest() -> void:
	if quest_res == null:
		return

	quest_res.end_quest()

func disable_interaction() -> void:
	interaction.disable_interaction()

func enable_interaction() -> void:
	interaction.enable_interaction()
