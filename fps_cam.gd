class_name BuildingCameraController
extends Camera3D

@export_group("Controls", "move_")
@export var move_speed := 3
@export var move_sprint_multiplier := 2
@export var move_rotation_sensitivity := 0.005

@export_group("Config")
@export var floor_height := 2

@export_group("Camera", "camera_")
@export var camera_distance := 20
@export var camera_target_height := -1

var _preview: MeshInstance3D
var _preview_collider: Area3D
var _preview_offset: Vector2i = Vector2i(0, 0)
var _preview_rotation: int = 0
var _preview_is_colliding := false
var _last_coord: Vector3
enum PreviewColor {GREEN, RED}
var _preview_colors := {
    PreviewColor.GREEN: Color(0, 1, 0, 0.4),
    PreviewColor.RED: Color(1, 0, 0, 0.4),
}

@onready var _building_ui := $"../../BuildingUi" as BuildingUi
@onready var _gridmap := $"../BuildingGrid" as BuildingGrid
@onready var _preview_container := $"../Preview" as StaticBody3D

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("floor_up"):
        position.y += floor_height
    elif event.is_action_pressed("floor_down"):
        position.y -= floor_height

func _ready() -> void:
    var camera_pos = Vector3(1, 1, 1).normalized() * camera_distance
    camera_pos.y += camera_target_height
    look_at_from_position(camera_pos, Vector3(0, camera_target_height, 0))

func _process(delta: float) -> void:
    _apply_movement(delta)

func _apply_movement(delta: float) -> void:
    if Input.is_action_pressed("rotate_camera"):
        var camera_rotation := Input.get_last_mouse_velocity()
        position -= transform.basis.z * camera_distance # move camera to focus of rotation
        var new_rotation = rotation\
            + Vector3(1, 0, 0) * -camera_rotation.y * move_rotation_sensitivity * delta\
            + Vector3(0, 1, 0) * -camera_rotation.x * move_rotation_sensitivity * delta
        if new_rotation.y > PI: # keep y rotation between -PI and PI
            new_rotation.y -= 2 * PI
        elif new_rotation.y < -PI:
            new_rotation.y += 2 * PI
        rotation = new_rotation
        position += transform.basis.z * camera_distance # return original distance from focus
    var direction_2d := Input.get_vector("move_left", "move_right", "move_front", "move_back").normalized()
    var direction := Vector3(direction_2d.x, 0, direction_2d.y).rotated(Vector3(0, 1, 0), rotation.y)
    if Input.is_action_pressed("move_sprint"):
        direction *= move_sprint_multiplier
    var movement: Vector3 = direction * move_speed * delta
    position += movement

func get_intersect_data() -> Dictionary:
    var mouse_position := get_viewport().get_mouse_position()
    var worldspace := get_world_3d().direct_space_state
    var ray_start := project_ray_origin(mouse_position)
    var ray_end := project_position(mouse_position, 1000)
    return worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(ray_start, ray_end, 0b10))

func _reset_preview_offset():
    _preview_offset = Vector2i(0, 0)
