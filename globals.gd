extends Node

enum PlayerMode {SELECTING, PLACING}
var mode := PlayerMode.SELECTING

signal building_ui_item_selected(id: int)

func emit_building_ui_item_selected(id: int) -> void:
    building_ui_item_selected.emit(id)
