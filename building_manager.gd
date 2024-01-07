class_name BuildingManager
extends Node3D

@onready var _camera := $Camera3D as BuildingCameraController
@onready var _grid := $BuildingGrid as BuildingGrid
@onready var _preview := $Preview as RoomPreview
@onready var _root := $".." as BuildingRoot
@onready var _ui := $"../BuildingUi" as BuildingUi

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("select"):
        var intersect_data := _camera.get_intersect_data()
        if !intersect_data.is_empty() and _ui.selected != -1 and _preview.placement_is_valid:
            _instantiate_room()

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    Globals.building_ui_item_selected.connect(_on_building_ui_item_selected)

func _process(delta: float) -> void:
    if _ui.selected != -1 and !Input.is_action_pressed("rotate_camera"):
        var intersect_data := _camera.get_intersect_data()
        if !intersect_data.is_empty():
            # show preview at position
            _preview.visible = true
            _preview.update_position(\
                intersect_data["position"], intersect_data["normal"])
        else:
            _preview.visible = false

func _instantiate_room() -> void:
    _grid.add_room(_preview._room_scene, Vector3i(_preview.position), _preview.rotation)

func _on_building_ui_item_selected(id: int) -> void:
    if id == -1:
        _preview.clear_room()
    else:
        _preview.set_room(_root._room_scenes[id])
