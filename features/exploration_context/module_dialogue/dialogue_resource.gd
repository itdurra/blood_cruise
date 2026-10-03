class_name DialogueResource extends Resource

#a resource used for a custom implementation of dialogue

#usage: 
#	1. call start_dialogue()
#	2. use get_voice()/get_text() to retrieve data
#	3. call next_line() to get next dialogue line
#	4. call end_dialogue() to reset dialogue

@export var current_line: int = 0

#these three should be the same length to sync properly
#Dialogue will stop based on array size of dialogues
@export var character_names: Array[String] #names of characters
@export var dialogues: Array[String] #dialogue
@export var voice_lines: Array[AudioStreamOggVorbis] #voicelines
@export var anim_names: Array[String] #animation string name

func start_dialogue() -> void:
	set_current_line(0)
	return

func next_line() -> void:
	self.increment_current_line()

func end_dialogue() -> void:
	set_current_line(0)

func has_next_line() -> bool:
	return self.get_current_line() < dialogues.size() - 1

#------------getters/setters ----------------#

func set_current_line(line_local: int) -> void:
	current_line = line_local

func increment_current_line() -> void:
	current_line += 1

func get_current_line() -> int:
	return current_line

func get_character_name() -> String:
	if self.get_current_line() >= character_names.size():
		return ""

	return character_names[current_line]

func get_voice() -> AudioStreamOggVorbis:
	if self.get_current_line() >= voice_lines.size():
		return null

	return voice_lines[current_line]

func get_anim_name() -> String:
	if self.get_current_line() >= anim_names.size():
		return ""

	return anim_names[current_line]

func get_text() -> String:
	if self.get_current_line() >= dialogues.size():
		return ""

	return dialogues[current_line]
