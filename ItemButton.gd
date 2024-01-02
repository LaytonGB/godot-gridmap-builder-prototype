class_name BuildingUiItem
extends PanelContainer

enum PanelColor {DEFAULT, HOVER}
@onready var colors := {
    PanelColor.DEFAULT: Color(.22, .22, .22, 1),
    PanelColor.HOVER: Color(.4, .4, .4, 1),
}

@onready var texture_rect := $ItemContainer/TextureRect as TextureRect
@onready var label := $ItemContainer/Label as Label

var hovered := false
var id: int

signal selected

func _ready() -> void:
    make_panel_unique()
    set_color(PanelColor.DEFAULT)
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)

func init(id: int, texture: Texture2D, label_text: String) -> void:
    self.id = id
    texture_rect.texture = texture
    label.text = label_text

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

func make_panel_unique() -> void:
    set("theme_override_styles/panel", get("theme_override_styles/panel").duplicate())

func set_color(color: PanelColor) -> void:
    get("theme_override_styles/panel").bg_color = colors.get(color)

func _on_selected() -> void:
    Globals.emit_building_ui_item_selected(id)
