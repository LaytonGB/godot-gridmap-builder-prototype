class_name RoomPreview
extends StaticBody3D

static var valid_placement_color := Color(0, 255, 0, 0.3)
static var invalid_placement_color := Color(255, 0, 0, 0.4)

var _room_scene: PackedScene
var _room: BuildingRoom
var _material: StandardMaterial3D
var _offset: Vector2
var _rotation: int = 0
var placement_is_valid := false

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("rotate_room"):
        _rotation = (_rotation + 1) % 4
        rotate_y(PI / 2)
    elif event.is_action_pressed("increase_offset_alt"):
        _offset.y += 1
    elif event.is_action_pressed("decrease_offset_alt"):
        _offset.y -= 1
    elif event.is_action_pressed("increase_offset"):
        _offset.x += 1
    elif event.is_action_pressed("decrease_offset"):
        _offset.x -= 1

func _process(delta: float) -> void:
    if _room:
        placement_is_valid = !_room.outline_area.has_overlapping_areas()
        _material.albedo_color = valid_placement_color if placement_is_valid\
            else invalid_placement_color

func set_room(room_scene: PackedScene) -> void:
    if _room:
        clear_room()
    _room_scene = room_scene
    _room = room_scene.instantiate() as BuildingRoom
    add_child(_room)
    _init_preview_material()
    _init_preview_area()

func clear_room() -> void:
    for child in get_children():
        child.queue_free()
    _room_scene = null
    _room = null
    _material = null

func update_position(pos: Vector3, normal: Vector3) -> void:
    var offset_dir := _get_offset_direction_from_normal(normal)
    var half_size := _room.get_aabb().size / 2
    if _rotation % 2 == 1: # adjust size orientation to match rotation
        half_size = Vector3(half_size.z, half_size.y, half_size.x)
    _clamp_preview_offset(offset_dir, half_size)
    pos += normal.abs() * .1 # fix exact-grid-border issues
    pos = pos.floor() # snap to grid
    pos += normal * half_size # move preview center to align
    pos += offset_dir[0] * _offset.x
    pos += offset_dir[1] * _offset.y
    position = pos

func _clamp_preview_offset(offset_dir: Array[Vector3], half_size: Vector3) -> void:
    var floor_half_size := half_size.floor()
    var max_offsets :=\
        Vector2(offset_dir[0].dot(floor_half_size), offset_dir[1].dot(floor_half_size))
    _offset.x = clamp(_offset.x, -max_offsets.x + 1, max_offsets.x)
    _offset.y = clamp(_offset.y, -max_offsets.y + 1, max_offsets.y)

func _init_preview_material() -> void:
    _material = StandardMaterial3D.new()
    _material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    _room.material_override = _material

func _init_preview_area() -> void:
    _room.outline_area.scale *= 0.99

func _get_offset_direction_from_normal(normal: Vector3) -> Array[Vector3]:
    var offset_dir: Array[Vector3]
    if normal.x != 0:
        offset_dir = [Vector3(0, 0, 1), Vector3(0, 1, 0)]
    elif normal.z != 0:
        offset_dir = [Vector3(1, 0, 0), Vector3(0, 1, 0)]
    else:
        offset_dir = [Vector3(0, 0, 1), Vector3(1, 0, 0)]
    return offset_dir

func _on_visibility_changed() -> void:
    _offset = Vector2.ZERO
