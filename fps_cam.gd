class_name FPSController
extends Camera3D

@export_group("Controls")
@export var move_speed := 3
@export var move_sprint_multiplier := 2

var pivot := Vector3.ZERO

func _unhandled_input(event) -> void:
    if event.is_action_pressed("select"):
        print(event)
        var mouse_position := get_viewport().get_mouse_position()
        var worldspace := get_world_3d().direct_space_state
        var ray_start := project_ray_origin(mouse_position)
        var ray_end := project_position(mouse_position, 1000)
        var intersect_data := worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(ray_start, ray_end))
        if !intersect_data.is_empty():
            var visualiser: MeshInstance3D = $"../ClickVisualiser"
            visualiser.visible = true
            visualiser.transform.origin = intersect_data.get("position")
        print(intersect_data)

func _process(delta) -> void:
    var direction := Vector3()
    direction += transform.basis.x * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
    direction += transform.basis.y * (Input.get_action_strength("move_up") - Input.get_action_strength("move_down"))
    direction += transform.basis.z * (Input.get_action_strength("move_back") - Input.get_action_strength("move_front"))
    direction = direction.normalized()
    if Input.is_action_pressed("move_sprint"):
        direction *= move_sprint_multiplier

    var movement: Vector3 = direction * move_speed * delta * transform.origin.distance_to(pivot)
    transform.origin += movement
    look_at(pivot)
