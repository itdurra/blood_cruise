class_name UIDialogue extends Control

var dialogue_res: DialogueResource

@onready var name_label: Label = %name_label
@onready var dialogue_label: Label = %dialogue_label
@onready var player_dialogue_label: Label = %player_dialogue_label
@onready var voice_line_player: AudioStreamPlayer = %voice_line_player
@onready var dialogue_box: PanelContainer = %dialogue_box

signal dialogue_ended
signal animation_requested(anim_name_local: String)

@export var player_name: String = "Brad"
@export var text_speed: int = 1

var is_typing: bool = false
var player_is_typing: bool = false
var total_characters: int = 0
var player_total_characters: int = 0

#build any services or other variables that we need in this context
func build() -> void:
	pass

# pass in and bind any dependencies that this context needs from parent
func bind_dependencies(dialogue_res_local: DialogueResource) -> void:
	dialogue_res = dialogue_res_local

# at this point, we have all dependencies resolved, and so we can do any
# setup that requires those, e.g. connect signals and use factories etc.
func setup() -> void:
	#if !dialogue_box.is_connected("gui_input", _handle_input):
	#	dialogue_box.connect("gui_input", _handle_input)

	if !self.is_connected("gui_input", _handle_input):
		self.connect("gui_input", _handle_input)

	dialogue_res.start_dialogue()
	self._call_dialogue_methods()
	self.grab_focus()

func next_line() -> void:
	if dialogue_res.has_next_line():
		dialogue_res.next_line()
		self._call_dialogue_methods()
	else:
		dialogue_res.end_dialogue()
		emit_signal("dialogue_ended")

func _call_dialogue_methods() -> void:
	self.set_label()
	self.set_dialogue()
	self.set_voice_line()
	self.trigger_anim()

func set_label() -> void:
	if !dialogue_res:
		return

	name_label.text = dialogue_res.get_character_name()

#requests a dialogue
func set_dialogue() -> void:
	if !dialogue_res:
		return

	if name_label.text == player_name:
		player_dialogue_label.text = dialogue_res.get_text()

		#typewriter effect
		player_total_characters = player_dialogue_label.text.length()
		player_is_typing = true
		player_dialogue_label.visible_characters = 0
		dialogue_label.visible_characters = 0	

	else:
		dialogue_label.text = dialogue_res.get_text()

		#typewriter effect
		total_characters = dialogue_label.text.length()
		is_typing = true
		dialogue_label.visible_characters = 0
		player_dialogue_label.visible_characters = 0

#requests a voice line
func set_voice_line() -> void:
	if !dialogue_res:
		return

	voice_line_player.stream = dialogue_res.get_voice()
	voice_line_player.play()

#requests an animation
#no action if animation string is empty
func trigger_anim() -> void:
	if !dialogue_res:
		return

	var anim_name_local: String = dialogue_res.get_anim_name()

	if !anim_name_local.is_empty():
		emit_signal("animation_requested", anim_name_local)

func _handle_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("Interact") || 
		event.is_action_pressed("ui_accept")
	):
		self.next_line()

#typewriter effect
func _process(_delta: float) -> void:
	if name_label.text == player_name:
		if !player_is_typing:
			return

		if player_dialogue_label.visible_characters < player_total_characters:
			player_dialogue_label.visible_characters += text_speed	
		else:
			player_is_typing = false
	else:
		if !is_typing:
			return

		if dialogue_label.visible_characters < total_characters:
			dialogue_label.visible_characters += text_speed	
		else:
			is_typing = false