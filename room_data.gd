class_name RoomData
extends Node

var room_scene: PackedScene
var position: Vector3
var rotation: Vector3

func _init(room_scene: PackedScene, position: Vector3i, rotation: Vector3) -> void:
    self.room_scene = room_scene
    self.position = position
    self.rotation = rotation

func instantiate_as_child_of(node: Node) -> void:
    var instance := room_scene.instantiate() as BuildingRoom
    node.add_child(instance)
    instance.position = position
    instance.rotation = rotation
