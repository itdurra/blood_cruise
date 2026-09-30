extends Node3D

@export var dialogue_res: DialogueResource
@export var degrees_to_turn: float = 180.0
@export var time_to_turn: float = 1.3

signal dialogue_requested(dialogue_res_local: DialogueResource)

@onready var turn_trigger: Area3D = $turn_trigger
@onready var fish_guy: Node3D = $fish_guy

var t: Tween

func _ready() -> void:
	turn_trigger.connect("body_entered", turn_character)

func turn_character(_body: Node3D) -> void:

	if !fish_guy:
		return

	if t:
		t.kill()

	t = create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_IN)
	t.tween_property(fish_guy, "rotation:y", degrees_to_turn, time_to_turn)
	t.tween_callback(_cleanup)

func _cleanup() -> void:
	emit_signal("dialogue_requested", dialogue_res)