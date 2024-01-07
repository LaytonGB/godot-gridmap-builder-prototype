# Each building room must have floor, cieling, walls, and an OutlineArea.

class_name BuildingRoom
extends CSGCombiner3D

var size: Vector3
var floor: CSGCombiner3D
var walls: CSGCombiner3D
var ceiling: CSGCombiner3D
var outline_area: Area3D
var valid_door_positions: Array[PositionRange] = []

func _ready() -> void:
    if OS.has_feature("debug"):
        assert(size != null, "BuildingRoom must have a non-null `size`")
        assert(floor != null, "BuildingRoom must have a non-null `floor`")
        assert(walls != null, "BuildingRoom must have a non-null `walls`")
        assert(ceiling != null, "BuildingRoom must have a non-null `ceiling`")
        assert(outline_area != null, "BuildingRoom must have a non-null `outline_area`")
        assert(!valid_door_positions.is_empty(), "BuildingRoom must have a non-empty `valid_door_positions`")

func show_ceiling() -> void:
    ceiling.visible = true

func hide_ceiling() -> void:
    ceiling.visible = false

func show_walls() -> void:
    walls.visible = true

func hide_walls() -> void:
    walls.visible = false

func show_floor() -> void:
    floor.visible = true

func hide_floor() -> void:
    floor.visible = false
