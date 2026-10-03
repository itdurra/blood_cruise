class_name UIQuest extends Node

#update quest UI

var t: Tween

@export var scale_target: float = 2

@onready var quest_description: Label = %quest_description

var scale_start: Vector2

func _ready() -> void:
    scale_start = quest_description.offset_transform_scale

func update_quest_ui(text_local: String) -> void:
    #TODO: other tween behavior
    quest_description.text = text_local

    if t:
        t.kill()

    var target_vec_local: Vector2 = Vector2(
        (scale_start.x + scale_target),
        (scale_start.y + scale_target)
    )

    t = create_tween()
    t.set_trans(Tween.TRANS_BOUNCE)
    t.set_ease(Tween.EASE_IN)
    t.set_parallel(false)
    t.tween_property(quest_description, "offset_transform_scale", target_vec_local, 3.0)
    t.tween_property(quest_description, "offset_transform_scale", scale_start, 1.0)


