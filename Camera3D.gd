extends Camera3D


var pos := Vector2()
var hovered_idx := -1

@onready var grid_map: GridMap = $"../GridMap"
@onready var mesh_lib: MeshLibrary = grid_map.mesh_library
@onready var pointer: MeshInstance3D = $"../PointerVisual"


# Called when the node enters the scene tree for the first time.
func _ready():
    look_at(Vector3.ZERO)
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _input(event):
    if event is InputEventMouseMotion:
        pos = event.position
        highlight_obj(pos)


func highlight_obj(mouse_pos):
    var worldspace := get_world_3d().direct_space_state
    var start := project_ray_origin(mouse_pos)
    var end := project_position(mouse_pos, 1000)
    var res := worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end, 0b00000000_00000000_00000000_00000001))
    #print(cam_position)
    print(res)
    if res.is_empty():
        clear_hovered()
    else:
        var pos := res.get("position") as Vector3
        if pos != null:
            pos = pos - (transform.basis.z.normalized() * 0.1)
            if pos.x < 0:
                pos.x -= 1
            pointer.position = pos
            pointer.visible = true
            var item_idx := grid_map.get_cell_item(pos)
            print(item_idx)
            update_hovered(item_idx)


func reset_highlight():
    set_highlight(1)


func clear_hovered():
    reset_highlight()
    hovered_idx = -1
    pointer.visible = false


func update_hovered(idx: int):
    if idx != hovered_idx:
        reset_highlight()
        hovered_idx = idx
        set_highlight(1.5)


func set_highlight(new_scale: float):
    if hovered_idx != -1:
        var mesh := mesh_lib.get_item_mesh(hovered_idx)
        var material := mesh.surface_get_material(0)
        material.albedo_color = Color(new_scale, new_scale, new_scale)
        mesh.surface_set_material(0, material)
