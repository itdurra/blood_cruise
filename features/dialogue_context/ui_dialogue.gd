extends Control

var dialogue_res: DialogueResource

@onready var name_label: Label = %name_label
@onready var dialogue_label: Label = %dialogue_label
@onready var voice_line_player: AudioStreamPlayer = %voice_line_player
@onready var dialogue_box: PanelContainer = %dialogue_box

signal dialogue_ended

#build any services or other variables that we need in this context
func build() -> void:
	pass

# pass in and bind any dependencies that this context needs from parent
func bind_dependencies(dialogue_res_local: DialogueResource) -> void:
	dialogue_res = dialogue_res_local

# at this point, we have all dependencies resolved, and so we can do any
# setup that requires those, e.g. connect signals and use factories etc.
func setup() -> void:
	dialogue_box.connect("gui_input", _handle_input)

	dialogue_res.start_dialogue()
	self.set_label()
	self.set_dialogue()
	self.set_voice_line()
	dialogue_box.grab_focus()

func next_line() -> void:
	if dialogue_res.has_next_line():
		dialogue_res.next_line()
		self.set_dialogue()
		self.set_voice_line()
	else:
		dialogue_res.end_dialogue()
		emit_signal("dialogue_ended")

func set_label() -> void:
	if !dialogue_res:
		return

	name_label.text = dialogue_res.get_character_name()

func set_dialogue() -> void:
	if !dialogue_res:
		return

	dialogue_label.text = dialogue_res.get_text()

func set_voice_line() -> void:
	if !dialogue_res:
		return

	voice_line_player.stream = dialogue_res.get_voice()
	voice_line_player.play()

func _handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") || event.is_action_pressed("ui_accept"):
		self.next_line()
