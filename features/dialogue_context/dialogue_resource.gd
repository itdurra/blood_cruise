class_name DialogueResource extends Resource

#a resource used for a custom implementation of dialogue

#usage: 
#	1. call start_dialogue()
#	2. use get_voice()/get_text() to retrieve data
#	3. call next_line() to get next dialogue line
#	4. call end_dialogue() to reset dialogue

@export var character_name: String
@export var dialogues: Array[String]
@export var voice_lines: Array[AudioStreamOggVorbis]
@export var current_line: int = 0

func set_current_line(line_local: int) -> void:
	current_line = line_local

func increment_current_line() -> void:
	current_line += 1

func get_current_line() -> int:
	return current_line

func get_character_name() -> String:
	return character_name

func start_dialogue() -> void:
	set_current_line(1)
	return

func get_voice() -> AudioStreamOggVorbis:
	return voice_lines[current_line]

func get_text() -> String:
	return dialogues[current_line]

func next_line() -> void:
	self.increment_current_line()

func end_dialogue() -> void:
	set_current_line(0)

func has_next_line() -> bool:
	return self.get_current_line() < dialogues.size()
