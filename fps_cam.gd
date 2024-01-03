class_name FPSController
extends Camera3D


class ClickData:
    var normal: Vector3
    var click_pos: Vector3

    func _init(normal: Vector3, click_pos: Vector3) -> void:
        self.normal = normal
        self.click_pos = click_pos

    func get_pos_cam_side() -> Vector3:
        return click_pos + normal

    func get_pos_obj_side() -> Vector3:
        return click_pos - normal


@export_group("Controls")
@export var move_speed := 3
@export var move_sprint_multiplier := 2

var _pivot := Vector3.ZERO
var _preview_container: MeshInstance3D
var _preview_offset: Vector2i = Vector2i(0, 0)
var _last_coord: Vector3

@onready var building_ui := $"../../BuildingUi" as BuildingUi
@onready var gridmap := $"../GridMap" as BuildingGrid

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("select"):
        var intersect_data := get_intersect_data()
        if !intersect_data.is_empty() and building_ui.selected != -1 and _last_coord:
            _instantiate_preview()
    elif event.is_action_pressed("increase_offset_alt"):
        _preview_offset.y += 1
    elif event.is_action_pressed("decrease_offset_alt"):
        _preview_offset.y -= 1
    elif event.is_action_pressed("increase_offset"):
        _preview_offset.x += 1
    elif event.is_action_pressed("decrease_offset"):
        _preview_offset.x -= 1

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    Globals.building_ui_item_selected.connect(_on_building_ui_item_selected)

func _process(delta: float) -> void:
    _apply_movement(delta)
    _show_placement_preview()

func _apply_movement(delta: float) -> void:
    #TODO rotate around origin (strafing causes drift over time)
    var direction := Vector3()
    direction += transform.basis.x * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
    direction += transform.basis.y * (Input.get_action_strength("move_up") - Input.get_action_strength("move_down"))
    direction += transform.basis.z * (Input.get_action_strength("move_back") - Input.get_action_strength("move_front"))
    direction = direction.normalized()
    if Input.is_action_pressed("move_sprint"):
        direction *= move_sprint_multiplier

    var movement: Vector3 = direction * move_speed * delta * transform.origin.distance_to(_pivot)
    transform.origin += movement
    look_at(_pivot)

func _show_placement_preview() -> void:
    if building_ui.selected != -1:
        var intersection_data = get_intersect_data()
        if intersection_data.is_empty():
            _preview_container.visible = false
        else:
            var pos: Vector3 = intersection_data["position"]
            var normal := intersection_data["normal"] as Vector3
            pos = _shift_pos_using_selected(normal, pos)
            _last_coord = gridmap.local_to_map(pos)
            _show_preview_at_coord()

func _shift_pos_using_selected(normal: Vector3, pos: Vector3) -> Vector3:
    var normals: Array[Vector3]
    if normal.x != 0:
        normals = [Vector3(0, 0, 1), Vector3(0, 1, 0)]
    elif normal.z != 0:
        normals = [Vector3(1, 0, 0), Vector3(0, 1, 0)]
    else:
        normals = [Vector3(0, 0, 1), Vector3(1, 0, 0)]
    var half_mesh_size := _preview_container.mesh.get_aabb().size / 2
    _clamp_preview_offset(normals, half_mesh_size)
    pos += normal * half_mesh_size # move preview center to align
    pos += normal.abs() * .1 # fix exact-grid-border issues
    pos += normals[0] * _preview_offset.x
    pos += normals[1] * _preview_offset.y
    return pos

func _clamp_preview_offset(normals: Array[Vector3], half_mesh_size: Vector3) -> void:
    var floor_half_mesh := half_mesh_size.floor()
    var max_offsets := Vector2i(normals[0].dot(floor_half_mesh), normals[1].dot(floor_half_mesh))
    _preview_offset.x = clamp(_preview_offset.x, -max_offsets.x + 1, max_offsets.x)
    _preview_offset.y = clamp(_preview_offset.y, -max_offsets.y + 1, max_offsets.y)

func _show_preview_at_coord() -> void:
    _preview_container.visible = true
    _preview_container.transform.origin = _last_coord

func _instantiate_preview() -> void:
    gridmap.set_cell_item(_last_coord, building_ui.selected)

func get_intersect_data() -> Dictionary:
    var mouse_position := get_viewport().get_mouse_position()
    var worldspace := get_world_3d().direct_space_state
    var ray_start := project_ray_origin(mouse_position)
    var ray_end := project_position(mouse_position, 1000)
    return worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(ray_start, ray_end, 0b10))

func _on_building_ui_item_selected(id: int) -> void:
    if _preview_container:
        if id == -1:
            _preview_container.queue_free()
            _preview_container = null
        else:
            _preview_container.mesh = gridmap.get_item_mesh(id)
    elif id != -1:
        var mesh_node := MeshInstance3D.new()
        mesh_node.mesh = gridmap.get_item_mesh(id)
        var material := StandardMaterial3D.new()
        material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
        material.albedo_color = Color(1, 0, 0, 0.4)
        mesh_node.material_override = material
        _preview_container = mesh_node
        _preview_container.visible = false
        _preview_container.visibility_changed.connect(_reset_preview_offset)
        get_parent().add_child(_preview_container)

func _reset_preview_offset():
    _preview_offset = Vector2i(0, 0)
