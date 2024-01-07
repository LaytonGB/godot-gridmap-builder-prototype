class_name BuildingGrid
extends CSGCombiner3D

var _room_data: Array[RoomData] = [
    RoomData.new(preload("res://assets/rooms/Bridge.tscn"), Vector3i.ZERO, Vector3.ZERO)
]

func _ready() -> void:
    for room in _room_data:
        _show_room(room)

func add_room(room_scene: PackedScene, position: Vector3i, rotation: Vector3) -> void:
    var room_data := RoomData.new(room_scene, position, rotation)
    _room_data.append(room_data)
    _show_room(room_data)

func _show_room(room_data: RoomData) -> void:
    room_data.instantiate_as_child_of(self)
