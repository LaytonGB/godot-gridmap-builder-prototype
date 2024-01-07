extends BuildingRoom

func _ready() -> void:
    size = Vector3(2, 2, 2)
    floor = $Floors
    walls = $Walls
    ceiling = $Ceilings
    outline_area = $OutlineArea
    valid_door_positions = [
        PositionRange.new(Vector3.ZERO, Vector3(-.5, 0, -.95), Vector3(.5, 0, -.95)),
        PositionRange.new(Vector3.ZERO, Vector3(-.5, 0, .95), Vector3(.5, 0, .95)),
        PositionRange.new(Vector3(0, PI / 2, 0), Vector3(-.95, 0, -.5), Vector3(-.95, 0, .5)),
        PositionRange.new(Vector3(0, PI / 2, 0), Vector3(.95, 0, -.5), Vector3(.95, 0, .5)),
    ]
    super._ready()
