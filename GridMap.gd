class_name BuildingGrid
extends GridMap

var item_sizes: Array[Vector3] = [
    Vector3(2, 1, 2),
    Vector3(4, 1, 4),
    Vector3(6, 1, 6),
]

func get_item_mesh(id: int) -> ArrayMesh:
    return mesh_library.get_item_mesh(id)

func get_item_collision(id: int) -> ConcavePolygonShape3D:
    return mesh_library.get_item_shapes(id)[0]

func get_item_collision_box(id: int) -> ConvexPolygonShape3D:
    return mesh_library.get_item_shapes(id)[2]
