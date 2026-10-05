class_name PS1ConvertMaterials extends Node

@export var ps1_shader_material: ShaderMaterial

var shader_materials: Array[ShaderMaterial]

#takes in a parent node from which to iterate through
func convert_all_materials(parent_node: Node3D) -> void:
	if !parent_node:
		return

	#get all nodes and iterate through them
	var nodes = self._get_all_children(parent_node)
	for node in nodes:
		if node is not MeshInstance3D:
			continue

		#for each surface in a mesh
		for surface_num: int in node.get_surface_override_material_count():
			#get texture from material's albedo
			#var mat_local: Material = node.get_active_material(surface_num)
			var mat_local: Material = node.mesh.surface_get_material(surface_num)
			if mat_local is not BaseMaterial3D:
				continue
			var texture_local: CompressedTexture2D = mat_local.get_texture(0)

			#add ps1 shader material to material override
			var dup_ps1_shader_mat: ShaderMaterial = ps1_shader_material.duplicate()
			shader_materials.append(dup_ps1_shader_mat) #store for later modifications
			node.set_surface_override_material(surface_num, dup_ps1_shader_mat)

			#update shader param albedo
			var shader_mat_local: Material = node.get_surface_override_material(surface_num)
			if shader_mat_local == null:
				continue
			shader_mat_local.set("shader_parameter/albedo", texture_local)

#for changing via a slider in settings
func change_slider(value_local: float) -> void:
	#clamp
	value_local = min(value_local, .96) #max/min values of slider
	value_local = max(value_local, 0.0) #max/min values of slider

	for shader_mat_local in shader_materials:
		shader_mat_local.set_shader_parameter("shader_parameter/jitter", value_local)

#get all child nodes recursively
func _get_all_children(node: Node) -> Array[Node]:
	var nodes: Array[Node] = []
	for N in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes.append_array(_get_all_children(N))
		else:
			nodes.append(N)
	return nodes
