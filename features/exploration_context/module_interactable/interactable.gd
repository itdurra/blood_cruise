class_name Interactable extends Node3D

#class for handling interactions from an Area3D
#includes a GUI

@onready var area_trigger: Area3D = %area_trigger
@onready var ui_interactable: Control = %ui_interactable
@onready var collision: CollisionShape3D = %collision

signal interaction_triggered

#build any services or other variables that we need in this context
func build() -> void:
	pass

# pass in and bind any dependencies that this context needs from parent
func bind_dependencies() -> void:
	pass

# at this point, we have all dependencies resolved, and so we can do any
# setup that requires those, e.g. connect signals and use factories etc.
func setup() -> void:
	area_trigger.connect("area_entered", _handle_area_entered)
	area_trigger.connect("area_exited", _handle_area_exited)
	ui_interactable.connect("gui_input", _handle_input)
	ui_interactable.hide()

func _handle_area_entered(_area: Area3D) -> void:
	ui_interactable.show()

func _handle_area_exited(_area: Area3D) -> void:
	ui_interactable.hide()

#handle input during a collision
func _handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		area_trigger.disconnect("area_entered", _handle_area_entered)
		area_trigger.disconnect("area_exited", _handle_area_exited)
		emit_signal("interaction_triggered")
		ui_interactable.hide()

func disable_interaction() -> void:
	collision.disabled = true

func enable_interaction() -> void:
	collision.disabled = false
