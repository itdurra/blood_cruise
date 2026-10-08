extends Node3D

@export var vertical_bob: float = .1
@export var horiz_bob: float = .05
@export var fast_vertical_bob: float = .1
@export var fast_horiz_bob: float = .6
@export var fast_time: float = .6
@export var normal_time: float = 1.0
@export var fast_rot: float = 22.0

@export var particles: GPUParticles3D


var is_in_fast_mode: int = 0
var starting_pos: Vector3
var starting_rot: Vector3

var t: Tween

func _ready() -> void:
	starting_pos = self.position
	starting_rot = self.rotation
	self._start_bob()

func _start_bob() -> void:
	if t:
		t.kill()
	t = create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_IN_OUT)
	t.set_parallel()
	t.tween_property(self, "position:x", starting_pos.x + horiz_bob, normal_time)
	t.tween_property(self, "position:y", starting_pos.y + vertical_bob, normal_time)
	t.tween_property(self, "position:z", starting_pos.z + horiz_bob, normal_time)
	t.set_parallel(false)
	t.tween_property(self, "position:x", starting_pos.x, normal_time)
	t.set_parallel()
	t.tween_property(self, "position:y", starting_pos.y, normal_time)
	t.tween_property(self, "position:z", starting_pos.z, normal_time)
	t.set_loops()
	
func start_fast_mode() -> void:
	particles.emitting = true


	if t:
		t.kill()
	t = create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	#t.set_ease(Tween.EASE_IN_OUT)
	t.set_parallel()
	t.tween_property(self, "position:x", starting_pos.x - fast_horiz_bob, fast_time)
	t.tween_property(self, "position:y", starting_pos.y + fast_vertical_bob, fast_time)
	t.tween_property(self, "rotation:x", deg_to_rad(-fast_rot), fast_time)
	t.set_parallel(false)
	t.tween_property(self, "position:x", starting_pos.x, fast_time)
	t.set_parallel()
	t.tween_property(self, "position:y", starting_pos.y, fast_time)
	t.tween_property(self, "position:z", starting_pos.z, fast_time)
	t.tween_property(self, "rotation:x", deg_to_rad(fast_rot), fast_time)
	t.set_loops()
