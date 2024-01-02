class_name BuildingUi
extends MarginContainer

@export var gridmap: GridMap

var selected: int = -1

@onready var item_bar := $PanelContainer/HBoxContainer as HBoxContainer
@onready var meshlib := gridmap.mesh_library as MeshLibrary
@onready var build_item := preload("res://building_ui_item.tscn")

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("deselect"):
        Globals.building_ui_item_selected.emit(-1)

func _ready() -> void:
    for id in meshlib.get_item_list():
        var item_texture := meshlib.get_item_preview(id)
        var item_label := meshlib.get_item_name(id)
        var ui_item := build_item.instantiate() as BuildingUiItem
        item_bar.add_child(ui_item)
        ui_item.init(id, item_texture, item_label)
    Globals.building_ui_item_selected.connect(_on_item_selected)

func _on_item_selected(id: int) -> void:
    selected = id
