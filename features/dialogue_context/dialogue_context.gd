class_name DialogueContext extends Node

@onready var ui_dialogue: Control = %ui_dialogue

var dialogue_res: DialogueResource

func build() -> void:
	#build any services or other variables that we need in this context
	pass

func bind_dependencies(dialogue_res_local: DialogueResource) -> void:
	dialogue_res = dialogue_res_local

func setup() -> void:
	self._mount_ui_dialogue()

func _mount_ui_dialogue() -> void:
	ui_dialogue.build()
	ui_dialogue.bind_dependencies(dialogue_res)
	ui_dialogue.setup()