@tool
extends Node

enum ELEMENT_TYPE {SURFACE_TAP, EDGE_SLIDE, SPATIAL_JUDGE}

signal element_created(element_type, position)

func spawn_element(element_type, speed=1.0, angle=0.0):
	# 参数验证
	speed = clamp(speed, 1.0, 3.0)
	angle = wrapf(angle, 0.0, TAU)
	
	# 四元数空间转换
	var base_speed = BPM/60 * 0.5
	var actual_speed = speed * base_speed
	
	var q = Quaternion(Vector3.UP, angle)
	var spawn_position = q * Vector3.FORWARD * 10.0
	
	var element = create_element_mesh(element_type)
	element.set_meta("generation_speed", actual_speed)
	emit_signal("element_created", element_type, spawn_position)
	return element

# 已迁移到spawn_element方法中使用四元数计算

func create_element_mesh(element_type):
	match element_type:
		ELEMENT_TYPE.SURFACE_TAP:
			return create_cube_mesh(0.2, Color.YELLOW)
		ELEMENT_TYPE.EDGE_SLIDE:
			return create_cylinder_mesh(0.1, 2.0, Color.CYAN)
		ELEMENT_TYPE.SPATIAL_JUDGE:
			return create_sphere_mesh(0.3, Color.MAGENTA)

func create_cube_mesh(size, color):
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	var mesh = BoxMesh.new()
	mesh.size = Vector3.ONE * size
	mesh.material = mat
	return mesh

func create_cylinder_mesh(radius, height, color):
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	var mesh = CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.material = mat
	return mesh

func create_sphere_mesh(radius, color):
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	var mesh = SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2
	mesh.material = mat
	return mesh
