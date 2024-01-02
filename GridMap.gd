class_name BuildingGrid
extends GridMap

var item_sizes: Array[Vector3] = [
    Vector3(2, 1, 2),
    Vector3(4, 1, 4),
    Vector3(6, 1, 6),
]

func get_item_mesh(id: int) -> ArrayMesh:
    return mesh_library.get_item_mesh(id)
