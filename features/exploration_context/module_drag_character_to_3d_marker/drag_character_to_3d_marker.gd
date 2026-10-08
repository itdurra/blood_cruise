class_name DragCharacterTo3DMarker extends Node

var t: Tween
var player_char

func build() -> void:
	#build any services or other variables that we need in this context
	pass

func bind_dependencies(player_char_local: PlayerCharacter) -> void:
	player_char = player_char_local

func setup() -> void:
	pass

func drag_character() -> void:
	if !player_char:
		return

	var player_cam_local: Camera3D = player_char.get_player_camera()

	if t:
		t.kill()

	t = create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_IN_OUT)
	t.set_parallel()
	t.tween_property(player_char, "global_position", self.global_position, 1.3)
	t.tween_property(player_cam_local, "global_rotation", self.global_rotation, 1.3)