class_name CutsceneContext extends Node

#use this to track order and store it as a resource
enum SubContext {
	BoatInTheOceanContext
}

@export var boat_in_the_ocean_scene: PackedScene

var current_subcontext: SubContext
var current_subcontext_node: Node
var player_data: PlayerData


signal cutscenes_finished

#TODO: add cutscene tracker so know which cutscenes to play

#build any services or other variables that we need in this context
func build() -> void:
	pass

# pass in and bind any dependencies that this context needs from parent
func bind_dependencies(player_data_local: PlayerData) -> void:
	player_data = player_data_local

# at this point, we have all dependencies resolved, and so we can do any
# setup that requires those, e.g. connect signals and use factories etc.
func setup() -> void:
	mount_boat_in_the_ocean_cutscene()

func mount_boat_in_the_ocean_cutscene() -> void:
	#tear down old subcontext
	if current_subcontext_node:
		current_subcontext_node.queue_free()

		#may require other teardown steps

	#build new subcontext
	current_subcontext = SubContext.BoatInTheOceanContext
	current_subcontext_node = boat_in_the_ocean_scene.instantiate()
	add_child(current_subcontext_node)

	var boat_in_the_ocean_subcontext: BoatInTheOceanContext = current_subcontext_node as BoatInTheOceanContext
	if boat_in_the_ocean_subcontext == null:
		printerr("Missing subcontext")
		return

	boat_in_the_ocean_subcontext.build()
	boat_in_the_ocean_subcontext.bind_dependencies(player_data)
	boat_in_the_ocean_subcontext.setup()

	boat_in_the_ocean_subcontext.connect("scene_finished", cutscenes_finished.emit)