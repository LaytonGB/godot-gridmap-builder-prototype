extends Node

signal building_ui_item_selected(id: int)

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("exit"):
        get_tree().quit()

func emit_building_ui_item_selected(id: int) -> void:
    building_ui_item_selected.emit(id)
