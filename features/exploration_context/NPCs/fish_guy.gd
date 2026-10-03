class_name InteractableCharacter extends Node3D

@export var anim_player: AnimationPlayer

var t: Tween

func trigger_anim(anim_name_local: String) -> void:
	if anim_player && anim_player.has_animation(anim_name_local):
		anim_player.play(anim_name_local)