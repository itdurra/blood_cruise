class_name QuestResource extends Resource

enum QuestStatus {
	NotStarted,
	InProgress,
	Complete
}

@export var quest_description: String
@export var quest_status: QuestStatus = QuestStatus.NotStarted


#-------------getters --------------#
func get_quest_description() -> String:
	return quest_description

func get_quest_status() -> QuestStatus:
	return quest_status

func is_active_quest() -> bool:
	return self.get_quest_status() == QuestStatus.InProgress

#-------------setters ---------------#

func set_quest_status(quest_status_local: QuestStatus) -> void:
	quest_status = quest_status_local

func start_quest() -> void:
	self.set_quest_status(QuestStatus.InProgress)

func end_quest() -> void:
	self.set_quest_status(QuestStatus.Complete)

#resetting save file
func restart_quest() -> void:
	self.set_quest_status(QuestStatus.NotStarted)