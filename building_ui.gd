class_name BuildingUi
extends MarginContainer

@export var _building_grid: BuildingGrid

var selected: int = -1

@onready var _root := $".." as BuildingRoot
@onready var _item_bar := $PanelContainer/HBoxContainer as HBoxContainer
@onready var _build_item := preload("res://building_ui_item.tscn")

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("deselect"):
        Globals.building_ui_item_selected.emit(-1)

func _ready() -> void:
    for id in _root._room_scenes.size():
        var packed_room: PackedScene = _root._room_scenes[id]
        var room := packed_room.instantiate() as BuildingRoom
        var room_name := room.name
        room.queue_free()
        var ui_item := _build_item.instantiate() as BuildingUiItem
        _item_bar.add_child(ui_item)
        ui_item.init(id, room_name)
    Globals.building_ui_item_selected.connect(_on_item_selected)

func _on_item_selected(id: int) -> void:
    selected = id
