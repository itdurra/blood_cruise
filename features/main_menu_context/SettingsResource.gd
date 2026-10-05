class_name Settings extends Resource

#audio
@export var mute: bool = false
@export var master_bus: float = 0
@export var music_bus: float = 0
@export var voice_bus: float = 0
@export var sfx_bus: float = 0
@export var ambient_bus: float = 0

#language
@export var language: String = "en"

#input
@export var inputs: Dictionary = {}

#video
@export var fullscreen: bool = false
@export var resolution: int = 5
@export var vsync: int = 0
@export var antialiasing: int = 1
@export var brightness: float = 50.0

#game
#@export var camera_shake: bool = true
@export var vertex_wobble: float = .85