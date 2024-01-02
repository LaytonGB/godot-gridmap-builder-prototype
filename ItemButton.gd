class_name ItemButton
extends PanelContainer

enum PanelColor {DEFAULT, HOVER}
@onready var colors := {
    PanelColor.DEFAULT: Color(.22, .22, .22, 1),
    PanelColor.HOVER: Color(.4, .4, .4, 1),
}

var hovered := false

signal selected

func _ready() -> void:
    set_color(PanelColor.DEFAULT)
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)

func _gui_input(event) -> void:
    if event is InputEventMouseButton and hovered:
        if event.is_action_pressed("select"):
            set_color(PanelColor.DEFAULT)
        elif event.is_action_released("select"):
            set_color(PanelColor.HOVER)
            selected.emit()

func _on_mouse_entered() -> void:
    hovered = true
    set_color(PanelColor.HOVER)

func _on_mouse_exited() -> void:
    hovered = false
    set_color(PanelColor.DEFAULT)

func set_color(color: PanelColor) -> void:
    get("theme_override_styles/panel").bg_color = colors.get(color)
